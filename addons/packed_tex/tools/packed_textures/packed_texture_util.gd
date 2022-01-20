# Code taken from: https://github.com/Zylann/godot_heightmap_plugin/blob/1.5.2/addons/zylann.hterrain/tools/packed_textures/packed_texture_util.gd
# HeightMap terrain for Godot Engine
#------------------------------------
#Copyright (c) 2016-2020 Marc Gilleron
#Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
#The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

tool

const Logger = preload("../../util/logger.gd")
const Errors = preload("../../util/errors.gd")
const Result = preload("../util/result.gd")

const _transform_params = [
	"normalmap_flip_y"
]


static func generate_image(sources: Dictionary, resolution: int, logger) -> Result:
	var image := Image.new()
	image.create(resolution, resolution, true, Image.FORMAT_RGBA8)
	
	image.lock()

	var flip_normalmap_y := false
	
	# TODO Accelerate with GDNative
	for key in sources:
		if key in _transform_params:
			continue
		
		var src_path : String = sources[key]
		
		logger.debug(str("Processing source \"", src_path, "\""))
		
		var src_image := Image.new()
		if src_path.begins_with("#"):
			# Plain color
			var col = Color(src_path)
			src_image.create(resolution, resolution, false, Image.FORMAT_RGBA8)
			src_image.fill(col)
			
		else:
			# File
			var err := src_image.load(src_path)
			if err != OK:
				return Result.new(false, "Could not open file \"{0}\": {1}" \
					.format([src_path, Errors.get_message(err)])) \
					.with_value(err)
			src_image.decompress()
		
		src_image.resize(image.get_width(), image.get_height())
		src_image.lock()
		
		# TODO Support more channel configurations
		if key == "rgb":
			for y in image.get_height():
				for x in image.get_width():
					var dst_col := image.get_pixel(x, y)
					var a := dst_col.a
					dst_col = src_image.get_pixel(x, y)
					dst_col.a = a
					image.set_pixel(x, y, dst_col)
					
		elif key == "a":
			for y in image.get_height():
				for x in image.get_width():
					var dst_col := image.get_pixel(x, y)
					dst_col.a = src_image.get_pixel(x, y).r
					image.set_pixel(x, y, dst_col)
		
		elif key == "rgba":
			# Meh
			image.blit_rect(src_image, 
				Rect2(0, 0, image.get_width(), image.get_height()), Vector2())

		src_image.unlock()

	image.unlock()
	
	if sources.has("normalmap_flip_y") and sources.normalmap_flip_y:
		_flip_normalmap_y(image)
	
	return Result.new(true).with_value(image)


static func _flip_normalmap_y(image: Image):
	image.lock()
	for y in image.get_height():
		for x in image.get_width():
			var col := image.get_pixel(x, y)
			col.g = 1.0 - col.g
			image.set_pixel(x, y, col)
	image.unlock()

