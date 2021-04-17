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
	return 	[
			{"name": "generate_sprites", "default_value": false},
			{"name": "generate_tileset", "default_value": false},
			{"name": "generate_tilemap", "default_value": false},
			{"name": "use_offset_for_tileset", "default_value": false}
			]

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
	resource.atlases = {}
	var tileset: TileSet
	if options["generate_tileset"]:
		tileset = TileSet.new()
		
	var json = JSON.parse(file.get_as_text())
	file.close()


	if json.error == OK and "regions" in json.result:
		
		var target_dir = source_file.get_base_dir().plus_file(json.result.name)
		var target_dir_sprites = source_file.get_base_dir().plus_file(json.result.name+"_sprites")
		var source = load(source_file.get_base_dir().plus_file(json.result.image))
		var tile_sizes = []
		var tile_id = 0
		
		if not Directory.new().dir_exists(target_dir):
			print_debug("Create directory ", target_dir)
			Directory.new().make_dir(target_dir)
		if options["generate_sprites"] and not Directory.new().dir_exists(target_dir_sprites):
			print_debug("Create directory ", target_dir_sprites)
			Directory.new().make_dir(target_dir_sprites)
	
		var max_size = Vector2()
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
			tex.take_over_path(filename)
			resource.atlases[region.name] = tex
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
			# Generate tileset
			if options["generate_tileset"]:
				if "idx" in region:
					tile_id = int(region.idx)
#				var size = Vector2(region.width, region.height)
#				if not size in tile_sizes:
#					tile_sizes.append(size)
				tileset.create_tile(tile_id)
				tileset.tile_set_texture(tile_id, source)
				tileset.tile_set_region(tile_id, tex.region)
				if options["use_offset_for_tileset"]:
					tileset.tile_set_texture_offset(tile_id, Vector2(region.origin[0],
													region.origin[1]))
				tileset.tile_set_name(tile_id, region.name)
				tile_id += 1
			if max_size.x < region.rect[2] or max_size.y < region.rect[3]:
				max_size = Vector2(region.rect[2], region.rect[3])
				
		if options["generate_tileset"]:
			print("Save tileset to ", target_dir+"_tileset.tres")
			ResourceSaver.save(target_dir+"_tileset.tres", tileset,
					ResourceSaver.FLAG_REPLACE_SUBRESOURCE_PATHS | ResourceSaver.FLAG_CHANGE_PATH)
			tileset.take_over_path(target_dir+"_tileset.tres")
			resource.tileset = tileset
			if options["generate_tilemap"]:
				var tilemap = TileMap.new()
				tilemap.tile_set = tileset
				var size = max_size
				if "using_grid" in json.result and json.result.using_grid:
					size = Vector2(
						json.result.grid_width,
						json.result.grid_height
					)
				
				tilemap.cell_size = size
				var scene = PackedScene.new()
				scene.pack(tilemap)
				print("Tilemap complete, cellsize = ", size)
				ResourceSaver.save(target_dir+"_tilemap.scn", scene,
					ResourceSaver.FLAG_REPLACE_SUBRESOURCE_PATHS | ResourceSaver.FLAG_CHANGE_PATH)

		var err = ResourceSaver.save(save_path+"."+get_save_extension(), resource,
					ResourceSaver.FLAG_REPLACE_SUBRESOURCE_PATHS | ResourceSaver.FLAG_CHANGE_PATH)
		if err == OK:
			return OK

	printerr("Can't parse JSON")
	return FAILED


