# Taken from: https://github.com/Zylann/godot_heightmap_plugin/blob/1.5.2/addons/zylann.hterrain/tools/util/result.gd
# HeightMap terrain for Godot Engine
#------------------------------------
#Copyright (c) 2016-2020 Marc Gilleron
#Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
#The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

# Data structure to hold the result of a function that can be expected to fail.
# The use case is to report errors back to the GUI and act accordingly,
# instead of forgetting them to the console or having the script break on an assertion.
# This is a C-like way of things, where the result can bubble, and does not require globals.

tool

# Replace `success` with `error : int`?
var success := false
var value = null
var message := ""
var inner_result = null


func _init(p_success: bool, p_message := "", p_inner = null):
	success = p_success
	message = p_message
	inner_result = p_inner


# TODO Can't type-hint self return
func with_value(v):
	value = v
	return self


func get_message() -> String:
	var msg := message
	if inner_result != null:
		msg += "\n"
		msg += inner_result.get_message()
	return msg


func is_ok() -> bool:
	return success
