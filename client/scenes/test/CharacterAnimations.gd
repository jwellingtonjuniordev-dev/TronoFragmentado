extends Node2D
# Cena isolada para inspecionar frames, direcoes e ataques.
# WASD altera direcao; Espaco reproduz ataque; 1-7 seleciona personagem.
const NAMES := ["guerreiro", "arqueiro", "mago", "lobo", "saqueador", "sentinela_runica", "guardiao_tempestade", "guardiao_sino_partido"]
var selected := 0
var direction := 0
var moving := false
var attack_remaining := 0.0
var elapsed := 0.0
var textures: Dictionary = {}

func _ready() -> void:
	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	for name in NAMES:
		textures[name] = {"move": load("res://assets/characters/%s/move.png" % name), "attack": load("res://assets/characters/%s/attack.png" % name)}

func _process(delta: float) -> void:
	elapsed += delta
	attack_remaining = maxf(0.0, attack_remaining - delta)
	moving = false
	if Input.is_key_pressed(KEY_W): direction = 1; moving = true
	elif Input.is_key_pressed(KEY_S): direction = 0; moving = true
	elif Input.is_key_pressed(KEY_A): direction = 2; moving = true
	elif Input.is_key_pressed(KEY_D): direction = 3; moving = true
	if Input.is_key_pressed(KEY_SPACE) and attack_remaining <= 0.0:
		attack_remaining = 0.42
	for i in range(NAMES.size()):
		if Input.is_key_pressed(KEY_1 + i): selected = i
	queue_redraw()

func _draw() -> void:
	var name: String = NAMES[selected]
	var attacking := attack_remaining > 0.0
	var atlas: Texture2D = textures[name]["attack" if attacking else "move"]
	var frame := clampi(int((1.0 - attack_remaining / 0.42) * 8.0), 0, 7) if attacking else (int(elapsed * 8.0) % 8 if moving else 0)
	draw_texture_rect_region(atlas, Rect2(Vector2(340, 145), Vector2(160, 160)), Rect2(frame * 160, direction * 160, 160, 160))
	draw_string(ThemeDB.fallback_font, Vector2(35, 45), "Personagem: %s | 1-8 trocar | WASD mover | Espaco atacar" % name, HORIZONTAL_ALIGNMENT_LEFT, -1, 17, Color.WHITE)
	draw_string(ThemeDB.fallback_font, Vector2(35, 75), "Direcao: %d | Frame: %d | Estado: %s" % [direction, frame, "ATAQUE" if attacking else ("MOVIMENTO" if moving else "IDLE")], HORIZONTAL_ALIGNMENT_LEFT, -1, 16, Color.WHITE)
