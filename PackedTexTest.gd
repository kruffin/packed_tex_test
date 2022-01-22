extends Spatial

onready var mesh = $MeshInstance

func _ready():
	if !OS.has_feature("Server"):
		var mat = load("res://PackedTexTest.tres")
		mesh.mesh.surface_set_material(0, mat)

