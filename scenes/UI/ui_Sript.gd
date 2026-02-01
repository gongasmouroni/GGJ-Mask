extends Control

@onready var mask: TextureRect = $Mask
@onready var options_menu_buttons: GridContainer = $Options_Menu_Buttons
@onready var main_menu_buttons: GridContainer = $Main_Menu_Buttons
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	mouse_filter = Control.MOUSE_FILTER_STOP
	for slot in $Main_Menu_Buttons.get_children():
		slot.mouse_entered.connect(_on_button_mouse_entered.bind(slot))

func _on_button_mouse_entered(slot:Control):
	if slot.name == "Play_Button":
		animation_player.play("Play_Button")
	if slot.name == "Options_Button":
		animation_player.play("options _Button")
	if slot.name == "Exit_Button":
		animation_player.play("quit button")

func _process(delta: float) -> void:
	pass
	
func exit_Button_On_Pressed() -> void:
	pass
	get_tree().quit()


func _on_options_button_pressed() -> void:
	main_menu_buttons.visible = false
	options_menu_buttons.visible = true
	
	


func _on_return_button_pressed() -> void:
	options_menu_buttons.visible = false
	main_menu_buttons.visible = true


func _on_play_button_pressed() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	get_tree().change_scene_to_file("res://scenes/tests/another_test.tscn")
