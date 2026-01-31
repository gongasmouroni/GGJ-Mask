extends Interactable

@export var texture : CompressedTexture2D

@onready var sprite_3d: Sprite3D = $Sprite3D

signal hasBeenPicked()

func _ready() -> void:
	sprite_3d.texture = texture
	prompt_message = "Pick up"



func _on_interacted(_body: Variant) -> void:
	hasBeenPicked.emit()
	queue_free()
