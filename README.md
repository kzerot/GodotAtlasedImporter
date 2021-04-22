<style>
body {
  max-width:90%;
}
img[src*="#center"]{
border: 1px solid #ddd;
border-radius: 4px;
padding: 3px;
display: block;
margin-left: auto;
margin-right: auto;
width: 956px;
height: auto;
}

img[src*="#logo"]{
  display: block;
  float: right;
  width: 180px;
  height:auto;
  padding: 3px;
}

img[src*="#image_small"]{
border: 1px solid #ddd;
border-radius: 4px;
padding: 3px;
display: block;
margin-right: auto;
width: 680px;
height: auto;
}

img[src*="#image_extra_small"]{
border: 1px solid #ddd;
border-radius: 4px;
padding: 3px;
display: block;
margin-right: auto;
width: 480px;
height: auto;
}
</style>

# Godot import plugin for Atlased files

This plugin imports sprite sheet files from <a href="https://witnessmonolith.itch.io/atlased" target="_blank" rel="noopener">Atlased editor</a> into <a href="https://godotengine.org" target="_blank">Godot engine</a>.
**Features:**
* Create <a href="https://docs.godotengine.org/en/stable/classes/class_atlastexture.html" target="_blank" rel="noopener noreferrer">AtlasTextures</a> which correspond to each individual sprite
* Create <a href="https://docs.godotengine.org/en/3.3/classes/class_tilemap.html" target="_blank" rel="noopener noreferrer">TileMap</a> and <a href="https://docs.godotengine.org/en/3.3/classes/class_tileset.html#class-tileset" target="_blank" rel="noopener noreferrer">TileSet</a>
* Create separate <a href="https://docs.godotengine.org/en/stable/classes/class_sprite.html" target="_blank" rel="noopener noreferrer">Sprite</a> for each individual atlas region as a packed scene

## Installation
* Download project from <a href="https://github.com/kzerot/GodotAtlasedImporter" target="_blank" rel="noopener">Github</a>
* You're interested in the **"addons" folder**. Create a folder of the same name inside your project and copy **addons/atlased_importer** to your "addons".
* Open your **"Project settings - Plugins"**, check the **Enabled** checkbox in the row with **AtlasedImporter** plugin.

## Basic usage

1. Within the **Godot** editor's **"Filesystem" tab** prepare **your directory** where your **assets will reside**
2. **Import the PNG sprite sheet first** by dragging it into Godot folder that you've created
3. Make sure to <a href="https://docs.godotengine.org/en/stable/getting_started/workflow/assets/import_process.html" target="_blank" rel="noopener noreferrer">set up texture import parameters</a> to best fit within your needs (for instance, disable "Filter" for pixel-art)
4. Import **Atlased JSON** file by dragging it into the **same directory** as you used for the **PNG image**.
5. **By default**, plugin will create a **new folder** named after Atlased sprite sheet and place a bunch of **.atlastex files** there. These are <a href="https://docs.godotengine.org/en/stable/classes/class_atlastexture.html" target="blank" rel="noopener noreferrer">AtlasTextures</a> - Godot engine's instrument to use sub-regions of a single <a href="https://docs.godotengine.org/en/stable/classes/class_texture.html#class-texture" target="_blank" rel="noopener noreferrer">Texture</a>.

## Creating Tilemap and Tileset

Godot engine has a pretty nice built-in support for tile-based levels and you could benefit from that :)
Please make sure to check out <a href="https://docs.godotengine.org/en/stable/tutorials/2d/using_tilemaps.html" target="_blank" rel="noopener noreferrer">how to use tilemaps in Godot engine</a>

Here's how **automatically create a Tileset and a Tilemap** out of your freshly imported Atlased files:

1. Inside **Godot** engine's **"Filesystem tab"** select your **Atlased JSON file**.
2. Now go to the **"Import" tab**
3. Check **"Generate Tileset"**
4. *(Optional)* check **Generate Tilemap** to create your tilemap as a separate scene file
5. Press **"Reimport"** button
6. *(Optional)* check **Use Offset For Tileset** if you want your tiles be offset to bottom-left by a half of their size. 

![Reimport with TileMap and TileSet generation](https://raw.githubusercontent.com/kzerot/GodotAtlasedImporter/main/readme_img/generate_tileset.png#image_extra_small)

After that you can review your newly created tileset.
![Atlased-based tileset inside Godot engine](https://raw.githubusercontent.com/kzerot/GodotAtlasedImporter/main/readme_img/tileset.png#image_small)
*<div style="text-align:right"><a href="https://opengameart.org/content/a-platformer-in-the-forest" target="_blank" rel="noopener">Platformer in the forest"</a> pixel-art by  <a href="https://opengameart.org/users/buch" target="_blank" rel="noopener">Buch</a></div>*

### Manually created TileMap
Now, create <a href="https://docs.godotengine.org/en/3.3/classes/class_tilemap.html" target="_blank" rel="noopener noreferrer">TileMap</a> node inside your scene.
Select it, open **Inspector tab** and drag your fresh tileset ***.tres file** into **Tile Set** field of TileMap properties.
![Godot TileMap settings](https://raw.githubusercontent.com/kzerot/GodotAtlasedImporter/main/readme_img/tilemap_settings.png#image_extra_small)
You may also need to adjust **Cell->Size** to match your tile size.
Enjoy :)

### TileMap generated by the plugin
If you've checked the **Generate Tilemap** checkbox inside **Import tab** for Atlased JSON file, the **Reimport** process would generate a separate TileMap for you.
It is a <a href="https://docs.godotengine.org/en/stable/classes/class_packedscene.html" target="_blank" rel="noopener noreferrer">PackedScene</a>.
To use it in your level, simply select appropriate parent Node in the **Scene tab** and use **Instance child scene** from it's context menu.

Now go create some tile-based level design goodness! :)

![Godot tilemap example using Atlased sprite sheet](https://raw.githubusercontent.com/kzerot/GodotAtlasedImporter/main/readme_img/example_map.png#image_small)

## Sprites

To have yourself a collection of separate Sprite objects in the form of <a href="https://docs.godotengine.org/en/stable/classes/class_packedscene.html" target="_blank" rel="noopener noreferrer">PackedScene</a> instances, select Atlased JSON file in the **Filesystem tab**, go to the **Import tab** and check **Generate Sprites**.
Press **Reimport button** and plugin will create new *_sprites directory for you, filling it with PackedScenes containing <a href="https://docs.godotengine.org/en/stable/classes/class_sprite.html" target="_blank" rel="noopener noreferrer">Sprite</a> node.

![Sprites generated from Atlased inside Godot](https://raw.githubusercontent.com/kzerot/GodotAtlasedImporter/main/readme_img/sprites.png#image_small)

Now use these generated Sprites inside your game scene like this:
```gdscript
extends Node

var chest = preload("res://tilemap_buch/sheet_sprites/chest1.scn").instance()

func _ready():
	add_child(chest)
```

Stay great, have fun and make some good games! :)