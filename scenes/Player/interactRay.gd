extends RayCast3D

@onready var prompt: Label = $prompt

func _physics_process(_delta: float) -> void:
	prompt.text = ''
	
	if is_colliding():
		var collider = get_collider()

		if collider is Interactable:
			prompt.text = collider.get_Prompt()
			
			if Input.is_action_just_pressed(collider.prompt_input):
					collider.interact(owner)
