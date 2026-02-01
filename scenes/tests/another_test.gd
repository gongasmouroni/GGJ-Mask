extends Node3D

@export var npcCount = 200

@export var npcScene : PackedScene

@onready var navigation_region_3d: NavigationRegion3D = $NavigationRegion3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(0.1, true).timeout
	for i in npcCount:
		var obj : CharacterBody3D = npcScene.instantiate()
		obj.position = NavigationServer3D.region_get_random_point(navigation_region_3d.get_rid(), 1, false)
		obj.position.y += 0.5
		add_child(obj)



func _on_player_equip_mask(mask: int) -> void:
	if mask == 5:
		randomize()
		var door = randi_range(1, 3)
		for i : Node3D in self.get_node("Gate" + door + " Security").get_children():
			i.queue_free()
			#i.collision_layer << 000000000
			#i.collision_mask << 00000000
