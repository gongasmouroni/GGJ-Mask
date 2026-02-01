extends CharacterBody3D

@onready var navAgent: NavigationAgent3D = $NavigationAgent3D

@export var player : CharacterBody3D = null
var currentDestiny : Vector3
var speed = 4
var movement_delta : float
@onready var path_cooldown: Timer = $pathCooldown
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if player and path_cooldown.is_stopped():
		navAgent.target_position = player.global_position
		path_cooldown.start()
	
	var next_path_position: Vector3 = navAgent.get_next_path_position()
	var direction: Vector3 = global_position.direction_to(next_path_position)
	velocity = direction * speed
	move_and_slide()
	
func _on_velocity_computed(safe_velocity: Vector3) -> void:
	pass
