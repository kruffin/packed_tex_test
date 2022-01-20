# Code taken from: https://github.com/Zylann/godot_heightmap_plugin/blob/1.5.2/addons/zylann.hterrain/util/logger.gd
# HeightMap terrain for Godot Engine
#------------------------------------
#Copyright (c) 2016-2020 Marc Gilleron
#Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
#The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

class Base:
	var _context := ""
	
	func _init(p_context):
		_context = p_context
	
	func debug(msg: String):
		pass

	func warn(msg: String):
		push_warning("{0}: {1}".format([_context, msg]))
	
	func error(msg: String):
		push_error("{0}: {1}".format([_context, msg]))


class Verbose extends Base:
	func _init(p_context: String).(p_context):
		pass
		
	func debug(msg: String):
		print(_context, ": ", msg)


static func get_for(owner: Object) -> Base:
	# Note: don't store the owner. If it's a Reference, it could create a cycle
	var context = owner.get_script().resource_path.get_file()
	if OS.is_stdout_verbose():
		return Verbose.new(context)
	return Base.new(context)

