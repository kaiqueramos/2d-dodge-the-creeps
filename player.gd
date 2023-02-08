extends Area2D

#o @export permite que eu veja a variável no inspector
#essa variável controla a velocidade que o personagem se move
#é necessário deixar o valor "alto" por que ele será multiplicado pelo delta, para que haja fluidez nos movimentos.
@export var speed = 400.0

var screen_size = Vector2.ZERO

#o modificador signal é próprio do gdscript
#ele cria um sinal customizado que posso disparar a qualquer momento
signal hit

func _ready():
	#carrega na variável o tamanho máximo da tela para que seja possível usar depois
	screen_size = get_viewport_rect().size
	hide()

func _process(delta):
	
	#por padrão o valor da direção do player será zero
	var direction = Vector2.ZERO
	
	#verifica se o botão foi pressionado e muda a direção de acordo com o botão
	if Input.is_action_pressed("ui_right"):
		direction.x += 1
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
		
	if Input.is_action_pressed("ui_up"):
		direction.y -= 1
	if Input.is_action_pressed("ui_down"):
		direction.y += 1
	
	#caso dois botões sejam pressionados ao mesmo tempo, poderá gerar bugs no jogo em questão de movimentação
	#a função normalized ajusta isso
	if direction.length() > 0:
		direction.normalized()
		
		#usando o sinal $ é possivel acessar os nodes da cena diretamente e com casting, e assim executar as ações desses nodes
		#no exemplo eu consigo acessar o node de animação e dar play na animação
		$AnimatedSprite2D.play()
	else:
		#e então pausar a mesma.
		$AnimatedSprite2D.stop()
	
	#por fim modifico a posição de fato, multiplicando pela velocidade e por delta
	position += direction * speed * delta
	
	#é necessário que o personagem fique preso a tela exibida
	#o clamp ajuda nesse caso. Essa função recebe 3 parâmetros
	#a posição atual do objeto, o valor mínimo e o máximo que o objeto pode percorrer
	#é possivel fazer na mão, mas essa função já ajuda muito
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	
	#também é possivel mudar a animação que está tocando apenas atribuindo a animação
	#e a direção do sprite, além de ser possível espelhar em todas as direções
	if direction.x != 0:
		$AnimatedSprite2D.animation = "right"
		$AnimatedSprite2D.flip_h = direction.x < 0
		$AnimatedSprite2D.flip_v = false
	elif direction.y != 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = direction.y > 0

#essa função é chamada para inicializar o player corretamente
func start(new_position):
	#recebo a posição via parâmetro
	position = new_position
	
	#mostra o item no canvas se ele estiver escondido
	show()
	
	#reativa o colision shape para que ele possa ter efeito no game
	$CollisionShape2D.disabled = false
	
func _on_body_entered(body):
	#esconde o item no canvas
	hide()
	
	#o set_deferred aciona um parâmetro do script via setter, o que é muito mais seguro para modificações em tempo de execução
	#nele passamos qual parâmetro deve ser alterado, e o valor que deve-se passar para o parâmetro
	#nesse caso, desabilita-se o colision shape no mundo do jogo, para que ele não tenha efeito
	$CollisionShape2D.set_deferred("disabled", true)
	
	#emite o sinal para que seja possível recebe-lo em outro local
	#emite tanto sinais padrões quanto sinais personalizados
	emit_signal("hit")
	
	
	
