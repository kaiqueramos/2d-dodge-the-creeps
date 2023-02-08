extends RigidBody2D

@export var min_speed = 150.0
@export var max_speed = 250.0

func _ready():
	$AnimatedSprite2D.play()
	
	#é possivel recuperar os nomes das animações a partir desse método
	var mob_types = $AnimatedSprite2D.sprite_frames.get_animation_names()
	
	#randi é uma função que recupera um numero inteiro aleatório
	#essa função pega um numero inteiro bem grande, divide pelo tamanho do array e usa o resto da divisão para mudar a animação
	$AnimatedSprite2D.animation = mob_types[randi() % mob_types.size()]

#esse signal observa se o mob deixou de aparecer na tela
#caso tenha, essa função é disparada
func _on_visible_on_screen_notifier_2d_screen_exited():
	#essa função remove o mob
	queue_free()
