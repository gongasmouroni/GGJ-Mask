extends CharacterBody3D

#Export vars
@export var SPEED = 5.0
@export var JUMP_VELOCITY = 4.5
@export var lookSpeed = 0.002
@export var sprintMult = 1.75

#Other nodes that matter
@onready var head: Node3D = $Head

#Variables
var look_rotation : Vector2
var finalSpeed : float

func _ready() -> void:
	look_rotation.y = rotation.y
	look_rotation.x = head.rotation.x
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_look(event.relative)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	if Input.is_action_pressed("sprint"):
		finalSpeed = SPEED * sprintMult
	else:
		finalSpeed = SPEED

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "forward", "back")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * finalSpeed
		velocity.z = direction.z * finalSpeed
	else:
		velocity.x = move_toward(velocity.x, 0, finalSpeed)
		velocity.z = move_toward(velocity.z, 0, finalSpeed)

	move_and_slide()

#Function to process camera rotation with the mouse
func rotate_look(rot_input : Vector2):
	look_rotation.x -= rot_input.y * lookSpeed
	look_rotation.x = clamp(look_rotation.x, deg_to_rad(-70), deg_to_rad(70))
	look_rotation.y -= rot_input.x * lookSpeed
	transform.basis = Basis()
	rotate_y(look_rotation.y)
	head.transform.basis = Basis()
	head.rotate_x(look_rotation.x)
