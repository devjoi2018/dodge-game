extends Node

@export var mob_scene: PackedScene
var score

func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	
func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	get_tree().call_group("mobs", "queue_free")


func _on_player_hit():
	game_over()


func _on_score_timer_timeout():
	score += 1
	$HUD.update_score(score)


func _on_start_timer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()


func _on_mob_timer_timeout():
	# Crea la instancia de la escena de un nuevo Mob
	var mob = mob_scene.instantiate()
	
	# Selecciona la ubicacion de forma aleatoria de Path2D
	var mob_spawn_location = get_node("MobPath/MobSpawnLocation")
	mob_spawn_location.progress_ratio = randi()
	
	# Establece la direccion perpendicular para la direccion de la ruta
	var direction = mob_spawn_location.rotation + PI / 2
	
	# Establece la posicion aleatorio del mob
	mob.position = mob_spawn_location.position
	
	# Agrega algunas direcciones aleatorias
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction
	
	# Selecciona la velocidad para el mob
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)
	
	add_child(mob)


func _on_hud_start_game():
	new_game()
