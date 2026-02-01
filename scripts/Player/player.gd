extends CharacterBody3D

#Export vars
@export var SPEED = 5.0
@export var JUMP_VELOCITY = 4.5
@export var lookSpeed = 0.002
@export var sprintMult = 10

@onready var mask_coldown: Timer = $MaskColdown

#Sound
@onready var steps: AudioStreamPlayer = $steps
@onready var bgmusic: AudioStreamPlayer = $bgmusic

#Other nodes that matter
@onready var head: Node3D = $Head

@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var control: Control = $Control

@onready var gui: Control = $Gui

var equipedMask : int = 0
var isMaskedEquiped : bool = false
var unlockedMasks : int = 1
var finalSpeed : float

signal maskChanged(mask:int)
signal equipMask(mask:int)

#Variables
var look_rotation : Vector2

func _ready() -> void:
	look_rotation.y = rotation.y
	look_rotation.x = head.rotation.x
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_look(event.relative)
	if Input.is_action_just_pressed("change_forward") && mask_coldown.is_stopped() && !isMaskedEquiped:
		equipedMask = (equipedMask + 1) % unlockedMasks
		maskChanged.emit(equipedMask)
		mask_coldown.start()
	if Input.is_action_just_pressed("change_backward") && mask_coldown.is_stopped() && !isMaskedEquiped:
		equipedMask = equipedMask - 1
		if equipedMask < 0:
			equipedMask = unlockedMasks - 1
		maskChanged.emit(equipedMask)
		mask_coldown.start()
	if Input.is_action_just_pressed("apply_mask")  && mask_coldown.is_stopped():
		if(isMaskedEquiped):
			bgmusic.stream = load("res://assets/Sound/Musics/Mask 1.mp3")
			bgmusic.play()
		else:
			bgmusic.stream = load(str("res://assets/Sound/Musics/Mask ", equipedMask + 2,".mp3"))
			bgmusic.play()
		if(equipedMask >= 3):
				set_collision_layer_value(3, isMaskedEquiped)
				set_collision_mask_value(3, isMaskedEquiped)
		isMaskedEquiped = !isMaskedEquiped
		equipMask.emit(equipedMask)
		mask_coldown.start()


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor() and equipedMask == 1 && isMaskedEquiped:
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "forward", "back")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	if (Input.is_action_just_pressed("sprint")) && equipedMask == 2 && isMaskedEquiped:
		velocity *= 100
	
	if(!is_on_floor() || velocity == Vector3.ZERO):
		steps.playing = false
	elif is_on_floor() && velocity != Vector3.ZERO && !steps.playing:
		steps.play()
	
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



func _on_pickable_mask_has_been_picked() -> void:
	unlockedMasks += 1


func _on_end_of_level_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		animation_player.play("finishGame")
		await animation_player.animation_finished
		gui.hide()
		control.show()
		get_tree().paused = true
