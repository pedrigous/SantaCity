extends CharacterBody2D

@onready var animacao_player: AnimatedSprite2D = $AnimatedSprite2D
const MAX_JUMP = 2
var jump_count = 0
const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var direction = 0

enum EstadoPlayer{
	andando,
	pulando,
	parado,
	caindo
}
var estado_atual: EstadoPlayer
var direcao = 0

var estado: EstadoPlayer

func _ready() -> void:
	preparar_parado()


func _physics_process(delta: float) -> void:
	match estado_atual:
		EstadoPlayer.parado:
			parado(delta)
		EstadoPlayer.andando:
			andando(delta)
		EstadoPlayer.pulando:
			pulando(delta)
		EstadoPlayer.caindo:
			caindo(delta)
	

	move_and_slide()


func ativar_gravidade (delta):
	if not is_on_floor():
		velocity += get_gravity() * delta
	
func mover(delta):
	if direction:
		velocity.x = move_toward(velocity.x, direction * SPEED, 400 * delta)
	else:
		velocity.x = move_toward(velocity.x, 0 * SPEED, 400 * delta)

func atualizar_animacao():
	direction = Input.get_axis("left", "right")
	if direction < 0:
		animacao_player.flip_h = true
	elif direction > 0:
		animacao_player.flip_h = false
		
func preparar_parado():
	estado_atual = EstadoPlayer.parado
	animacao_player.play("parado")

func pode_pular():
	if jump_count < MAX_JUMP:
		return true
	else:
		return false
		
func pulando(delta):
	ativar_gravidade(delta)
	mover(delta)
	
	if Input.is_action_just_pressed("jump") && pode_pular():
		return
	if velocity.y > 0:
		return

func parado(delta):
	ativar_gravidade(delta)
	mover(delta)
	if velocity.x != 0 :
		return

func andando(delta):
	ativar_gravidade(delta)
	mover(delta)
	
	if velocity.x == 0:
		preparar_parado()
		return
		
	if Input.is_action_just_pressed("jump"):
		preparar_pulo()
		return
	
	if not is_on_floor():
		jump_count +=1
		preparar_caindo()
		return
	
func caindo(delta):
	ativar_gravidade(delta)
	mover(delta)
	
	if Input.is_action_just_pressed("pular") and pode_pular():
		preparar_pulo()
		return
	
	if is_on_floor():
		jump_count = 0
		
		if velocity.x == 0:
			preparar_parado()
		else:
			preparar_andando()
		return
	
func preparar_pulo():
	estado_atual = EstadoPlayer.pulando
	animacao_player.play("pulando")
	velocity.y = JUMP_VELOCITY
	jump_count += 1
	

func preparar_andando():
	estado_atual = EstadoPlayer.andando
	animacao_player.play("andando")

func preparar_caindo():
	estado_atual = EstadoPlayer.caindo
	animacao_player.play("parado")
