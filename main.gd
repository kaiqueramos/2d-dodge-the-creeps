extends Node

@export var mob_scene : PackedScene

var score = 0

func _ready():
	randomize()
	
func new_game():
	score = 0
	$HUD.update_score(score)
	
	get_tree().call_group("mobs", "queue_free")
	$Player.start($StartPosition.position)
	
	$StartTimer.start()
	$Music.play()
	
	$HUD.show_message("Get ready...")
	await $StartTimer.timeout
	$ScoreTimer.start()
	$MobTimer.start()
	
	
func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	$Music.stop()
	$DeathSound.play()
	
func _on_mob_timer_timeout():
	
	#Guardo o PathFollow em uma variável, que vai representar onde o mob vai spawnar
	var mob_spawn_location = $MobPath/MobSpawnLocation
	
	#defino um valor aleatório para spawnar um mob, que vai de 0 a 1
	mob_spawn_location.progress_ratio = randf()
	
	#crio a variavel do mob instanciado e adiciono na scene tree
	var mob = mob_scene.instantiate()
	add_child(mob)
	
	#defino a posição do mob como a posição do spawner
	mob.position = mob_spawn_location.position
	
	#defino a direção como sendo 90º da direção original
	var direction = mob_spawn_location.rotation + PI/2
	
	#adiciono mais uma direção randomica, que vai de -45º até 45º
	direction += randf_range(-PI / 4, PI / 4)
	
	#defino a rotação do mob como a direção calculada antes
	mob.rotation = direction
	
	#sobre a velocidade, defino um valor randomico no x positivo baseado no valor configurado no script do mob
	#esse valor fará o mob ir para a direita independente da rotação, ou seja, sempre vai de um lado da tela para o outro.
	var velocity = Vector2(randf_range(mob.min_speed, mob.max_speed), 0)
	
	#por fim, adiciono a velocidade ao mob a partir da direção que ele se encontra
	mob.linear_velocity = velocity.rotated(direction)


func _on_score_timer_timeout():
	score += 1
	$HUD.update_score(score)
