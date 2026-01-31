extends Node3D

@export var npcCount = 200

@export var npcScene : PackedScene

@onready var navigation_region_3d: NavigationRegion3D = $NavigationRegion3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	await get_tree().create_timer(0.1, true).timeout
	for i in npcCount:
		var obj : CharacterBody3D = npcScene.instantiate()
		obj.position = NavigationServer3D.region_get_random_point(navigation_region_3d.get_rid(), 1, false)
		obj.scale = Vector3(0.2, 0.2, 0.2)
		add_child(obj)
