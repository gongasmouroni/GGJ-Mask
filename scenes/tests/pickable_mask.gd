extends Interactable

@export var texture : CompressedTexture2D
@export var EnemyScene : PackedScene
@onready var sprite_3d: Sprite3D = $Sprite3D

signal hasBeenPicked()

func _ready() -> void:
	sprite_3d.texture = texture
	prompt_message = "Pick up"



func _on_interacted(_body: Variant) -> void:
	hasBeenPicked.emit()
	var tmp : Node3D = EnemyScene.instantiate()
	tmp.player = $"../../Player"
	get_parent().add_child(tmp)
	tmp.global_position = self.global_position
	queue_free()
