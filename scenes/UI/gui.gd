extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var canvas_modulate: CanvasModulate = $CanvasModulate
@onready var texture_rect: TextureRect = $TextureRect

var paths = ["res://assets/Masks/Red_Carnival_Mask_PNG_Clip_Art_Image.png", "res://assets/Masks/oni.png"]
var index = 0

var isApplied = false
var canInteract = true

func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("change_forward") || Input.is_action_just_pressed("change_backward"):
		if canInteract:
			canInteract = false
			animation_player.stop()
			animation_player.play("change_mask")
			index = (index + 1) % 2
			await get_tree().create_timer(0.4, true).timeout
			texture_rect.texture = load(paths[index])
			await get_tree().create_timer(0.9, true).timeout
			canInteract = true
	if Input.is_action_just_pressed("apply_mask"):
		if isApplied:
			canvas_modulate.color = Color.WHITE
		if !isApplied:
			canvas_modulate.color = Color.AQUA 
		isApplied = !isApplied
			
