# Code taken from: https://github.com/Zylann/godot_heightmap_plugin/blob/1.5.2/addons/zylann.hterrain/tools/packed_textures/packed_texture_importer.gd
# HeightMap terrain for Godot Engine
#------------------------------------
#Copyright (c) 2016-2020 Marc Gilleron
#Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
#The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


tool
extends EditorImportPlugin

const StreamTextureImporter = preload("./stream_texture_importer.gd")
const PackedTextureUtil = preload("./packed_texture_util.gd")
const Errors = preload("../../util/errors.gd")
const Result = preload("../util/result.gd")
const Logger = preload("../../util/logger.gd")

const IMPORTER_NAME = "hterrain_packed_texture_importer"
const RESOURCE_TYPE = "StreamTexture"

var _logger = Logger.get_for(self)


func get_importer_name() -> String:
	return IMPORTER_NAME


func get_visible_name() -> String:
	# This shows up next to "Import As:"
	return "HTerrainPackedTexture"


func get_recognized_extensions() -> Array:
	return ["packed_tex"]


func get_save_extension() -> String:
	return "stex"


func get_resource_type() -> String:
	return RESOURCE_TYPE


func get_preset_count() -> int:
	return 1


func get_preset_name(preset_index: int) -> String:
	return ""


func get_import_options(preset_index: int) -> Array:
	return [
		{
			"name": "compress/mode",
			"default_value": StreamTextureImporter.COMPRESS_VIDEO_RAM,
			"property_hint": PROPERTY_HINT_ENUM,
			"hint_string": StreamTextureImporter.COMPRESS_HINT_STRING
		},
		{
			"name": "flags/repeat",
			"default_value": StreamTextureImporter.REPEAT_ENABLED,
			"property_hint": PROPERTY_HINT_ENUM,
			"hint_string": StreamTextureImporter.REPEAT_HINT_STRING
		},
		{
			"name": "flags/filter",
			"default_value": true
		},
		{
			"name": "flags/mipmaps",
			"default_value": true
		}
	]


func get_option_visibility(option: String, options: Dictionary) -> bool:
	return true


func import(p_source_path: String, p_save_path: String, options: Dictionary, 
	r_platform_variants: Array, r_gen_files: Array) -> int:

	var result := _import(p_source_path, p_save_path, options, r_platform_variants, r_gen_files)
	
	if not result.success:
		_logger.error(result.get_message())
		# TODO Show detailed error in a popup if result is negative
	
	var code : int = result.value
	return code


func _import(p_source_path: String, p_save_path: String, options: Dictionary, 
	r_platform_variants: Array, r_gen_files: Array) -> Result:
	
	var f := File.new()
	var err := f.open(p_source_path, File.READ)
	if err != OK:
		return Result.new(false, "Could not open file {0}: {1}" \
			.format([p_source_path, Errors.get_message(err)])) \
			.with_value(err)
	var text := f.get_as_text()
	f.close()
	
	var json_result := JSON.parse(text)
	if json_result.error != OK:
		return Result.new(false, "Failed to parse file {0}: {1}" \
			.format([p_source_path, json_result.error_string])) \
			.with_value(json_result.error)
	var json_data : Dictionary = json_result.result
	
	var resolution : int = int(json_data.resolution)
	var contains_albedo : bool = json_data.get("contains_albedo", false)
	var sources = json_data.get("src")

	var result := PackedTextureUtil.generate_image(sources, resolution, _logger)
	
	if not result.success:
		return Result.new(false, 
			"While importing {0}".format([p_source_path]), result) \
			.with_value(result.value)

	var image : Image = result.value
	
	result = StreamTextureImporter.import(
		p_source_path, 
		image,
		p_save_path,
		r_platform_variants,
		r_gen_files,
		contains_albedo,
		get_visible_name(),
		options["compress/mode"],
		options["flags/repeat"],
		options["flags/filter"],
		options["flags/mipmaps"])
	
	if not result.success:
		return Result.new(false, 
			"While importing {0}".format([p_source_path]), result) \
			.with_value(result.value)
	
	return Result.new(true).with_value(OK)

