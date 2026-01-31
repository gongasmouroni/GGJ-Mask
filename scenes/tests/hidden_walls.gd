extends Node3D




func _on_player_equip_mask(mask: int) -> void:
	if mask == 0:
		for child in get_children():
			child.on_player_equip_mask(mask)
