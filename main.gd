extends Node

@export var mob_scene: PackedScene
@export var pickup_scene: PackedScene

var score
var total_pickups: int = 0



	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func game_over() -> void:
	$ScoreTimer.stop()
	$MobTimer.stop()
	$PickupTimer.stop()
	$HUD.show_game_over()
	
func victory():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$PickupTimer.stop()
	$HUD.show_victory()
	get_tree().call_group("mobs", "queue_free")

func new_game():
	score = 30
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$PickupTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Reach your deadline!")
	
	get_tree().call_group("mobs", "queue_free")
	

func _on_mob_timer_timeout() -> void:
	var mob = mob_scene.instantiate()
	
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()
	mob.position = mob_spawn_location.position
	
	var direction = mob_spawn_location.rotation + PI / 2
	
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction
	
	var velocity = Vector2(randf_range(150.0, 250.0,), 0.0)
	
	mob.linear_velocity = velocity.rotated(direction)
	
	add_child(mob)
	


func _on_score_timer_timeout() -> void:
	score -= 1
	$HUD.update_score(score)
	
	if score == 0:
		victory()
		
		

func _on_start_timer_timeout() -> void:
	$MobTimer.start()
	$ScoreTimer.start()
	$PickupTimer.start()
	


func _on_pickup_timer_timeout() -> void:
	var pickup = pickup_scene.instantiate()
	
	var pickup_spawn_location = $MobPath/MobSpawnLocation
	pickup_spawn_location.progress_ratio = randf()
	pickup.position = pickup_spawn_location.position
	
	var direction = pickup_spawn_location.rotation + PI / 2
	
	direction += randf_range(-PI / 4, PI / 4)
	pickup.rotation = direction
	
	var velocity = Vector2(randf_range(150.0, 250.0,), 0.0)
	
	pickup.linear_velocity = velocity.rotated(direction)
	
	add_child(pickup)


func _on_player_pickup() -> void:
	total_pickups += 1
	$HUD.update_pickups(total_pickups) # Replace with function body.
