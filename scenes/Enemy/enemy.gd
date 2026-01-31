extends CharacterBody3D

@export var playerPath : NodePath

@onready var navigation_region_3d: NavigationRegion3D = $"../NavigationRegion3D"
@onready var navAgent: NavigationAgent3D = $NavigationAgent3D

var player = null
var currentDestiny : Vector3
var speed = 1.8

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if (playerPath):
		player = get_node(playerPath)
	if (player == null):
		currentDestiny = NavigationServer3D.region_get_random_point(navigation_region_3d.get_rid(), 1, false)
		navAgent.set_target_position(currentDestiny)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if (player != null):
		look_at(Vector3(player.global_position.x, global_position.y, player.global_position.z), Vector3.UP)

func _physics_process(_delta: float) -> void:
	if (player == null):
		velocity = Vector3.ZERO
		if (navAgent.is_target_reached() || !navAgent.is_target_reachable() || navAgent.target_position == Vector3.ZERO):
			#print("RAND:", NavigationServer3D.region_get_random_point(navigation_region_3d.get_rid(), 1, false))
			currentDestiny = NavigationServer3D.region_get_random_point(navigation_region_3d.get_rid(), 1, false)
			navAgent.set_target_position(currentDestiny)
		var next_location = navAgent.get_next_path_position()
		velocity = (next_location - global_transform.origin).normalized() * speed
		#print("RAND:", NavigationServer3D.region_get_random_point(navigation_region_3d.get_rid(), 1, false))
		#print("Next Location: ", next_location)
		#print("navAgent next path: ", navAgent.get_next_path_position())
		#print("Self postion: ", self.position)
		#print("curr Des: ", currentDestiny)
		look_at(Vector3(next_location.x, global_position.y, next_location.z), Vector3.UP)
		move_and_slide()
