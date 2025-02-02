extends Node2D

func _on_cliff_trigger_body_entered(body):
	if (body.has_method("player")):
		global.spawn_point = 'enter_cliff'
		get_tree().change_scene_to_file("res://scenes/cliff.tscn")
