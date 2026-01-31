extends StaticBody3D

@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D
@onready var cpu_particles_3d: CPUParticles3D = $CPUParticles3D

var isApplied = false

@export var staticWall = true

func _unhandled_input(_event: InputEvent) -> void:
	if !staticWall:
		if Input.is_action_just_pressed("apply_mask"):
			self.visible = isApplied
			collision_shape_3d.disabled = !isApplied
			cpu_particles_3d.emitting = !isApplied
			isApplied = !isApplied
