extends Node3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		animation_player.play("close")
	


func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.is_in_group("Player"):
		await get_tree().create_timer(5.0, true).timeout
		animation_player.play_backwards("close")
