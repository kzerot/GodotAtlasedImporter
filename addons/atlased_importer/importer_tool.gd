tool
extends EditorImportPlugin

func get_importer_name():
	return "importer.atlased"

func get_visible_name():
	return "Atlased Importer"

func get_recognized_extensions():
	return ["json", "atlased"]

func get_save_extension():
	return "tres"

func get_resource_type():
	return "Resource"

func get_preset_count():
	return 1

func get_preset_name(i):
	return "Default"

func get_import_options(i):
	return [{"name": "generate_sprites", "default_value": false}]

func get_import_order():
	return 999


func get_option_visibility(option, options):
	return true


func import(source_file, save_path, options, platform_variants, gen_files):
	print(options)
	var file = File.new()
	if file.open(source_file, File.READ) != OK:
		return FAILED
	print_debug("processing %s" % source_file)
#	print_debug(source_file, save_path, options, platform_variants, gen_files)

	var resource = preload("res://addons/atlased_importer/atlased_resource.gd").new()
	resource.atlases = []
	var json = JSON.parse(file.get_as_text())

	file.close()
	print(ResourceSaver.get_recognized_extensions(resource))
	if json.error == OK and "regions" in json.result:
		
		var target_dir = source_file.get_base_dir().plus_file(json.result.name)
		var target_dir_sprites = source_file.get_base_dir().plus_file(json.result.name+"_sprites")
		
		# in case if image is still not imported
#		if not Directory.new().file_exists(json.result.texture_name):
#			for i in 3:
#				# attempts for load image_texture
				
		var source = load(source_file.get_base_dir().plus_file(json.result.image))
		if not Directory.new().dir_exists(target_dir):
			print_debug("Create directory ", target_dir)
			Directory.new().make_dir(target_dir)
		if options["generate_sprites"] and not Directory.new().dir_exists(target_dir_sprites):
			print_debug("Create directory ", target_dir_sprites)
			Directory.new().make_dir(target_dir_sprites)
			
		
			
		for region in json.result.regions:
			print_debug("Import region ", region)
			var tex = AtlasTexture.new()
			# Fill the Mesh with data read in "file", left as an exercise to the reader
			tex.atlas = source
			tex.region = Rect2(region.rect[0],
								region.rect[1],
								region.rect[2],
								region.rect[3])
			var filename = target_dir.plus_file(region.name+".atlastex")
			ResourceSaver.save(filename, tex)
			resource.atlases.append(tex)
			if options["generate_sprites"]:
				var sprite = Sprite.new()
				sprite.name = region.name
				sprite.texture = tex
				sprite.centered = false
				sprite.offset.x = - region.origin[0]
				sprite.offset.y = - region.origin[1]
				var scene = PackedScene.new()

				var result = scene.pack(sprite)
				if result == OK:
					var error = ResourceSaver.save(
							target_dir_sprites.plus_file(region.name+".scn"), 
							scene) 
					if error != OK:
						push_error("Error while creating sprite " + region.name)

		
		var err = ResourceSaver.save(save_path+"."+get_save_extension(), resource)
		print(err)
		return OK
	else:
		print_debug("Can't parse JSON")
	return FAILED
