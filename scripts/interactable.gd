extends CollisionObject3D
class_name Interactable

signal interacted(body)

var prompt_message = "Interact"

@export var prompt_input = "interact"

func get_Prompt():
	var keyname = ""
	for action in InputMap.action_get_events(prompt_input):
		if action is InputEvent:
			keyname = action.as_text_physical_keycode()
			break;
	
	return prompt_message + "\n[" + keyname + "]"

func interact(body):
	interacted.emit(body)
