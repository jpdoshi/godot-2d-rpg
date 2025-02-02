extends Node2D

func _on_world_trigger_body_entered(body):
	if (body.has_method("player")):
		global.spawn_point = 'exit_cliff'
		get_tree().change_scene_to_file("res://scenes/world.tscn")
