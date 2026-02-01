extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var canvas_modulate: CanvasModulate = $CanvasModulate
@onready var glitch_effect: Control = $GlitchEffect
@onready var mask: TextureRect = $Control/Mask

var paths = ["res://assets/Masks/mask_husk.png", "res://assets/Masks/mask_fear.png", "res://assets/Masks/mask_twoface.png", "res://assets/Masks/Mask-1-alone.png"]
var index = 0

var isApplied = false
var canInteract = true

func _unhandled_input(_event: InputEvent) -> void:
	#if Input.is_action_just_pressed("change_forward") || Input.is_action_just_pressed("change_backward"):
		#if canInteract:
			#canInteract = false
			#animation_player.stop()
			#animation_player.play("change_mask")
			#index = (index + 1) % 3
			#await get_tree().create_timer(0.4, true).timeout
			#texture_rect.texture = load(paths[index])
			#await get_tree().create_timer(0.9, true).timeout
			#canInteract = true
	if Input.is_action_just_pressed("apply_mask"):
		pass
			


func _on_player_mask_changed(index: int) -> void:
			canInteract = false
			animation_player.stop()
			animation_player.play("change_mask")
			await get_tree().create_timer(0.4, true).timeout
			mask.texture = load(paths[index])
			await get_tree().create_timer(0.9, true).timeout
			canInteract = true


func _on_player_equip_mask(mask: int) -> void:
	if mask == 0:
		if isApplied:
			canvas_modulate.color = Color.WHITE
		if !isApplied:
			animation_player.play("Wall_mask_Equip")
		glitch_effect.visible = !glitch_effect.visible	 
		isApplied = !isApplied
	elif mask == 1:
		if isApplied:
			canvas_modulate.color = Color.WHITE
		if !isApplied:
			animation_player.play("Jump_mask_Equip")
		glitch_effect.visible = !glitch_effect.visible
		isApplied = !isApplied
	elif mask == 2:
		if isApplied:
			canvas_modulate.color = Color.WHITE
		if !isApplied:
			animation_player.play("Dash_mask_Equip")
		glitch_effect.visible = !glitch_effect.visible
		isApplied = !isApplied
