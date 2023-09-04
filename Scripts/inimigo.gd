extends Area2D

@export var movimento_por_turno: int = 2
@export var vida: int = 3

var ataques = 1
var movimento_restante
var pode_andar = true
var posicao_do_jogador_no_tilemap
var posicao_no_tilemap

var jogador_na_area = null

var astargrid

var turno_ativo = false

func _ready():
	astargrid = AStarGrid2D.new()
	astargrid.size = Vector2i(24, 24)
	astargrid.cell_size = Vector2i(32, 32)
	astargrid.diagonal_mode = 1
	astargrid.update()
	movimento_restante = movimento_por_turno

func _process(delta):
	if turno_ativo and pode_andar:
		if movimento_restante > 0:
			var caminho = pega_direcao()
			if caminho != null:
				anda(caminho)
			else:
				movimento_restante = 0
			pode_andar = false
			get_node("Timer").start()
		elif ataques == 1 and jogador_na_area:
			jogador_na_area.atacado()
			ataques = 0
		else:
			passa_turno()

func passa_turno():
	turno_ativo = false
	ataques = 1
	movimento_restante = movimento_por_turno
	owner.passa_turno()

func pega_direcao():
	var caminho = astargrid.get_id_path(posicao_no_tilemap, posicao_do_jogador_no_tilemap)
	if caminho.size() > 2:
		return caminho[1]
	else:
		return null

func anda(nova_posicao):
	self.global_position = get_parent().get_parent().tile_map.map_to_local(nova_posicao)
	posicao_no_tilemap = nova_posicao
	movimento_restante -= 1

func _on_timer_timeout():
	pode_andar = true

func _on_area_entered(area):
	if area.name == "Jogador":
		jogador_na_area = area


func _on_area_exited(area):
	if area.name == "Jogador":
		jogador_na_area = null

func morre():
	owner.tira_inimigo(self)
	queue_free()
