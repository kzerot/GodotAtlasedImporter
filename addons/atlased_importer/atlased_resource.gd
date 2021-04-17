extends Resource

export(Dictionary) var atlases
export(TileSet) var tileset
#export var atlas_height	:= 256
#export var atlas_width 	:= 256
#export var grid_height	:= 32
#export var grid_width	:= 32
#export var atlas_name	:= ""

func get_image(img: String) -> Texture:
	if img in atlases:
		return atlases[img]
	return Texture.new()
