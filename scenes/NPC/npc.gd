extends CharacterBody3D

var player : CharacterBody3D

@export var isStatic = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if (!isStatic):
		player = get_parent().get_node("Player")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (!isStatic):
		look_at(player.position)
