extends Node2D

@onready
var jogador = $Jogador
@onready
var tile_map = $TileMap

var personagens = []
var turno = 0

var inimigo_morto = preload("res://Assets/dead-sponge.png")

func _ready():
	print(tile_map.get_used_rect())
	jogador.turno_ativo = true
	jogador.celula_atual = tile_map.local_to_map(jogador.position)
	personagens.append(jogador)
	for i in get_node("Inimigos").get_children():
		personagens.append(i)
		muda_tiles(i)
	
	muda_tiles(jogador)

func passa_turno():
	get_node("CanvasLayer/Retratos/" + str(personagens[turno].name)).position.y = 42
	turno += 1
	if turno > (personagens.size() - 1):
		get_node("CanvasLayer/Label2").text = "Ataques restantes: " + str(jogador.ataques_por_turno)
		turno = 0
	var personagem = personagens[turno]
	muda_tiles(personagem)
	if turno > 0:
		personagem.posicao_do_jogador_no_tilemap = tile_map.local_to_map(jogador.position)
		personagem.posicao_no_tilemap = tile_map.local_to_map(personagem.position)
		
	personagem.turno_ativo = true
	get_node("CanvasLayer/Retratos/" + str(personagem.name)).position.y = 60

func eh_mapa(coords):
	return tile_map.get_cell_source_id(0, coords)

func muda_tiles(personagem):
	
	if personagem == jogador:
		get_node("CanvasLayer/Label").text = "Movimentos restantes: " + str(personagem.movimento_restante)
	else:
		get_node("CanvasLayer/Label").text = ""
	pass
	

func deixa_pra_depois(personagem):
	var posicao_do_personagem = tile_map.local_to_map(personagem.position)
	var movimento = personagem.movimento_restante
	if personagem == jogador: 
		tile_map.set_cell(0, posicao_do_personagem, 0, Vector2i(1,0), 0)
	else:
		tile_map.set_cell(0, posicao_do_personagem, 0, Vector2i(0,1), 0)
	
	
	var tile = Vector2i(0,0)
	for i in movimento+1:
		if i+1 == movimento+1:
			tile = Vector2i(1,1)
			
		if tile_map.get_cell_atlas_coords(0, posicao_do_personagem + Vector2i(i+1, 0)) != Vector2i(-1, -1):
			tile_map.set_cell(0, posicao_do_personagem + Vector2i(i+1, 0), 0, tile, 0)
		if tile_map.get_cell_atlas_coords(0, posicao_do_personagem + Vector2i(0, i+1)) != Vector2i(-1, -1):
			tile_map.set_cell(0, posicao_do_personagem + Vector2i(0, i+1), 0, tile, 0)
		
		if tile_map.get_cell_atlas_coords(0, posicao_do_personagem - Vector2i(0, i+1)) != Vector2i(-1, -1):
			tile_map.set_cell(0, posicao_do_personagem - Vector2i(0, i+1), 0, tile, 0)
		if tile_map.get_cell_atlas_coords(0, posicao_do_personagem - Vector2i(i+1, 0)) != Vector2i(-1, -1):
			tile_map.set_cell(0, posicao_do_personagem - Vector2i(i+1, 0), 0, tile, 0)

func tira_inimigo(inimigo):
	get_node("CanvasLayer/Retratos/" + str(inimigo.name)).set_texture(inimigo_morto)
	var inimigo_atual = get_node("Inimigos/" + str(inimigo.name))
	var posicao = tile_map.local_to_map(inimigo_atual.position)
	tile_map.set_cell(0, posicao, 1, Vector2i(0, 0), 0)
	personagens.erase(inimigo)
	if personagens.size() == 1:
		get_node("CanvasLayer/Ganhou").visible = true


func _on_reload_pressed():
	var _reload = get_tree().reload_current_scene()
