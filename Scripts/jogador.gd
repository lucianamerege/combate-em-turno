extends Area2D

var ataques_por_turno = 1
var ataques_restantes = 1

var celula_atual
var movimento_por_turno = 3
var movimento_restante = 3
var turno_ativo = false

var vida = 5
@onready
var animacao = $AnimationPlayer
@onready
var arma = $Marker2D

@export var bala : PackedScene

func atacado():
	vida -= 1
	animacao.play("dano")
	owner.get_node("CanvasLayer/Label3").text = "Vida: " + str(vida)
	if vida == 0:
		owner.get_node("CanvasLayer/Perdeu").visible = true

func _process(delta):
	if turno_ativo and vida > 0:
		look_at(get_global_mouse_position())
		if Input.is_action_just_pressed("ui_cancel"):
			turno_ativo = false
			ataques_restantes = ataques_por_turno
			movimento_restante = movimento_por_turno
			owner.get_node("CanvasLayer/Label2").text = ""
			get_parent().passa_turno()
		if movimento_restante > 0:
			if Input.is_action_just_pressed("ui_right"):
				anda(Vector2i(1, 0))
			elif Input.is_action_just_pressed("ui_left"):
				anda(Vector2i(-1, 0))
			elif Input.is_action_just_pressed("ui_up"):
				anda(Vector2i(0, -1))
			elif Input.is_action_just_pressed("ui_down"):
				anda(Vector2i(0, 1))
		if Input.is_action_just_pressed("atirar") and ataques_restantes > 0:
			atira()


func atira():
	var b = bala.instantiate()
	owner.add_child(b)
	b.transform = arma.global_transform
	ataques_restantes -= 1
	owner.get_node("CanvasLayer/Label2").text = "Ataques restantes: " + str(ataques_restantes)

func anda(lado):
	if owner.eh_mapa(celula_atual + lado) != -1:
		celula_atual.x = celula_atual.x + lado.x
		celula_atual.y = celula_atual.y + lado.y
		self.global_position = owner.tile_map.map_to_local(celula_atual)
		movimento_restante -= 1
		owner.muda_tiles(self)


func _on_area_entered(area):
	if area.is_in_group("inimigo"):
		area.jogador_na_area = self

func _on_area_exited(area):
	if area.is_in_group("inimigo"):
		area.jogador_na_area = null
