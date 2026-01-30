extends Control

@onready var mask: TextureRect = $Mask
@onready var options_menu_buttons: GridContainer = $Options_Menu_Buttons
@onready var main_menu_buttons: GridContainer = $Main_Menu_Buttons

func _ready() -> void:
	for slot in $Main_Menu_Buttons.get_children():
		slot.mouse_entered.connect(_on_button_mouse_entered.bind(slot))

func _on_button_mouse_entered(slot:Control):
	if slot.name == "Play_Button":
		mask.modulate = Color(0.8, 0.2, 0.2, 1)
	if slot.name == "Options_Button":
		mask.modulate = Color(0.2, 0.8, 0.2, 1)
	if slot.name == "Exit_Button":
		mask.modulate = Color(0.2, 0.2, 0.8, 1)

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
