extends Node2D

# MVP 0.2 - procedural scenery and simple animated characters; no external assets.
# MVP 0.6.0 - texturas pixel art de autoria propria; coordenadas de colisao intactas.
var visual_terrain: Texture2D = preload("res://assets/visual060/terrain.png")
var visual_tree: Texture2D = preload("res://assets/visual060/tree.png")
var visual_houses: Array[Texture2D] = [
	preload("res://assets/visual060/house0.png"),
	preload("res://assets/visual060/house1.png"),
	preload("res://assets/visual060/house2.png"),
	preload("res://assets/visual060/house3.png")
]
var visual_icons := {
	"Espada de ferro": preload("res://assets/visual060/sword.png"),
	"Escudo de madeira": preload("res://assets/visual060/shield.png"),
	"Armadura de couro": preload("res://assets/visual060/armor.png"),
	"Pocao pequena": preload("res://assets/visual060/potion.png"),
	"Pele de lobo": preload("res://assets/visual060/pelt.png"),
	"Retalho de tecido": preload("res://assets/visual060/cloth.png")
}

# Icones oficiais recebidos na MVP 1.1.0.8.2.
var official_item_icons := {
	"Espada de ferro": preload("res://assets/icones/itens/espadas/espada_de_ferro.png"),
	"Escudo de madeira": preload("res://assets/icones/itens/escudos/escudo_de_madeira.png"),
	"Arco do Vigia Runico": preload("res://assets/icones/itens/arcos/arco_do_vigia_runico.png"),
	"Aljava do Sino Partido": preload("res://assets/icones/itens/aljavas/aljava_do_sino_partido.png"),
	"Cajado do Firmamento": preload("res://assets/icones/itens/cajados/cajado_do_firmamento.png"),
	"Orbe do Sino Partido": preload("res://assets/icones/itens/orbes_grimorios/orbe_do_sino_partido.png"),
	"Manto das Estrelas": preload("res://assets/icones/itens/tunicas/manto_das_estrelas.png"),
	"Colete da Sombra Verde": preload("res://assets/icones/itens/vestimentas_arqueiro/colete_da_sombra_verde.png"),
	"Armadura do trono": preload("res://assets/icones/itens/armaduras/armadura_do_trono.png"),
	"Picareta de aco": preload("res://assets/icones/itens/ferramentas/picareta_de_aco.png"),
	"Pocao pequena": preload("res://assets/icones/itens/consumiveis/pocao_pequena.png"),
	"Presa de lobo": preload("res://assets/icones/itens/materiais/presa_de_lobo.png"),
	"Marca da Tempestade": preload("res://assets/icones/itens/itens_especiais/marca_da_tempestade.png"),
	"Espada de cavaleiro": preload("res://assets/icones/itens/espadas/espada_de_cavaleiro.png"),
	"Lamina de presas": preload("res://assets/icones/itens/espadas/lamina_de_presas.png"),
	"Espada ancestral": preload("res://assets/icones/itens/espadas/espada_ancestral.png"),
	"Espada do saqueador": preload("res://assets/icones/itens/espadas/espada_do_saqueador.png"),
	"Lamina da Vigilia Runica": preload("res://assets/icones/itens/espadas/lamina_da_vigilia_runica.png"),
	"Espada de aco do Guardiao": preload("res://assets/icones/itens/espadas/espada_de_aco_do_guardiao.png"),
	"Espada da Guarda de Valedouro": preload("res://assets/icones/itens/espadas/espada_da_guarda_de_valedouro.png"),
	"Lamina real de Valedouro": preload("res://assets/icones/itens/espadas/lamina_real_de_valedouro.png"),
	"Lamina do Sino Partido": preload("res://assets/icones/itens/espadas/lamina_do_sino_partido.png"),
	"Lamina da Aurora de Valedouro": preload("res://assets/icones/itens/espadas/lamina_da_aurora_de_valedouro.png"),
	"Escudo reforcado": preload("res://assets/icones/itens/escudos/escudo_reforcado.png"),
	"Escudo de ferro": preload("res://assets/icones/itens/escudos/escudo_de_ferro.png"),
	"Escudo do saqueador": preload("res://assets/icones/itens/escudos/escudo_do_saqueador.png"),
	"Escudo reforcado de aco": preload("res://assets/icones/itens/escudos/escudo_reforcado_de_aco.png"),
	"Escudo da muralha": preload("res://assets/icones/itens/escudos/escudo_da_muralha.png"),
	"Escudo do Sino Partido": preload("res://assets/icones/itens/escudos/escudo_do_sino_partido.png"),
	"Arco do Aprendiz": preload("res://assets/icones/itens/arcos/arco_do_aprendiz.png"),
	"Arco do Sino Partido": preload("res://assets/icones/itens/arcos/arco_do_sino_partido.png"),
	"Arco da Bruma Antiga": preload("res://assets/icones/itens/arcos/arco_da_bruma_antiga.png"),
	"Cajado do Aprendiz": preload("res://assets/icones/itens/cajados/cajado_do_aprendiz.png"),
	"Cajado do Eco Runico": preload("res://assets/icones/itens/cajados/cajado_do_eco_runico.png"),
	"Cajado do Sino Partido": preload("res://assets/icones/itens/cajados/cajado_do_sino_partido.png"),
	"Veste do Aprendiz": preload("res://assets/icones/itens/tunicas/veste_do_aprendiz.png"),
	"Manto do Eco": preload("res://assets/icones/itens/tunicas/manto_do_eco.png"),
	"Manto do Sino Partido": preload("res://assets/icones/itens/tunicas/manto_do_sino_partido.png"),
	"Colete do Explorador": preload("res://assets/icones/itens/vestimentas_arqueiro/colete_do_explorador.png"),
	"Colete do Batedor": preload("res://assets/icones/itens/vestimentas_arqueiro/colete_do_batedor.png"),
	"Colete do Sino Partido": preload("res://assets/icones/itens/vestimentas_arqueiro/colete_do_sino_partido.png"),
	"Armadura de couro": preload("res://assets/icones/itens/armaduras/armadura_de_couro.png"),
	"Armadura de pedra": preload("res://assets/icones/itens/armaduras/armadura_de_pedra.png"),
	"Armadura de ferro": preload("res://assets/icones/itens/armaduras/armadura_de_ferro.png"),
	"Couraca da Guarda": preload("res://assets/icones/itens/armaduras/couraca_da_guarda.png"),
	"Armadura de placas reais": preload("res://assets/icones/itens/armaduras/armadura_de_placas_reais.png"),
	"Armadura do Sino Partido": preload("res://assets/icones/itens/armaduras/armadura_do_sino_partido.png"),
	"Armadura do Bastião": preload("res://assets/icones/itens/armaduras/armadura_do_bastiao.png"),
	"Machado de lenhador": preload("res://assets/icones/itens/ferramentas/machado_de_lenhador.png"),
	"Machado de aco": preload("res://assets/icones/itens/ferramentas/machado_de_aco.png"),
	"Picareta de mineiro": preload("res://assets/icones/itens/ferramentas/picareta_de_mineiro.png"),
	"Kit de herbalista": preload("res://assets/icones/itens/ferramentas/kit_de_herbalista.png"),
	"Kit botanico": preload("res://assets/icones/itens/ferramentas/kit_botanico.png"),
	"Pocao media": preload("res://assets/icones/itens/consumiveis/pocao_media.png"),
	"Pocao completa": preload("res://assets/icones/itens/consumiveis/pocao_completa.png"),
	"Pocao de mana": preload("res://assets/icones/itens/consumiveis/pocao_de_mana.png"),
	"Pele de lobo": preload("res://assets/icones/itens/materiais/pele_de_lobo.png"),
	"Retalho de tecido": preload("res://assets/icones/itens/materiais/retalho_de_tecido.png"),
	"Adaga enferrujada": preload("res://assets/icones/itens/materiais/adaga_enferrujada.png"),
	"Fragmento de metal antigo": preload("res://assets/icones/itens/materiais/fragmento_de_metal_antigo.png"),
	"Minerio de ferro": preload("res://assets/icones/itens/materiais/minerio_de_ferro.png"),
	"Barra de ferro": preload("res://assets/icones/itens/materiais/barra_de_ferro.png"),
	"Madeira": preload("res://assets/icones/itens/materiais/madeira.png"),
	"Fragmento de madeira": preload("res://assets/icones/itens/materiais/fragmento_de_madeira.png"),
	"Fragmento de rocha": preload("res://assets/icones/itens/materiais/fragmento_de_rocha.png"),
	"Tabua de madeira": preload("res://assets/icones/itens/materiais/tabua_de_madeira.png"),
	"Bloco de pedra": preload("res://assets/icones/itens/materiais/bloco_de_pedra.png"),
	"Erva rara": preload("res://assets/icones/itens/materiais/erva_rara.png"),
	"Lasca de runa": preload("res://assets/icones/itens/materiais/lasca_de_runa.png"),
	"Nucleo runico": preload("res://assets/icones/itens/materiais/nucleo_runico.png"),
	"Selo das Ruinas": preload("res://assets/icones/itens/itens_especiais/selo_das_ruinas.png"),
}

# MVP 0.6.2 - world camera, original 960x640 viewport and UI retained.
const WORLD_W := 1920.0
const WORLD_H := 1280.0
const VIEW_W := 960.0
const VIEW_H := 640.0
var guardian_pulse_warning: Dictionary = {}
var camera_offset := Vector2.ZERO
var camera_ready := false

func _update_camera(delta: float) -> void:
	if not players.has(player_id):
		return
	var hero: Dictionary = players[player_id]
	var hero_pos := Vector2(float(hero.get("x", 0)), float(hero.get("y", 0)))
	var desired := Vector2(
		clampf(hero_pos.x - VIEW_W * 0.5, 0.0, WORLD_W - VIEW_W),
		clampf(hero_pos.y - 340.0, 0.0, WORLD_H - VIEW_H)
	)
	if not camera_ready:
		camera_offset = desired
		camera_ready = true
	else:
		camera_offset = camera_offset.lerp(desired, clampf(delta * 5.0, 0.0, 1.0))

func _screen_to_world(screen_pos: Vector2) -> Vector2:
	return screen_pos + camera_offset

# Forest area is rendered in world coordinates, behind all actors.
var forest_ground: Texture2D = preload("res://assets/visual063/forest_ground.png")
var forest_ruins: Texture2D = preload("res://assets/visual063/ruins.png")
var forest_chest: Texture2D = preload("res://assets/visual063/forest_chest.png")
var forest_chest_open: Texture2D = preload("res://assets/visual063/forest_chest_open.png")

const CHEST_LOCATIONS := {
	"forest_ancient_01": Vector2(1735, 1060),
	"forest_ancient_02": Vector2(1170, 1010),
	"valley_supply_01": Vector2(1030, 665)
}
var chest_server_clock_offset := 0.0

func _chest_seconds_remaining(chest_id: String) -> int:
	var cooldowns: Dictionary = profile.get("chest_cooldowns", {})
	var deadline := float(cooldowns.get(chest_id, 0.0))
	return maxi(0, ceili(deadline - (Time.get_unix_time_from_system() + chest_server_clock_offset)))

func _draw_forest() -> void:
	draw_texture_rect(forest_ground, Rect2(960, 640, 960, 640), false)
	draw_texture_rect(forest_ruins, Rect2(1450, 1015, 220, 165), false)
	# Runic landmark: visible only after Tessa unlocks the investigation.
	if str(profile.get("rune_ruins_quest", "locked")) in ["active", "ready", "completed"]:
		var rune_pos: Vector2 = Vector2(1500, 1030)
		var rune_tint: Color = Color("8ed9ff") if str(profile.get("rune_ruins_quest", "")) == "active" else Color("e4c27c")
		draw_arc(rune_pos, 28.0, 0.0, TAU, 32, rune_tint, 2.0)
		draw_line(rune_pos + Vector2(-10, 9), rune_pos + Vector2(0, -12), rune_tint, 3.0)
		draw_line(rune_pos + Vector2(0, -12), rune_pos + Vector2(10, 9), rune_tint, 3.0)
		draw_line(rune_pos + Vector2(-7, 1), rune_pos + Vector2(7, 1), rune_tint, 2.0)
	for chest_id in CHEST_LOCATIONS:
		var chest_pos: Vector2 = CHEST_LOCATIONS[chest_id]
		# Baú fechado enquanto disponível; aberto durante o tempo de reposição.
		var chest_texture: Texture2D = forest_chest_open if _chest_seconds_remaining(chest_id) > 0 else forest_chest
		draw_texture_rect(chest_texture, Rect2(chest_pos + Vector2(-45, -40), Vector2(90, 75)), false)
		if _chest_seconds_remaining(chest_id) > 0:
			draw_rect(Rect2(chest_pos + Vector2(-22, -26), Vector2(45, 13)), Color("3d3229"))
			draw_line(chest_pos + Vector2(-22, -26), chest_pos + Vector2(23, -26), Color("e3c88b"), 3.0)
		else:
			draw_arc(chest_pos, 54.0, 0.0, TAU, 32, Color("f5d077", 0.65), 1.5)

const OBSTACLES = [Rect2(115, 100, 155, 115), Rect2(620, 110, 190, 135), Rect2(100, 410, 180, 135), Rect2(685, 420, 170, 120), Rect2(1110, 115, 155, 115), Rect2(1450, 125, 190, 135), Rect2(1100, 440, 180, 135), Rect2(1500, 430, 170, 120), Rect2(120, 825, 155, 115), Rect2(640, 825, 190, 135), Rect2(120, 1070, 180, 135), Rect2(685, 1070, 170, 120)]
const TESSA = Vector2(350, 300)
const BLACKSMITH = Vector2(550, 310)
const BANK_KEEPER: Vector2 = Vector2(665, 310)
const BANK_RANGE: float = 85.0
# The collision centers must match TREE_TRUNKS in server/main.py.
const TREE_BASES = [Vector2(45,103), Vector2(315,148), Vector2(550,88), Vector2(885,128), Vector2(45,493), Vector2(350,548), Vector2(610,538), Vector2(925,503), Vector2(1020, 100), Vector2(1330, 110), Vector2(1720, 100), Vector2(1850, 450), Vector2(1040, 520), Vector2(1370, 565), Vector2(1710, 575), Vector2(40, 790), Vector2(340, 810), Vector2(580, 795), Vector2(905, 815), Vector2(45, 1190), Vector2(350, 1190), Vector2(620, 1210), Vector2(940, 1180), Vector2(1030, 810), Vector2(1370, 830), Vector2(1710, 820), Vector2(1850, 1190), Vector2(1070,760), Vector2(1225,860), Vector2(1435,830), Vector2(1580,835), Vector2(1790,840), Vector2(1850,810), Vector2(1100,930), Vector2(1280,910), Vector2(1480,920), Vector2(1640,895), Vector2(1810,950), Vector2(1080,1100), Vector2(1230,1160), Vector2(1410,1110), Vector2(1600,1150), Vector2(1800,1150)]
const ROCKS = [Vector3(290,368,19), Vector3(650,382,22), Vector3(540,480,16), Vector3(78,375,18), Vector3(1090, 355, 20), Vector3(1680, 380, 21), Vector3(1180, 1040, 20), Vector3(1580, 1040, 23)]
const BUSHES = [Vector3(300,255,13), Vector3(680,365,14), Vector3(565,510,12), Vector3(1320, 300, 13), Vector3(1740, 480, 14), Vector3(380, 1000, 14)]
const BARRELS = [Vector3(295,220,12), Vector3(680,255,12), Vector3(1240, 265, 12), Vector3(1580, 280, 12), Vector3(315, 930, 12)]
const FENCES = [Rect2(70,382,82,10), Rect2(690,405,65,10), Rect2(1150, 388, 90, 10), Rect2(1510, 392, 85, 10), Rect2(90, 1015, 90, 10)]
var socket := WebSocketPeer.new()
var player_id := ""
var players := {}
var monsters := {}
var profile := {}
var dungeon_active := false
var dungeon_stage := 0
var dungeon_enemy_hp := 0
var dungeon_boss_phase := 0
var dungeon_pos := Vector2i(1, 2)
var dungeon_enemy_pos := Vector2i(8, 2)
var dungeon_enemy_name := "Esqueleto Errante"
# MVP 1.1.0.7.8: orientação visual da cripta, independente do combate no servidor.
var dungeon_hero_facing := "down"
var dungeon_boss_facing := "down"
var dungeon_walk_timer := 0.0
var dungeon_click_path: Array[Vector2i] = []
var dungeon_hero_visual := Vector2(1, 2)
var dungeon_enemy_visual := Vector2(8, 2)
var dungeon_visual_stage := -1
var dungeon_hit_flash := 0.0
var dungeon_enemy_attack_in := 0.0
var dungeon_special_cells: Array[Vector2i] = []
var dungeon_special_in := 0.0
var dungeon_attack_flash := 0.0
var dungeon_auto_attack_elapsed := 0.0
var dungeon_auto_route: Array[Vector2i] = []
var dungeon_manual_pause := 0.0
var dungeon_auto_enemy_last := Vector2i(-1, -1)
var dungeon_facing := Vector2.RIGHT
var dungeon_show_range := true
var dungeon_last_enemy_hp := -1
var notice := ""
# Victory presentation: the server alone grants rewards.
var crypt_victory_time: float = 0.0
var crypt_victory_first: bool = false
var guardian_banner := ""
var guardian_banner_time := 0.0
# MVP 0.5.7: efeitos visuais temporarios; dano e recompensas sao do servidor.
var combat_effects: Array = []
var attack_flash_remaining := 0.0
# Profession effects are visual only. Rewards and respawn remain server-authoritative.
var gathering_animations: Array = []
# Sons originais, locais e opcionais. O servidor continua a controlar os resultados.
var gathering_audio: AudioStreamPlayer
var crafting_audio: AudioStreamPlayer
const SFX_CHOP: AudioStream = preload("res://assets/audio/chop.wav")
const SFX_MINE: AudioStream = preload("res://assets/audio/mine.wav")
const SFX_HERB: AudioStream = preload("res://assets/audio/herb.wav")
const SFX_FORGE_OK: AudioStream = preload("res://assets/audio/forge_success.wav")
const SFX_FORGE_FAIL: AudioStream = preload("res://assets/audio/forge_fail.wav")

func _play_gather_sfx(kind: String) -> void:
	if gathering_audio == null:
		return
	match kind:
		"wood": gathering_audio.stream = SFX_CHOP
		"ore": gathering_audio.stream = SFX_MINE
		_: gathering_audio.stream = SFX_HERB
	gathering_audio.play()

func _play_crafting_sfx(success: bool) -> void:
	if crafting_audio == null:
		return
	crafting_audio.stream = SFX_FORGE_OK if success else SFX_FORGE_FAIL
	crafting_audio.play()


func _begin_gather_animation(kind: String, world_pos: Vector2) -> void:
	gathering_animations.append({"kind":kind, "pos":world_pos, "time":0.0, "duration":1.05})
	if gathering_animations.size() > 12:
		gathering_animations.pop_front()

func _draw_gather_animations() -> void:
	for animation in gathering_animations:
		var world_pos: Vector2 = animation["pos"]
		var elapsed: float = float(animation["time"])
		var duration: float = float(animation["duration"])
		var fade: float = clampf((duration - elapsed) / 0.35, 0.0, 1.0)
		var kind: String = str(animation["kind"])
		var seed_value: int = int(world_pos.x * 13.0 + world_pos.y * 7.0)
		# Short, readable tool motion and a burst of deterministic particles.
		var swing: float = sin(elapsed * 16.0) * 0.8
		if kind == "wood":
			draw_line(world_pos + Vector2(-21, -25), world_pos + Vector2(-8 + swing * 12.0, -44), Color("a87949", fade), 5.0)
			draw_line(world_pos + Vector2(-13 + swing * 12.0, -44), world_pos + Vector2(-2 + swing * 12.0, -44), Color("cbd4d5", fade), 8.0)
		elif kind == "ore":
			draw_line(world_pos + Vector2(-22, -20), world_pos + Vector2(-8 + swing * 12.0, -45), Color("a87949", fade), 5.0)
			draw_line(world_pos + Vector2(-18 + swing * 12.0, -45), world_pos + Vector2(2 + swing * 12.0, -45), Color("cbd4d5", fade), 7.0)
		else:
			draw_arc(world_pos + Vector2(0, -20), 17.0 + elapsed * 13.0, 0.0, TAU, 24, Color(0.73, 0.46, 1.0, fade), 2.0)
		for particle_index in range(11):
			var angle: float = float((seed_value + particle_index * 47) % 360) * PI / 180.0
			var velocity: float = 16.0 + float(particle_index % 4) * 12.0
			var displacement := Vector2(cos(angle), sin(angle)) * velocity * elapsed
			var particle_pos := world_pos + Vector2(0, -22) + displacement + Vector2(0, 18.0 * elapsed * elapsed)
			var particle_color := Color("d5a96d", fade) if kind == "wood" else Color("b8c5c9", fade) if kind == "ore" else Color("b8f0a4", fade)
			draw_circle(particle_pos, 2.0 + float(particle_index % 3), particle_color)


func _add_combat_effect(world_pos: Vector2, message: String, tint: Color, duration: float = 0.9) -> void:
	combat_effects.append({"pos":world_pos, "label":message, "color":tint, "time":duration, "duration":duration})
	if combat_effects.size() > 40:
		combat_effects.pop_front()

func _draw_combat_effects() -> void:
	var font := ThemeDB.fallback_font
	for effect in combat_effects:
		var remaining: float = float(effect["time"])
		var duration: float = float(effect["duration"])
		var progress: float = clampf(1.0 - remaining / duration, 0.0, 1.0)
		var origin: Vector2 = effect["pos"]
		var label: String = str(effect["label"])
		var tint: Color = effect["color"]
		tint.a = clampf(remaining / 0.25, 0.0, 1.0)
		var pos := origin + Vector2(0.0, -48.0 - 34.0 * progress)
		# Dark backdrop and outline make text readable over any terrain.
		var width := maxf(64.0, font.get_string_size(label, HORIZONTAL_ALIGNMENT_LEFT, -1, 19).x + 16.0)
		draw_rect(Rect2(pos + Vector2(-width / 2.0, -20.0), Vector2(width, 27.0)), Color(0.05, 0.08, 0.10, 0.72 * tint.a))
		# Godot centra dentro de [x, x + width]; deslocar o inicio para a esquerda.
		var text_origin := pos - Vector2(width / 2.0, 0.0)
		draw_string_outline(font, text_origin, label, HORIZONTAL_ALIGNMENT_CENTER, width, 19, 4, Color(0.04, 0.05, 0.07, tint.a))
		draw_string(font, text_origin, label, HORIZONTAL_ALIGNMENT_CENTER, width, 19, tint)
		if label.begins_with("-"):
			var impact := origin + Vector2(0.0, -22.0)
			var lifetime := minf(progress * duration / 0.42, 1.0)
			var fade := 1.0 - lifetime
			if fade > 0.0:
				var radius := 8.0 + 22.0 * lifetime
				draw_circle(impact, 13.0 * fade, Color(1.0, 0.94, 0.63, 0.36 * fade))
				draw_arc(impact, radius, 0.0, TAU, 32, Color(1.0, 0.71, 0.32, 0.95 * fade), 3.0)
				for i in range(8):
					var angle := TAU * float(i) / 8.0
					var direction := Vector2(cos(angle), sin(angle))
					var particle := impact + direction * (12.0 + 24.0 * lifetime)
					var particle_color := Color(1.0, 0.84, 0.40, fade)
					draw_line(particle - direction * 6.0 * fade, particle, particle_color, 2.5)

# MVP 0.9.3: efeitos visuais distintos, sem alterar o dano autoritativo.
var class_cast_fx: Array = []

func _draw_class_cast_fx() -> void:
	for fx in class_cast_fx:
		var position_fx: Vector2 = fx["pos"]
		var elapsed: float = float(fx["elapsed"])
		var duration: float = float(fx["duration"])
		var progress: float = clampf(elapsed / duration, 0.0, 1.0)
		var fade: float = 1.0 - progress
		var class_type: String = str(fx["class"])
		var center: Vector2 = position_fx + Vector2(0, -27)
		if class_type == "Guerreiro":
			# Corte dourado em arco com impacto no alvo.
			var slash_angle: float = -PI * 0.75 + progress * PI * 1.4
			draw_arc(center, 33.0 + 9.0 * progress, slash_angle - 1.1, slash_angle + 0.6, 26, Color(1.0, 0.77, 0.30, fade), 6.0 * fade + 1.0)
			draw_arc(center, 42.0, slash_angle - 0.9, slash_angle + 0.4, 20, Color(1.0, 0.95, 0.70, fade * 0.75), 2.0)
			for spark in range(7):
				var angle: float = TAU * float(spark) / 7.0 + progress * 2.0
				var end_point: Vector2 = center + Vector2(cos(angle), sin(angle)) * (12.0 + progress * 45.0)
				draw_line(end_point, end_point - Vector2(cos(angle), sin(angle)) * 10.0, Color(1.0, 0.70, 0.25, fade), 2.0)
		elif class_type == "Mago":
			# Runas e ondas de energia violeta.
			draw_circle(center, 29.0 * fade, Color(0.55, 0.30, 0.95, 0.22 * fade))
			for ring in range(3):
				var radius: float = 15.0 + float(ring) * 14.0 + progress * 31.0
				draw_arc(center, radius, progress * TAU + float(ring), progress * TAU + float(ring) + PI * 1.55, 36, Color(0.73, 0.50, 1.0, fade), 3.0)
			for rune in range(6):
				var angle: float = TAU * float(rune) / 6.0 - progress * 2.0
				var point: Vector2 = center + Vector2(cos(angle), sin(angle)) * (26.0 + progress * 32.0)
				draw_circle(point, 3.0 * fade + 1.0, Color(0.90, 0.77, 1.0, fade))
		elif class_type == "Arqueiro":
			# Trajetoria verde e ponta de flecha convergindo no alvo.
			var source: Vector2 = fx.get("source", position_fx - Vector2(100, 0)) + Vector2(0, -27)
			var direction: Vector2 = (center - source).normalized()
			var tip: Vector2 = source.lerp(center, minf(1.0, progress * 2.0))
			var tail: Vector2 = tip - direction * 26.0
			draw_line(tail, tip, Color(0.45, 1.0, 0.64, fade), 4.0)
			draw_line(tip, tip - direction.rotated(0.65) * 12.0, Color(0.88, 1.0, 0.71, fade), 3.0)
			draw_line(tip, tip - direction.rotated(-0.65) * 12.0, Color(0.88, 1.0, 0.71, fade), 3.0)
			draw_arc(center, 12.0 + progress * 32.0, 0.0, TAU, 32, Color(0.50, 1.0, 0.66, fade), 2.0)

var was_space_down := false
var show_inventory := false
var was_i_down := false
var npc_message := "Aproxima-te de Tessa e prime E para conversar."
var send_elapsed := 0.0
var animation_time := 0.0
# MVP 0.6.1: animation state from authoritative server positions.
var actor_motion: Dictionary = {}
var actor_hurt: Dictionary = {}
var attack_anim_left := 0.0
# MVP 1.0.4.7: projectiles are cosmetic; hit confirmation comes from the server.
var basic_projectiles: Array = []
# MVP 1.0.4.8: impactos cosméticos de ataques básicos confirmados.
var basic_impacts: Array = []
var basic_attack_direction := Vector2.RIGHT
var monster_attack_anim: Dictionary = {}
const MONSTER_ATTACK_DURATION := 0.38

const ACTOR_WALK_EPS := 0.6
const ACTOR_ANIM_SPEED := 8.0

func _track_actor(actor_key: String, world_pos: Vector2, delta: float, fallback_facing: String = "down") -> void:
	var state: Dictionary = actor_motion.get(actor_key, {})
	if state.is_empty():
		actor_motion[actor_key] = {"pos":world_pos, "facing":fallback_facing, "moving":false, "clock":0.0, "motion_hold":0.0}
		return
	var old_pos: Vector2 = state["pos"]
	var displacement := world_pos - old_pos
	var motion_hold: float = maxf(0.0, float(state.get("motion_hold", 0.0)) - delta)
	if displacement.length() > ACTOR_WALK_EPS:
		motion_hold = 0.19
		if absf(displacement.x) > absf(displacement.y):
			state["facing"] = "right" if displacement.x > 0.0 else "left"
		else:
			state["facing"] = "down" if displacement.y > 0.0 else "up"
	var moving := motion_hold > 0.0
	state["clock"] = float(state.get("clock", 0.0)) + delta if moving else 0.0
	state["motion_hold"] = motion_hold
	state["moving"] = moving
	state["pos"] = world_pos
	actor_motion[actor_key] = state

func _refresh_actor_motion(delta: float) -> void:
	for id in players:
		var p: Dictionary = players[id]
		_track_actor("p:" + str(id), Vector2(float(p.get("x", 0.0)), float(p.get("y", 0.0))), delta, str(p.get("facing", "down")))
	for id in monsters:
		var m: Dictionary = monsters[id]
		if bool(m.get("alive", false)):
			_track_actor("m:" + str(id), Vector2(float(m.get("x", 0.0)), float(m.get("y", 0.0))), delta)
	for key in actor_hurt.keys():
		actor_hurt[key] = maxf(0.0, float(actor_hurt[key]) - delta)

var was_e_down := false
var was_f_down := false
var was_g_down := false
var was_c_down := false
var was_v_down := false
# Nodes and availability are supplied by the authoritative Python server.
const GATHER_CHANCES := {"wood":100, "ore":70, "herb":20}
const GATHER_LABELS := {"wood":"Madeira", "ore":"Minerio de ferro", "herb":"Erva rara"}
var smith_recipe_page := 0
var sell_page := 0
var pending_sale_item := ""
var pending_sale_gear_id := ""
var pending_sale_quantity := 1
var sell_confirm_open := false
const SMITH_RECIPES := [
	{"id":"aurora_blade", "name":"Lamina da Aurora de Valedouro", "cost":"10 Barra de ferro + 12 Lasca de runa + 5 Fragmento de metal antigo | Nivel 40", "chance":55},
	{"id":"mist_bow", "name":"Arco da Bruma Antiga", "cost":"12 Tabua de madeira + 12 Lasca de runa + 2 Nucleo runico | Nivel 40", "chance":55},
	{"id":"sky_staff", "name":"Cajado do Firmamento", "cost":"20 Fragmento de madeira + 12 Lasca de runa + 3 Nucleo runico | Nivel 40", "chance":50},
	{"id":"bastion_armor", "name":"Armadura do Bastião", "cost":"18 Barra de ferro + 10 Fragmento de metal antigo + 3 Nucleo runico | Nivel 60", "chance":40},
	{"id":"shadow_vest", "name":"Colete da Sombra Verde", "cost":"20 Pele de lobo + 18 Retalho de tecido + 3 Nucleo runico | Nivel 60", "chance":45},
	{"id":"star_mantle", "name":"Manto das Estrelas", "cost":"24 Retalho de tecido + 10 Erva rara + 4 Nucleo runico | Nivel 60", "chance":40},
	{"id":"guard_sword", "name":"Espada da Guarda de Valedouro", "cost":"5 Barra de ferro + 4 Lasca de runa", "chance":70},
	{"id":"ranger_bow", "name":"Arco do Vigia Runico", "cost":"5 Tabua de madeira + 5 Lasca de runa", "chance":70},
	{"id":"mage_staff", "name":"Cajado do Eco Runico", "cost":"12 Fragmento de madeira + 5 Lasca de runa + 1 Nucleo runico", "chance":65},
	{"id":"guard_armor", "name":"Couraca da Guarda", "cost":"6 Barra de ferro + 4 Pele de lobo", "chance":70},
	{"id":"ranger_armor", "name":"Colete do Batedor", "cost":"8 Pele de lobo + 5 Retalho de tecido", "chance":75},
	{"id":"mage_armor", "name":"Manto do Eco", "cost":"10 Retalho de tecido + 2 Erva rara", "chance":75},

	{"id":"steel_axe", "name":"Machado de aco", "cost":"24 madeira + 5 barras + 2 adagas | Lenhador 6", "chance":55},
	{"id":"steel_pick", "name":"Picareta de aco", "cost":"24 pedra + 6 barras + 5 minerios | Mineiro 6", "chance":50},
	{"id":"botanical_kit", "name":"Kit botanico", "cost":"5 ervas + 4 tabuas + 1 metal antigo | Herbalista 6", "chance":45},
	{"id":"lumber_axe", "name":"Machado de lenhador", "cost":"12 madeira + 2 barras | Lenhador nivel 3", "chance":80},
	{"id":"mining_pick", "name":"Picareta de mineiro", "cost":"12 pedra + 3 barras | Mineiro nivel 3", "chance":75},
	{"id":"herbal_kit", "name":"Kit de herbalista", "cost":"2 ervas + 2 tabuas | Herbalista nivel 3", "chance":65},
	{"id":"iron_bar", "name":"Barra de ferro", "cost":"3 minerios", "chance":80},
	{"id":"fang_blade", "name":"Lamina de presas", "cost":"2 presas + 1 barra", "chance":60},
	{"id":"stone_block", "name":"Bloco de pedra", "cost":"6 fragmentos de rocha", "chance":80},
	{"id":"wood_plank", "name":"Tabua de madeira", "cost":"6 fragmentos de madeira", "chance":80},
	{"id":"wood_shield", "name":"Escudo reforcado", "cost":"2 tabuas + 3 peles", "chance":65},
	{"id":"stone_armor", "name":"Armadura de pedra", "cost":"2 blocos + 1 barra", "chance":40},
	{"id":"medium_potion", "name":"Pocao media", "cost":"1 erva + 2 pequenas", "chance":55},
	{"id":"full_potion", "name":"Pocao completa", "cost":"3 ervas + 2 medias + 1 metal", "chance":15},
	{"id":"raider_shield", "name":"Escudo do saqueador", "cost":"4 adagas + 3 barras + 2 tabuas", "chance":25},
	{"id":"raider_sword", "name":"Espada do saqueador", "cost":"6 adagas + 4 barras + 3 presas", "chance":12},
	{"id":"ancient_blade", "name":"Espada ancestral", "cost":"5 metais + 6 barras + 8 presas + 12 frag. madeira", "chance":3},
	{"id":"rune_blade", "name":"Lamina da Vigilia Runica", "cost":"8 lascas + 1 nucleo + 4 barras", "chance":65}
]

var key_previous := {}
var name_input: LineEdit
var pending_new_hero_name: String = ""
var class_picker: OptionButton
var saved_hero_picker: OptionButton
var saved_hero_names: Array[String] = []
const HERO_CONFIG := "user://hero_profile.cfg"
var remembered_hero: String = ""
var show_shop := false
var smith_mode := "craft"
var upgrade_confirm_slot := ""
var smith_dialog := false
var smith_dialog_click_targets: Array = []
var show_quests := false
var quest_page: int = 0
var show_professions := false
var show_classes := false
var show_skill_tree := false
var show_dialog := false
var hover_item := ""
var hover_gear_id := ""
var inventory_click_targets: Array = []
var shop_click_targets: Array = []
var crafting_click_targets: Array = []
var inventory_page := 0
# MVP 1.0.6.8: local-only inventory organization. Server remains authoritative.
var inventory_category_index: int = 0
var inventory_rarity_index: int = 0
var inventory_sort_index: int = 0
var inventory_search: String = ""
var inventory_search_active: bool = false
const INVENTORY_CATEGORIES := ["Todos", "Equipamentos", "Materiais", "Consumiveis", "Missao"]
const INVENTORY_RARITIES := ["Todas", "Comum", "Incomum", "Raro", "Epico", "Lendario"]
const INVENTORY_SORTS := ["Nome", "Quantidade", "Raridade"]

var dialog_speaker := ""
var dialog_text := ""

# Navegacao por clique: grade de 16 px e A*; servidor valida o movimento.
const NAV_CELL := 16
var nav_grid: AStarGrid2D
var nav_path: Array[Vector2] = []
var nav_destination := Vector2.ZERO
var nav_active := false
var nav_last_position := Vector2.ZERO
var nav_stall_time := 0.0
var nav_repath_cooldown := 0.0

# MVP 0.5.6 - combate automatico (opt-in; servidor valida todos os golpes).
const AUTO_DETECT_RANGE := 180.0
# Margem de 8 px abaixo do limite validado pelo servidor.
func _basic_attack_stop_range() -> float:
	match str(profile.get("combat_class", "Guerreiro")):
		"Mago": return 117.0
		"Arqueiro": return 142.0
		_: return 57.0
const AUTO_ATTACK_INTERVAL := 0.60
const AUTO_REPATH_INTERVAL := 0.70
var auto_combat := false
# Destino escolhido pelo jogador tem prioridade sobre a perseguicao automatica.
var manual_click_route := false
var auto_target_id := ""
var click_attack_target_id := ""
var click_attack_elapsed := 0.0
var auto_attack_elapsed := 0.0
var auto_repath_elapsed := 0.0

func _click_attack_update(delta: float, manual_movement: bool) -> void:
	if click_attack_target_id == "" or not players.has(player_id):
		return
	# WASD controls movement, but does not suppress basic ranged attacks.
	var enemy: Dictionary = monsters.get(click_attack_target_id, {})
	if not bool(enemy.get("alive", false)):
		click_attack_target_id = ""
		nav_active = false
		return
	var me: Dictionary = players[player_id]
	var pos := Vector2(float(me.get("x", 0)), float(me.get("y", 0)))
	var enemy_pos := Vector2(float(enemy.get("x", 0)), float(enemy.get("y", 0)))
	if pos.distance_to(enemy_pos) <= _basic_attack_stop_range():
		if not manual_movement:
			nav_active = false
		click_attack_elapsed -= delta
		if click_attack_elapsed <= 0.0 and socket.get_ready_state() == WebSocketPeer.STATE_OPEN:
			click_attack_elapsed = 0.55
			socket.send_text(JSON.stringify({"type":"attack", "target_id":click_attack_target_id}))
	elif not manual_movement:
		auto_repath_elapsed -= delta
		if auto_repath_elapsed <= 0.0 or not nav_active:
			auto_repath_elapsed = 0.8
			var start_cell := _nav_nearest_open(_nav_cell(pos))
			if start_cell.x < 0:
				click_attack_target_id = ""
				return
			var best_cost := INF
			var best_goal := Vector2.ZERO
			for i in range(16):
				var angle := TAU * float(i) / 16.0
				var candidate := enemy_pos + Vector2(cos(angle), sin(angle)) * maxf(45.0, _basic_attack_stop_range() - 12.0)
				if _nav_blocked(candidate):
					continue
				var goal_cell := _nav_nearest_open(_nav_cell(candidate))
				if goal_cell.x < 0:
					continue
				var route := nav_grid.get_point_path(start_cell, goal_cell)
				if route.is_empty():
					continue
				var cost := float(route.size())
				if cost < best_cost:
					best_cost = cost
					best_goal = candidate
			if best_cost == INF:
				click_attack_target_id = ""
				nav_active = false
				notice = "Alvo inacessivel: caminho bloqueado."
				return
			_nav_route(pos, best_goal)
			manual_click_route = false

func _auto_target_position() -> Vector2:
	var enemy: Dictionary = monsters.get(auto_target_id, {})
	return Vector2(float(enemy.get("x", 0.0)), float(enemy.get("y", 0.0)))

func _auto_choose_target(pos: Vector2) -> void:
	var nearest := AUTO_DETECT_RANGE
	auto_target_id = ""
	for id in monsters:
		var enemy: Dictionary = monsters[id]
		if not bool(enemy.get("alive", false)):
			continue
		var enemy_pos := Vector2(float(enemy.get("x", 0.0)), float(enemy.get("y", 0.0)))
		var dist := pos.distance_to(enemy_pos)
		if dist < nearest:
			nearest = dist
			auto_target_id = str(id)

func _auto_update(delta: float, manual_movement: bool) -> void:
	if click_attack_target_id != "" or not auto_combat or not players.has(player_id) or name_input.visible:
		return
	var me: Dictionary = players[player_id]
	if float(me.get("hp", 0.0)) <= 0.0:
		auto_target_id = ""
		nav_active = false
		return
	var pos := Vector2(float(me.get("x", 0.0)), float(me.get("y", 0.0)))
	var enemy: Dictionary = monsters.get(auto_target_id, {})
	if not bool(enemy.get("alive", false)) or pos.distance_to(_auto_target_position()) > AUTO_DETECT_RANGE * 1.5:
		_auto_choose_target(pos)
	if auto_target_id == "":
		return
	var target_pos := _auto_target_position()
	var dist := pos.distance_to(target_pos)
	if dist <= _basic_attack_stop_range():
		if not manual_movement and not (manual_click_route and nav_active):
			nav_active = false
		if auto_attack_elapsed >= AUTO_ATTACK_INTERVAL:
			auto_attack_elapsed = 0.0
			socket.send_text(JSON.stringify({"type":"attack", "target_id":auto_target_id}))
	elif not manual_movement and not (manual_click_route and nav_active):
		auto_repath_elapsed -= delta
		if auto_repath_elapsed <= 0.0:
			auto_repath_elapsed = 1.1
			var best_route: PackedVector2Array = PackedVector2Array()
			var best_goal := Vector2.ZERO
			var best_cost := INF
			var start_cell := _nav_nearest_open(_nav_cell(pos))
			if start_cell.x < 0:
				nav_active = false
				return
			# Search walkable points around the enemy, never its blocked body.
			for i in range(16):
				var angle := TAU * float(i) / 16.0
				var candidate := target_pos + Vector2(cos(angle), sin(angle)) * maxf(44.0, _basic_attack_stop_range() - 12.0)
				if _nav_blocked(candidate):
					continue
				var goal_cell := _nav_nearest_open(_nav_cell(candidate))
				if goal_cell.x < 0:
					continue
				var route := nav_grid.get_point_path(start_cell, goal_cell)
				if route.is_empty():
					continue
				var cost := 0.0
				for j in range(1, route.size()):
					cost += route[j-1].distance_to(route[j])
				if cost < best_cost:
					best_cost = cost
					best_route = route
					best_goal = candidate
			if best_route.is_empty():
				# Unreachable target: stop trying every frame and seek a different enemy later.
				nav_active = false
				auto_target_id = ""
				auto_repath_elapsed = 2.0
			else:
				nav_path.clear()
				for point in best_route:
					nav_path.append(point)
				nav_destination = best_goal
				nav_active = true
				nav_stall_time = 0.0

func _nav_blocked(pos: Vector2) -> bool:
	const BODY_RADIUS := 12.0
	if pos.x < BODY_RADIUS or pos.x > WORLD_W - BODY_RADIUS or pos.y < BODY_RADIUS or pos.y > WORLD_H - BODY_RADIUS:
		return true
	for r in OBSTACLES + FENCES:
		var closest: Vector2 = pos.clamp(r.position, r.end)
		if pos.distance_squared_to(closest) < BODY_RADIUS * BODY_RADIUS:
			return true
	for resource in profile.get("resource_nodes", []):
		var center := Vector2(float(resource.get("x", 0)), float(resource.get("y", 0)))
		var radius := float(resource.get("radius", 13.0))
		if pos.distance_squared_to(center) < pow(BODY_RADIUS + radius, 2):
			return true
	for obstacle in BARRELS:
		if pos.distance_squared_to(Vector2(obstacle.x, obstacle.y)) < pow(BODY_RADIUS + obstacle.z, 2):
			return true
	if pos.distance_squared_to(TESSA) < pow(BODY_RADIUS + 12.0, 2) or pos.distance_squared_to(BLACKSMITH) < pow(BODY_RADIUS + 12.0, 2) or pos.distance_squared_to(BANK_KEEPER) < pow(BODY_RADIUS + 12.0, 2):
		return true
	return false

func _build_navigation() -> void:
	nav_grid = AStarGrid2D.new()
	nav_grid.region = Rect2i(0, 0, 120, 80)
	nav_grid.cell_size = Vector2(NAV_CELL, NAV_CELL)
	nav_grid.offset = Vector2(NAV_CELL / 2.0, NAV_CELL / 2.0)
	nav_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_ONLY_IF_NO_OBSTACLES
	nav_grid.update()
	for y in range(80):
		for x in range(120):
			var cell := Vector2i(x, y)
			if _nav_blocked(nav_grid.get_point_position(cell)):
				nav_grid.set_point_solid(cell)

func _nav_nearest_open(cell: Vector2i) -> Vector2i:
	var best := Vector2i(-1, -1)
	var best_dist := INF
	for y in range(maxi(0, cell.y - 7), mini(80, cell.y + 8)):
		for x in range(maxi(0, cell.x - 7), mini(120, cell.x + 8)):
			var candidate := Vector2i(x, y)
			if nav_grid.is_point_solid(candidate):
				continue
			var d := Vector2(candidate).distance_squared_to(Vector2(cell))
			if d < best_dist:
				best_dist = d
				best = candidate
	return best

func _nav_cell(pos: Vector2) -> Vector2i:
	return Vector2i(clampi(int(floor(pos.x / NAV_CELL)), 0, 119), clampi(int(floor(pos.y / NAV_CELL)), 0, 79))

func _nav_route(from_pos: Vector2, to_pos: Vector2) -> void:
	if nav_grid == null:
		return
	var start := _nav_nearest_open(_nav_cell(from_pos))
	var finish := _nav_nearest_open(_nav_cell(to_pos))
	if start.x < 0 or finish.x < 0:
		nav_active = false
		return
	var points := nav_grid.get_point_path(start, finish)
	nav_path.clear()
	for point in points:
		nav_path.append(point)
	if nav_path.is_empty():
		nav_active = false
		return
	nav_destination = to_pos if not _nav_blocked(to_pos) else nav_grid.get_point_position(finish)
	nav_active = true
	nav_stall_time = 0.0

func _nav_direction(delta: float) -> Vector2:
	if not nav_active or not players.has(player_id):
		return Vector2.ZERO
	var me: Dictionary = players[player_id]
	var pos := Vector2(float(me.get("x", 0)), float(me.get("y", 0)))
	while not nav_path.is_empty() and pos.distance_to(nav_path[0]) < 11.0:
		nav_path.pop_front()
	if nav_path.is_empty():
		if pos.distance_to(nav_destination) < 14.0:
			nav_active = false
			return Vector2.ZERO
		if _nav_blocked(nav_destination):
			nav_active = false
			return Vector2.ZERO
		return pos.direction_to(nav_destination)
	if pos.distance_to(nav_last_position) < 1.5:
		nav_stall_time += delta
	else:
		nav_stall_time = 0.0
	nav_last_position = pos
	nav_repath_cooldown = maxf(0.0, nav_repath_cooldown - delta)
	if nav_stall_time > 0.65 and nav_repath_cooldown <= 0.0:
		nav_repath_cooldown = 1.0
		_nav_route(pos, nav_destination)
		if nav_path.is_empty():
			return Vector2.ZERO
	return pos.direction_to(nav_path[0])

# Sprite atlases: four directions (down, up, left, right) x four animation frames.
const SPRITE_W := 96
const SPRITE_H := 112
var hero_sprite: Texture2D = preload("res://assets/sprites/hero.png")
var hero_unarmed_sprite: Texture2D = preload("res://assets/visual110/hero_unarmed_detailed.png")
var district_terrain: Array[Texture2D] = [
	preload("res://assets/visual110/terrain_0.png"),
	preload("res://assets/visual110/terrain_1.png"),
	preload("res://assets/visual110/terrain_2.png"),
	preload("res://assets/visual110/terrain_3.png")
]
# MVP 1.1.0.7.5: atlas direcionais independentes para movimento e ataque.
# Ordem provisoria das linhas: baixo, cima, esquerda, direita.
var character_animation_atlases: Dictionary = {
	"guerreiro": {"move": preload("res://assets/characters/guerreiro/move.png"), "attack": preload("res://assets/characters/guerreiro/attack.png")},
	"arqueiro": {"move": preload("res://assets/characters/arqueiro/move.png"), "attack": preload("res://assets/characters/arqueiro/attack.png")},
	"mago": {"move": preload("res://assets/characters/mago/move.png"), "attack": preload("res://assets/characters/mago/attack.png")},
	"lobo": {"move": preload("res://assets/characters/lobo/move.png"), "attack": preload("res://assets/characters/lobo/attack.png")},
	"saqueador": {"move": preload("res://assets/characters/saqueador/move.png"), "attack": preload("res://assets/characters/saqueador/attack.png")},
	"sentinela_runica": {"move": preload("res://assets/characters/sentinela_runica/move.png"), "attack": preload("res://assets/characters/sentinela_runica/attack.png")},
	"guardiao_tempestade": {"move": preload("res://assets/characters/guardiao_tempestade/move.png"), "attack": preload("res://assets/characters/guardiao_tempestade/attack.png")},
	"guardiao_sino_partido": {"move": preload("res://assets/characters/guardiao_sino_partido/move.png"), "attack": preload("res://assets/characters/guardiao_sino_partido/attack.png")},
	"velkran": {"move": preload("res://assets/characters/velkran/move.png"), "attack": preload("res://assets/characters/velkran/attack.png")},
}

var class_hero_sprites: Dictionary = {
	"Guerreiro": preload("res://assets/visual110/hero_warrior.png"),
	"Arqueiro": preload("res://assets/visual110/hero_archer.png"),
	"Mago": preload("res://assets/visual110/hero_mage.png")
}
var city_npc_sprites: Dictionary = {
	"cartographer": preload("res://assets/visual110/npc_cartographer.png"),
	"merchant": preload("res://assets/visual110/npc_merchant.png"),
	"sentinel": preload("res://assets/visual110/npc_sentinel.png")
}
var tessa_sprite: Texture2D = preload("res://assets/visual110/npc_tessa_atlas.png")
var wolf_sprite: Texture2D = preload("res://assets/sprites/wolf.png")
var raider_sprite: Texture2D = preload("res://assets/sprites/raider.png")
var visual_npc_tessa_atlas: Texture2D = preload("res://assets/visual110/npc_tessa_atlas.png")
var visual_npc_ferreiro_detail: Texture2D = preload("res://assets/visual110/npc_ferreiro_detail.png")
var visual_wolf_detail: Texture2D = preload("res://assets/visual110/wolf_detail.png")
var visual_wolf_walk: Texture2D = preload("res://assets/visual110/wolf_walk.png")
var visual_wolf_real: Texture2D = preload("res://assets/visual110/wolf_anim_real.png")
var visual_raider_fighter_real: Texture2D = preload("res://assets/visual110/raider_fighter_real.png")
var visual_raider_hooded_real: Texture2D = preload("res://assets/visual110/raider_hooded_real.png")
var visual_raider_shaman_real: Texture2D = preload("res://assets/visual110/raider_shaman_real.png")
var visual_decor_reference: Texture2D = preload("res://assets/visual110/decor_reference_strip.png")
var visual_items_reference: Texture2D = preload("res://assets/visual110/items_reference_strip.png")
var visual_raider_walk: Texture2D = preload("res://assets/visual110/raider_walk.png")
var visual_boss_bell_walk: Texture2D = preload("res://assets/visual110/boss_bell_walk.png")
var visual_boss_storm_walk: Texture2D = preload("res://assets/visual110/boss_storm_walk.png")

var visual_raider_detail: Texture2D = preload("res://assets/visual110/raider_detail.png")
var visual_boss_bell_detail: Texture2D = preload("res://assets/visual110/boss_bell_detail.png")
var visual_boss_storm_detail: Texture2D = preload("res://assets/visual110/boss_storm_detail.png")
var visual_house_cottage: Texture2D = preload("res://assets/visual110/house_cottage.png")
var visual_house_workshop: Texture2D = preload("res://assets/visual110/house_workshop.png")
var visual_house_guild: Texture2D = preload("res://assets/visual110/house_guild.png")
var visual_house_townhall: Texture2D = preload("res://assets/visual110/house_townhall.png")
var visual_tree_oak: Texture2D = preload("res://assets/visual110/tree_oak.png")
var visual_tree_autumn: Texture2D = preload("res://assets/visual110/tree_autumn.png")
var visual_tree_blossom: Texture2D = preload("res://assets/visual110/tree_blossom.png")
var visual_tree_pine: Texture2D = preload("res://assets/visual110/tree_pine.png")



func _pressed_once(key: Key) -> bool:
	var down := Input.is_physical_key_pressed(key)
	var was := bool(key_previous.get(key, false))
	key_previous[key] = down
	return down and not was

func _send_action(kind: String, item: String = "") -> void:
	if socket.get_ready_state() == WebSocketPeer.STATE_OPEN:
		socket.send_text(JSON.stringify({"type":kind, "item":item}))

func _bank_nearby() -> bool:
	if not players.has(player_id):
		return false
	var hero: Dictionary = players[player_id]
	return Vector2(float(hero.get("x", 0)), float(hero.get("y", 0))).distance_to(BANK_KEEPER) <= BANK_RANGE

func _smith_nearby() -> bool:
	if not players.has(player_id):
		return false
	var hero: Dictionary = players[player_id]
	return Vector2(float(hero.get("x", 0)), float(hero.get("y", 0))).distance_to(BLACKSMITH) <= 90.0

func _ask_sell(item: String, gear_id: String = "") -> void:
	if not _smith_nearby():
		notice = "Aproxima-te do Ferreiro para vender itens."
		return
	var stock: Dictionary = profile.get("inventory", {})
	if int(stock.get(item, 0)) < 1:
		return
	# Server checks allowed items; rare items are protected there.
	pending_sale_item = item
	pending_sale_gear_id = gear_id
	# Quantity is chosen in the confirmation dialog, never in the smith shop.
	pending_sale_quantity = 1
	sell_confirm_open = true

func _equip_label(value: Variant) -> String:
	return "Nao equipado" if value == null or str(value) == "" else str(value)

func _cancel_hero_creation() -> void:
	# ESC cancela a criação em qualquer etapa, sem alterar o herói ativo.
	pending_new_hero_name = ""
	name_input.clear()
	name_input.hide()
	class_picker.hide()
	name_input.release_focus()
	class_picker.release_focus()
	notice = "Criacao de heroi cancelada."

func _submit_name(value: String) -> void:
	# Primeiro consulta o servidor; nunca escolhe classe antes de validar o nome.
	if socket.get_ready_state() != WebSocketPeer.STATE_OPEN:
		return
	if value.strip_edges().length() < 3:
		notice = "Nome deve ter pelo menos 3 caracteres."
		return
	socket.send_text(JSON.stringify({"type":"check_hero_name", "name":value.strip_edges()}))

# Selecao de personagens persistidos; o servidor continua a validar o carregamento.
func _on_saved_hero_selected(index: int) -> void:
	if index <= 0 or index >= saved_hero_picker.item_count:
		return
	if socket.get_ready_state() != WebSocketPeer.STATE_OPEN:
		return
	var chosen: String = saved_hero_picker.get_item_text(index)
	# Solicita explicitamente o carregamento do heroi escolhido, sem criar outro.
	socket.send_text(JSON.stringify({"type":"select_hero", "name":chosen}))
	saved_hero_picker.hide()
	notice = "A carregar heroi: " + chosen

func _refresh_saved_hero_picker(heroes: Array) -> void:
	saved_hero_picker.clear()
	saved_hero_picker.add_item("Selecionar heroi existente...")
	for hero_entry in heroes:
		var hero_name := str(hero_entry.get("name", ""))
		if hero_name != "":
			saved_hero_picker.add_item(hero_name)
	saved_hero_picker.select(0)

func _on_creation_class_selected(index: int) -> void:
	if pending_new_hero_name == "" or socket.get_ready_state() != WebSocketPeer.STATE_OPEN:
		return
	var chosen_class := class_picker.get_item_text(index)
	socket.send_text(JSON.stringify({"type":"name", "name":pending_new_hero_name, "class":chosen_class, "create_only":true}))
	pending_new_hero_name = ""
	name_input.hide()
	class_picker.hide()
	name_input.release_focus()


var show_attributes: bool = false
var show_bank: bool = false
var bank_click_targets: Array = []
var bank_page: int = 0

func _paged_panel_page_count() -> int:
	# Only panels with more than two pages respond to Up / Down.
	if show_quests:
		var mission_count: int = 2 # Protecao de Valedouro e Primeira Entrega
		if str(profile.get("quest", "not_started")) == "completed":
			mission_count += 1 # Floresta
		if str(profile.get("forest_quest", "locked")) == "completed":
			mission_count += 1 # Selo
		if str(profile.get("guardian_quest", "locked")) == "completed":
			mission_count += 1 # Cripta
		if bool(profile.get("bank_intro_done", false)):
			mission_count += 1 # Reserva
		return maxi(1, int(ceili(float(mission_count) / 3.0)))
	if show_bank:
		var bag_count: int = 0
		var bank_count: int = 0
		for item in profile.get("inventory", {}):
			if str(item) != "Selo das Ruinas" and not EQUIPMENT_RARITY.has(str(item)):
				bag_count += 1
		bag_count += profile.get("gear_bag", []).size()
		for item in profile.get("bank_items", {}):
			if not EQUIPMENT_RARITY.has(str(item)):
				bank_count += 1
		bank_count += profile.get("bank_gear", []).size()
		return maxi(1, int(ceili(float(maxi(bag_count, bank_count)) / 8.0)))
	if show_inventory:
		var entries: Array = []
		var items: Dictionary = profile.get("inventory", {})
		for item in items:
			if int(items[item]) > 0 and not EQUIPMENT_RARITY.has(str(item)):
				entries.append({"name":str(item), "amount":int(items[item]), "id":"", "level":0, "enchant":""})
		for gear_value in profile.get("gear_bag", []):
			if gear_value is Dictionary:
				entries.append({"name":str(gear_value.get("name", "")), "amount":1, "id":str(gear_value.get("id", "")), "level":int(gear_value.get("level", 0)), "enchant":str(gear_value.get("enchant", ""))})
		return maxi(1, int(ceili(float(_inventory_visible_entries(entries).size()) / 8.0)))
	if show_shop and smith_mode == "craft":
		return maxi(1, int(ceili(float(SMITH_RECIPES.size()) / 5.0)))
	if show_shop and smith_mode == "shop":
		return 3
	return 1

func _navigate_paged_panel(direction: int) -> bool:
	var pages: int = _paged_panel_page_count()
	if pages <= 1:
		return false
	if show_quests:
		quest_page = clampi(quest_page + direction, 0, pages - 1)
	elif show_bank:
		bank_page = clampi(bank_page + direction, 0, pages - 1)
	elif show_inventory:
		inventory_page = clampi(inventory_page + direction, 0, pages - 1)
	elif show_shop and smith_mode == "craft":
		smith_recipe_page = clampi(smith_recipe_page + direction, 0, pages - 1)
	elif show_shop and smith_mode == "shop":
		sell_page = clampi(sell_page + direction, 0, pages - 1)
	else:
		return false
	queue_redraw()
	return true

func _input(event: InputEvent) -> void:
	# A caixa LineEdit consome eventos de teclado; tratar ESC antes da GUI.
	if event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_ESCAPE and (name_input.visible or class_picker.visible):
		_cancel_hero_creation()
		get_viewport().set_input_as_handled()
		return
	# O menu de herois tem prioridade sobre a navegacao/combate por clique.
	# Nao marcar o evento como handled: o OptionButton e o seu PopupMenu
	# precisam de receber o clique atraves do sistema de GUI do Godot.
	if is_instance_valid(saved_hero_picker) and saved_hero_picker.visible:
		if event is InputEventMouseButton or event is InputEventMouseMotion:
			return
	if event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_O and not name_input.visible and not inventory_search_active:
		show_attributes = not show_attributes
		if show_attributes:
			show_classes = false
			show_skill_tree = false
		get_viewport().set_input_as_handled()
		queue_redraw()
		return
	if show_attributes and event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var point: Vector2 = event.position
		for i in range(5):
			if Rect2(640, 167 + i * 58, 38, 32).has_point(point):
				if socket.get_ready_state() == WebSocketPeer.STATE_OPEN:
					socket.send_text(JSON.stringify({"type":"allocate_attribute", "attribute":["forca","vitalidade","destreza","inteligencia","agilidade"][i]}))
				get_viewport().set_input_as_handled()
				return

	# Capture arrow key presses while a paginated panel is open.
	# A two-page panel must also be navigable.
	if event is InputEventKey and event.pressed and not event.echo and not name_input.visible and not inventory_search_active:
		var arrow_direction: int = 0
		if event.keycode == KEY_UP or event.physical_keycode == KEY_UP:
			arrow_direction = -1
		elif event.keycode == KEY_DOWN or event.physical_keycode == KEY_DOWN:
			arrow_direction = 1
		if arrow_direction != 0 and _navigate_paged_panel(arrow_direction):
			get_viewport().set_input_as_handled()
			return
	if event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_B and not name_input.visible and not inventory_search_active:
		if not show_bank and not _bank_nearby():
			notice = "Aproxima-te da Guardiã do Armazém (junto ao Ferreiro) e prime B."
			get_viewport().set_input_as_handled()
			return
		show_bank = not show_bank
		if show_bank:
			notice = "Guardiã: Bem-vindo ao armazém! Os teus pertences estão seguros comigo."
			show_inventory = false
			show_shop = false
			bank_page = 0
		get_viewport().set_input_as_handled()
		return
	if show_bank and not _bank_nearby():
		show_bank = false
		notice = "Afastaste-te do armazém."
	if show_bank and event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			bank_page += 1
			get_viewport().set_input_as_handled()
			return
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			bank_page = maxi(0, bank_page - 1)
			get_viewport().set_input_as_handled()
			return
		if event.button_index == MOUSE_BUTTON_LEFT:
			for target in bank_click_targets:
				if target["rect"].has_point(event.position):
					if socket.get_ready_state() == WebSocketPeer.STATE_OPEN:
						socket.send_text(JSON.stringify({"type":"bank_transfer", "direction":str(target["direction"]), "item":str(target["item"]), "gear_id":str(target.get("gear_id",""))}))
					else:
						notice = "Sem ligacao ao servidor. Nao foi possivel transferir o item."
					get_viewport().set_input_as_handled()
					return
		if Rect2(180, 75, 620, 430).has_point(event.position):
			get_viewport().set_input_as_handled()
			return

	# Filter controls and text search live entirely inside the backpack window.
	if show_inventory and not name_input.visible and not sell_confirm_open:
		if inventory_search_active and event is InputEventKey and event.pressed:
			if event.keycode == KEY_ESCAPE or event.keycode == KEY_ENTER or event.keycode == KEY_KP_ENTER:
				inventory_search_active = false
			elif event.keycode == KEY_BACKSPACE:
				if inventory_search.length() > 0:
					inventory_search = inventory_search.substr(0, inventory_search.length() - 1)
					inventory_page = 0
			elif event.unicode >= 32 and not event.ctrl_pressed and not event.alt_pressed and inventory_search.length() < 40:
				inventory_search += char(event.unicode)
				inventory_page = 0
			get_viewport().set_input_as_handled()
			return
		if event is InputEventMouseButton and event.pressed:
			var filter_click: Vector2 = get_global_mouse_position()
			if event.button_index == MOUSE_BUTTON_LEFT:
				for tab_index in range(INVENTORY_CATEGORIES.size()):
					var tab_rect: Rect2 = Rect2(511 + tab_index * 84, 250, 81, 20)
					if tab_rect.has_point(filter_click):
						inventory_category_index = tab_index
						inventory_page = 0
						inventory_search_active = false
						get_viewport().set_input_as_handled()
						return
				if Rect2(511, 273, 100, 20).has_point(filter_click):
					inventory_rarity_index = (inventory_rarity_index + 1) % INVENTORY_RARITIES.size()
					inventory_page = 0
					inventory_search_active = false
					get_viewport().set_input_as_handled()
					return
				if Rect2(615, 273, 102, 20).has_point(filter_click):
					inventory_sort_index = (inventory_sort_index + 1) % INVENTORY_SORTS.size()
					inventory_page = 0
					inventory_search_active = false
					get_viewport().set_input_as_handled()
					return
				if Rect2(721, 273, 207, 20).has_point(filter_click):
					inventory_search_active = true
					get_viewport().set_input_as_handled()
					return
			elif event.button_index == MOUSE_BUTTON_RIGHT and Rect2(721, 273, 207, 20).has_point(filter_click):
				inventory_search = ""
				inventory_page = 0
				inventory_search_active = false
				get_viewport().set_input_as_handled()
				return
	if dungeon_active and event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT and not name_input.visible:
		var crypt_mouse := get_global_mouse_position()
		var crypt_origin := Vector2(195, 151)
		var crypt_rect := Rect2(crypt_origin, Vector2(480, 240))
		if crypt_rect.has_point(crypt_mouse):
			var destination := Vector2i(int((crypt_mouse.x - crypt_origin.x) / 48.0), int((crypt_mouse.y - crypt_origin.y) / 48.0))
			dungeon_auto_route.clear()
			dungeon_manual_pause = 1.2
			dungeon_click_path = _crypt_find_path(dungeon_pos, destination)
			get_viewport().set_input_as_handled()
			return
	# Diary controls use viewport coordinates, never world coordinates.
	if show_quests and event is InputEventMouseButton and event.pressed:
		var diary_rect: Rect2 = Rect2(155, 55, 650, 465)
		if diary_rect.has_point(event.position):
			if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				quest_page += 1
			elif event.button_index == MOUSE_BUTTON_WHEEL_UP:
				quest_page = maxi(0, quest_page - 1)
			elif event.button_index == MOUSE_BUTTON_LEFT:
				if Rect2(570, 479, 95, 29).has_point(event.position):
					quest_page = maxi(0, quest_page - 1)
				elif Rect2(670, 479, 115, 29).has_point(event.position):
					quest_page += 1
			get_viewport().set_input_as_handled()
			return
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var click_pos: Vector2 = get_global_mouse_position()
		for slot in range(2):
			var rect: Rect2 = Rect2(HOTBAR_X + float(slot) * (HOTBAR_SIZE + HOTBAR_GAP), HOTBAR_Y, HOTBAR_SIZE, HOTBAR_SIZE)
			if rect.has_point(click_pos) and not show_shop and not show_inventory and not show_dialog and not show_quests and not show_professions and not show_classes and not show_skill_tree:
				_hotbar_action(slot)
				get_viewport().set_input_as_handled()
				return
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT and show_skill_tree:
		var tree_click: Vector2 = get_global_mouse_position()
		var selected_node: String = ""
		var tree_nodes: Array[String] = ["power", "guard", "technique", "mastery", "resilience"]
		for tree_index in range(tree_nodes.size()):
			if Rect2(295, 206 + tree_index * 57, 365, 49).has_point(tree_click):
				selected_node = tree_nodes[tree_index]
				break
		if selected_node != "" and socket.get_ready_state() == WebSocketPeer.STATE_OPEN:
			socket.send_text(JSON.stringify({"type":"unlock_skill_node", "node":selected_node}))
		get_viewport().set_input_as_handled()
		return
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT and show_classes:
		var class_mouse: Vector2 = get_global_mouse_position()
		for j in range(3):
			if Rect2(280, 174 + j * 38, 395, 35).has_point(class_mouse):
				var chosen: String = ["Guerreiro", "Mago", "Arqueiro"][j]
				if socket.get_ready_state() == WebSocketPeer.STATE_OPEN:
					notice = "Classe definitiva: " + str(profile.get("combat_class", "Guerreiro"))
				show_classes = false
				get_viewport().set_input_as_handled()
				return
		get_viewport().set_input_as_handled()
		return
	if event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_U and not name_input.visible:
		if show_shop and smith_mode == "upgrade":
			show_shop = false
			smith_mode = "shop"
		elif _smith_nearby():
			show_shop = true
			smith_mode = "upgrade"
			show_dialog = false
			smith_dialog = false
			show_inventory = false
		else:
			notice = "Aproxima-te do Ferreiro para abrir as melhorias (U)."
		upgrade_confirm_slot = ""
		get_viewport().set_input_as_handled()
		return
	if smith_mode == "upgrade" and show_shop and event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var mouse_pos := get_global_mouse_position()
		for j in range(3):
			var enchant_rect := Rect2(30 + j * 136, 444, 130, 29)
			if enchant_rect.has_point(mouse_pos):
				if upgrade_confirm_slot == "":
					notice = "Seleciona primeiro um equipamento com um clique."
				else:
					var enchant_name: String = ["Furia", "Protecao", "Runico"][j]
					if socket.get_ready_state() == WebSocketPeer.STATE_OPEN:
						socket.send_text(JSON.stringify({"type":"enchant", "slot":upgrade_confirm_slot, "enchant":enchant_name}))
					upgrade_confirm_slot = ""
				get_viewport().set_input_as_handled()
				return
		for i in range(3):
			var slot_rect := Rect2(30, 130 + i * 98, 404, 88)
			if slot_rect.has_point(mouse_pos):
				var slot_name: String = ["weapon", "offhand", "armor"][i]
				if upgrade_confirm_slot == slot_name:
					if socket.get_ready_state() == WebSocketPeer.STATE_OPEN:
						socket.send_text(JSON.stringify({"type":"upgrade", "slot":slot_name}))
					upgrade_confirm_slot = ""
				else:
					upgrade_confirm_slot = slot_name
				get_viewport().set_input_as_handled()
				return
	if sell_confirm_open and event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_ESCAPE:
		sell_confirm_open = false
		get_viewport().set_input_as_handled()
		return
	if sell_confirm_open and event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			var point := get_global_mouse_position()
			var owned: int = int(profile.get("inventory", {}).get(pending_sale_item, 0))
			for qty_index in range(6):
				var qty_rect := Rect2(500 + qty_index * 65, 292, 61, 32)
				if qty_rect.has_point(point):
					var qty_value: int = [1, 5, 10, 20, 50, owned][qty_index]
					pending_sale_quantity = 1 if pending_sale_gear_id != "" else mini(9999, mini(owned, qty_value))
					break
			if Rect2(500, 350, 185, 43).has_point(point):
				if pending_sale_quantity > 0 and pending_sale_quantity <= owned and socket.get_ready_state() == WebSocketPeer.STATE_OPEN:
					socket.send_text(JSON.stringify({"type":"sell", "item":pending_sale_item, "quantity":pending_sale_quantity, "gear_id":pending_sale_gear_id}))
				sell_confirm_open = false
			elif Rect2(696, 350, 185, 43).has_point(point):
				sell_confirm_open = false
		get_viewport().set_input_as_handled()
		return
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
		click_attack_target_id = ""
		var click := get_global_mouse_position()
		if click.y < 44.0 or click.y > 540.0 or name_input.visible or not players.has(player_id):
			return
		if show_inventory and Rect2(495, 60, 448, 458).has_point(click):
			for target in inventory_click_targets:
				if target["rect"].has_point(click):
					_ask_sell(str(target["item"]), str(target.get("gear_id", "")))
					get_viewport().set_input_as_handled()
					return
		# Evita movimentacao ao clicar nas janelas.
		if (show_inventory and Rect2(495, 60, 448, 458).has_point(click)) or (show_quests and Rect2(155, 55, 650, 465).has_point(click)):
			return
		if show_shop or show_dialog:
			return
		# Botao direito reservado para venda e acoes de contexto.
		get_viewport().set_input_as_handled()
		return
	if event is InputEventMouseButton and event.pressed and show_inventory and Rect2(495, 60, 448, 458).has_point(get_global_mouse_position()):
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			inventory_page += 1
			get_viewport().set_input_as_handled()
			return
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			inventory_page = maxi(0, inventory_page - 1)
			get_viewport().set_input_as_handled()
			return
	if event is InputEventMouseButton and event.pressed and show_shop and smith_mode == "craft" and Rect2(16, 62, 420, 455).has_point(get_global_mouse_position()):
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			smith_recipe_page = mini(int(ceili(float(SMITH_RECIPES.size()) / 5.0)) - 1, smith_recipe_page + 1)
			get_viewport().set_input_as_handled()
			return
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			smith_recipe_page = maxi(0, smith_recipe_page - 1)
			get_viewport().set_input_as_handled()
			return
	if event is InputEventMouseButton and event.pressed and show_shop and smith_mode == "shop" and Rect2(16, 62, 435, 520).has_point(get_global_mouse_position()):
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			sell_page = mini(2, sell_page + 1)
			get_viewport().set_input_as_handled()
			return
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			sell_page = maxi(0, sell_page - 1)
			get_viewport().set_input_as_handled()
			return
	if event is InputEventMouseMotion:
		var mouse := get_global_mouse_position()
		hover_item = ""
		hover_gear_id = ""
		if show_inventory:
			for target in inventory_click_targets:
				if target["rect"].has_point(mouse):
					hover_item = str(target["item"])
					hover_gear_id = str(target.get("gear_id", ""))
					break
		if hover_item == "" and show_shop:
			for target in shop_click_targets:
				if target["rect"].has_point(mouse):
					hover_item = str(target["item"])
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		var mouse := get_global_mouse_position()
		if smith_dialog and show_dialog:
			for target in smith_dialog_click_targets:
				if target["rect"].has_point(mouse):
					smith_mode = str(target["mode"])
					show_dialog = false
					smith_dialog = false
					show_shop = true
					get_viewport().set_input_as_handled()
					return
		if show_inventory:
			for target in inventory_click_targets:
				if target["rect"].has_point(mouse):
					if str(target["action"]) == "inspect":
						notice = _item_description(str(target["item"]))
					elif str(target["action"]) == "equip" and str(target.get("gear_id", "")) != "":
						if socket.get_ready_state() == WebSocketPeer.STATE_OPEN:
							socket.send_text(JSON.stringify({"type":"equip", "item":str(target["item"]), "gear_id":str(target["gear_id"])}))
					else:
						_send_action(str(target["action"]), str(target["item"]))
					get_viewport().set_input_as_handled()
					return
		if show_shop:
			for target in crafting_click_targets:
				if target["rect"].has_point(mouse):
					socket.send_text(JSON.stringify({"type":"craft","recipe":str(target["recipe"])}))
					get_viewport().set_input_as_handled()
					return
			for target in shop_click_targets:
				if target["rect"].has_point(mouse):
					if str(target["action"]) == "sell":
						_ask_sell(str(target["item"]))
					else:
						_send_action(str(target["action"]), str(target["item"]))
					get_viewport().set_input_as_handled()
					return
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var attack_mouse: Vector2 = get_global_mouse_position()
		if attack_mouse.y >= 45.0 and attack_mouse.y < 538.0 and not show_inventory and not show_shop and not show_dialog and not show_quests and not show_professions and not show_classes and not show_skill_tree and not sell_confirm_open and not name_input.visible:
			var nearest_id := ""
			var nearest_distance := 43.0
			var attack_world: Vector2 = _screen_to_world(attack_mouse)
			for monster_id in monsters:
				var monster: Dictionary = monsters[monster_id]
				if not bool(monster.get("alive", false)):
					continue
				var monster_pos := Vector2(float(monster.get("x", 0)), float(monster.get("y", 0)))
				var distance_to_click := attack_world.distance_to(monster_pos)
				if distance_to_click < nearest_distance:
					nearest_distance = distance_to_click
					nearest_id = str(monster_id)
			if nearest_id != "":
				click_attack_target_id = nearest_id
				click_attack_elapsed = 0.0
				auto_repath_elapsed = 0.0
				manual_click_route = false
			else:
				# Clique esquerdo: monstro > material > deslocacao.
				click_attack_target_id = ""
				var resource_id := ""
				var resource_distance := 35.0
				for resource in profile.get("resource_nodes", []):
					var resource_pos := Vector2(float(resource.get("x", 0)), float(resource.get("y", 0)))
					var distance := attack_world.distance_to(resource_pos)
					if distance < resource_distance:
						resource_distance = distance
						resource_id = str(resource.get("id", ""))
				if resource_id != "":
					if players.has(player_id):
						var me: Dictionary = players[player_id]
						var hero_pos := Vector2(float(me.get("x", 0)), float(me.get("y", 0)))
						if hero_pos.distance_to(attack_world) <= 85.0 and socket.get_ready_state() == WebSocketPeer.STATE_OPEN:
							socket.send_text(JSON.stringify({"type":"gather", "node_id":resource_id}))
						else:
							_nav_route(hero_pos, attack_world)
							manual_click_route = nav_active
							notice = "Aproxima-te do recurso e clica novamente para recolher."
				elif players.has(player_id):
					var me: Dictionary = players[player_id]
					_nav_route(Vector2(float(me.get("x", 0)), float(me.get("y", 0))), attack_world)
					manual_click_route = nav_active
			get_viewport().set_input_as_handled()
			return

# Inventory categories and sorting only change what is displayed, never the inventory itself.
func _inventory_entry_category(entry: Dictionary) -> String:
	var item_name: String = str(entry.get("name", ""))
	if item_name == "Selo das Ruinas":
		return "Missao"
	if str(entry.get("id", "")) != "" or EQUIPMENT_RARITY.has(item_name):
		return "Equipamentos"
	if item_name.begins_with("Pocao"):
		return "Consumiveis"
	return "Materiais"

func _inventory_visible_entries(entries: Array) -> Array:
	var result: Array = []
	var category: String = INVENTORY_CATEGORIES[inventory_category_index]
	var rarity: String = INVENTORY_RARITIES[inventory_rarity_index]
	var query: String = inventory_search.strip_edges().to_lower()
	for value in entries:
		if not (value is Dictionary):
			continue
		var entry: Dictionary = value
		var item_name: String = str(entry.get("name", ""))
		if category != "Todos" and _inventory_entry_category(entry) != category:
			continue
		var entry_rarity: String = str(EQUIPMENT_RARITY.get(item_name, "Comum"))
		if rarity != "Todas" and entry_rarity != rarity:
			continue
		if query != "" and not item_name.to_lower().contains(query):
			continue
		result.append(entry)
	var order: int = inventory_sort_index
	result.sort_custom(func(a: Dictionary, b: Dictionary) -> bool:
		var an: String = str(a.get("name", ""))
		var bn: String = str(b.get("name", ""))
		if order == 1:
			var aq: int = int(a.get("amount", 0))
			var bq: int = int(b.get("amount", 0))
			if aq != bq:
				return aq > bq
		elif order == 2:
			var rank: Dictionary = {"Comum":0, "Incomum":1, "Raro":2, "Epico":3, "Lendario":4}
			var ar: int = int(rank.get(str(EQUIPMENT_RARITY.get(an, "Comum")), 0))
			var br: int = int(rank.get(str(EQUIPMENT_RARITY.get(bn, "Comum")), 0))
			if ar != br:
				return ar > br
		return an.naturalnocasecmp_to(bn) < 0
	)
	return result

func _item_icon(item: String) -> String:
	match item:
		"Espada de ferro": return "ESP"
		"Escudo de madeira": return "ESC"
		"Armadura de couro": return "ARM"
		"Lamina de presas": return "PRE"
		"Presa de lobo": return "FNG"
		"Adaga enferrujada": return "ADG"
		"Fragmento de metal antigo": return "MET"
		"Minerio de ferro": return "FER"
		"Barra de ferro": return "BAR"
		"Madeira": return "MAD"
		"Fragmento de madeira": return "FMA"
		"Fragmento de rocha": return "FRO"
		"Tabua de madeira": return "TAB"
		"Bloco de pedra": return "BLO"
		"Escudo reforcado": return "REF"
		"Armadura de pedra": return "PED"
		"Escudo do saqueador": return "SAQ"
		"Espada do saqueador": return "SAD"
		"Erva rara": return "ERV"
		"Selo das Ruinas": return "SEL"
		"Pocao pequena": return "HP+"
		"Pocao media": return "HP++"
		"Pocao completa": return "FULL"
		"Espada ancestral": return "ANC"
		"Machado de lenhador": return "MCH"
		"Picareta de mineiro": return "PIC"
		"Kit de herbalista": return "KIT"
		"Machado de aco": return "ACO"
		"Picareta de aco": return "PCA"
		"Kit botanico": return "BOT"
		"Armadura de ferro": return "AFR"
		"Escudo reforcado de aco": return "ERA"
		"Espada de aco do Guardiao": return "EAG"
		"Espada de cavaleiro": return "ECV"
		"Lamina real de Valedouro": return "LRV"
		"Escudo de ferro": return "EFR"
		"Escudo da muralha": return "EMU"
		"Armadura de placas reais": return "APR"
		"Armadura do trono": return "ATR"
		"Pele de lobo": return "PEL"
		"Retalho de tecido": return "TEC"
	return "???"

func _item_description(item: String) -> String:
	if EQUIPMENT_COMPARE.has(item) and EQUIPMENT_LEVEL_REQUIREMENTS.has(item):
		var item_data: Dictionary = EQUIPMENT_COMPARE[item]
		var required_level: int = int(EQUIPMENT_LEVEL_REQUIREMENTS[item])
		var required_class: String = str(EQUIPMENT_REQUIRED_CLASS.get(item, ""))
		var stat_text: String = "+%d ATQ" % int(item_data.get("attack", 0)) if int(item_data.get("attack", 0)) > 0 else "+%d DEF" % int(item_data.get("defense", 0))
		return "%s | %s | Nivel %d | %s" % [item, stat_text, required_level, required_class]
	match item:
		"Espada de cavaleiro": return "Ataque +18 | Compra: 520 ouro"
		"Espada de aco do Guardiao": return "Ataque +32 | Compra: 1250 ouro"
		"Lamina real de Valedouro": return "Ataque +46 | Compra: 2800 ouro"
		"Escudo de ferro": return "Defesa +11 | Compra: 480 ouro"
		"Escudo reforcado de aco": return "Defesa +19 | Compra: 850 ouro"
		"Escudo da muralha": return "Defesa +29 | Compra: 1950 ouro"
		"Armadura de ferro": return "Defesa +16 | Compra: 650 ouro"
		"Armadura de placas reais": return "Defesa +25 | Compra: 1600 ouro"
		"Armadura do trono": return "Defesa +37 | Compra: 3400 ouro"
		"Espada de ferro": return "Arma | +8 ataque | Clica para equipar"
		"Escudo de madeira": return "Escudo | +3 defesa | Clica para equipar"
		"Armadura de couro": return "Armadura | +5 defesa | Clica para equipar"
		"Pocao pequena": return "Consumivel | Recupera 35 HP | Clica para usar"
		"Pele de lobo": return "Material | Vende ao Ferreiro por 5 ouro"
		"Retalho de tecido": return "Material | Vende ao Ferreiro por 8 ouro"
		"Selo das Ruinas": return "Reliquia | Entrega a Tessa na missao do Guardiao"
		"Lamina de presas": return "Arma +14 ataque | Fabricada no ferreiro"
		"Presa de lobo": return "Material raro 15% | 2 presas + 1 barra = Lamina"
		"Adaga enferrujada": return "Drop raro 20% | Forja escudos e espadas"
		"Fragmento de metal antigo": return "Drop raro 15% do Guardiao"
		"Minerio de ferro": return "Minerio: 70% na rocha | 3 minerios = 1 barra"
		"Barra de ferro": return "Material | Usada para criar Lamina de presas"
		"Madeira": return "Recurso recolhido em arvores"
		"Erva rara": return "Recurso raro recolhido em arbustos"
		"Pocao media": return "Recupera 100 HP"
		"Pocao completa": return "Recupera toda a vida"
		"Espada ancestral": return "Arma lendaria +38 ataque"
		"Machado de lenhador": return "Ferramenta | Lenhador nivel 3: +1 fragmento de madeira"
		"Picareta de mineiro": return "Ferramenta | Mineiro nivel 3: +10% chance de ferro"
		"Kit de herbalista": return "Ferramenta | Herbalista nivel 3: +10% chance de erva"
		"Machado de aco": return "Ferramenta avancada | Lenhador 6: +2 madeira"
		"Picareta de aco": return "Ferramenta avancada | Mineiro 6: +20% chance de ferro"
		"Kit botanico": return "Ferramenta avancada | Herbalista 6: +20% chance de erva"
		"Fragmento de madeira": return "3 por arvore | 6 para uma tabua | Vendavel"
		"Fragmento de rocha": return "3 se nao sair minerio | 6 para um bloco | Vendavel"
		"Tabua de madeira": return "2 tabuas + 3 peles = Escudo reforcado"
		"Bloco de pedra": return "2 blocos + 1 barra = Armadura de pedra"
		"Escudo reforcado": return "Escudo +6 defesa | Criado no Ferreiro"
		"Armadura de pedra": return "Armadura +10 defesa | Criada no Ferreiro"
		"Escudo do saqueador": return "Escudo raro +13 defesa | 25% na forja"
		"Espada do saqueador": return "Espada rara +25 ataque | 12% na forja"
	return item


# Apenas dados de apresentacao; o servidor continua a ser autoritativo.
const EQUIPMENT_CLASS_REQUIREMENTS := {
	"Arco do Sino Partido": "Arqueiro",
	"Aljava do Sino Partido": "Arqueiro",
	"Colete do Sino Partido": "Arqueiro",
	"Cajado do Sino Partido": "Mago",
	"Orbe do Sino Partido": "Mago",
	"Manto do Sino Partido": "Mago",
	"Lamina do Sino Partido": "Guerreiro",
	"Escudo do Sino Partido": "Guerreiro",
	"Armadura do Sino Partido": "Guerreiro",
}
const EQUIPMENT_LEVEL_REQUIREMENTS := {"Lamina da Aurora de Valedouro": 40, "Arco da Bruma Antiga": 40, "Cajado do Firmamento": 40, "Armadura do Bastião": 60, "Colete da Sombra Verde": 60, "Manto das Estrelas": 60, "Arco do Aprendiz": 1, "Colete do Explorador": 1, "Cajado do Aprendiz": 1, "Veste do Aprendiz": 1, "Espada da Guarda de Valedouro": 20, "Arco do Vigia Runico": 20, "Cajado do Eco Runico": 20, "Couraca da Guarda": 20, "Colete do Batedor": 20, "Manto do Eco": 20}
const EQUIPMENT_REQUIRED_CLASS := {"Lamina da Aurora de Valedouro": "Guerreiro", "Arco da Bruma Antiga": "Arqueiro", "Cajado do Firmamento": "Mago", "Armadura do Bastião": "Guerreiro", "Colete da Sombra Verde": "Arqueiro", "Manto das Estrelas": "Mago", "Arco do Aprendiz": "Arqueiro", "Colete do Explorador": "Arqueiro", "Cajado do Aprendiz": "Mago", "Veste do Aprendiz": "Mago", "Espada da Guarda de Valedouro": "Guerreiro", "Arco do Vigia Runico": "Arqueiro", "Cajado do Eco Runico": "Mago", "Couraca da Guarda": "Guerreiro", "Colete do Batedor": "Arqueiro", "Manto do Eco": "Mago"}
const EQUIPMENT_COMPARE := {
	"Arco do Sino Partido": {"slot":"weapon", "attack":35, "defense":0, "price":0},
	"Aljava do Sino Partido": {"slot":"offhand", "attack":0, "defense":20, "price":0},
	"Colete do Sino Partido": {"slot":"armor", "attack":0, "defense":30, "price":0},
	"Cajado do Sino Partido": {"slot":"weapon", "attack":35, "defense":0, "price":0},
	"Orbe do Sino Partido": {"slot":"offhand", "attack":0, "defense":20, "price":0},
	"Manto do Sino Partido": {"slot":"armor", "attack":0, "defense":30, "price":0},

	"Lamina da Aurora de Valedouro": {"slot":"weapon", "attack":44, "defense":0, "price":0},
	"Arco da Bruma Antiga": {"slot":"weapon", "attack":42, "defense":0, "price":0},
	"Cajado do Firmamento": {"slot":"weapon", "attack":41, "defense":0, "price":0},
	"Armadura do Bastião": {"slot":"armor", "attack":0, "defense":40, "price":0},
	"Colete da Sombra Verde": {"slot":"armor", "attack":0, "defense":30, "price":0},
	"Manto das Estrelas": {"slot":"armor", "attack":0, "defense":25, "price":0},
	"Arco do Aprendiz": {"slot":"weapon", "attack":11, "defense":0, "price":180},
	"Colete do Explorador": {"slot":"armor", "attack":0, "defense":9, "price":210},
	"Cajado do Aprendiz": {"slot":"weapon", "attack":12, "defense":0, "price":180},
	"Veste do Aprendiz": {"slot":"armor", "attack":0, "defense":8, "price":210},

	"Espada da Guarda de Valedouro": {"slot":"weapon", "attack":29, "defense":0, "price":0},
	"Arco do Vigia Runico": {"slot":"weapon", "attack":27, "defense":0, "price":0},
	"Cajado do Eco Runico": {"slot":"weapon", "attack":26, "defense":0, "price":0},
	"Couraca da Guarda": {"slot":"armor", "attack":0, "defense":24, "price":0},
	"Colete do Batedor": {"slot":"armor", "attack":0, "defense":17, "price":0},
	"Manto do Eco": {"slot":"armor", "attack":0, "defense":13, "price":0},

	"Espada de ferro": {"slot":"weapon", "attack":8, "defense":0, "price":65},
	"Escudo de madeira": {"slot":"offhand", "attack":0, "defense":3, "price":45},
	"Armadura de couro": {"slot":"armor", "attack":0, "defense":5, "price":90},
	"Lamina de presas": {"slot":"weapon", "attack":14, "defense":0, "price":0},
	"Espada ancestral": {"slot":"weapon", "attack":38, "defense":0, "price":0},
	"Escudo reforcado": {"slot":"offhand", "attack":0, "defense":6, "price":0},
	"Armadura de pedra": {"slot":"armor", "attack":0, "defense":10, "price":0},
	"Escudo do saqueador": {"slot":"offhand", "attack":0, "defense":13, "price":0},
	"Espada do saqueador": {"slot":"weapon", "attack":25, "defense":0, "price":0},
	"Armadura de ferro": {"slot":"armor", "attack":0, "defense":16, "price":650},
	"Escudo reforcado de aco": {"slot":"offhand", "attack":0, "defense":19, "price":850},
	"Espada de aco do Guardiao": {"slot":"weapon", "attack":32, "defense":0, "price":1250},
	"Espada de cavaleiro": {"slot":"weapon", "attack":18, "defense":0, "price":520},
	"Lamina real de Valedouro": {"slot":"weapon", "attack":46, "defense":0, "price":2800},
	"Escudo de ferro": {"slot":"offhand", "attack":0, "defense":11, "price":480},
	"Escudo da muralha": {"slot":"offhand", "attack":0, "defense":29, "price":1950},
	"Armadura de placas reais": {"slot":"armor", "attack":0, "defense":25, "price":1600},
	"Armadura do trono": {"slot":"armor", "attack":0, "defense":37, "price":3400},
	"Lamina do Sino Partido": {"slot":"weapon", "attack":35, "defense":0, "price":0},
	"Escudo do Sino Partido": {"slot":"offhand", "attack":0, "defense":20, "price":0},
	"Armadura do Sino Partido": {"slot":"armor", "attack":0, "defense":30, "price":0},
	"Lamina da Vigilia Runica": {"slot":"weapon", "attack":30, "defense":0, "price":0},
}

# Raridade e uma classificacao visual fixa dos equipamentos existentes.
# Os atributos e os precos permanecem sob autoridade do servidor.
const EQUIPMENT_RARITY := {
	"Arco do Sino Partido":"Raro",
	"Aljava do Sino Partido":"Raro",
	"Colete do Sino Partido":"Raro",
	"Cajado do Sino Partido":"Raro",
	"Orbe do Sino Partido":"Raro",
	"Manto do Sino Partido":"Raro",

	"Lamina da Aurora de Valedouro":"Epico",
	"Arco da Bruma Antiga":"Epico",
	"Cajado do Firmamento":"Epico",
	"Armadura do Bastião":"Epico",
	"Colete da Sombra Verde":"Epico",
	"Manto das Estrelas":"Epico",
	"Arco do Aprendiz":"Comum",
	"Colete do Explorador":"Comum",
	"Cajado do Aprendiz":"Comum",
	"Veste do Aprendiz":"Comum",

	"Espada da Guarda de Valedouro":"Raro",
	"Arco do Vigia Runico":"Raro",
	"Cajado do Eco Runico":"Raro",
	"Couraca da Guarda":"Raro",
	"Colete do Batedor":"Raro",
	"Manto do Eco":"Raro",

	"Espada de ferro":"Comum", "Escudo de madeira":"Comum", "Armadura de couro":"Comum",
	"Espada de cavaleiro":"Incomum", "Escudo de ferro":"Incomum", "Armadura de ferro":"Incomum",
	"Lamina de presas":"Incomum", "Escudo reforcado":"Incomum", "Armadura de pedra":"Incomum",
	"Escudo do saqueador":"Raro", "Espada do saqueador":"Raro", "Lamina da Vigilia Runica":"Raro", "Espada de aco do Guardiao":"Raro",
	"Escudo reforcado de aco":"Raro", "Armadura de placas reais":"Epico", "Escudo da muralha":"Epico",
	"Espada ancestral":"Epico", "Lamina real de Valedouro":"Lendario", "Armadura do trono":"Lendario",
	"Lamina do Sino Partido":"Raro", "Escudo do Sino Partido":"Raro", "Armadura do Sino Partido":"Raro"
}

func _rarity_color(item: String) -> Color:
	match str(EQUIPMENT_RARITY.get(item, "")):
		"Comum": return Color("c6cbc5")
		"Incomum": return Color("83d6a0")
		"Raro": return Color("80b7f4")
		"Epico": return Color("c5a0f8")
		"Lendario": return Color("f6c66d")
	return Color("697969")

func _draw_individual_gear_comparison(gear_id: String) -> void:
	var selected: Dictionary = {}
	for value in profile.get("gear_bag", []):
		if value is Dictionary and str(value.get("id", "")) == gear_id:
			selected = value
			break
	if selected.is_empty():
		return
	var name: String = str(selected.get("name", ""))
	if not EQUIPMENT_COMPARE.has(name):
		return
	var candidate: Dictionary = EQUIPMENT_COMPARE[name]
	var slot: String = str(candidate.get("slot", ""))
	var equipped_items: Dictionary = profile.get("equipment", {})
	var equipped_gears: Dictionary = profile.get("gear_equipped", {})
	var current_name: String = str(equipped_items.get(slot, ""))
	var current: Dictionary = EQUIPMENT_COMPARE.get(current_name, {})
	var current_gear: Dictionary = equipped_gears.get(slot, {})
	var attribute: String = "attack" if slot == "weapon" else "defense"
	var label: String = "ATQ" if slot == "weapon" else "DEF"
	var level: int = int(selected.get("level", 0))
	var current_level: int = int(current_gear.get("level", 0))
	var enchant: String = str(selected.get("enchant", ""))
	var current_enchant: String = str(current_gear.get("enchant", ""))
	var enchant_bonus: Dictionary = {"Furia":{"attack":3,"defense":0}, "Protecao":{"attack":0,"defense":3}, "Runico":{"attack":5,"defense":5}}
	var new_bonus: Dictionary = enchant_bonus.get(enchant, {})
	var old_bonus: Dictionary = enchant_bonus.get(current_enchant, {})
	var new_stat: int = int(candidate.get(attribute, 0)) + level * 2 + int(new_bonus.get(attribute, 0))
	var old_stat: int = int(current.get(attribute, 0)) + current_level * 2 + int(old_bonus.get(attribute, 0))
	var difference: int = new_stat - old_stat
	var origin := Vector2(495, 370)
	var area := Rect2(origin, Vector2(447, 174))
	draw_rect(area, Color("14272b", 0.99))
	draw_rect(area, _rarity_color(name), false, 2.0)
	_draw_panel_text(origin + Vector2(12, 23), "INSPECIONAR: " + name + " +%d" % level, _rarity_color(name), 13, 418.0)
	_draw_panel_text(origin + Vector2(12, 45), "Raridade: " + str(EQUIPMENT_RARITY.get(name, "Comum")) + " | Encanto: " + (enchant if enchant != "" else "Nenhum"), Color("e5ddc5"), 12, 418.0)
	_draw_panel_text(origin + Vector2(12, 69), "Equipado: " + (current_name + " +%d" % current_level if current.has(attribute) else "Nenhum"), Color("cdd7d1"), 12, 418.0)
	_draw_panel_text(origin + Vector2(12, 92), "%s atual: %d    Selecionado: %d" % [label, old_stat, new_stat], Color.WHITE, 13)
	_draw_panel_text(origin + Vector2(12, 116), "Variacao: %+d %s" % [difference, label], Color("85e5a3") if difference > 0 else Color("f29a8d") if difference < 0 else Color("d2d5ce"), 14)
	if name in ["Lamina do Sino Partido", "Escudo do Sino Partido", "Armadura do Sino Partido", "Arco do Sino Partido", "Aljava do Sino Partido", "Colete do Sino Partido", "Cajado do Sino Partido", "Orbe do Sino Partido", "Manto do Sino Partido"]:
		var pieces: Array[String] = ["Lamina do Sino Partido", "Escudo do Sino Partido", "Armadura do Sino Partido"]
		if str(profile.get("combat_class", "Guerreiro")) == "Arqueiro":
			pieces = ["Arco do Sino Partido", "Aljava do Sino Partido", "Colete do Sino Partido"]
		elif str(profile.get("combat_class", "Guerreiro")) == "Mago":
			pieces = ["Cajado do Sino Partido", "Orbe do Sino Partido", "Manto do Sino Partido"]
		var count_before: int = 0
		for piece_slot in ["weapon", "offhand", "armor"]:
			if str(equipped_items.get(piece_slot, "")) in pieces:
				count_before += 1
		var count_after: int = count_before
		if current_name != name:
			if current_name in pieces:
				count_after -= 1
			count_after += 1
		var preview: String = "Conjunto: %d/3 -> %d/3" % [count_before, count_after]
		if count_after >= 3:
			preview += "  (+8 DEF, +12 ATQ)"
		elif count_after >= 2:
			preview += "  (+8 DEF)"
		_draw_panel_text(origin + Vector2(12, 142), preview, Color("90caff"), 11, 418.0)
	else:
		_draw_panel_text(origin + Vector2(12, 142), "Encanto equipado: " + (current_enchant if current_enchant != "" else "Nenhum"), Color("b5d8bd"), 11)
	_draw_panel_text(origin + Vector2(12, 162), "Unidade: " + gear_id.substr(0, 8) + " | Clica para equipar", Color("d6c8a8"), 11)

func _draw_equipment_comparison(item: String) -> bool:
	if not EQUIPMENT_COMPARE.has(item):
		return false
	var candidate: Dictionary = EQUIPMENT_COMPARE[item]
	var slot: String = str(candidate["slot"])
	var equipped: Dictionary = profile.get("equipment", {})
	var current_name: String = str(equipped.get(slot, ""))
	var current: Dictionary = EQUIPMENT_COMPARE.get(current_name, {})
	var stat: String = "ATQ" if slot == "weapon" else "DEF"
	var key: String = "attack" if slot == "weapon" else "defense"
	var before: int = int(current.get(key, 0))
	var after: int = int(candidate.get(key, 0))
	var diff: int = after - before
	var diff_color: Color = Color("85e5a3") if diff > 0 else Color("f29a8d") if diff < 0 else Color("d2d5ce")
	var origin: Vector2 = Vector2(495, 394) if show_inventory else Vector2(495, 78)
	var area := Rect2(origin, Vector2(447, 134))
	draw_rect(area, Color("14272b", 0.98))
	draw_rect(area, Color("c4a76a"), false, 1.5)
	_draw_panel_text(origin + Vector2(12, 22), "COMPARAR: " + item, Color("f3ce80"), 13, 420)
	_draw_panel_text(origin + Vector2(12, 34), "RARIDADE: " + str(EQUIPMENT_RARITY.get(item, "Comum")), _rarity_color(item), 11)
	_draw_panel_text(origin + Vector2(12, 51), "Equipado: " + (current_name if current.has(key) else "Nenhum"), Color("d3d9d3"), 12, 415)
	_draw_panel_text(origin + Vector2(12, 76), "%s atual: %d     Novo: %d" % [stat, before, after], Color.WHITE, 13)
	_draw_panel_text(origin + Vector2(12, 99), "Variacao: %+d %s" % [diff, stat], diff_color, 14)
	if int(candidate.get("price", 0)) > 0:
		_draw_panel_text(origin + Vector2(250, 118), "Loja: %d ouro" % int(candidate["price"]), Color("f3ce80"), 11)
	return true

func _draw_item_slot(rect: Rect2, item: String, amount: int, action: String, is_shop: bool = false) -> void:
	var highlighted := rect.has_point(get_global_mouse_position())
	draw_rect(rect, Color("405a54") if highlighted else Color("24363c"))
	draw_rect(rect, Color("e8c76b") if highlighted else _rarity_color(item), false, 1.5)
	var icon_rect := Rect2(rect.position + Vector2(5, 5), Vector2(43, rect.size.y - 10))
	draw_rect(icon_rect, Color("364943"))
	if official_item_icons.has(item):
		draw_texture_rect(official_item_icons[item], Rect2(icon_rect.position + Vector2(2, 0), Vector2(39, 39)), false)
	elif visual_icons.has(item):
		draw_texture_rect(visual_icons[item], Rect2(icon_rect.position + Vector2(2, 0), Vector2(39, 39)), false)
	else:
		var fallback_icon: Texture2D = null
		var lower_name: String = item.to_lower()
		if lower_name.contains("espada") or lower_name.contains("lamina") or lower_name.contains("arco") or lower_name.contains("cajado"):
			fallback_icon = visual_icons.get("Espada de ferro", null)
		elif lower_name.contains("escudo") or lower_name.contains("aljava") or lower_name.contains("orbe"):
			fallback_icon = visual_icons.get("Escudo de madeira", null)
		elif lower_name.contains("armadura") or lower_name.contains("colete") or lower_name.contains("manto") or lower_name.contains("veste"):
			fallback_icon = visual_icons.get("Armadura de couro", null)
		elif lower_name.contains("pocao"):
			fallback_icon = visual_icons.get("Pocao pequena", null)
		if fallback_icon != null:
			var category_index: int = 0
			if lower_name.contains("arco"): category_index = 2
			elif lower_name.contains("cajado"): category_index = 3
			elif lower_name.contains("escudo"): category_index = 4
			elif lower_name.contains("armadura") or lower_name.contains("colete"): category_index = 5
			elif lower_name.contains("manto") or lower_name.contains("veste"): category_index = 6
			elif lower_name.contains("pocao"): category_index = 13
			var source_x: float = float(category_index) * 69.75
			draw_texture_rect_region(visual_items_reference, Rect2(icon_rect.position + Vector2(2, 0), Vector2(39, 39)), Rect2(source_x, 0, 69.75, 121))
		else:
			_draw_panel_text(icon_rect.position + Vector2(5, 25), _item_icon(item), Color("f4d28c"), 12)
	var name_max_width := rect.size.x - 111.0
	var font := ThemeDB.fallback_font
	var name_size := 11
	var words := item.split(" ")
	var name_lines: Array[String] = []
	var current_line := ""
	for word in words:
		var candidate := word if current_line == "" else current_line + " " + word
		if font.get_string_size(candidate, HORIZONTAL_ALIGNMENT_LEFT, -1, name_size).x > name_max_width and current_line != "":
			name_lines.append(current_line)
			current_line = word
		else:
			current_line = candidate
	if current_line != "":
		name_lines.append(current_line)
	for line_index in range(mini(3, name_lines.size())):
		_draw_panel_text(rect.position + Vector2(57, 16 + line_index * 12), name_lines[line_index], _rarity_color(item) if EQUIPMENT_RARITY.has(item) else Color.WHITE, name_size, name_max_width)
	if amount > 0:
		_draw_panel_text(rect.position + Vector2(rect.size.x - 44, 24), "x%d" % amount, Color("f3ce80"), 12)
	var target := {"rect":rect, "item":item, "action":action}
	if is_shop:
		shop_click_targets.append(target)
	else:
		inventory_click_targets.append(target)

func _ready() -> void:
	gathering_audio = AudioStreamPlayer.new()
	gathering_audio.volume_db = -11.0
	add_child(gathering_audio)
	crafting_audio = AudioStreamPlayer.new()
	crafting_audio.volume_db = -13.0
	add_child(crafting_audio)
	_build_navigation()
	name_input = LineEdit.new()
	name_input.position = Vector2(315, 165)
	name_input.size = Vector2(320, 42)
	name_input.placeholder_text = "Nome do heroi (3-20 caracteres) + Enter"
	name_input.visible = false
	add_child(name_input)
	name_input.text_submitted.connect(_submit_name)
	class_picker = OptionButton.new()
	class_picker.position = Vector2(315, 215)
	class_picker.size = Vector2(320, 38)
	for hero_class in ["Guerreiro", "Arqueiro", "Mago"]:
		class_picker.add_item(hero_class)
	class_picker.visible = false
	add_child(class_picker)
	class_picker.item_selected.connect(_on_creation_class_selected)
	# Lista de herois existente, independente da criacao de um novo heroi.
	saved_hero_picker = OptionButton.new()
	saved_hero_picker.position = Vector2(315, 112)
	saved_hero_picker.size = Vector2(320, 38)
	saved_hero_picker.add_item("A aguardar personagens...")
	# Impedir que o clique na interface atravesse para o mundo 2D.
	saved_hero_picker.mouse_filter = Control.MOUSE_FILTER_STOP
	#saved_hero_picker.get_popup().mouse_filter = Control.MOUSE_FILTER_STOP
	saved_hero_picker.item_selected.connect(_on_saved_hero_selected)
	saved_hero_picker.hide() # Apenas a tecla Z apresenta a lista.
	add_child(saved_hero_picker)
	var cfg := ConfigFile.new()
	if cfg.load(HERO_CONFIG) == OK:
		remembered_hero = str(cfg.get_value("hero", "name", ""))
		name_input.text = remembered_hero
	var err := socket.connect_to_url("ws://127.0.0.1:8000/ws")
	if err != OK:
		npc_message = "Erro ao iniciar WebSocket: %s" % err

var skill_cooldown_left: float = 0.0
var class_skill_cooldown_left: float = 0.0
# Barra de habilidades MVP 0.8.6 (sem alterar o servidor).
const HOTBAR_X: float = 320.0
const HOTBAR_Y: float = 480.0
const HOTBAR_SIZE: float = 46.0
const HOTBAR_GAP: float = 7.0

func _hotbar_action(slot: int) -> void:
	if name_input.visible or show_dialog or show_shop or show_inventory or show_quests or show_professions or show_classes or show_skill_tree or sell_confirm_open:
		return
	if socket.get_ready_state() != WebSocketPeer.STATE_OPEN:
		notice = "Liga o servidor para usar habilidades."
		return
	match slot:
		0:
			if skill_cooldown_left > 0.0:
				notice = "Golpe Arcano: aguarda %.0f segundos." % ceilf(skill_cooldown_left)
			else:
				socket.send_text(JSON.stringify({"type":"skill"}))
		1:
			if class_skill_cooldown_left > 0.0:
				notice = "Habilidade de classe: aguarda %.0f segundos." % ceilf(class_skill_cooldown_left)
			else:
				socket.send_text(JSON.stringify({"type":"class_skill"}))

func _draw_hotbar() -> void:
	var font: Font = ThemeDB.fallback_font
	var labels: Array[String] = ["ARCANO", "CLASSE"]
	var symbols: Array[String] = ["*", "!"]
	for i in range(2):
		var x: float = HOTBAR_X + float(i) * (HOTBAR_SIZE + HOTBAR_GAP)
		var rect: Rect2 = Rect2(x, HOTBAR_Y, HOTBAR_SIZE, HOTBAR_SIZE)
		var cooling: bool = (i == 0 and skill_cooldown_left > 0.0) or (i == 1 and class_skill_cooldown_left > 0.0)
		draw_rect(rect, Color("172b32", 0.94))
		draw_rect(rect, Color("8f9b94"), false, 1.5)
		draw_string(font, Vector2(x + 5.0, HOTBAR_Y + 11.0), str(i + 1), HORIZONTAL_ALIGNMENT_LEFT, 16, 10, Color("f5d796"))
		draw_string(font, Vector2(x + 17.0, HOTBAR_Y + 28.0), symbols[i], HORIZONTAL_ALIGNMENT_LEFT, 22, 17, Color("f6d99b"))
		draw_string(font, Vector2(x + 3.0, HOTBAR_Y + 41.0), labels[i], HORIZONTAL_ALIGNMENT_CENTER, 40, 8, Color("cfe2da"))
		if cooling:
			var left: float = class_skill_cooldown_left if i == 1 else skill_cooldown_left
			var total: float = float({"Guerreiro": 14.0, "Mago": 17.0, "Arqueiro": 15.0}.get(str(profile.get("combat_class", "Guerreiro")), 14.0)) if i == 1 else 12.0
			var ratio: float = clampf(left / total, 0.0, 1.0)
			draw_rect(Rect2(x + 1.0, HOTBAR_Y + 1.0, HOTBAR_SIZE - 2.0, (HOTBAR_SIZE - 2.0) * ratio), Color(0.06, 0.08, 0.13, 0.68))
			draw_string(font, Vector2(x + 12.0, HOTBAR_Y + 29.0), str(ceilf(left)), HORIZONTAL_ALIGNMENT_LEFT, 30, 18, Color.WHITE)

func _process(delta: float) -> void:
	# Smooth local presentation only; the server remains authoritative for positions.
	if dungeon_active:
		var smoothing := clampf(delta * 11.0, 0.0, 1.0)
		dungeon_hero_visual = dungeon_hero_visual.lerp(Vector2(dungeon_pos), smoothing)
		dungeon_enemy_visual = dungeon_enemy_visual.lerp(Vector2(dungeon_enemy_pos), smoothing)
	crypt_victory_time = maxf(0.0, crypt_victory_time - delta)
	dungeon_hit_flash = maxf(0.0, dungeon_hit_flash - delta)
	dungeon_enemy_attack_in = maxf(0.0, dungeon_enemy_attack_in - delta)
	dungeon_special_in = maxf(0.0, dungeon_special_in - delta)
	dungeon_attack_flash = maxf(0.0, dungeon_attack_flash - delta)
	skill_cooldown_left = maxf(0.0, skill_cooldown_left - delta)
	class_skill_cooldown_left = maxf(0.0, class_skill_cooldown_left - delta)
	animation_time += delta
	_refresh_actor_motion(delta)
	attack_anim_left = maxf(0.0, attack_anim_left - delta)
	for impact_index in range(basic_impacts.size() - 1, -1, -1):
		basic_impacts[impact_index]["elapsed"] = float(basic_impacts[impact_index]["elapsed"]) + delta
		if float(basic_impacts[impact_index]["elapsed"]) >= float(basic_impacts[impact_index]["duration"]):
			basic_impacts.remove_at(impact_index)
	for projectile_index in range(basic_projectiles.size() - 1, -1, -1):
		basic_projectiles[projectile_index]["elapsed"] = float(basic_projectiles[projectile_index]["elapsed"]) + delta
		if float(basic_projectiles[projectile_index]["elapsed"]) >= float(basic_projectiles[projectile_index]["duration"]):
			basic_projectiles.remove_at(projectile_index)
	for monster_key in monster_attack_anim.keys():
		monster_attack_anim[monster_key] = maxf(0.0, float(monster_attack_anim[monster_key]) - delta)
		if float(monster_attack_anim[monster_key]) <= 0.0:
			monster_attack_anim.erase(monster_key)
	for fx_index in range(class_cast_fx.size() - 1, -1, -1):
		class_cast_fx[fx_index]["elapsed"] = float(class_cast_fx[fx_index]["elapsed"]) + delta
		if float(class_cast_fx[fx_index]["elapsed"]) >= float(class_cast_fx[fx_index]["duration"]):
			class_cast_fx.remove_at(fx_index)
	for i in range(combat_effects.size() - 1, -1, -1):
		combat_effects[i]["time"] = float(combat_effects[i]["time"]) - delta
		if float(combat_effects[i]["time"]) <= 0.0:
			combat_effects.remove_at(i)
	for gather_index in range(gathering_animations.size() - 1, -1, -1):
		gathering_animations[gather_index]["time"] = float(gathering_animations[gather_index]["time"]) + delta
		if float(gathering_animations[gather_index]["time"]) >= float(gathering_animations[gather_index]["duration"]):
			gathering_animations.remove_at(gather_index)
	attack_flash_remaining = maxf(0.0, attack_flash_remaining - delta)
	guardian_banner_time = maxf(0.0, guardian_banner_time - delta)
	if not guardian_pulse_warning.is_empty():
		guardian_pulse_warning["remaining"] = maxf(0.0, float(guardian_pulse_warning.get("remaining", 0.0)) - delta)
		if float(guardian_pulse_warning["remaining"]) <= 0.0:
			guardian_pulse_warning.clear()
	socket.poll()
	while socket.get_available_packet_count() > 0:
		var payload = JSON.parse_string(socket.get_packet().get_string_from_utf8())
		if typeof(payload) != TYPE_DICTIONARY:
			continue
		match payload.get("type", ""):
			"hero_name_check":
				# Respostas atrasadas não podem reabrir a criação cancelada.
				if not name_input.visible:
					continue
				var candidate := str(payload.get("name", ""))
				if bool(payload.get("exists", false)):
					notice = "O nome '" + candidate + "' ja existe. Escolhe outro nome."
					name_input.show()
					class_picker.hide()
					name_input.grab_focus()
				else:
					pending_new_hero_name = candidate
					notice = "Nome disponivel. Escolhe a classe definitiva no menu."
					class_picker.select(-1)
					class_picker.show()
			"hero_list":
				_refresh_saved_hero_picker(payload.get("heroes", []))
			"hero_selected":
				# O servidor confirmou que os dados do personagem foram carregados.
				remembered_hero = str(payload.get("name", ""))
				saved_hero_picker.hide()
				name_input.hide()
				class_picker.hide()
				var cfg := ConfigFile.new()
				cfg.set_value("hero", "name", remembered_hero)
				cfg.save(HERO_CONFIG)
				notice = "A jogar com " + remembered_hero
			"welcome":
				player_id = str(payload.get("id", ""))
				# Nao carregar automaticamente: permitir escolher o heroi existente.
				socket.send_text(JSON.stringify({"type":"list_heroes"}))
				for p in payload.get("players", []):
					players[p["id"]] = p
				_set_monsters(payload.get("monsters", []))
				for boss in payload.get("monsters", []):
					if str(boss.get("kind", "")) in ["guardiao", "guardiao_tempestade"] and bool(boss.get("alive", false)):
						guardian_banner = "O GUARDIAO DO SINO PARTIDO ESTA NA FLORESTA!"
						guardian_banner_time = 5.0
			"join", "state":
				var p = payload.get("player", {})
				if p.has("id"):
					players[p["id"]] = p
			"leave":
				players.erase(payload.get("id", ""))
			"monsters":
				_set_monsters(payload.get("monsters", []))
			"profile":
				profile = payload
				dungeon_active = bool(payload.get("dungeon_active", false))
				if not dungeon_active:
					dungeon_click_path.clear()
					dungeon_auto_attack_elapsed = 0.0
					dungeon_auto_route.clear()
				var new_crypt_stage := int(payload.get("dungeon_stage", 0))
				if new_crypt_stage != dungeon_stage or not dungeon_active:
					dungeon_click_path.clear()
					dungeon_auto_route.clear()
				dungeon_stage = new_crypt_stage
				if dungeon_visual_stage != dungeon_stage:
					dungeon_visual_stage = dungeon_stage
					dungeon_hero_visual = Vector2(1, 2)
					dungeon_enemy_visual = Vector2(8, 2)
					dungeon_last_enemy_hp = -1
				var crypt_hp := int(payload.get("dungeon_enemy_hp", 0))
				if dungeon_active and dungeon_last_enemy_hp > crypt_hp and crypt_hp > 0:
					dungeon_hit_flash = 0.25
					dungeon_attack_flash = 0.35
					var aim := Vector2(dungeon_enemy_pos - dungeon_pos)
					if aim.length_squared() > 0.0:
						dungeon_facing = aim.normalized()
				dungeon_enemy_hp = crypt_hp
				dungeon_boss_phase = int(payload.get("dungeon_boss_phase", 0))
				dungeon_enemy_attack_in = float(payload.get("dungeon_enemy_attack_in", 0.0))
				dungeon_special_in = float(payload.get("dungeon_special_in", 0.0))
				dungeon_special_cells.clear()
				var warning_cells: Array = payload.get("dungeon_special_cells", [])
				for warning_cell in warning_cells:
					if warning_cell is Array and warning_cell.size() >= 2:
						dungeon_special_cells.append(Vector2i(int(warning_cell[0]), int(warning_cell[1])))
				dungeon_last_enemy_hp = crypt_hp
				var old_crypt_pos: Vector2i = dungeon_pos
				var crypt_cell: Array = payload.get("dungeon_pos", [1, 2])
				if crypt_cell.size() >= 2:
					dungeon_pos = Vector2i(int(crypt_cell[0]), int(crypt_cell[1]))
				var hero_step: Vector2i = dungeon_pos - old_crypt_pos
				if hero_step.x != 0:
					dungeon_hero_facing = "right" if hero_step.x > 0 else "left"
				elif hero_step.y != 0:
					dungeon_hero_facing = "down" if hero_step.y > 0 else "up"
				if not dungeon_click_path.is_empty() and dungeon_pos == dungeon_click_path[0]:
					dungeon_click_path.pop_front()
				if not dungeon_auto_route.is_empty() and dungeon_pos == dungeon_auto_route[0]:
					dungeon_auto_route.pop_front()
				var enemy_cell: Array = payload.get("dungeon_enemy_pos", [8, 2])
				if enemy_cell.size() >= 2:
					dungeon_enemy_pos = Vector2i(int(enemy_cell[0]), int(enemy_cell[1]))
				dungeon_enemy_name = str(payload.get("dungeon_enemy_name", "Inimigo"))
				chest_server_clock_offset = float(payload.get("server_time", Time.get_unix_time_from_system())) - Time.get_unix_time_from_system()
			"guardian_spawned":
				guardian_banner = str(payload.get("text", "O GUARDIAO DO SINO PARTIDO DESPERTOU!"))
				guardian_banner_time = 6.0
			"skill_cast":
				var skill_pos := Vector2(float(payload.get("x", 0.0)), float(payload.get("y", 0.0)))
				var is_class_skill: bool = bool(payload.get("class_skill", false))
				var fx_color: Color = Color("ffd36a") if str(payload.get("class_name", "")) == "Guerreiro" else Color("b88aff") if str(payload.get("class_name", "")) == "Mago" else Color("8cf1b4")
				_add_combat_effect(skill_pos + Vector2(0, -20), str(payload.get("label", "GOLPE ARCANO")) + "!", fx_color if is_class_skill else Color("c59aff"))
				if is_class_skill:
					class_cast_fx.append({"pos":skill_pos, "source":Vector2(float(payload.get("source_x", 0.0)), float(payload.get("source_y", 0.0))), "class":str(payload.get("class_name", "")), "elapsed":0.0, "duration":0.65})
					if class_cast_fx.size() > 24:
						class_cast_fx.pop_front()
				if str(payload.get("attacker_id", "")) == player_id:
					if is_class_skill:
						class_skill_cooldown_left = float(payload.get("cooldown", 7.0))
					else:
						skill_cooldown_left = float(payload.get("cooldown", 9.0))
					attack_flash_remaining = 0.28
					attack_anim_left = 0.42
			"combat_hit":
				var hit_pos := Vector2(float(payload.get("x", 0.0)), float(payload.get("y", 0.0)))
				_add_combat_effect(hit_pos, ("CRITICO -%d!" if bool(payload.get("critical", false)) else "HIT -%d") % int(payload.get("damage", 0)), Color("ff6f56") if bool(payload.get("critical", false)) else Color("ffdf9b"), 1.5 if bool(payload.get("critical", false)) else 1.0)
				actor_hurt["m:" + str(payload.get("target_id", ""))] = 0.24
				if str(payload.get("attacker_id", "")) == player_id:
					attack_flash_remaining = 0.16
					attack_anim_left = 0.30
					if players.has(player_id):
						var attacker_data: Dictionary = players[player_id]
						var attack_origin := Vector2(float(attacker_data.get("x", 0.0)), float(attacker_data.get("y", 0.0)))
						var combat_class_name: String = str(profile.get("combat_class", "Guerreiro"))
						basic_attack_direction = (hit_pos - attack_origin).normalized()
						if basic_attack_direction.length_squared() < 0.01:
							basic_attack_direction = Vector2.RIGHT
						basic_impacts.append({"pos":hit_pos + Vector2(0, -25), "class":combat_class_name, "elapsed":0.0, "duration":0.38})
						if basic_impacts.size() > 24:
							basic_impacts.pop_front()
						if combat_class_name == "Mago" or combat_class_name == "Arqueiro":
							basic_projectiles.append({"from":attack_origin + Vector2(0, -28), "to":hit_pos + Vector2(0, -26), "class":combat_class_name, "elapsed":0.0, "duration":0.26})
							if basic_projectiles.size() > 18:
								basic_projectiles.pop_front()
			"healing_effect":
				var heal_at := Vector2(float(payload.get("x", 0.0)), float(payload.get("y", 0.0)))
				_add_combat_effect(heal_at, "+%d HP" % int(payload.get("amount", 0)), Color("8dffac"), 1.3)
			"guardian_phase":
				guardian_banner = str(payload.get("text", "O GUARDIAO MUDOU DE FASE!"))
				guardian_banner_time = 6.0
				var phase_pos := Vector2(float(payload.get("x", 0.0)), float(payload.get("y", 0.0)))
				_add_combat_effect(phase_pos + Vector2(0, -55), "FASE %d!" % int(payload.get("phase", 2)), Color("ff9d60"), 2.0)
			"guardian_pulse_warning":
				guardian_pulse_warning = {"x": float(payload.get("x", 0.0)), "y": float(payload.get("y", 0.0)), "radius": float(payload.get("radius", 92.0)), "duration": float(payload.get("duration", 1.65)), "remaining": float(payload.get("duration", 1.65))}
				_add_combat_effect(Vector2(float(payload.get("x", 0.0)), float(payload.get("y", 0.0))) + Vector2(0, -58), "PULSO! SAI DA AREA!", Color("ff8c72"), 1.2)
			"guardian_pulse_resolved":
				guardian_pulse_warning.clear()
				var pulse_at := Vector2(float(payload.get("x", 0.0)), float(payload.get("y", 0.0)))
				_add_combat_effect(pulse_at, "PULSO DAS RUINAS!", Color("e1a6ff"), 1.3)
				for hit in payload.get("hits", []):
					var struck_at := Vector2(float(hit.get("target_x", 0.0)), float(hit.get("target_y", 0.0)))
					_add_combat_effect(struck_at, "HIT -%d" % int(hit.get("damage", 0)), Color("e8a4ff"), 1.3)
					actor_hurt["p:" + str(hit.get("target_id", ""))] = 0.34
			"guardian_special":
				var pulse_at := Vector2(float(payload.get("x", 0.0)), float(payload.get("y", 0.0)))
				_add_combat_effect(pulse_at, "PULSO DAS RUINAS!", Color("e1a6ff"), 1.5)
				var struck_at := Vector2(float(payload.get("target_x", 0.0)), float(payload.get("target_y", 0.0)))
				_add_combat_effect(struck_at, "HIT -%d" % int(payload.get("damage", 0)), Color("e8a4ff"), 1.3)
				actor_hurt["p:" + str(payload.get("target_id", ""))] = 0.34
				monster_attack_anim["m:" + str(payload.get("attacker_id", ""))] = MONSTER_ATTACK_DURATION
			"monster_attack":
				var monster_key := "m:" + str(payload.get("attacker_id", ""))
				monster_attack_anim[monster_key] = MONSTER_ATTACK_DURATION
				var damage_at := Vector2(float(payload.get("x", 0.0)), float(payload.get("y", 0.0)))
				_add_combat_effect(damage_at, "MISS" if bool(payload.get("miss", false)) else ("0" if int(payload.get("damage", 0)) == 0 else "HIT -%d" % int(payload.get("damage", 0))), Color("a8c7d4") if bool(payload.get("miss", false)) or int(payload.get("damage", 0)) == 0 else Color("ff8e86"), 1.1)
				actor_hurt["p:" + str(payload.get("target_id", ""))] = 0.24
			"chest_reward":
				var reward_at := Vector2(float(payload.get("x", 1735.0)), float(payload.get("y", 1060.0)))
				_add_combat_effect(reward_at, "+%d ouro  +%d XP  +%d pocoes" % [int(payload.get("gold", 0)), int(payload.get("xp", 0)), int(payload.get("potions", 0))], Color("ffdc83"), 1.8)
			"combat_reward":
				var reward_pos := Vector2(float(payload.get("x", 0.0)), float(payload.get("y", 0.0)))
				_add_combat_effect(reward_pos, "+%d XP  +%d ouro" % [int(payload.get("xp", 0)), int(payload.get("gold", 0))], Color("a9f0ac"), 1.35)
			"notice":
				notice = str(payload.get("text", ""))
				if notice.begins_with("Sino Partido purificado!"):
					crypt_victory_first = true
					crypt_victory_time = 8.0
				elif notice.begins_with("Cripta purificada novamente!"):
					crypt_victory_first = false
					crypt_victory_time = 8.0
				if notice.begins_with("Heroi ") and notice.ends_with(" carregado e guardado."):
					remembered_hero = notice.trim_prefix("Heroi ").trim_suffix(" carregado e guardado.")
					var cfg := ConfigFile.new()
					cfg.set_value("hero", "name", remembered_hero)
					cfg.save(HERO_CONFIG)
					socket.send_text(JSON.stringify({"type":"list_heroes"}))
			"smith_dialog":
				dialog_speaker = "Ferreiro"
				dialog_text = str(payload.get("text", ""))
				show_dialog = true
				smith_dialog = true
				show_shop = false
			"gather_result":
				var gather_at := Vector2(float(payload.get("x", 0.0)), float(payload.get("y", 0.0)))
				_begin_gather_animation(str(payload.get("kind", "wood")), gather_at)
				_play_gather_sfx(str(payload.get("kind", "wood")))
			"item_float":
				var item_at := Vector2(float(payload.get("x", 0.0)), float(payload.get("y", 0.0)))
				_add_combat_effect(item_at, str(payload.get("text", "")), Color("ffe4a5"), 1.7)
			"craft_result":
				var craft_at := Vector2(float(payload.get("x", 0.0)), float(payload.get("y", 0.0)))
				_add_combat_effect(craft_at, ("CRIADO: " if bool(payload.get("success", false)) else "FALHOU: ") + str(payload.get("item", "")), Color("a5ffbb") if bool(payload.get("success", false)) else Color("ff988c"), 1.7)
				_play_crafting_sfx(bool(payload.get("success", false)))
			"npc":
				smith_dialog = false
				dialog_speaker = str(payload.get("name", ""))
				dialog_text = str(payload.get("text", ""))
				npc_message = dialog_speaker + ": " + dialog_text
				show_dialog = true
	if _pressed_once(KEY_T) and not name_input.visible:
		auto_combat = not auto_combat
		auto_target_id = ""
		auto_attack_elapsed = 0.0
		auto_repath_elapsed = 0.0
		if not auto_combat and not manual_click_route:
			nav_active = false
		notice = "Combate automatico ATIVADO (T para desligar)." if auto_combat else "Combate automatico DESATIVADO."
	if _pressed_once(KEY_C) and not name_input.visible:
		show_classes = not show_classes
		show_skill_tree = false
	if _pressed_once(KEY_L) and not name_input.visible:
		show_skill_tree = not show_skill_tree
		show_classes = false
	if _pressed_once(KEY_P) and not name_input.visible:
		show_professions = not show_professions
	if _pressed_once(KEY_Q) and not name_input.visible:
		show_quests = not show_quests
	if _pressed_once(KEY_ESCAPE):
		show_bank = false
		show_dialog = false
		smith_dialog = false
		show_inventory = false
		show_shop = false
		show_quests = false
		show_professions = false
		show_classes = false
		show_skill_tree = false
		show_attributes = false
	if _pressed_once(KEY_Z) and not name_input.visible:
		# Z abre/fecha a lista; nao interfere com a criacao (N).
		saved_hero_picker.visible = not saved_hero_picker.visible
		if saved_hero_picker.visible and socket.get_ready_state() == WebSocketPeer.STATE_OPEN:
			socket.send_text(JSON.stringify({"type":"list_heroes"}))
	if _pressed_once(KEY_N) and not name_input.visible and not class_picker.visible:
		saved_hero_picker.hide()
		name_input.clear()
		name_input.show()
		class_picker.hide()
		pending_new_hero_name = ""
		name_input.grab_focus()
	if _pressed_once(KEY_M) and not name_input.visible:
		show_shop = not show_shop
		if show_shop:
			notice = "Oficina: aproxima-te do ferreiro na estrada a leste de Tessa."
	if not name_input.visible and _pressed_once(KEY_H):
		_send_action("use", "Pocao pequena")
	if not name_input.visible and _pressed_once(KEY_J):
		if socket.get_ready_state() == WebSocketPeer.STATE_OPEN:
			socket.send_text(JSON.stringify({"type":"use_mana_potion"}))
	var attack_key_pressed := _pressed_once(KEY_1)
	var heal_key_pressed := _pressed_once(KEY_2)
	var leave_key_pressed := _pressed_once(KEY_3)
	if not dungeon_active and not name_input.visible and attack_key_pressed:
		_hotbar_action(0)
	if not name_input.visible and _pressed_once(KEY_K) and not dungeon_active and socket.get_ready_state() == WebSocketPeer.STATE_OPEN:
		socket.send_text(JSON.stringify({"type":"dungeon_action","action":"enter"}))
	if dungeon_active and not name_input.visible and socket.get_ready_state() == WebSocketPeer.STATE_OPEN:
		dungeon_walk_timer -= delta
		dungeon_manual_pause = maxf(0.0, dungeon_manual_pause - delta)
		var crypt_dx := int(Input.is_physical_key_pressed(KEY_D)) - int(Input.is_physical_key_pressed(KEY_A))
		var crypt_dy := int(Input.is_physical_key_pressed(KEY_S)) - int(Input.is_physical_key_pressed(KEY_W))
		var crypt_manual: bool = absi(crypt_dx) + absi(crypt_dy) > 0
		var crypt_class_move := str(profile.get("combat_class", "Guerreiro"))
		var crypt_attack_range: int = 1 if crypt_class_move == "Guerreiro" else (3 if crypt_class_move == "Arqueiro" else 2)
		var crypt_target_distance: int = absi(dungeon_pos.x - dungeon_enemy_pos.x) + absi(dungeon_pos.y - dungeon_enemy_pos.y)
		if crypt_manual:
			dungeon_click_path.clear()
			dungeon_auto_route.clear()
			dungeon_manual_pause = 0.8
		elif auto_combat and dungeon_enemy_hp > 0 and dungeon_click_path.is_empty() and dungeon_manual_pause <= 0.0 and crypt_target_distance > crypt_attack_range:
			if dungeon_auto_route.is_empty() or dungeon_auto_enemy_last != dungeon_enemy_pos:
				dungeon_auto_route = _crypt_find_attack_route(dungeon_pos, dungeon_enemy_pos, crypt_attack_range)
				dungeon_auto_enemy_last = dungeon_enemy_pos
		else:
			dungeon_auto_route.clear()
		if dungeon_walk_timer <= 0.0:
			if not crypt_manual:
				var active_route: Array[Vector2i] = dungeon_click_path if not dungeon_click_path.is_empty() else dungeon_auto_route
				if not active_route.is_empty():
					var next_cell: Vector2i = active_route[0]
					var step: Vector2i = next_cell - dungeon_pos
					if absi(step.x) + absi(step.y) == 1:
						crypt_dx = step.x
						crypt_dy = step.y
					else:
						dungeon_click_path.clear()
						dungeon_auto_route.clear()
			if abs(crypt_dx) + abs(crypt_dy) == 1:
				dungeon_walk_timer = 0.19
				socket.send_text(JSON.stringify({"type":"dungeon_action","action":"walk","dx":crypt_dx,"dy":crypt_dy}))
		dungeon_auto_attack_elapsed += delta
		var crypt_distance_now: int = absi(dungeon_pos.x - dungeon_enemy_pos.x) + absi(dungeon_pos.y - dungeon_enemy_pos.y)
		var crypt_class_now := str(profile.get("combat_class", "Guerreiro"))
		var crypt_range_now: int = 1 if crypt_class_now == "Guerreiro" else (3 if crypt_class_now == "Arqueiro" else 2)
		var crypt_auto_ready: bool = auto_combat and dungeon_enemy_hp > 0 and crypt_distance_now <= crypt_range_now and dungeon_auto_attack_elapsed >= 0.8
		if attack_key_pressed or crypt_auto_ready:
			dungeon_auto_attack_elapsed = 0.0
			socket.send_text(JSON.stringify({"type":"dungeon_action","action":"attack"}))
		elif heal_key_pressed:
			socket.send_text(JSON.stringify({"type":"dungeon_action","action":"heal"}))
		elif leave_key_pressed:
			socket.send_text(JSON.stringify({"type":"dungeon_action","action":"leave"}))
	if not dungeon_active and not name_input.visible and heal_key_pressed:
		_hotbar_action(1)
	auto_attack_elapsed += delta
	var manual_movement := Input.is_physical_key_pressed(KEY_W) or Input.is_physical_key_pressed(KEY_A) or Input.is_physical_key_pressed(KEY_S) or Input.is_physical_key_pressed(KEY_D)
	if socket.get_ready_state() == WebSocketPeer.STATE_OPEN and not dungeon_active:
		_click_attack_update(delta, manual_movement)
		_auto_update(delta, manual_movement)
	send_elapsed += delta
	var f_down := Input.is_physical_key_pressed(KEY_F)
	var g_down := Input.is_physical_key_pressed(KEY_G)
	var e_down := Input.is_physical_key_pressed(KEY_E)
	var space_down := Input.is_physical_key_pressed(KEY_SPACE)
	var i_down := Input.is_physical_key_pressed(KEY_I)
	if i_down and not was_i_down:
		show_inventory = not show_inventory
	was_i_down = i_down
	if socket.get_ready_state() == WebSocketPeer.STATE_OPEN and not name_input.visible:
		if send_elapsed >= 0.05:
			send_elapsed = 0.0
			var direction := Vector2(
				int(Input.is_physical_key_pressed(KEY_D)) - int(Input.is_physical_key_pressed(KEY_A)),
				int(Input.is_physical_key_pressed(KEY_S)) - int(Input.is_physical_key_pressed(KEY_W))
			).normalized()
			if direction.length_squared() > 0.0:
				nav_active = false # WASD cancela o percurso.
				manual_click_route = false
			elif nav_active:
				direction = _nav_direction(delta)
				if not nav_active:
					manual_click_route = false
			if dungeon_active:
				direction = Vector2.ZERO
			# Send zero vector too, to stop remote walk animation.
			socket.send_text(JSON.stringify({"type": "move", "dx": direction.x, "dy": direction.y}))
		if e_down and not was_e_down and players.has(player_id):
			var interact_hero: Dictionary = players[player_id]
			var interact_pos := Vector2(float(interact_hero.get("x", 0)), float(interact_hero.get("y", 0)))
			if interact_pos.distance_to(BLACKSMITH) <= 95.0:
				socket.send_text(JSON.stringify({"type":"smith_interact"}))
			else:
				socket.send_text(JSON.stringify({"type":"interact"}))
		if g_down and not was_g_down and players.has(player_id):
			var gather_hero: Dictionary = players[player_id]
			var gather_pos := Vector2(float(gather_hero.get("x", 0)), float(gather_hero.get("y", 0)))
			var gather_nearest := ""
			var gather_distance := 85.0
			for resource in profile.get("resource_nodes", []):
				var candidate_pos := Vector2(float(resource.get("x", 0)), float(resource.get("y", 0)))
				var candidate_distance := gather_pos.distance_to(candidate_pos)
				if candidate_distance < gather_distance:
					gather_distance = candidate_distance
					gather_nearest = str(resource.get("id", ""))
			if gather_nearest != "":
				socket.send_text(JSON.stringify({"type": "gather", "node_id":gather_nearest}))
			else:
				notice = "Procura os marcadores RECOLHER [G] no mapa e aproxima-te (85 px)."
		if f_down and not was_f_down and players.has(player_id):
			var hero: Dictionary = players[player_id]
			var hero_pos := Vector2(float(hero.get("x", 0)), float(hero.get("y", 0)))
			var nearest_id := ""
			var nearest_distance := 95.0
			for chest_id in CHEST_LOCATIONS:
				var dist := hero_pos.distance_to(CHEST_LOCATIONS[chest_id])
				if dist < nearest_distance:
					nearest_id = chest_id
					nearest_distance = dist
			if not nearest_id.is_empty():
				socket.send_text(JSON.stringify({"type":"open_chest","chest_id":nearest_id}))
	was_e_down = e_down
	was_f_down = f_down
	was_g_down = g_down
	was_space_down = space_down
	_update_camera(delta)
	queue_redraw()


func _draw_city_districts() -> void:
	# Cosmetic only. No changes to navigation, collisions or authoritative world coordinates.
	var font := ThemeDB.fallback_font
	var signs: Array = [
		{"p":Vector2(435, 375),"title":"VALEDOURO","subtitle":"Praca dos Viajantes","color":Color("e9c78b")},
		{"p":Vector2(1430, 352),"title":"BAIRRO DAS RUNAS","subtitle":"Mercado Oriental","color":Color("a4d8e4")},
		{"p":Vector2(475, 1110),"title":"VILA DOS ARTIFICES","subtitle":"Oficinas e Armazens","color":Color("e7bb83")},
		{"p":Vector2(1425, 1130),"title":"FRONTEIRA ANTIGA","subtitle":"Estrada das Ruinas","color":Color("b2d6a0")}
	]
	for sign_data in signs:
		var p: Vector2 = sign_data["p"]
		var tint: Color = sign_data["color"]
		draw_rect(Rect2(p + Vector2(-86, -20), Vector2(172, 37)), Color("19272c", 0.86))
		draw_rect(Rect2(p + Vector2(-86, -20), Vector2(172, 3)), tint)
		draw_string(font, p + Vector2(-80, -2), str(sign_data["title"]), HORIZONTAL_ALIGNMENT_LEFT, 165, 12, tint)
		draw_string(font, p + Vector2(-80, 12), str(sign_data["subtitle"]), HORIZONTAL_ALIGNMENT_LEFT, 165, 10, Color("e5e1d4"))
	# Carved entrance arches, market flags, paving accents and banners.
	for gate in [Vector2(485, 42), Vector2(1450, 42), Vector2(480, 680)]:
		for side in [-38.0, 38.0]:
			var foot: Vector2 = gate + Vector2(side, 0)
			draw_rect(Rect2(foot + Vector2(-7, -25), Vector2(14, 65)), Color("58635d"))
			draw_rect(Rect2(foot + Vector2(-4, -21), Vector2(7, 54)), Color("9fa69b"))
			draw_rect(Rect2(foot + Vector2(-9, -31), Vector2(18, 9)), Color("c3b99b"))
		draw_rect(Rect2(gate + Vector2(-46, -41), Vector2(92, 14)), Color("777d70"))
		draw_rect(Rect2(gate + Vector2(-39, -38), Vector2(78, 5)), Color("c2b99a"))
		for flag_side in [-32.0, 32.0]:
			var flag: Vector2 = gate + Vector2(flag_side, -47)
			draw_line(flag, flag + Vector2(0, -29), Color("b4a37b"), 2.0)
			draw_colored_polygon(PackedVector2Array([flag + Vector2(0, -28), flag + Vector2(21, -23), flag + Vector2(0, -12)]), Color("a84f54"))
	# Lively fountains and water ripple in eastern plaza; visual only.
	var fountain: Vector2 = Vector2(1445, 645)
	draw_ellipse_shadow(fountain + Vector2(0, 9), 31.0)
	draw_circle(fountain, 26.0, Color("8d8f86"))
	draw_circle(fountain, 20.0, Color("30687a"))
	draw_arc(fountain, 16.0 + sin(animation_time * 2.0) * 2.0, 0.0, TAU, 28, Color("9cd4df", 0.7), 1.5)
	draw_rect(Rect2(fountain + Vector2(-4, -23), Vector2(8, 24)), Color("a9aba0"))
	draw_circle(fountain + Vector2(0, -26), 7.0, Color("d5d0b7"))
	# Street lanterns with day/night-aware warm light.
	for lantern in [Vector2(330, 375), Vector2(735, 355), Vector2(1260, 350), Vector2(1600, 705), Vector2(350, 1020), Vector2(740, 1030)]:
		draw_line(lantern, lantern + Vector2(0, -42), Color("4c3d31"), 5.0)
		draw_rect(Rect2(lantern + Vector2(-9, -55), Vector2(18, 17)), Color("4e3f32"))
		draw_rect(Rect2(lantern + Vector2(-6, -52), Vector2(12, 11)), Color("f2cb77", 0.90))
		draw_arc(lantern + Vector2(0, -46), 16.0, 0.0, TAU, 20, Color("f5c96f", 0.17), 2.0)

func _draw_expansion_decor() -> void:
	# Market stalls and well; signage drawn as foreground overlay.
	# Market stalls near the eastern square.
	for x in [1140.0, 1390.0, 1670.0]:
		var y := 675.0
		draw_rect(Rect2(x, y + 19, 105, 45), Color("74533b"))
		draw_rect(Rect2(x + 8, y + 30, 90, 12), Color("c79b60"))
		draw_colored_polygon(PackedVector2Array([
			Vector2(x-7,y+19),Vector2(x+18,y-14),Vector2(x+91,y-14),Vector2(x+116,y+19)
		]), Color("a34945"))
		for k in range(4):
			draw_line(Vector2(x + 18 + k*20, y-12), Vector2(x+7+k*27, y+17), Color("dfb17e"), 3.0)
	# Water well in the southern artisans' courtyard.
	draw_ellipse_shadow(Vector2(480, 1015), 29.0)
	draw_circle(Vector2(480, 1000), 26.0, Color("726c63"))
	draw_circle(Vector2(480, 1000), 18.0, Color("2c6170"))
	draw_arc(Vector2(480, 1000), 23.0, 0.0, TAU, 32, Color("d1b88b"), 5.0)

func _draw_rune_outpost() -> void:
	# Eastern patrol landmark; decoration only, without new collision geometry.
	var center: Vector2 = Vector2(1740, 460)
	var glow: Color = Color("82c8e8", 0.55)
	for ring_index in range(3):
		draw_arc(center, 33.0 + float(ring_index) * 17.0, 0.0, TAU, 40, Color(glow.r, glow.g, glow.b, 0.25 - float(ring_index) * 0.05), 2.0)
	for rune_index in range(4):
		var angle: float = float(rune_index) * TAU / 4.0
		var rune_center: Vector2 = center + Vector2(cos(angle), sin(angle)) * 48.0
		draw_line(rune_center + Vector2(-5, 9), rune_center + Vector2(0, -11), glow, 2.0)
		draw_line(rune_center + Vector2(0, -11), rune_center + Vector2(6, 9), glow, 2.0)
	# Cracked rune monolith and its shadow.
	draw_ellipse_shadow(center + Vector2(0, 10), 26.0)
	draw_colored_polygon(PackedVector2Array([
		center + Vector2(-18, 10), center + Vector2(-13, -45),
		center + Vector2(1, -63), center + Vector2(20, -37),
		center + Vector2(18, 10)]), Color("4b5961"))
	draw_line(center + Vector2(1, -53), center + Vector2(-3, -16), Color("92d8f5"), 3.0)
	draw_line(center + Vector2(-3, -16), center + Vector2(8, -3), Color("92d8f5"), 3.0)
	draw_line(center + Vector2(1, -53), center + Vector2(12, -36), Color("92d8f5"), 2.0)

func _draw_region_signs() -> void:
	# Foreground signs are always above tree canopies; labels never clipped by foliage.
	var font := ThemeDB.fallback_font
	var signs := [
		{"pos":Vector2(1040, 565), "label":"MERCADO DO LESTE"},
		{"pos":Vector2(295, 750), "label":"BAIRRO DOS ARTESAOS"},
		{"pos":Vector2(1470, 790), "label":"PORTAO DA FLORESTA"},
		{"pos":Vector2(1130, 660), "label":"FLORESTA DE VALEDOURO"},
		{"pos":Vector2(1630, 190), "label":"POSTO DAS RUNAS"}
	]
	for region_sign in signs:
		var at: Vector2 = region_sign["pos"]
		var width := 225.0
		draw_rect(Rect2(at + Vector2(12, 33), Vector2(8, 28)), Color("4c3427"))
		draw_rect(Rect2(at + Vector2(width-20, 33), Vector2(8, 28)), Color("4c3427"))
		draw_rect(Rect2(at - Vector2(3, 3), Vector2(width+6, 40)), Color("3a2921"))
		draw_rect(Rect2(at, Vector2(width, 34)), Color("a78051"))
		draw_rect(Rect2(at + Vector2(5, 5), Vector2(width-10, 24)), Color("634a34"))
		draw_string(font, at + Vector2(11, 24), str(region_sign["label"]), HORIZONTAL_ALIGNMENT_LEFT, 204, 13, Color("ffe9ba"))

func _draw_forest_arch() -> void:
	# Portal de pedra e muralha arruinada, sem bloquear o trilho de terra.
	var x := 1420.0
	var y := 1040.0
	for side in [0.0, 170.0]:
		var at := Vector2(x+side, y)
		draw_rect(Rect2(at, Vector2(39, 126)), Color("424d47"))
		draw_rect(Rect2(at + Vector2(4, 4), Vector2(31, 116)), Color("92988b"))
		for row in range(6):
			draw_line(at+Vector2(4, 12+row*18), at+Vector2(35, 12+row*18), Color("5c6b63"), 2.0)
			draw_line(at+Vector2(18 if row%2==0 else 25, 12+row*18), at+Vector2(18 if row%2==0 else 25, 30+row*18), Color("5c6b63"), 2.0)
		for j in range(3):
			draw_rect(Rect2(at+Vector2(j*13, -13), Vector2(12, 18)), Color("a4a899"))
	# Raised lintel with broken battlements and dark central arch.
	draw_rect(Rect2(x+32, y+3, 148, 25), Color("858c80"))
	draw_rect(Rect2(x+44, y+8, 122, 15), Color("a4a99b"))
	for j in range(8):
		draw_rect(Rect2(x+35+j*18, y-10, 13, 16), Color("9da495"))
	# Ivy and moss.
	for j in range(12):
		var xx := x + 7 + float(j%3)*12
		var yy := y + 12 + float(j)*8
		draw_circle(Vector2(xx, yy), 4.0, Color("476e47"))
	# Small carved crest above the gateway.
	draw_colored_polygon(PackedVector2Array([Vector2(x+98,y+5),Vector2(x+111,y+5),Vector2(x+108,y+19),Vector2(x+104,y+23),Vector2(x+100,y+19)]), Color("d6bc79"))

func _draw() -> void:
	inventory_click_targets.clear()
	shop_click_targets.clear()
	crafting_click_targets.clear()
	smith_dialog_click_targets.clear()
	# World coordinates and viewport are independent; the HUD remains fixed.
	draw_set_transform(-camera_offset)
	for tile_y in range(2):
		for tile_x in range(2):
			var tile_pos := Vector2(tile_x * 960.0, tile_y * 640.0)
			draw_texture_rect(district_terrain[tile_y * 2 + tile_x], Rect2(tile_pos, Vector2(960, 640)), false)
	_draw_forest()
	_draw_forest_arch()
	_draw_expansion_decor()
	_draw_rune_outpost()
	if nav_active:
		for waypoint in nav_path:
			draw_circle(waypoint, 3.0, Color(0.98, 0.80, 0.36, 0.65))
		draw_arc(nav_destination, 9.0, 0.0, TAU, 24, Color(0.98, 0.80, 0.36, 0.85), 2.0)
	if auto_combat and auto_target_id != "" and bool(monsters.get(auto_target_id, {}).get("alive", false)):
		var target_pos := _auto_target_position()
		draw_arc(target_pos, 26.0, 0.0, TAU, 36, Color("f66d54"), 2.5)
	# Terrain texture replaces old geometric roads and grass.
	for rect in OBSTACLES:
		var building_index: int = OBSTACLES.find(rect)
		var building_rect := Rect2(rect.position + Vector2(-13, -40), rect.size + Vector2(26, 55))
		_draw_house(rect)
	_draw_city_districts()
	# Draw by foot/trunk Y so characters pass behind canopies naturally.
	var drawables: Array = []
	for resource in profile.get("resource_nodes", []):
		var pos := Vector2(float(resource.get("x", 0)), float(resource.get("y", 0)))
		match str(resource.get("kind", "")):
			"wood":
				drawables.append({"kind":"tree", "y":pos.y, "pos":pos})
			"ore":
				drawables.append({"kind":"rock", "y":pos.y, "pos":Vector3(pos.x,pos.y,float(resource.get("radius",21.0)))})
			"herb":
				drawables.append({"kind":"bush", "y":pos.y, "pos":Vector3(pos.x,pos.y,float(resource.get("radius",13.0)))})
	for barrel in BARRELS:
		drawables.append({"kind":"barrel", "y":barrel.y, "pos":barrel})
	for fence in FENCES:
		drawables.append({"kind":"fence", "y":fence.position.y+fence.size.y, "rect":fence})
	for id in monsters:
		var m: Dictionary = monsters[id]
		if bool(m.get("alive", false)):
			drawables.append({"kind":"monster", "y":float(m.get("y", 0)), "data":m})
	drawables.append({"kind":"tessa", "y":TESSA.y})
	drawables.append({"kind":"ferreiro", "y":BLACKSMITH.y})
	drawables.append({"kind":"armazem", "y":BANK_KEEPER.y})
	for id in players:
		var p: Dictionary = players[id]
		drawables.append({"kind":"player", "y":float(p.get("y",0)), "data":p, "id":id})
	drawables.sort_custom(func(a, b): return float(a["y"]) < float(b["y"]))
	for entry in drawables:
		match entry["kind"]:
			"tree":
				var tree_base: Vector2 = entry["pos"]
				_draw_tree(tree_base)
			"rock":
				_draw_rock(entry["pos"])
			"bush":
				_draw_bush(entry["pos"])
			"barrel":
				_draw_barrel(entry["pos"])
			"fence":
				_draw_fence(entry["rect"])
			"monster":
				_draw_monster(entry["data"])
			"tessa":
				_draw_character(TESSA, "down", false, "Tessa", true)
			"ferreiro":
				_draw_blacksmith()
			"armazem":
				_draw_bank_keeper()
			"player":
				var p: Dictionary = entry["data"]
				var pos := Vector2(float(p.get("x",0)), float(p.get("y",0)))
				_draw_character(pos, str(p.get("facing", "down")), bool(p.get("walking", false)), "Tu" if entry["id"] == player_id else "Viajante", false)
	_draw_region_signs()
	_draw_gather_markers()
	_draw_night_lighting()
	# Boss label above scenery and trees, centered without truncation.
	for monster_id in monsters:
		var boss: Dictionary = monsters[monster_id]
		# O Guardião da Tempestade já tem o nome desenhado na rotina do monstro.
		if str(boss.get("kind", "")) == "guardiao" and bool(boss.get("alive", false)):
			var boss_pos := Vector2(float(boss.get("x", 0)), float(boss.get("y", 0)))
			draw_string_outline(ThemeDB.fallback_font, boss_pos + Vector2(-120, -116), "GUARDIAO DO SINO PARTIDO", HORIZONTAL_ALIGNMENT_CENTER, 240, 15, 3, Color("27162d"))
			draw_string(ThemeDB.fallback_font, boss_pos + Vector2(-120, -116), "GUARDIAO DO SINO PARTIDO", HORIZONTAL_ALIGNMENT_CENTER, 240, 15, Color("f4d7ff"))
	# Combat overlay: always above roads, houses, trees, actors and HUD terrain.
	if players.has(player_id):
		var hero: Dictionary = players[player_id]
		var hero_pos := Vector2(float(hero.get("x", 0)), float(hero.get("y", 0)))
		for chest_id in CHEST_LOCATIONS:
			var chest_pos: Vector2 = CHEST_LOCATIONS[chest_id]
			if hero_pos.distance_to(chest_pos) < 105.0:
				var remaining := _chest_seconds_remaining(chest_id)
				var hint := "[F] ABRIR BAU" if remaining == 0 else "BAU: %02d:%02d" % [int(remaining / 60.0), remaining % 60]
				draw_string(ThemeDB.fallback_font, chest_pos + Vector2(-95, -65), hint, HORIZONTAL_ALIGNMENT_CENTER, 190, 17, Color("ffe1a0"))
	# A ground warning is drawn in world coordinates, before HUD and combat text.
	if not guardian_pulse_warning.is_empty():
		var pulse_center := Vector2(float(guardian_pulse_warning.get("x", 0.0)), float(guardian_pulse_warning.get("y", 0.0)))
		var pulse_radius := float(guardian_pulse_warning.get("radius", 92.0))
		var pulse_fraction := 1.0 - float(guardian_pulse_warning.get("remaining", 0.0)) / maxf(0.01, float(guardian_pulse_warning.get("duration", 1.0)))
		draw_circle(pulse_center, pulse_radius, Color(0.95, 0.15, 0.12, 0.12 + pulse_fraction * 0.16))
		draw_arc(pulse_center, pulse_radius, 0.0, TAU, 64, Color(1.0, 0.34, 0.18, 0.92), 3.0)
		draw_arc(pulse_center, pulse_radius * pulse_fraction, 0.0, TAU, 64, Color(1.0, 0.90, 0.50, 0.88), 3.0)
	_draw_gather_animations()
	_draw_class_cast_fx()
	_draw_basic_projectiles()
	_draw_basic_impacts()
	_draw_combat_effects()
	if attack_flash_remaining > 0.0 and players.has(player_id):
		var attacker: Dictionary = players[player_id]
		var sword_pos := Vector2(float(attacker.get("x", 0.0)), float(attacker.get("y", 0.0)))
		var intensity: float = clampf(attack_flash_remaining / 0.16, 0.0, 1.0)
		_draw_basic_attack_fx(sword_pos, intensity)
	draw_set_transform(Vector2.ZERO)
	_draw_hud()
	_draw_hotbar()
	if dungeon_active:
		_draw_crypt_dungeon()
	if crypt_victory_time > 0.0:
		_draw_crypt_victory()
	if show_classes:
		_draw_classes_panel()
	if show_attributes:
		_draw_attributes_panel()
	if show_skill_tree:
		_draw_skill_tree_panel()
	if show_professions:
		_draw_professions_panel()
	if guardian_banner_time > 0.0:
		draw_rect(Rect2(185, 48, 590, 47), Color(0.12, 0.08, 0.16, 0.93))
		draw_rect(Rect2(187, 50, 586, 43), Color(0.32, 0.18, 0.38, 0.92), false, 2.0)
		draw_string(ThemeDB.fallback_font, Vector2(200, 79), guardian_banner, HORIZONTAL_ALIGNMENT_CENTER, 560, 17, Color("f6d3ff"))
	if show_shop:
		_draw_rpg_panel(Rect2(16, 62, 435, 520), "FERREIRO - " + ("FORJA" if smith_mode == "craft" else "MELHORIAS" if smith_mode == "upgrade" else "LOJA E VENDA"), "M")
		if smith_mode == "upgrade":
			_draw_panel_text(Vector2(32, 115), "CLICA 2 VEZES PARA CONFIRMAR MELHORIA", Color("f3ce80"), 12)
			var equipped: Dictionary = profile.get("equipment", {})
			var gears: Dictionary = profile.get("gear_equipped", {})
			for i in range(3):
				var slot_name: String = ["weapon", "offhand", "armor"][i]
				var item_name: String = str(equipped.get(slot_name, ""))
				var gear: Dictionary = gears.get(slot_name, {})
				var level: int = clampi(int(gear.get("level", 0)), 0, 10)
				var rr := Rect2(30, 130 + i * 98, 404, 88)
				draw_rect(rr, Color("40574d") if upgrade_confirm_slot == slot_name else Color("304b49"))
				draw_rect(rr, Color("e5c478"), false, 1.0)
				_draw_panel_text(rr.position + Vector2(8, 21), ["ARMA", "ESCUDO", "ARMADURA"][i] + ": " + (item_name if item_name != "<null>" and item_name != "" else "Vazio") + " +%d" % level, Color("fff0c7"), 12, 390)
				if level >= 10:
					_draw_panel_text(rr.position + Vector2(8, 44), "Nivel maximo +10", Color("a6e8bc"), 12)
				else:
					var chance: int = [90,80,70,60,50,40,30,20,12,5][level]
					var metal: int = 1 + int(level / 2.0)
					_draw_panel_text(rr.position + Vector2(8, 44), "+%d -> +%d | %d%% sucesso | +2 atributo" % [level,level+1,chance], Color("b5d8bd"), 12)
					_draw_panel_text(rr.position + Vector2(8, 65), "%d ouro | %d barras | %d minerios%s" % [100*(level+1),metal,2+level," | 1 metal antigo" if level >= 6 else ""], Color("f3ce80"), 11)
				if upgrade_confirm_slot == slot_name:
					_draw_panel_text(rr.position + Vector2(245, 84), "CLICA PARA CONFIRMAR", Color("ffe4a1"), 10)
			for j in range(3):
				var er := Rect2(30 + j * 136, 444, 130, 29)
				draw_rect(er, Color("354b59"))
				draw_rect(er, Color("d8b57b"), false, 1.0)
				_draw_panel_text(er.position + Vector2(7, 20), ["FURIA 65%", "PROTECAO 50%", "RUNICO 20%"][j], Color("f3ce80"), 11)
			_draw_panel_text(Vector2(32, 490), "Seleciona item 1x e clica no encanto. 900G + 2 barras + 1 metal.", Color("b5d8bd"), 10)
			_draw_panel_text(Vector2(32, 512), "Encanto unico | falha nao destroi | U fecha", Color("e5bda1"), 11)
		elif smith_mode == "craft":
			_draw_panel_text(Vector2(32, 115), "CLICA NA RECEITA PARA TENTAR FABRICAR", Color("f3ce80"), 13)
			for index in range(mini(5, SMITH_RECIPES.size() - smith_recipe_page * 5)):
				var recipe: Dictionary = SMITH_RECIPES[smith_recipe_page * 5 + index]
				var rr := Rect2(30, 130 + index * 72, 404, 64)
				draw_rect(rr, Color("304b49"))
				draw_rect(rr, Color("b89b62"), false, 1.0)
				_draw_panel_text(rr.position + Vector2(9, 21), str(recipe["name"]) + " - %d%% sucesso" % int(recipe["chance"]), Color("f7dc9b"), 13)
				_draw_panel_text(rr.position + Vector2(9, 45), str(recipe["cost"]), Color("ffffff"), 12)
				crafting_click_targets.append({"rect":rr, "recipe":recipe["id"]})
			_draw_panel_text(Vector2(32, 508), "Forja %d/%d | Roda / Setas para mais receitas" % [smith_recipe_page + 1, int(ceili(float(SMITH_RECIPES.size()) / 5.0))], Color("e5bda1"), 11)
		else:
			_draw_panel_text(Vector2(32, 117), "CLICA PARA COMPRAR | CORES = RARIDADE", Color("f3ce80"), 12)
			var shop_items := ["Espada de ferro", "Escudo de madeira", "Armadura de couro", "Espada de cavaleiro", "Escudo de ferro", "Armadura de ferro", "Espada de aco do Guardiao", "Escudo reforcado de aco", "Armadura de placas reais", "Lamina real de Valedouro", "Escudo da muralha", "Armadura do trono", "Arco do Aprendiz", "Colete do Explorador", "Cajado do Aprendiz", "Veste do Aprendiz"]
			var shop_prices := [65, 45, 90, 520, 480, 650, 1250, 850, 1600, 2800, 1950, 3400, 180, 210, 180, 210]
			var shop_attack := [8, 0, 0, 18, 0, 0, 32, 0, 0, 46, 0, 0, 11, 0, 12, 0]
			var shop_defense := [0, 3, 5, 0, 11, 16, 0, 19, 25, 0, 29, 37, 0, 9, 0, 8]
			for i in range(mini(6, shop_items.size() - sell_page * 6)):
				var idx: int = sell_page * 6 + i
				var rr := Rect2(30, 130 + i * 55, 404, 51)
				_draw_item_slot(rr, shop_items[idx], 0, "buy", true)
				var bonus := "+%d ATQ" % shop_attack[idx] if shop_attack[idx] > 0 else "+%d DEF" % shop_defense[idx]
				_draw_panel_text(Vector2(326, 147 + i * 55), bonus, Color("b5d8bd"), 11)
				_draw_panel_text(Vector2(337, 165 + i * 55), "%d G" % shop_prices[idx], Color("f3ce80"), 11)
			_draw_panel_text(Vector2(32, 469), "LOJA %d/%d | Roda / Setas | U: MELHORIAS" % [sell_page + 1, int(ceili(float(shop_items.size()) / 6.0))], Color("b5d8bd"), 11)
			_draw_panel_text(Vector2(32, 493), "Vendas: abre a mochila (I), clica direito no item", Color("b5d8bd"), 11)
			_draw_panel_text(Vector2(32, 519), "e escolhe a quantidade na confirmacao.", Color("b5d8bd"), 11)

	if show_inventory:
		_draw_rpg_panel(Rect2(495, 62, 447, 455), "MOCHILA E EQUIPAMENTOS", "I")
		var equipment: Dictionary = profile.get("equipment", {})
		_draw_panel_text(Vector2(511, 118), "EQUIPADO  (CLICA PARA RETIRAR)", Color("f3ce80"), 13)
		var slots := ["weapon", "offhand", "armor"]
		var labels := ["ARMA", "ESCUDO", "ARMADURA"]
		for i in range(slots.size()):
			var equipped := _equip_label(equipment.get(slots[i]))
			var r := Rect2(511 + i * 139, 131, 132, 78)
			draw_rect(r, Color("2b4041"))
			draw_rect(r, Color("a98e58"), false, 1.0)
			_draw_panel_text(r.position + Vector2(7, 20), labels[i], Color("f3ce80"), 11)
			_draw_panel_text(r.position + Vector2(7, 43), _item_icon(equipped) if equipped != "Nao equipado" else "--", Color.WHITE, 13)
			if equipped != "Nao equipado":
				inventory_click_targets.append({"rect":r,"item":equipped,"action":"unequip"})
		var active_tool := str(profile.get("subclass_tool", ""))
		var tool_rect := Rect2(511, 214, 417, 34)
		draw_rect(tool_rect, Color("2b4041"))
		draw_rect(tool_rect, Color("a98e58"), false, 1.0)
		_draw_panel_text(Vector2(519, 236), "SUBCLASSE: " + (active_tool if active_tool != "" and active_tool != "<null>" else "Nenhuma"), Color("f3ce80"), 12)
		if active_tool != "" and active_tool != "<null>":
			inventory_click_targets.append({"rect":tool_rect,"item":active_tool,"action":"unequip_tool"})
		# MVP 1.0.6.9: five dedicated inventory tabs, without modifying server inventory.
		var tab_labels: Array[String] = ["TODOS", "EQUIP.", "MATER.", "POCOES", "MISSAO"]
		for tab_index in range(tab_labels.size()):
			var tab_rect: Rect2 = Rect2(511 + tab_index * 84, 250, 81, 20)
			var selected: bool = tab_index == inventory_category_index
			draw_rect(tab_rect, Color("3a5862") if selected else Color("233d43"))
			draw_rect(tab_rect, Color("90caff") if selected else Color("a98e58"), false, 1.0 if not selected else 2.0)
			_draw_panel_text(tab_rect.position + Vector2(5, 14), tab_labels[tab_index], Color("d3f0ff") if selected else Color("f3ce80"), 10, 73.0)
		for filter_rect in [Rect2(511, 273, 100, 20), Rect2(615, 273, 102, 20), Rect2(721, 273, 207, 20)]:
			draw_rect(filter_rect, Color("233d43"))
			draw_rect(filter_rect, Color("a98e58"), false, 1.0)
		_draw_panel_text(Vector2(516, 287), "Rar.: " + INVENTORY_RARITIES[inventory_rarity_index], Color("f3ce80"), 10, 90.0)
		_draw_panel_text(Vector2(620, 287), "Ord.: " + INVENTORY_SORTS[inventory_sort_index], Color("f3ce80"), 10, 94.0)
		var search_label: String = "Busca: " + inventory_search
		if inventory_search_active:
			search_label += "_"
		elif inventory_search == "":
			search_label += "(clique para escrever)"
		_draw_panel_text(Vector2(726, 287), search_label, Color("c5e7ec"), 10, 195.0)

		var items: Dictionary = profile.get("inventory", {})
		var index := 0
		var inventory_entries: Array = []
		var gear_bag: Array = profile.get("gear_bag", [])
		for inventory_item in items:
			if int(items[inventory_item]) > 0 and not EQUIPMENT_RARITY.has(str(inventory_item)):
				inventory_entries.append({"name":str(inventory_item), "amount":int(items[inventory_item]), "id":"", "level":0, "enchant":""})
		for gear_value in gear_bag:
			if gear_value is Dictionary:
				var gear: Dictionary = gear_value
				inventory_entries.append({"name":str(gear.get("name", "")), "amount":1, "id":str(gear.get("id", "")), "level":int(gear.get("level",0)), "enchant":str(gear.get("enchant", ""))})
		inventory_entries = _inventory_visible_entries(inventory_entries)
		inventory_page = mini(inventory_page, maxi(0, int(ceili(float(inventory_entries.size()) / 8.0)) - 1))
		for entry_value in inventory_entries.slice(inventory_page * 8, (inventory_page + 1) * 8):
			var entry: Dictionary = entry_value
			var item: String = str(entry["name"])
			if index >= 8:
				break
			var col_index := index % 2
			var row_index := int(index / 2.0)
			var item_rect := Rect2(511 + col_index * 212, 296 + row_index * 40, 205, 37)
			var action := "equip" if str(entry["id"]) != "" else "use" if item in ["Pocao pequena", "Pocao media", "Pocao completa"] else "equip_tool" if item in ["Machado de lenhador", "Picareta de mineiro", "Kit de herbalista", "Machado de aco", "Picareta de aco", "Kit botanico"] else "inspect"
			_draw_item_slot(item_rect, item, int(entry["amount"]), action)
			if str(entry["id"]) != "":
				var details := "+%d" % int(entry["level"])
				if str(entry["enchant"]) != "":
					details += " " + str(entry["enchant"])
				_draw_panel_text(item_rect.position + Vector2(57, 38), details, Color("f3ce80"), 10, 140.0)
				inventory_click_targets[inventory_click_targets.size() - 1]["gear_id"] = str(entry["id"])
			index += 1
		if inventory_entries.is_empty():
			_draw_panel_text(Vector2(511, 317), "Nenhum item corresponde aos filtros.", Color("abb7b1"), 13)
		var set_names: Array[String] = ["Lamina do Sino Partido", "Escudo do Sino Partido", "Armadura do Sino Partido"]
		var set_count: int = 0
		for set_slot in slots:
			if str(equipment.get(set_slot, "")) in set_names:
				set_count += 1
		var set_status: String = "CONJUNTO DO SINO: %d/3" % set_count
		if set_count >= 3:
			set_status += "  +8 DEF  +12 ATQ"
		elif set_count >= 2:
			set_status += "  +8 DEF"
		else:
			set_status += "  2 pecas: +8 DEF | 3: +12 ATQ"
		_draw_panel_text(Vector2(511, 462), set_status, Color("90caff") if set_count >= 2 else Color("b8c6ca"), 11, 420.0)
		_draw_panel_text(Vector2(511, 478), "Mochila %d/%d | Equipamentos por unidade" % [inventory_page + 1, maxi(1, int(ceili(float(inventory_entries.size()) / 8.0)))], Color("f3ce80"), 12)
		_draw_panel_text(Vector2(511, 500), "Esquerdo: usar/equipar | Direito: vender | Roda / Setas: paginas | Abas acima", Color("b5d8bd"), 12)
	if hover_item != "" and (show_inventory or show_shop):
		if hover_gear_id != "" and show_inventory:
			_draw_individual_gear_comparison(hover_gear_id)
		elif not _draw_equipment_comparison(hover_item):
			var tip := Rect2(Vector2(495, 519), Vector2(447, 27))
			draw_rect(tip, Color("18272a", 0.96))
			_draw_panel_text(tip.position + Vector2(8, 18), _item_description(hover_item), Color("f3ce80"), 12)
	if show_bank and not _bank_nearby():
		show_bank = false
	if show_bank:
		_draw_rpg_panel(Rect2(180, 75, 620, 430), "ARMAZEM PESSOAL", "B")
		var guardian_line: String = "Guardiã: Guarda um item e recebe 75 ouro e 2 pocoes."
		if bool(profile.get("bank_intro_done", false)):
			var supply: Dictionary = profile.get("bank_supply_progress", {})
			guardian_line = "Reserva: Madeira %d/5 | Rocha %d/3. Premio: 180 ouro + 120 XP." % [int(supply.get("Fragmento de madeira", 0)), int(supply.get("Fragmento de rocha", 0))]
			if bool(profile.get("bank_supply_done", false)):
				guardian_line = "Guardiã: Reserva de Valedouro concluida. Obrigada!"
		_draw_panel_text(Vector2(200, 123), guardian_line, Color("a9e1ff"), 11, 560.0)
		_draw_panel_text(Vector2(200, 146), "MOCHILA  (clique para guardar 1)", Color("f3ce80"), 12)
		_draw_panel_text(Vector2(500, 146), "BAU  (clique para retirar 1)", Color("90caff"), 12)
		bank_click_targets.clear()
		var bag_entries: Array = []
		var bank_entries: Array = []
		for item_key in profile.get("inventory", {}):
			if str(item_key) != "Selo das Ruinas" and not EQUIPMENT_RARITY.has(str(item_key)):
				bag_entries.append({"name":str(item_key), "amount":int(profile["inventory"][item_key]), "id":""})
		for gear_value in profile.get("gear_bag", []):
			if gear_value is Dictionary:
				bag_entries.append({"name":str(gear_value.get("name","")), "amount":1, "id":str(gear_value.get("id",""))})
		var stored: Dictionary = profile.get("bank_items", {})
		for item_key in stored:
			if not EQUIPMENT_RARITY.has(str(item_key)):
				bank_entries.append({"name":str(item_key), "amount":int(stored[item_key]), "id":""})
		for gear_value in profile.get("bank_gear", []):
			if gear_value is Dictionary:
				bank_entries.append({"name":str(gear_value.get("name","")), "amount":1, "id":str(gear_value.get("id",""))})
		bag_entries.sort_custom(func(a: Dictionary, b: Dictionary) -> bool: return str(a["name"]) < str(b["name"]))
		bank_entries.sort_custom(func(a: Dictionary, b: Dictionary) -> bool: return str(a["name"]) < str(b["name"]))
		var max_pages: int = maxi(1, int(ceili(float(maxi(bag_entries.size(), bank_entries.size())) / 8.0)))
		bank_page = mini(bank_page, max_pages - 1)
		for side in range(2):
			var entries: Array = bag_entries if side == 0 else bank_entries
			for row_index in range(mini(8, maxi(0, entries.size() - bank_page * 8))):
				var entry: Dictionary = entries[bank_page * 8 + row_index]
				var cell: Rect2 = Rect2(198 + side * 300, 157 + row_index * 38, 283, 33)
				draw_rect(cell, Color("2b4041"))
				draw_rect(cell, Color("a98e58"), false, 1.0)
				_draw_panel_text(cell.position + Vector2(6, 23), str(entry["name"]) + " x%d" % int(entry["amount"]), Color("e5e9df"), 11, 267.0)
				bank_click_targets.append({"rect":cell, "item":str(entry["name"]), "gear_id":str(entry["id"]), "direction":"deposit" if side == 0 else "withdraw"})
		_draw_panel_text(Vector2(201, 482), "Pagina %d/%d | Roda / Setas cima-baixo | B: fechar" % [bank_page + 1, max_pages], Color("b5d8bd"), 11)
	if show_quests:
		_draw_rpg_panel(Rect2(155, 55, 650, 465), "DIARIO DE MISSOES", "Q")
		var missions: Array[Dictionary] = []
		var quest_stage: String = str(profile.get("quest", "not_started"))
		var wolves: int = mini(3, int(profile.get("kills", 0)))
		var first_goal: String = "Fala com Tessa para iniciar."
		if quest_stage == "active":
			first_goal = "Derrota lobos nas proximidades: %d/3" % wolves
		elif quest_stage == "completed":
			first_goal = "A vila esta segura."
		missions.append({"title":"A protecao de Valedouro", "state":quest_stage, "goal":first_goal, "reward":"100 XP | 50 ouro | 2 pocoes"})
		var forest_stage: String = str(profile.get("forest_quest", "locked"))
		if quest_stage == "completed":
			var forest_goal: String = "Fala com Tessa para iniciar."
			if forest_stage == "active":
				forest_goal = "Explora baus diferentes: %d/2" % int(profile.get("forest_quest_chests", []).size())
			elif forest_stage == "ready":
				forest_goal = "Regressa a Tessa para receber a recompensa."
			elif forest_stage == "completed":
				forest_goal = "Exploracao concluida."
			missions.append({"title":"Exploracao da Floresta", "state":forest_stage, "goal":forest_goal, "reward":"200 XP | 150 ouro | 3 pocoes"})
		if forest_stage == "completed":
			var guardian_stage: String = str(profile.get("guardian_quest", "locked"))
			var guardian_goal: String = "Fala com Tessa para iniciar."
			if guardian_stage == "active":
				guardian_goal = "Guardiao: %d/1 | Selo: %d/1" % [mini(1, int(profile.get("guardian_quest_kills", 0))), mini(1, int(profile.get("inventory", {}).get("Selo das Ruinas", 0)))]
			elif guardian_stage == "ready":
				guardian_goal = "Regressa a Tessa com o Selo."
			elif guardian_stage == "completed":
				guardian_goal = "O Selo foi entregue."
			missions.append({"title":"O Selo das Ruinas", "state":guardian_stage, "goal":guardian_goal, "reward":"450 XP | 500 ouro | 5 pocoes"})
		if str(profile.get("guardian_quest", "locked")) == "completed":
			var crypt_stage: String = str(profile.get("crypt_quest", "locked"))
			var crypt_goal: String = "Fala com Tessa para investigar a Cripta."
			if crypt_stage == "active":
				crypt_goal = "Vai ao portal a sudeste das ruinas e usa E."
			elif crypt_stage == "investigated":
				crypt_goal = "Derrota saqueadores: %d/3" % int(profile.get("crypt_raiders", 0))
			elif crypt_stage == "ready":
				crypt_goal = "Regressa a Tessa para concluir."
			elif crypt_stage == "completed":
				crypt_goal = "Pista do Sino Partido encontrada."
			missions.append({"title":"Ecos da Cripta do Sino Partido", "state":crypt_stage, "goal":crypt_goal, "reward":"Pista da historia do Sino Partido"})
		var intro_done: bool = bool(profile.get("bank_intro_done", false))
		missions.append({"title":"A Primeira Entrega", "state":"completed" if intro_done else "active", "goal":"Primeiro deposito no armazem realizado." if intro_done else "Guarda um item com a Guardiã do Armazem.", "reward":"75 ouro | 2 pocoes"})
		if intro_done:
			var reserve: Dictionary = profile.get("bank_supply_progress", {})
			var reserve_done: bool = bool(profile.get("bank_supply_done", false))
			var reserve_goal: String = "Deposita madeira %d/5 e rocha %d/3." % [int(reserve.get("Fragmento de madeira", 0)), int(reserve.get("Fragmento de rocha", 0))]
			if reserve_done:
				reserve_goal = "Reservas de Valedouro abastecidas."
			missions.append({"title":"A Reserva de Valedouro", "state":"completed" if reserve_done else "active", "goal":reserve_goal, "reward":"180 ouro | 120 XP"})
		if bool(profile.get("dungeon_claimed", false)) and str(profile.get("crypt_quest", "")) == "completed":
			var echo_stage: String = str(profile.get("bell_echo_quest", "locked"))
			var echo_goal: String = "Fala com Tessa para iniciar a investigacao."
			if echo_stage == "active":
				echo_goal = "Entrega a Tessa metal antigo: %d/3 na mochila." % mini(3, int(profile.get("inventory", {}).get("Fragmento de metal antigo", 0)))
			elif echo_stage == "completed":
				echo_goal = "As runas do Sino Partido foram decifradas."
			missions.append({"title":"O Eco do Sino Partido", "state":echo_stage, "goal":echo_goal, "reward":"180 XP | 240 ouro | 2 pocoes"})
		if str(profile.get("bell_echo_quest", "locked")) == "completed":
			var rune_stage: String = str(profile.get("rune_ruins_quest", "locked"))
			var rune_goal: String = "Fala com Tessa para iniciar."
			if rune_stage == "active":
				rune_goal = "Examina a pedra no portal das ruinas (E)."
			elif rune_stage == "ready":
				rune_goal = "Regressa a Tessa com a inscricao."
			elif rune_stage == "completed":
				rune_goal = "Inscricao runica entregue a Tessa."
			missions.append({"title":"As Pedras que Cantam", "state":rune_stage, "goal":rune_goal, "reward":"250 XP | 300 ouro"})
		if str(profile.get("rune_ruins_quest", "locked")) == "completed":
			var watch_stage: String = str(profile.get("rune_watch_quest", "locked"))
			var watch_goal: String = "Fala com Tessa para iniciar a vigilia."
			if watch_stage == "active":
				watch_goal = "Derrota saqueadores: %d/5." % mini(5, int(profile.get("rune_watch_kills", 0)))
			elif watch_stage == "ready":
				watch_goal = "Regressa a Tessa para receber a recompensa."
			elif watch_stage == "completed":
				watch_goal = "A inscricao runica foi protegida."
			missions.append({"title":"Vigilia das Runas", "state":watch_stage, "goal":watch_goal, "reward":"300 XP | 350 ouro"})
		# MVP 1.0.7.6: active objectives first, ready-to-turn-in next, completed last.
		# Stable ordering within each state retains the original story progression.
		var ordered_missions: Array[Dictionary] = []
		for stage_group in [["active", "investigated"], ["ready"], ["locked", "not_started"], ["completed"]]:
			for mission_entry in missions:
				if str(mission_entry.get("state", "")) in stage_group:
					ordered_missions.append(mission_entry)
		missions = ordered_missions
		var page_count: int = maxi(1, int(ceili(float(missions.size()) / 3.0)))
		quest_page = clampi(quest_page, 0, page_count - 1)
		var unfinished_count: int = 0
		for mission_entry in missions:
			if str(mission_entry.get("state", "")) != "completed":
				unfinished_count += 1
		_draw_panel_text(Vector2(176, 115), "OBJETIVOS | %d PENDENTES | %d CONCLUIDAS" % [unfinished_count, missions.size() - unfinished_count], Color("b5c8c0"), 12)

		for card_index in range(3):
			var mission_index: int = quest_page * 3 + card_index
			if mission_index >= missions.size():
				break
			var mission: Dictionary = missions[mission_index]
			var card: Rect2 = Rect2(174, 130 + card_index * 112, 612, 103)
			var stage: String = str(mission["state"])
			draw_rect(card, Color("29403d") if stage == "ready" else Color("20343a"))
			draw_rect(card, Color("d6b66f") if stage == "ready" else Color("627d75"), false, 2.0 if stage == "ready" else 1.0)
			var stage_label: String = "CONCLUIDA" if stage == "completed" else "PRONTA" if stage == "ready" else "EM CURSO" if stage in ["active", "investigated"] else "DISPONIVEL"
			var stage_color: Color = Color("94d6a5") if stage == "completed" else Color("f5cf85")
			_draw_panel_text(card.position + Vector2(12, 24), str(mission["title"]), Color("f5d997"), 15, 410.0)
			_draw_panel_text(card.position + Vector2(482, 24), stage_label, stage_color, 12, 116.0)
			_draw_panel_text(card.position + Vector2(12, 53), "Objetivo: " + str(mission["goal"]), Color("e8efeb"), 12, 575.0)
			_draw_panel_text(card.position + Vector2(12, 81), "Recompensa: " + str(mission["reward"]), Color("a6dcb9"), 12, 575.0)
		_draw_panel_text(Vector2(176, 496), "Pagina %d/%d  |  Roda / Setas cima-baixo" % [quest_page + 1, page_count], Color("cbd7d0"), 12)
		for nav_data in [{"rect":Rect2(570, 479, 95, 29), "text":"ANTERIOR"}, {"rect":Rect2(670, 479, 115, 29), "text":"SEGUINTE"}]:
			var nav_rect: Rect2 = nav_data["rect"]
			draw_rect(nav_rect, Color("35504d"))
			draw_rect(nav_rect, Color("b89b62"), false, 1.0)
			_draw_panel_text(nav_rect.position + Vector2(9, 20), str(nav_data["text"]), Color("f5d997"), 12)

	if show_dialog:
		_draw_rpg_panel(Rect2(205, 382 if smith_dialog else 405, 550, 147 if smith_dialog else 124), dialog_speaker.to_upper(), "ESC")
		_draw_dialog_wrapped(Vector2(225, 440 if smith_dialog else 465), dialog_text, 510.0, 14)
		if smith_dialog:
			var choices := [
				{"rect":Rect2(225, 482, 245, 36), "mode":"shop", "text":"COMPRAR EQUIPAMENTOS"},
				{"rect":Rect2(482, 482, 252, 36), "mode":"craft", "text":"FABRICAR ITENS"}
			]
			for choice in choices:
				var rr: Rect2 = choice["rect"]
				draw_rect(rr, Color("38534e"))
				draw_rect(rr, Color("d5b46b"), false, 1.0)
				_draw_panel_text(rr.position + Vector2(14, 24), str(choice["text"]), Color("fff2cc"), 13)
				smith_dialog_click_targets.append(choice)

# Keep NPC dialogue inside the panel; wrap by actual font metrics.
	if sell_confirm_open:
		draw_rect(Rect2(0, 44, 960, 496), Color(0, 0, 0, 0.65))
		_draw_rpg_panel(Rect2(480, 181, 420, 231), "CONFIRMAR VENDA", "ESC")
		var owned_count: int = int(profile.get("inventory", {}).get(pending_sale_item, 0))
		_draw_panel_text(Vector2(500, 242), "Vender %dx %s?" % [pending_sale_quantity, pending_sale_item], Color("fff2cc"), 14, 375)
		_draw_panel_text(Vector2(500, 271), "Disponivel: %d | Escolhe a quantidade:" % owned_count, Color("d3d9d3"), 12)
		for qty_index in range(6):
			var qty: int = [1, 5, 10, 20, 50, owned_count][qty_index]
			var qty_rect := Rect2(500 + qty_index * 65, 292, 61, 32)
			var enabled: bool = (pending_sale_gear_id == "" or qty == 1) and qty > 0 and qty <= owned_count
			draw_rect(qty_rect, Color("64734b") if qty == pending_sale_quantity and enabled else Color("304b49") if enabled else Color("273337"))
			draw_rect(qty_rect, Color("d5b46b"), false, 1.0)
			_draw_panel_text(qty_rect.position + Vector2(8, 22), "TUDO" if qty_index == 5 else "%dx" % qty, Color("fff2cc") if enabled else Color("88918e"), 12)
		_draw_panel_text(Vector2(500, 343), "A venda nao pode ser desfeita.", Color("d3d9d3"), 12)
		for button_data in [{"rect":Rect2(500, 350, 185, 43), "label":"CONFIRMAR"}, {"rect":Rect2(696, 350, 185, 43), "label":"CANCELAR"}]:
			var rr: Rect2 = button_data["rect"]
			draw_rect(rr, Color("38534e"))
			draw_rect(rr, Color("d5b46b"), false, 1.0)
			_draw_panel_text(rr.position + Vector2(18, 28), str(button_data["label"]), Color("fff2cc"), 13)

func _draw_gather_markers() -> void:
	for resource in profile.get("resource_nodes", []):
		var pos := Vector2(float(resource.get("x", 0)), float(resource.get("y", 0)))
		var kind := str(resource.get("kind", ""))
		var chance := int(resource.get("chance", 0))
		if kind == "herb":
			draw_circle(pos + Vector2(0, -12), 9.0, Color("a35ee5", 0.8))
			draw_circle(pos + Vector2(0, -12), 4.0, Color("eec9ff"))
		var label_text := "[G] %s %d%%" % [str(GATHER_LABELS.get(kind, "Recurso")), chance]
		draw_string_outline(ThemeDB.fallback_font, pos + Vector2(-110, -49), label_text, HORIZONTAL_ALIGNMENT_CENTER, 220, 12, 3, Color("182320"))
		draw_string(ThemeDB.fallback_font, pos + Vector2(-110, -49), label_text, HORIZONTAL_ALIGNMENT_CENTER, 220, 12, Color("f5e3aa") if kind != "herb" else Color("f0b7ff"))

func _is_night() -> bool:
	# 3 real hours of daylight followed by 30 real minutes of night.
	# 12,600-second shared cycle; deterministic after reconnecting.
	var cycle_seconds: int = int(Time.get_unix_time_from_system()) % 12600
	return cycle_seconds >= 10800

func _draw_night_lighting() -> void:
	if not _is_night():
		return
	# Soft night tint, followed by warm pools of light from lanterns.
	draw_rect(Rect2(0, 0, WORLD_W, WORLD_H), Color(0.04, 0.09, 0.20, 0.53))
	for house in OBSTACLES:
		var lamp: Vector2 = Vector2(house.position) + Vector2(float(house.size.x) + 13.0, float(house.size.y) - 35.0)
		_draw_lamp_glow(lamp, 78.0)
	for street_lamp in [Vector2(470, 315), Vector2(950, 330), Vector2(1430, 340), Vector2(980, 970), Vector2(1400, 970)]:
		_draw_lamp_glow(street_lamp, 105.0)
	if players.has(player_id):
		var hero: Dictionary = players[player_id]
		var hero_pos := Vector2(float(hero.get("x", 0)), float(hero.get("y", 0)))
		_draw_lamp_glow(hero_pos + Vector2(12, -25), 90.0)
		draw_line(hero_pos + Vector2(13, -14), hero_pos + Vector2(13, -34), Color("d9b16a"), 3.0)
		draw_circle(hero_pos + Vector2(13, -35), 5.0, Color("ffe3a0"))

func _draw_lamp_glow(pos: Vector2, radius: float) -> void:
	for step in range(6, 0, -1):
		var fraction := float(step) / 6.0
		draw_circle(pos, radius * fraction, Color(1.0, 0.78, 0.35, 0.015))
		draw_circle(pos, radius * fraction * 0.65, Color(1.0, 0.87, 0.55, 0.017))

func _draw_dialog_wrapped(origin: Vector2, content: String, max_width: float, font_size: int) -> void:
	var font := ThemeDB.fallback_font
	var line := ""
	var y := origin.y
	for word in content.split(" ", false):
		var candidate := word if line.is_empty() else line + " " + word
		if not line.is_empty() and font.get_string_size(candidate, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size).x > max_width:
			draw_string(font, Vector2(origin.x, y), line, HORIZONTAL_ALIGNMENT_LEFT, max_width, font_size, Color.WHITE)
			y += 21.0
			line = word
		else:
			line = candidate
	if not line.is_empty():
		draw_string(font, Vector2(origin.x, y), line, HORIZONTAL_ALIGNMENT_LEFT, max_width, font_size, Color.WHITE)

func _draw_rpg_panel(rect: Rect2, heading: String, close_key: String) -> void:
	draw_rect(rect, Color("111d24", 0.97))
	draw_rect(rect, Color("b89b62"), false, 2.0)
	draw_rect(Rect2(rect.position, Vector2(rect.size.x, 40)), Color("263b3d"))
	draw_line(rect.position + Vector2(0, 40), rect.position + Vector2(rect.size.x, 40), Color("b89b62"), 1.0)
	_draw_panel_text(rect.position + Vector2(14, 26), heading, Color("f5d997"), 17, rect.size.x - 95)
	_draw_panel_text(rect.position + Vector2(rect.size.x - 78, 26), "[" + close_key + "]", Color("b5c8c0"), 13)

func _draw_panel_text(pos: Vector2, content: String, color: Color, size: int, width: float = -1.0) -> void:
	draw_string(ThemeDB.fallback_font, pos, content, HORIZONTAL_ALIGNMENT_LEFT, width, size, color)

func _near_road(pos: Vector2) -> bool:
	return (pos.y > 260 and pos.y < 380) or (pos.x > 420 and pos.x < 550)

func _inside_building(pos: Vector2) -> bool:
	for rect in OBSTACLES:
		if rect.grow(15).has_point(pos):
			return true
	return false

func _draw_isometric_ground() -> void:
	draw_rect(Rect2(0, 0, 960, 640), Color("354e3f"))
	# 64 x 32 isometric diamond tiles, purely decorative: server coordinates stay unchanged.
	for row in range(-3, 47):
		for col in range(-3, 20):
			var x := float(col * 64 + (row % 2) * 32)
			var y := float(row * 16)
			var terrain_seed := posmod(col * 19 + row * 31, 11)
			var shade := Color("486e51") if terrain_seed < 5 else Color("4d7655")
			if terrain_seed == 0:
				shade = Color("557b57")
			_diamond(Vector2(x, y), 32, 16, shade)
			if terrain_seed == 2:
				draw_circle(Vector2(x + 4, y + 2), 1.6, Color("d9b96c"))

func _diamond(center: Vector2, rx: float, ry: float, color: Color) -> void:
	draw_colored_polygon(PackedVector2Array([center + Vector2(0,-ry), center + Vector2(rx,0), center + Vector2(0,ry), center + Vector2(-rx,0)]), color)
	draw_polyline(PackedVector2Array([center + Vector2(0,-ry), center + Vector2(rx,0), center + Vector2(0,ry), center + Vector2(-rx,0), center + Vector2(0,-ry)]), Color(0.10,0.19,0.14,0.12), 1)

func _draw_roads() -> void:
	draw_rect(Rect2(0, 278, 960, 85), Color("95866a"))
	draw_rect(Rect2(440, 0, 88, 640), Color("95866a"))
	for row in range(0, 21):
		for col in range(0, 35):
			var p := Vector2(col * 31 + (row % 2) * 15, row * 31 + 8)
			if _near_road(p):
				draw_rect(Rect2(p, Vector2(24, 12)), Color("c1b18a") if (row + col) % 3 else Color("b5a580"))
				draw_line(p + Vector2(0,12), p + Vector2(24,12), Color("746b58",0.55), 1)

# MVP 0.5.8 - purely decorative terrain. No new collision bodies.
func _draw_road_details() -> void:
	# Subtle edge stones and worn cobblestones; avoid the centre of the roads.
	for i in range(48):
		var x := float((i * 71 + 19) % 955)
		for y in [275.0, 365.0]:
			var point := Vector2(x, y)
			draw_line(point, point + Vector2(11, 0), Color("d4c39a", 0.58), 2.0)
	for i in range(32):
		var y := float((i * 67 + 23) % 630)
		for x in [438.0, 530.0]:
			var point := Vector2(x, y)
			draw_line(point, point + Vector2(0, 9), Color("d4c39a", 0.48), 2.0)
	for i in range(85):
		var point := Vector2(float((i * 79 + 17) % 960), float((i * 131 + 31) % 540))
		if _near_road(point):
			draw_circle(point, 1.1, Color("6c6352", 0.34))

func _draw_ground_details() -> void:
	# Grass clusters, flowers and scattered leaves, outside houses and roads.
	for i in range(125):
		var point := Vector2(float((i * 173 + 29) % 950), float((i * 113 + 47) % 530))
		if _near_road(point) or _inside_building(point):
			continue
		var shade := Color("315f42", 0.6) if i % 3 else Color("73966a", 0.48)
		draw_line(point, point + Vector2(-2, -5), shade, 1.0)
		draw_line(point, point + Vector2(2, -4), shade, 1.0)
		if i % 7 == 0:
			draw_circle(point + Vector2(0, -6), 2.0, Color("f1d28b") if i % 2 else Color("cfa2a7"))

func _draw_foliage() -> void:
	for i in range(46):
		var p := Vector2(float((i*137+37)%930+15), float((i*83+43)%520+15))
		if not _near_road(p) and not _inside_building(p):
			draw_circle(p, 2.3, Color("e3c875") if i%2 else Color("d9a0ac"))
			draw_line(p, p + Vector2(0,5), Color("2a603f"), 1)

func _draw_tree(base: Vector2) -> void:
	# Reference trees have true alpha; deterministic variants per world position.
	var variant := absi(int(base.x * 7.0 + base.y * 3.0)) % 4
	var tree: Texture2D = [visual_tree_oak, visual_tree_autumn, visual_tree_blossom, visual_tree_pine][variant]
	_draw_visual_actor(tree, base + Vector2(0, 3), 82.0, 94.0)

func _draw_rock(v: Vector3) -> void:
	var p := Vector2(v.x, v.y)
	draw_ellipse_shadow(p, v.z)
	# Source image: stone occupies the final ~57 pixels of a 295x75 strip.
	draw_texture_rect_region(visual_decor_reference, Rect2(p + Vector2(-v.z * 1.45, -v.z * 2.2), Vector2(v.z * 2.9, v.z * 2.5)), Rect2(232, 0, 63, 75))

func draw_ellipse_shadow(p: Vector2, r: float) -> void:
	# A sombra usa a transformacao da camara e restaura-a ao terminar.
	# Repor Vector2.ZERO aqui faria os objetos seguintes saltarem de posicao.
	draw_set_transform(p + Vector2(4, 4) - camera_offset, 0.0, Vector2(1.0, 0.35))
	draw_circle(Vector2.ZERO, r, Color(0, 0, 0, 0.26))
	draw_set_transform(-camera_offset)

func _draw_bush(v: Vector3) -> void:
	var p := Vector2(v.x, v.y)
	draw_ellipse_shadow(p, v.z)
	var variant: int = absi(int(v.x * 3.0 + v.y)) % 4
	var start_x: float = [0.0, 63.0, 121.0, 179.0][variant]
	var width_px: float = [63.0, 58.0, 58.0, 53.0][variant]
	draw_texture_rect_region(visual_decor_reference, Rect2(p + Vector2(-v.z * 1.5, -v.z * 2.2), Vector2(v.z * 3.0, v.z * 2.5)), Rect2(start_x, 0, width_px, 75))

func _draw_barrel(v: Vector3) -> void:
	var p := Vector2(v.x,v.y)
	draw_ellipse_shadow(p,v.z)
	draw_rect(Rect2(p+Vector2(-v.z,-25),Vector2(v.z*2,25)),Color("865534"))
	draw_rect(Rect2(p+Vector2(-v.z,-21),Vector2(v.z*2,4)),Color("c4a26d"))
	draw_rect(Rect2(p+Vector2(-v.z,-6),Vector2(v.z*2,4)),Color("c4a26d"))
	draw_ellipse_shadow(p+Vector2(0,-25),v.z)

func _draw_fence(r: Rect2) -> void:
	draw_rect(Rect2(r.position+Vector2(0,-11),Vector2(r.size.x,7)),Color("8c603f"))
	for i in range(int(r.size.x/18)+1):
		var x := r.position.x+i*18.0
		draw_rect(Rect2(Vector2(x,r.position.y-21),Vector2(8,31)),Color("b08755"))

func _draw_house(rect: Rect2) -> void:
	# Keep the original collision rectangles; artwork is visual only.
	var variant := absi(int(rect.position.x * 3.0 + rect.position.y)) % 4
	var house: Texture2D = [visual_house_cottage, visual_house_workshop, visual_house_guild, visual_house_townhall][variant]
	var art_width := maxf(118.0, rect.size.x + 26.0)
	var art_height := maxf(105.0, rect.size.y + 52.0)
	_draw_visual_actor(house, rect.position + Vector2(rect.size.x * 0.5, rect.size.y), art_width, art_height)

func _draw_professions_panel() -> void:
	_draw_rpg_panel(Rect2(530, 68, 395, 318), "PROFISSOES", "P")

	var skill_data: Dictionary = profile.get("professions", {})

	var entries: Array[Dictionary] = [
		{"key": "lenhador", "name": "LENHADOR", "desc": "Recolha de madeira", "color": Color("9bbd77")},
		{"key": "mineiro", "name": "MINEIRO", "desc": "Extracao de rochas e ferro", "color": Color("c9a57e")},
		{"key": "herbalista", "name": "HERBALISTA", "desc": "Procura de ervas raras", "color": Color("b9a5df")}
	]

	for i in range(entries.size()):
		var entry: Dictionary = entries[i]
		var info: Dictionary = skill_data.get(str(entry["key"]), {})
		var level: int = int(info.get("level", 1))
		var exp: int = int(info.get("xp", 0))
		var required: int = maxi(1, int(info.get("xp_next", 50)))
		var y: float = 112.0 + float(i) * 84.0

		_draw_panel_text(
			Vector2(548, y),
			"%s NIVEL %d" % [str(entry["name"]), level],
			Color("f3ce80"),
			14
		)

		var perk_text: String = str(entry["desc"])
		if level >= 6:
			perk_text += " | Ferramenta avancada desbloqueada"
		elif level >= 3:
			perk_text += " | Ferramenta desbloqueada"
		_draw_panel_text(
			Vector2(548, y + 20.0),
			perk_text,
			Color("d3d9d3"),
			11
		)

		_bar(
			Rect2(548, y + 29.0, 352, 17),
			float(exp) / float(required),
			entry["color"],
			"%d / %d XP" % [exp, required]
		)

	_draw_panel_text(
		Vector2(548, 369),
		"Recolhe com G | P para fechar",
		Color("b5d8bd"),
		12
	)

func _draw_skill_tree_panel() -> void:
	var font: Font = ThemeDB.fallback_font
	var cls: String = str(profile.get("combat_class", "Guerreiro"))
	var mastery: Dictionary = profile.get("skill_mastery", {})
	var mastery_level: int = mini(5, int(int(mastery.get(cls, 0)) / 8))
	var tree: Dictionary = profile.get("skill_tree", {})
	var unlocked: Array = tree.get(cls, [])
	var panel: Rect2 = Rect2(265, 95, 430, 425)
	draw_rect(panel, Color("13252d", 0.97))
	draw_rect(panel, Color("d8ae6c"), false, 2.0)
	draw_string(font, Vector2(284, 127), "ARVORE DE TALENTOS", HORIZONTAL_ALIGNMENT_LEFT, 385, 20, Color("f2d69c"))
	draw_string(font, Vector2(284, 159), "%s | Maestria Nv.%d" % [cls, mastery_level], HORIZONTAL_ALIGNMENT_LEFT, 390, 15, Color("b8e5c6"))
	draw_string(font, Vector2(284, 188), "Desbloqueia talentos permanentes por classe:", HORIZONTAL_ALIGNMENT_LEFT, 390, 13, Color("c1d2d3"))
	for i in range(5):
		var node_id: String = ["power", "guard", "technique", "mastery", "resilience"][i]
		var needed: int = [1, 3, 2, 4, 5][i]
		var owned: bool = unlocked.has(node_id)
		var available: bool = mastery_level >= needed and (i == 0 or unlocked.has("power"))
		var rect: Rect2 = Rect2(295, 206 + i * 57, 365, 49)
		draw_rect(rect, Color("244c3d") if owned else Color("36463c") if available else Color("29333b"))
		draw_rect(rect, Color("d6ad6b"), false, 1.0)
		var class_technique: String = "VIGOR: cura 10% do dano" if cls == "Guerreiro" else "SINTONIA: recupera 8 MP" if cls == "Mago" else "PRECISAO: +20% vs Guardiao"
		var label_text: String = ["PODER: +5 ATQ", "GUARDA: +5 DEF", class_technique, "MAESTRIA: +7 ATQ", "RESILIENCIA: +7 DEF"][i]
		var state_text: String = "DESBLOQUEADO" if owned else "CLICA PARA DESBLOQUEAR" if available else "REQUER MAESTRIA NV.%d" % needed
		draw_string(font, Vector2(rect.position.x + 12, rect.position.y + 20), label_text, HORIZONTAL_ALIGNMENT_LEFT, 335, 15, Color("f4dfb4"))
		draw_string(font, Vector2(rect.position.x + 12, rect.position.y + 37), state_text, HORIZONTAL_ALIGNMENT_LEFT, 335, 11, Color("b9d8c6"))
	draw_string(font, Vector2(284, 507), "B / ESC: fechar | Cada classe tem a sua arvore.", HORIZONTAL_ALIGNMENT_LEFT, 400, 12, Color("e5d6ba"))

func _draw_attributes_panel() -> void:
	var font: Font = ThemeDB.fallback_font
	var panel: Rect2 = Rect2(265, 90, 430, 435)
	draw_rect(panel, Color("13252d", 0.98))
	draw_rect(panel, Color("d8ae6c"), false, 2.0)
	draw_string(font, Vector2(284, 123), "ATRIBUTOS DO CAMPEAO", HORIZONTAL_ALIGNMENT_LEFT, 395, 19, Color("f2d69c"))
	var remaining: int = int(profile.get("attribute_points", 0))
	draw_string(font, Vector2(284, 148), "Pontos disponiveis: %d" % remaining, HORIZONTAL_ALIGNMENT_LEFT, 380, 15, Color("a8ebc0"))
	var attrs: Dictionary = profile.get("attributes", {})
	var keys: Array[String] = ["forca", "vitalidade", "destreza", "inteligencia", "agilidade"]
	var labels: Array[String] = ["FORCA", "VITALIDADE", "DESTREZA", "INTELIGENCIA", "AGILIDADE"]
	var descriptions: Array[String] = ["Guerreiro: ATQ + 10% protecao", "+3 HP por ponto; +1 DEF a cada 2", "Arqueiro: ATQ + critico", "Mago: ATQ + 2 MP por ataque", "+1% esquiva / 5 pontos (max 20%)"]
	for i in range(5):
		var y: float = 167.0 + float(i) * 58.0
		draw_rect(Rect2(280, y, 399, 48), Color("243b41"))
		draw_string(font, Vector2(292, y + 20), "%s: %d" % [labels[i], int(attrs.get(keys[i], 5))], HORIZONTAL_ALIGNMENT_LEFT, 225, 15, Color("f0e0b9"))
		draw_string(font, Vector2(292, y + 37), descriptions[i], HORIZONTAL_ALIGNMENT_LEFT, 320, 11, Color("abc7c7"))
		draw_rect(Rect2(640, y, 38, 32), Color("426c58") if remaining > 0 else Color("3b454b"))
		draw_string(font, Vector2(650, y + 23), "+", HORIZONTAL_ALIGNMENT_LEFT, 25, 22, Color.WHITE)
	draw_string(font, Vector2(284, 501), "O / ESC: fechar | + distribui 1 ponto.", HORIZONTAL_ALIGNMENT_LEFT, 395, 12, Color("e5d6ba"))

func _draw_classes_panel() -> void:
	var font: Font = ThemeDB.fallback_font
	var area: Rect2 = Rect2(265, 95, 430, 285)
	draw_rect(area, Color("13252d", 0.97))
	draw_rect(area, Color("d8ae6c"), false, 2.0)
	draw_string(font, Vector2(284, 126), "CLASSES DE COMBATE", HORIZONTAL_ALIGNMENT_LEFT, 380, 20, Color("f2d69c"))
	draw_string(font, Vector2(284, 155), "Classe atual: " + str(profile.get("combat_class", "Guerreiro")), HORIZONTAL_ALIGNMENT_LEFT, 380, 15, Color("b8e5c6"))
	var mastery: Dictionary = profile.get("skill_mastery", {})
	var current_class: String = str(profile.get("combat_class", "Guerreiro"))
	var class_hits: int = int(mastery.get(current_class, 0))
	var arcane_hits: int = int(mastery.get("Arcano", 0))
	draw_string(font, Vector2(284, 176), "Maestria classe: Nv.%d (%d/8) | Arcano: Nv.%d (%d/8)" % [mini(5, int(class_hits / 8)), class_hits % 8 if class_hits < 40 else 8, mini(5, int(arcane_hits / 8)), arcane_hits % 8 if arcane_hits < 40 else 8], HORIZONTAL_ALIGNMENT_LEFT, 395, 12, Color("b5d8bd"))
	draw_string(font, Vector2(284, 200), "GUERREIRO    +8 ATQ / +7 DEF | Arcano 165%", HORIZONTAL_ALIGNMENT_LEFT, 390, 14, Color("ffdcaa"))
	draw_string(font, Vector2(284, 238), "MAGO             +3 ATQ / +1 DEF | Arcano 210%", HORIZONTAL_ALIGNMENT_LEFT, 390, 14, Color("cbaaff"))
	draw_string(font, Vector2(284, 276), "ARQUEIRO       +6 ATQ / +3 DEF | Arcano 185%", HORIZONTAL_ALIGNMENT_LEFT, 390, 14, Color("a7e5c6"))
	draw_string(font, Vector2(284, 328), "C / ESC: fechar | Classe definitiva", HORIZONTAL_ALIGNMENT_LEFT, 395, 13, Color("e5d6ba"))
	draw_string(font, Vector2(284, 354), "A classe foi escolhida ao criar o personagem." , HORIZONTAL_ALIGNMENT_LEFT, 395, 12, Color("c1d2d3"))

func _draw_hud() -> void:
	var font := ThemeDB.fallback_font
	draw_rect(Rect2(0, 0, 960, 45), Color("172329", 0.96))
	draw_line(Vector2(0, 44), Vector2(960, 44), Color("c69a5c"), 2)
	draw_string(font, Vector2(16, 29), "CRONICAS DO TRONO FRAGMENTADO   |   VALEDOURO - REINOS EM ASCENSAO", HORIZONTAL_ALIGNMENT_LEFT, 928, 17, Color("f1d5a0"))
	# Painel fixo: indicadores, atalhos e mensagens ocupam linhas independentes.
	# O mundo continua clicavel apenas acima de y=538; nao alterar limites de input.
	draw_rect(Rect2(0, 538, 960, 102), Color("172329", 0.98))
	draw_line(Vector2(0, 538), Vector2(960, 538), Color("c69a5c"), 2)
	var hp: float = float(profile.get("hp", 0))
	var max_hp: float = maxf(1.0, float(profile.get("max_hp", 1)))
	var xp: float = float(profile.get("xp", 0))
	var xp_next: float = maxf(1.0, float(profile.get("xp_next", 100)))
	var mana: float = float(profile.get("mana", 100))
	var max_mana: float = maxf(1.0, float(profile.get("max_mana", 100)))
	_bar(Rect2(15, 547, 220, 15), hp / max_hp, Color("bb4d53"), "VIDA %d / %d" % [int(hp), int(max_hp)])
	_bar(Rect2(15, 567, 220, 15), mana / max_mana, Color("9663d4"), "MANA %d / %d" % [int(mana), int(max_mana)])
	_bar(Rect2(15, 587, 220, 13), xp / xp_next, Color("679cce"), "XP %d / %d" % [int(xp), int(xp_next)])
	draw_string(font, Vector2(252, 558), "NIVEL %s   %s   OURO %s   LOBOS %s/3" % [str(profile.get("level", 1)), str(profile.get("combat_class", "Guerreiro")), str(profile.get("gold", 0)), str(profile.get("kills", 0))], HORIZONTAL_ALIGNMENT_LEFT, 476, 14, Color("e9d49f"))
	draw_string(font, Vector2(252, 577), "WASD mover | Clique atacar | 1 Arcano | 2 Classe | H Vida | J Mana | K Cripta", HORIZONTAL_ALIGNMENT_LEFT, 688, 11, Color("d6e2dc"))
	draw_string(font, Vector2(252, 594), "T Auto | C Classes | L Talentos | B Armazem | E Falar | I Mochila | M Loja | Q Missoes | P Profissoes", HORIZONTAL_ALIGNMENT_LEFT, 688, 11, Color("d6e2dc"))
	if auto_combat:
		draw_string(font, Vector2(760, 558), "AUTO: ON", HORIZONTAL_ALIGNMENT_LEFT, 180, 12, Color("ffbd70"))
	# Separador impede que o texto verde invada a barra de XP.
	draw_line(Vector2(15, 604), Vector2(945, 604), Color("53616b", 0.85), 1)
	var connected: bool = socket.get_ready_state() == WebSocketPeer.STATE_OPEN
	var status_text: String = ("ONLINE" if connected else "SEM SERVIDOR") + "  |  " + notice
	draw_string(font, Vector2(15, 619), status_text, HORIZONTAL_ALIGNMENT_LEFT, 930, 12, Color("9fdeb6") if connected else Color("e3a0a0"))
	draw_string(font, Vector2(15, 635), npc_message, HORIZONTAL_ALIGNMENT_LEFT, 930, 12, Color("f4e8cf"))

func _bar(rect: Rect2, value: float, color: Color, title: String) -> void:
	draw_rect(rect,Color("394247"))
	draw_rect(Rect2(rect.position,Vector2(rect.size.x*clampf(value,0.0,1.0),rect.size.y)),color)
	draw_rect(rect,Color("d5bc85"),false,1)
	draw_string(ThemeDB.fallback_font,rect.position + Vector2(5,rect.size.y-3),title,HORIZONTAL_ALIGNMENT_LEFT,-1,10,Color.WHITE)

func _sprite_direction(facing: String) -> int:
	match facing:
		"up": return 1
		"left": return 2
		"right": return 3
		_: return 0

func _draw_sprite(texture: Texture2D, pos: Vector2, direction: int, walking: bool, actor_key: String = "", sprite_scale: float = 1.0) -> void:
	var state: Dictionary = actor_motion.get(actor_key, {})
	var anim_clock: float = float(state.get("clock", animation_time))
	var frame := (1 + int(anim_clock * ACTOR_ANIM_SPEED) % 3) if walking else 0
	var source := Rect2(frame * SPRITE_W, direction * SPRITE_H, SPRITE_W, SPRITE_H)
	var bob := 1.5 * sin(anim_clock * 17.0) if walking else 0.0
	var size := Vector2(72, 84) * sprite_scale
	var target := Rect2(pos + Vector2(-size.x / 2.0, -size.y + 15.0 + bob), size)
	draw_texture_rect_region(texture, target, source)
	var hurt_alpha := clampf(float(actor_hurt.get(actor_key, 0.0)) / 0.24, 0.0, 1.0)
	if hurt_alpha > 0.0:
		draw_rect(Rect2(pos + Vector2(-25, -62), Vector2(50, 56)), Color(1.0, 0.28, 0.18, 0.18 * hurt_alpha))

func _draw_bank_keeper() -> void:
	var pos: Vector2 = BANK_KEEPER
	draw_ellipse_shadow(pos, 13.0)
	# The dedicated NPC sprite is a complete character; no geometric
	# armor rectangles are drawn over the face or torso.
	_draw_visual_actor(visual_npc_ferreiro_detail, pos, 54.0, 70.0)
	draw_circle(pos + Vector2(0, -77), 10.0, Color("284d68", 0.90))
	draw_string(ThemeDB.fallback_font, pos + Vector2(-5, -72), "B", HORIZONTAL_ALIGNMENT_LEFT, -1, 13, Color("f6d585"))

func _draw_blacksmith() -> void:
	var pos := BLACKSMITH
	draw_ellipse_shadow(pos, 13.0)
	_draw_visual_actor(visual_npc_ferreiro_detail, pos, 59.0, 75.0)
	# Avental de couro e martelo para distinguir o ferreiro de Tessa.
	draw_colored_polygon(PackedVector2Array([
		pos + Vector2(-12, -37), pos + Vector2(12, -37),
		pos + Vector2(16, -11), pos + Vector2(-16, -11)
	]), Color("785039"))
	draw_line(pos + Vector2(23, -26), pos + Vector2(23, -51), Color("9b6b43"), 4.0)
	draw_rect(Rect2(pos + Vector2(12, -54), Vector2(23, 9)), Color("abb4b8"))
	draw_string(ThemeDB.fallback_font, pos + Vector2(-55, -76), "Ferreiro", HORIZONTAL_ALIGNMENT_CENTER, 110, 13, Color("ffe0a4"))


# Ataques basicos: efeitos apenas visuais; dano e alcance continuam no servidor.
# Ataques básicos orientados ao alvo, sem alterar dano ou colisão no servidor.
func _draw_basic_attack_fx(pos: Vector2, intensity: float) -> void:
	var combat_class: String = str(profile.get("combat_class", "Guerreiro"))
	var center: Vector2 = pos + Vector2(0.0, -27.0)
	var direction: Vector2 = basic_attack_direction
	if direction.length_squared() < 0.01:
		direction = Vector2.RIGHT
	var angle: float = direction.angle()
	if combat_class == "Mago":
		var orb: Vector2 = center + direction * 25.0
		var arcane: Color = Color(0.69, 0.43, 1.0, intensity)
		draw_circle(orb, 10.0 + (1.0 - intensity) * 7.0, Color(0.52, 0.26, 0.96, intensity * 0.23))
		draw_circle(orb, 5.0, arcane)
		for i in range(4):
			var a: float = float(i) * TAU / 4.0 + animation_time * 8.0
			draw_circle(orb + Vector2(cos(a), sin(a)) * 13.0, 2.0, arcane)
	elif combat_class == "Arqueiro":
		var bow_center: Vector2 = center + direction * 14.0
		var bow_side: Vector2 = direction.rotated(PI / 2.0)
		var bow_top: Vector2 = bow_center + bow_side * 19.0
		var bow_bottom: Vector2 = bow_center - bow_side * 19.0
		var bow_front: Vector2 = bow_center + direction * 10.0
		draw_line(bow_top, bow_front, Color(0.74, 0.52, 0.28, intensity), 3.0)
		draw_line(bow_front, bow_bottom, Color(0.74, 0.52, 0.28, intensity), 3.0)
		draw_line(bow_top, bow_bottom, Color(0.95, 0.92, 0.78, intensity), 1.5)
		draw_line(center, center + direction * 46.0, Color(0.64, 0.98, 0.72, intensity), 2.5)
	else:
		var swing: float = 1.0 - intensity
		var from_angle: float = angle - 1.15
		var to_angle: float = from_angle + 2.35 * swing
		var slash_center: Vector2 = center + direction * 18.0
		draw_arc(slash_center, 34.0, from_angle, to_angle, 26, Color(1.0, 0.87, 0.48, intensity), 5.0)
		draw_arc(slash_center, 40.0, from_angle, to_angle, 26, Color(1.0, 0.97, 0.72, intensity * 0.6), 2.0)

# Efeito visual direcional de ataques basicos confirmados pelo servidor.
func _draw_basic_projectiles() -> void:
	for projectile in basic_projectiles:
		var start: Vector2 = projectile["from"]
		var target: Vector2 = projectile["to"]
		var progress: float = clampf(float(projectile["elapsed"]) / maxf(0.01, float(projectile["duration"])), 0.0, 1.0)
		var direction: Vector2 = (target - start).normalized()
		if direction.length_squared() < 0.01:
			direction = Vector2.RIGHT
		var tip: Vector2 = start.lerp(target, progress)
		var fade: float = clampf((1.0 - progress) * 3.0, 0.0, 1.0)
		if str(projectile["class"]) == "Mago":
			draw_line(tip - direction * 22.0, tip, Color(0.66, 0.38, 1.0, fade * 0.6), 6.0)
			draw_circle(tip, 10.0, Color(0.57, 0.24, 1.0, fade * 0.25))
			draw_circle(tip, 5.0, Color(0.84, 0.67, 1.0, fade))
		else:
			var tail: Vector2 = tip - direction * 25.0
			draw_line(tail, tip, Color(0.77, 0.98, 0.67, fade), 3.0)
			draw_line(tail, tail + direction.rotated(0.6) * 10.0, Color(0.43, 0.81, 0.49, fade), 2.0)
			draw_line(tail, tail + direction.rotated(-0.6) * 10.0, Color(0.43, 0.81, 0.49, fade), 2.0)
			draw_line(tip, tip - direction.rotated(0.7) * 10.0, Color(0.94, 0.96, 0.71, fade), 2.0)
			draw_line(tip, tip - direction.rotated(-0.7) * 10.0, Color(0.94, 0.96, 0.71, fade), 2.0)

# Impactos por classe; os números de dano continuam vindos do servidor.
func _draw_basic_impacts() -> void:
	for impact in basic_impacts:
		var at: Vector2 = impact["pos"]
		var progress: float = clampf(float(impact["elapsed"]) / maxf(0.01, float(impact["duration"])), 0.0, 1.0)
		var alpha: float = 1.0 - progress
		var radius: float = 6.0 + progress * 22.0
		match str(impact["class"]):
			"Mago":
				draw_arc(at, radius, 0.0, TAU, 28, Color(0.75, 0.45, 1.0, alpha), 3.0)
				for i in range(6):
					var a: float = TAU * float(i) / 6.0 + progress
					draw_circle(at + Vector2(cos(a), sin(a)) * radius, 2.5, Color(0.90, 0.72, 1.0, alpha))
			"Arqueiro":
				for i in range(4):
					var a: float = TAU * float(i) / 4.0 + PI / 4.0
					var ray: Vector2 = Vector2(cos(a), sin(a))
					draw_line(at + ray * 4.0, at + ray * radius, Color(0.64, 0.98, 0.72, alpha), 2.5)
			_:
				draw_arc(at, radius, -2.5, 0.5, 20, Color(1.0, 0.82, 0.42, alpha), 4.0)
				draw_line(at + Vector2(-radius * 0.5, -radius * 0.5), at + Vector2(radius * 0.5, radius * 0.5), Color(1.0, 0.95, 0.73, alpha), 2.0)

# Desenha um frame do atlas 8x4 sem alterar o estado do servidor.
# A animacao de ataque e temporizada pelos eventos de combate existentes.
func _draw_character_atlas(kind: String, pos: Vector2, facing: String, moving: bool, attack_left: float, width: float, height: float) -> bool:
	if not character_animation_atlases.has(kind):
		return false
	var atlas: Dictionary = character_animation_atlases[kind]
	var attacking: bool = attack_left > 0.0
	var texture: Texture2D = atlas["attack"] if attacking else atlas["move"]
	var direction: int = 0
	match facing:
		"up": direction = 1
		"left": direction = 2
		"right": direction = 3
	var frame: int = 0
	if attacking:
		frame = clampi(int((1.0 - attack_left / 0.42) * 8.0), 0, 7)
	elif moving:
		frame = int(animation_time * 8.0) % 8
	# Os sprites do Sino Partido usam 8x4 células de 128x140; outros atlases, 160x160.
	var cell_width: float = float(texture.get_width()) / 8.0 if kind == "guardiao_sino_partido" else 160.0
	var cell_height: float = float(texture.get_height()) / 4.0 if kind == "guardiao_sino_partido" else 160.0
	var source := Rect2(frame * cell_width, direction * cell_height, cell_width, cell_height)
	var destination := Rect2(pos + Vector2(-width * 0.5, -height), Vector2(width, height))
	draw_texture_rect_region(texture, destination, source)
	return true

func _draw_character(pos: Vector2, facing: String, walking: bool, label: String, npc: bool) -> void:
	draw_ellipse_shadow(pos, 13.0)
	var actor_key := "npc:tessa" if npc else ("p:" + player_id if label == "Tu" else "")
	var motion: Dictionary = actor_motion.get(actor_key, {})
	var effective_facing := str(motion.get("facing", facing))
	var moving := bool(motion.get("moving", walking))
	var equipped_weapon := str(profile.get("equipment", {}).get("weapon", ""))
	var equipment_now: Dictionary = profile.get("equipment", {})
	var has_weapon: bool = str(equipment_now.get("weapon", "")) != ""
	var has_armor: bool = str(equipment_now.get("armor", "")) != ""
	# The detailed class atlases already include weapon and robes. Never use
	# them for an empty slot: otherwise unequipping cannot change appearance.
	var use_full_class_atlas: bool = false
	var character_sprite: Texture2D = tessa_sprite if npc else (class_hero_sprites.get(str(profile.get("combat_class", "Guerreiro")), hero_unarmed_sprite) if use_full_class_atlas else hero_unarmed_sprite)
	var class_kind: String = str(profile.get("combat_class", "Guerreiro")).to_lower()
	var drew_new_atlas: bool = false
	if not npc and label == "Tu":
		if has_weapon:
			drew_new_atlas = _draw_character_atlas(class_kind, pos, effective_facing, moving, attack_anim_left, 62.0, 74.0)
	if not drew_new_atlas:
		_draw_sprite(character_sprite, pos, _sprite_direction(effective_facing), moving, actor_key)
	if not npc and label == "Tu":
		# Sprites de classe sao completos: armadura, armas e silhueta ja
		# fazem parte do atlas. Sobreposicoes antigas deformavam o corpo.
		# Preservamos apenas efeitos de encantamento e armas lendarias,
		# sem redesenhar o torso, os membros ou a armadura por cima.
		var equipment: Dictionary = profile.get("equipment", {})
		var bob: float = sin(animation_time * 14.0) * 2.0 if walking else 0.0
		if not drew_new_atlas:
			_draw_equipment_appearance(pos, equipment, bob)
			_draw_class_weapon_if_equipped(pos, equipment, bob)
		_draw_enchantment_fx(pos, bob)
		if has_weapon and str(profile.get("combat_class", "Guerreiro")) == "Guerreiro":
			_draw_legendary_weapon_fx(pos, bob, equipment)

	if npc:
		draw_circle(pos + Vector2(0,-65), 9, Color("e6c46b"))
		draw_string(ThemeDB.fallback_font,pos + Vector2(-3,-60),"!",HORIZONTAL_ALIGNMENT_LEFT,-1,14,Color("463821"))
	draw_string(ThemeDB.fallback_font,pos + Vector2(-35,-74),label,HORIZONTAL_ALIGNMENT_CENTER,70,13,Color.WHITE)


# Sobreposicoes desenhadas sobre o sprite do heroi, sem alterar os atributos do servidor.
# Efeitos apenas visuais, ligados aos encantamentos efetivamente equipados.
# Nao alteram o calculo de ataque/defesa do servidor.
func _draw_enchantment_fx(pos: Vector2, bob: float) -> void:
	var equipped: Dictionary = profile.get("gear_equipped", {})
	var phase: float = animation_time
	for slot in ["weapon", "offhand", "armor"]:
		var gear: Dictionary = equipped.get(slot, {})
		var enchant: String = str(gear.get("enchant", ""))
		if enchant == "":
			continue
		var color: Color = Color("ff8853") if enchant == "Furia" else Color("75c7ff") if enchant == "Protecao" else Color("c49aff")
		var center: Vector2 = pos + Vector2(18, -29 + bob) if slot == "weapon" else pos + Vector2(-19, -24 + bob) if slot == "offhand" else pos + Vector2(0, -29 + bob)
		var radius: float = 11.0 if slot == "weapon" else 14.0 if slot == "offhand" else 19.0
		var pulse: float = 0.55 + 0.45 * sin(phase * 3.1 + float(radius))
		var glow: Color = Color(color.r, color.g, color.b, 0.18 + pulse * 0.25)
		draw_arc(center, radius + pulse * 2.0, 0.0, TAU, 24, glow, 2.0)
		for spark in range(3):
			var angle: float = phase * (1.5 if enchant == "Furia" else -1.1) + float(spark) * TAU / 3.0
			var sparkle: Vector2 = center + Vector2(cos(angle), sin(angle)) * (radius + 4.0)
			draw_circle(sparkle, 1.5 + pulse, Color(color.r, color.g, color.b, 0.4 + pulse * 0.45))
		if enchant == "Runico":
			draw_arc(center, radius - 4.0, phase, phase + PI * 1.3, 16, Color("e6d5ff", 0.5), 1.5)

# MVP 0.8.4: identidade visual de armas especiais, sem efeitos de dano extra.
# A aura segue o heroi, muda de intensidade durante o ataque e desaparece ao desequipar.
func _draw_legendary_weapon_fx(pos: Vector2, bob: float, equipment: Dictionary) -> void:
	var weapon: String = str(equipment.get("weapon", ""))
	if weapon not in ["Lamina real de Valedouro", "Espada ancestral", "Espada de aco do Guardiao"]:
		return
	var is_royal: bool = weapon == "Lamina real de Valedouro"
	var is_ancient: bool = weapon == "Espada ancestral"
	var glow_color: Color = Color("ffd36a") if is_royal else Color("b88aff") if is_ancient else Color("7de7ff")
	var phase: float = animation_time * 3.4
	var attacking: bool = attack_anim_left > 0.0
	var intensity: float = 1.0 if attacking else 0.45 + 0.22 * sin(phase)
	var origin: Vector2 = pos + Vector2(18.0, -22.0 + bob)
	var tip: Vector2 = pos + Vector2(28.0, -43.0 + bob)
	if attacking:
		var swing: float = 1.0 - clampf(attack_anim_left / 0.30, 0.0, 1.0)
		var angle: float = -1.4 + swing * 2.6
		tip = pos + Vector2(18.0, -23.0) + Vector2(cos(angle), sin(angle)) * 38.0
	var aura_color: Color = Color(glow_color.r, glow_color.g, glow_color.b, 0.22 + intensity * 0.28)
	draw_line(origin, tip, aura_color, 11.0 if attacking else 8.0)
	draw_line(origin, tip, Color(glow_color.r, glow_color.g, glow_color.b, 0.55 + intensity * 0.35), 2.0)
	for i in range(4):
		var t: float = fposmod(animation_time * (0.6 + float(i) * 0.12) + float(i) * 0.27, 1.0)
		var point: Vector2 = origin.lerp(tip, t)
		point += Vector2(sin(phase + float(i) * 2.0), cos(phase * 0.8 + float(i))) * (2.0 + intensity * 3.0)
		draw_circle(point, 1.2 + intensity * 1.1, Color(glow_color.r, glow_color.g, glow_color.b, 0.35 + intensity * 0.45))
	if attacking:
		var swing_progress: float = 1.0 - clampf(attack_anim_left / 0.30, 0.0, 1.0)
		var slash_color: Color = Color(glow_color.r, glow_color.g, glow_color.b, (1.0 - swing_progress) * 0.85)
		draw_arc(pos + Vector2(18.0, -23.0), 40.0, -1.4, -1.4 + swing_progress * 2.6, 22, slash_color, 4.0)
		if is_royal:
			draw_arc(pos + Vector2(18.0, -23.0), 45.0, -1.4, -1.4 + swing_progress * 2.6, 22, slash_color, 1.5)

func _draw_class_weapon_if_equipped(pos: Vector2, equipment: Dictionary, bob: float) -> void:
	var weapon: String = str(equipment.get("weapon", ""))
	if weapon == "":
		return
	var hero_class: String = str(profile.get("combat_class", "Guerreiro"))
	if hero_class == "Arqueiro":
		var center: Vector2 = pos + Vector2(21, -28 + bob)
		draw_arc(center, 22.0, -PI * 0.65, PI * 0.65, 24, Color("bd8b4f"), 3.0)
		draw_line(center + Vector2(22.0 * cos(-PI * 0.65), 22.0 * sin(-PI * 0.65)), center + Vector2(22.0 * cos(PI * 0.65), 22.0 * sin(PI * 0.65)), Color("eee1b9"), 1.5)
	elif hero_class == "Mago":
		var base: Vector2 = pos + Vector2(19, -13 + bob)
		var tip: Vector2 = pos + Vector2(19, -63 + bob)
		draw_line(base, tip, Color("b8945d"), 4.0)
		draw_circle(tip, 6.0, Color("71c9ff"))
		draw_circle(tip + Vector2(-2, -2), 2.0, Color("e7f9ff"))


func _draw_equipment_appearance(pos: Vector2, equipment: Dictionary, bob: float) -> void:
	var weapon: String = str(equipment.get("weapon", ""))
	var shield: String = str(equipment.get("offhand", ""))
	var armor: String = str(equipment.get("armor", ""))
	var royal: bool = armor in ["Armadura de placas reais", "Armadura do trono"]
	var metal: bool = armor in ["Armadura de ferro", "Armadura de pedra", "Armadura do Sino Partido", "Colete do Sino Partido", "Manto do Sino Partido"] or royal
	if armor in ["Couraca da Guarda", "Colete do Batedor", "Manto do Eco", "Armadura do Bastião", "Colete da Sombra Verde", "Manto das Estrelas"]:
		var outfit_color: Color = Color("d8b67d") if armor == "Armadura do Bastião" else Color("377b68") if armor == "Colete da Sombra Verde" else Color("7864ca") if armor == "Manto das Estrelas" else Color("879fb5") if armor == "Couraca da Guarda" else Color("608e6e") if armor == "Colete do Batedor" else Color("7969ad")
		draw_colored_polygon(PackedVector2Array([pos+Vector2(-13,-37+bob),pos+Vector2(13,-37+bob),pos+Vector2(15,-17+bob),pos+Vector2(-15,-17+bob)]),outfit_color)
		draw_line(pos+Vector2(-10,-31+bob),pos+Vector2(10,-23+bob),Color("c3e9ff") if armor == "Manto do Eco" else Color("e3d49a"),2.0)
	if metal:
		var plate_color: Color = Color("477e9f") if armor == "Armadura do Sino Partido" else Color("778b9b") if armor == "Armadura de ferro" else Color("788078") if armor == "Armadura de pedra" else Color("a9aebb") if armor == "Armadura de placas reais" else Color("d5ad58")
		draw_colored_polygon(PackedVector2Array([pos + Vector2(-12,-37+bob),pos + Vector2(12,-37+bob),pos + Vector2(15,-18+bob),pos + Vector2(-15,-18+bob)]),plate_color)
		draw_line(pos + Vector2(0,-35+bob),pos + Vector2(0,-20+bob),plate_color.darkened(0.35),2.0)
		draw_rect(Rect2(pos + Vector2(-18,-36+bob),Vector2(6,10)),plate_color.lightened(0.2))
		draw_rect(Rect2(pos + Vector2(12,-36+bob),Vector2(6,10)),plate_color.lightened(0.2))
		if armor == "Armadura do Sino Partido":
			draw_line(pos + Vector2(-11,-34+bob), pos + Vector2(11,-21+bob), Color("91e8ff"), 2.0)
			draw_line(pos + Vector2(11,-34+bob), pos + Vector2(-11,-21+bob), Color("91e8ff"), 2.0)
			draw_circle(pos + Vector2(0,-27+bob), 4.0, Color("ffe3a0"))
		if royal:
			draw_circle(pos + Vector2(0,-30+bob),3.0,Color("f7d576"))
			draw_line(pos + Vector2(-12,-37+bob),pos + Vector2(12,-37+bob),Color("e8d9a5"),2.0)
	if shield != "" and str(profile.get("combat_class", "Guerreiro")) == "Guerreiro" and shield.begins_with("Escudo"):
		var shield_color: Color = Color("805839") if shield == "Escudo de madeira" else Color("777e88") if shield == "Escudo do saqueador" else Color("829aa8") if shield in ["Escudo de ferro","Escudo reforcado"] else Color("b0bec6") if shield == "Escudo reforcado de aco" else Color("568bad") if shield in ["Escudo do Sino Partido", "Aljava do Sino Partido", "Orbe do Sino Partido"] else Color("c8a251")
		var shield_size: float = 20.0 if shield == "Escudo da muralha" else 16.0
		var shield_center: Vector2 = pos + Vector2(-19,-13+bob)
		draw_colored_polygon(PackedVector2Array([shield_center+Vector2(-9,-shield_size),shield_center+Vector2(9,-shield_size),shield_center+Vector2(9,3),shield_center+Vector2(0,11),shield_center+Vector2(-9,3)]),shield_color)
		draw_line(shield_center+Vector2(0,-shield_size+3),shield_center+Vector2(0,7),Color("f0d28c"),2.0)
		if shield in ["Escudo reforcado de aco","Escudo da muralha","Escudo do Sino Partido"]:
			draw_arc(shield_center+Vector2(0,-4),7,0.0,TAU,12,Color("f3d47d"),1.5)
	if weapon != "" and weapon not in ["Lamina da Vigilia Runica", "Espada da Guarda de Valedouro"] and str(profile.get("combat_class", "Guerreiro")) == "Guerreiro":
		var tip: Vector2 = pos + Vector2(28,-43+bob)
		var grip: Vector2 = pos + Vector2(18,-18+bob)
		var blade_color: Color = Color("b3bdc7") if weapon in ["Espada de ferro","Lamina de presas"] else Color("d5e7f2") if weapon in ["Espada de cavaleiro","Espada de aco do Guardiao"] else Color("e6c66b") if weapon == "Lamina real de Valedouro" else Color("78d8f5") if weapon == "Lamina do Sino Partido" else Color("b8d5cc")
		var blade_width: float = 7.0 if weapon in ["Espada de aco do Guardiao","Lamina real de Valedouro","Espada ancestral","Lamina do Sino Partido","Lamina da Vigilia Runica"] else 4.0
		draw_line(grip,tip,blade_color,blade_width)
		draw_line(pos+Vector2(11,-24+bob),pos+Vector2(25,-19+bob),Color("e1b35c"),4.0)
		if weapon in ["Espada de aco do Guardiao","Lamina real de Valedouro","Espada ancestral","Lamina do Sino Partido","Lamina da Vigilia Runica"]:
			draw_circle(tip,3.0,Color("81dfff") if weapon == "Espada de aco do Guardiao" else Color("ffe08a"))

# Draw the rare blade even for Arqueiro/Mago, whose base weapon renderer
# normally omits swords. This is visual only and does not change class range.
# A arma rúnica mantém identidade própria em todas as classes.
# O efeito é estritamente visual: não altera o dano ou a distância de ataque.
func _draw_rune_blade_overlay(pos: Vector2, bob: float) -> void:
	var base: Vector2 = pos + Vector2(18.0, -17.0 + bob)
	var tip: Vector2 = pos + Vector2(30.0, -51.0 + bob)
	var phase: float = animation_time * 3.0
	var glow: float = 0.65 + 0.25 * sin(phase)
	draw_line(base, tip, Color(0.25, 0.8, 1.0, 0.25 + glow * 0.3), 10.0)
	draw_line(base, tip, Color("82dfff"), 5.0)
	draw_line(base + Vector2(-8, -6), base + Vector2(8, 0), Color("e5bb73"), 3.0)
	draw_circle(tip, 3.5, Color("d7f9ff"))
	draw_arc(base + Vector2(6, -19), 20.0, 0.0, TAU, 24, Color(0.3, 0.8, 1.0, 0.22 + glow * 0.2), 2.0)
	for spark in range(3):
		var angle: float = phase + float(spark) * TAU / 3.0
		var at: Vector2 = base + Vector2(6, -19) + Vector2(cos(angle), sin(angle)) * 18.0
		draw_circle(at, 1.6, Color("a8edff"))

func _draw_class_weapon_overlay(pos: Vector2, bob: float, weapon: String) -> void:
	var hand: Vector2 = pos + Vector2(19, -19+bob)
	if weapon in ["Lamina da Aurora de Valedouro", "Arco da Bruma Antiga", "Arco do Sino Partido", "Cajado do Firmamento", "Cajado do Sino Partido"]:
		draw_arc(hand+Vector2(6,-20), 25.0, 0.0, TAU, 24, Color("f8d48a",0.65) if weapon == "Lamina da Aurora de Valedouro" else Color("79f1c6",0.65) if weapon == "Arco da Bruma Antiga" else Color("a9a0ff",0.65), 2.5)
	if weapon in ["Espada da Guarda de Valedouro", "Lamina da Aurora de Valedouro"]:
		draw_line(hand, hand+Vector2(13,-36), Color("cde3ef"), 6.0)
		draw_line(hand+Vector2(-7,-7), hand+Vector2(8,-3), Color("f0ca75"), 4.0)
	elif weapon in ["Arco do Vigia Runico", "Arco da Bruma Antiga"]:
		draw_arc(hand+Vector2(6,-14), 21.0, -PI/2, PI/2, 20, Color("a0dfc1"), 4.0)
		draw_line(hand+Vector2(6,-35),hand+Vector2(6,7),Color("f1e3bb"),1.5)
		draw_circle(hand+Vector2(26,-14),3.0,Color("78e7ff"))
	else:
		draw_line(hand, hand+Vector2(8,-39), Color("9473bb"), 5.0)
		draw_circle(hand+Vector2(8,-42), 7.0, Color("78dcff"))
		draw_arc(hand+Vector2(8,-42), 11.0, 0, TAU, 24, Color("b7edff",0.7), 2.0)

func _draw_crypt_blade_overlay(pos: Vector2, bob: float) -> void:
	var start: Vector2 = pos + Vector2(17.0, -18.0 + bob)
	var tip: Vector2 = pos + Vector2(31.0, -49.0 + bob)
	draw_line(start, tip, Color("78d8f5"), 6.0)
	draw_line(start + Vector2(-8.0, -6.0), start + Vector2(8.0, 1.0), Color("e9c878"), 3.0)
	draw_circle(tip, 3.5, Color("e0faff"))
	draw_arc(start + Vector2(7.0, -18.0), 18.0, 0.0, TAU, 20, Color(0.35, 0.85, 1.0, 0.3), 1.5)

func _set_monsters(data: Array) -> void:
	monsters.clear()
	for m in data:
		monsters[str(m.get("id", ""))] = m

func _draw_visual_actor(texture: Texture2D, feet: Vector2, width: float, height: float, bounce: float = 0.0) -> void:
	# A single full-body sprite, never split into 96x112 animation cells.
	if texture == null:
		return
	var rect := Rect2(feet + Vector2(-width * 0.5, -height + bounce), Vector2(width, height))
	draw_texture_rect(texture, rect, false)

func _draw_monster(m: Dictionary) -> void:
	var pos := Vector2(float(m.get("x", 0)), float(m.get("y", 0)))
	var is_wolf := str(m.get("kind", "")) == "lobo"
	var is_storm_boss := str(m.get("kind", "")) == "guardiao_tempestade"
	var is_guardian := str(m.get("kind", "")) in ["guardiao", "guardiao_tempestade"]
	var is_rune_sentinel := str(m.get("kind", "")) == "sentinela_runica"
	draw_ellipse_shadow(pos, 18.0)
	# The server currently does not transmit monster facing/animation state.
	# Use a subtle idle cycle until monster movement data is expanded.
	var active_effects: Dictionary = m.get("effects", {})
	if active_effects.has("stun"):
		draw_arc(pos + Vector2(0, -48), 22.0, 0.0, TAU, 24, Color("ffdb76"), 3.0)
		for star in range(3):
			var star_angle: float = animation_time * 2.5 + TAU * float(star) / 3.0
			draw_circle(pos + Vector2(0, -48) + Vector2(cos(star_angle), sin(star_angle)) * 22.0, 3.0, Color("ffe9a6"))
	if active_effects.has("burn"):
		for flame in range(4):
			var flame_offset: float = sin(animation_time * 8.0 + float(flame)) * 5.0
			draw_circle(pos + Vector2(-14.0 + flame * 9.0, -15.0 - flame_offset), 4.0, Color("ff8746", 0.85))
	if active_effects.has("slow"):
		draw_arc(pos + Vector2(0, -20), 27.0, 0.0, TAU, 28, Color("83d7ff", 0.85), 3.0)
	var actor_key := "m:" + str(m.get("id", ""))
	var motion: Dictionary = actor_motion.get(actor_key, {})
	if is_guardian:
		draw_circle(pos + Vector2(0, -32), 45.0, Color(0.16, 0.70, 0.91, 0.24) if is_storm_boss else Color(0.55, 0.21, 0.64, 0.16))
		draw_arc(pos + Vector2(0, -32), 45.0, 0.0, TAU, 32, Color("65e6ff") if is_storm_boss else Color("dca5ef"), 2.0)
	var attack_left := float(monster_attack_anim.get(actor_key, 0.0))
	var attack_progress := 1.0 - attack_left / MONSTER_ATTACK_DURATION
	var attack_lunge := Vector2.ZERO
	if attack_left > 0.0:
		var facing := str(motion.get("facing", "down"))
		var attack_direction := Vector2(0, 1)
		if facing == "up":
			attack_direction = Vector2(0, -1)
		elif facing == "left":
			attack_direction = Vector2(-1, 0)
		elif facing == "right":
			attack_direction = Vector2(1, 0)
		attack_lunge = attack_direction * sin(attack_progress * PI) * (16.0 if is_guardian else 10.0)
	var visual_texture: Texture2D = visual_wolf_detail if is_wolf else (visual_boss_storm_detail if is_storm_boss else (visual_boss_bell_detail if is_guardian else visual_raider_detail))
	var visual_width := 105.0 if is_guardian else (65.0 if is_wolf else 57.0)
	var visual_height := 111.0 if is_guardian else (53.0 if is_wolf else 77.0)
	var is_moving: bool = bool(motion.get("moving", false))
	var visual_bob := sin(animation_time * 7.0) * 1.3 if is_moving else 0.0
	var walk_texture: Texture2D = visual_wolf_real if is_wolf else (visual_boss_storm_walk if is_storm_boss else (visual_raider_shaman_real if is_guardian else (visual_raider_hooded_real if is_rune_sentinel else visual_raider_fighter_real)))
	var total_frames: int = 10 if is_wolf else (4 if is_storm_boss else 15)
	var frame_index: int = 0
	if is_moving:
		frame_index = (1 + int(animation_time * 7.0)) % (7 if is_wolf else (4 if is_storm_boss else 6))
	if attack_left > 0.0:
		frame_index = (3 + int(attack_progress * 4.0)) % 10 if is_wolf else (7 + int(attack_progress * 7.0)) % total_frames
	var frame_width: float = float(walk_texture.get_width()) / float(total_frames)
	var frame_height: float = float(walk_texture.get_height())
	var target_rect := Rect2(pos + attack_lunge + Vector2(-visual_width * 0.5, -visual_height + visual_bob), Vector2(visual_width, visual_height))
	var monster_kind: String = "lobo" if is_wolf else ("guardiao_tempestade" if is_storm_boss else ("sentinela_runica" if is_rune_sentinel else "saqueador"))
	var drew_new_monster: bool = false
	# Guardiao do Sino Partido: reutiliza o boss e os eventos de ataque existentes.
	if is_guardian and not is_storm_boss:
		monster_kind = "guardiao_sino_partido"
	drew_new_monster = _draw_character_atlas(monster_kind, pos + attack_lunge, str(motion.get("facing", "down")), is_moving, attack_left, visual_width, visual_height)
	if not drew_new_monster:
		draw_texture_rect_region(walk_texture, target_rect, Rect2(float(frame_index) * frame_width, 0, frame_width, frame_height))
	if is_rune_sentinel:
		draw_arc(pos + Vector2(0, -30) + attack_lunge, 27.0, 0.0, TAU, 28, Color("65d8ff"), 2.0)

	if attack_left > 0.0:
		var effect_center := pos + Vector2(0, -29) + attack_lunge
		var effect_radius := 36.0 if is_guardian else 22.0
		var effect_color := Color("d6a2f7") if is_guardian else (Color("ffcc85") if is_wolf else Color("f3a58d"))
		draw_arc(effect_center, effect_radius, -1.1 + attack_progress * 1.5, 0.8 + attack_progress * 1.5, 14, effect_color, 3.0)
		draw_line(effect_center + Vector2(-effect_radius * 0.45, -7), effect_center + Vector2(effect_radius * 0.5, 7), effect_color, 2.0)
	# The boss artwork includes its own weapon; avoid double-drawing a staff.
	var bar_width := 90.0 if is_guardian else (64.0 if is_rune_sentinel else 40.0)
	var bar_y := -100.0 if is_guardian else (-79.0 if is_rune_sentinel else -65.0)
	draw_rect(Rect2(pos + Vector2(-bar_width / 2.0, bar_y), Vector2(bar_width, 6)), Color("4b1c1c"))
	draw_rect(Rect2(pos + Vector2(-bar_width / 2.0, bar_y), Vector2(bar_width * float(m.get("hp",0)) / maxf(1.0,float(m.get("max_hp",1))), 6)), (Color("4bdcff") if is_storm_boss else Color("b47bda")) if is_guardian else Color("70d47b"))
	if is_storm_boss:
		draw_string(ThemeDB.fallback_font, pos + Vector2(-95, bar_y - 10), "GUARDIAO DA TEMPESTADE", HORIZONTAL_ALIGNMENT_CENTER, 190, 13, Color("a1f0ff"))
	if not is_guardian:
		draw_string(ThemeDB.fallback_font, pos + Vector2(-60 if is_rune_sentinel else -33, bar_y - 7), "Lobo" if is_wolf else ("Sentinela Runica" if is_rune_sentinel else "Saqueador"), HORIZONTAL_ALIGNMENT_CENTER, 120 if is_rune_sentinel else 66, 12, Color.WHITE)

# MVP 1.0.2: primeira instancia narrativa, com encontros validados pelo servidor.
# MVP 1.0.3: mapa tatico exploravel, movimento por grelha e colisoes no servidor.
func _crypt_find_path(start: Vector2i, goal: Vector2i) -> Array[Vector2i]:
	var result: Array[Vector2i] = []
	var obstacles := [Vector2i(4, 1), Vector2i(4, 3), Vector2i(7, 1), Vector2i(7, 3)]
	if goal.x < 0 or goal.x >= 10 or goal.y < 0 or goal.y >= 5 or goal in obstacles or goal == dungeon_enemy_pos:
		return result
	var queue: Array[Vector2i] = [start]
	var previous := {start: start}
	var directions := [Vector2i(1, 0), Vector2i(-1, 0), Vector2i(0, 1), Vector2i(0, -1)]
	while not queue.is_empty():
		var current: Vector2i = queue.pop_front()
		if current == goal:
			break
		for direction in directions:
			var next_cell: Vector2i = current + direction
			if next_cell.x >= 0 and next_cell.x < 10 and next_cell.y >= 0 and next_cell.y < 5 and next_cell not in obstacles and next_cell != dungeon_enemy_pos and not previous.has(next_cell):
				previous[next_cell] = current
				queue.append(next_cell)
	if not previous.has(goal):
		return result
	var cursor: Vector2i = goal
	while cursor != start:
		result.push_front(cursor)
		cursor = previous[cursor]
	return result


# BFS: shortest reachable path to any free tile within the class attack radius.
func _crypt_find_attack_route(start: Vector2i, enemy: Vector2i, attack_range: int) -> Array[Vector2i]:
	var result: Array[Vector2i] = []
	var blocked := [Vector2i(4, 1), Vector2i(4, 3), Vector2i(7, 1), Vector2i(7, 3)]
	var queue: Array[Vector2i] = [start]
	var previous := {start: start}
	var directions := [Vector2i(1, 0), Vector2i(-1, 0), Vector2i(0, 1), Vector2i(0, -1)]
	var destination := Vector2i(-1, -1)
	while not queue.is_empty():
		var current: Vector2i = queue.pop_front()
		var distance := absi(current.x - enemy.x) + absi(current.y - enemy.y)
		if distance > 0 and distance <= attack_range:
			destination = current
			break
		for direction in directions:
			var candidate: Vector2i = current + direction
			if candidate.x < 0 or candidate.x >= 10 or candidate.y < 0 or candidate.y >= 5:
				continue
			if candidate in blocked or candidate == enemy or previous.has(candidate):
				continue
			previous[candidate] = current
			queue.append(candidate)
	if destination.x < 0:
		return result
	var cursor := destination
	while cursor != start:
		result.push_front(cursor)
		cursor = previous[cursor]
	return result


func _draw_crypt_shadow(center: Vector2, radius_x: float, radius_y: float, tint: Color) -> void:
	var points := PackedVector2Array()
	for i in range(20):
		var angle := float(i) * TAU / 20.0
		points.append(center + Vector2(cos(angle) * radius_x, sin(angle) * radius_y))
	draw_colored_polygon(points, tint)


func _draw_crypt_dungeon() -> void:
	var panel := Rect2(100, 62, 760, 510)
	draw_rect(panel, Color("10151e", 0.99))
	draw_rect(panel, Color("b79b64"), false, 3.0)
	var font := ThemeDB.fallback_font
	var rooms := ["Vestibulo dos Ossos", "Galeria das Sentinelas", "Sala do Eco", "Guardiao do Sino"]
	var stage := clampi(dungeon_stage, 0, 3)
	draw_string(font, Vector2(125, 96), "CRIPTA DO SINO PARTIDO", HORIZONTAL_ALIGNMENT_LEFT, 700, 23, Color("f1d9a4"))
	draw_string(font, Vector2(125, 124), "Sala %d/4 - %s" % [stage+1, rooms[stage]], HORIZONTAL_ALIGNMENT_LEFT, 700, 16, Color("c9e4e2"))
	var cell_size := 48.0
	var origin := Vector2(195, 151)
	var blocks := [Vector2i(4,1), Vector2i(4,3), Vector2i(7,1), Vector2i(7,3)]
	# Highlight attackable cells without changing server-side combat rules.
	var crypt_class_name := str(profile.get("combat_class", "Guerreiro"))
	var visible_range := 1 if crypt_class_name == "Guerreiro" else (3 if crypt_class_name == "Arqueiro" else 2)
	# Crypt masonry: individual stone slabs, pillars, torchlight and visible actors.
	var torch_positions := [Vector2(172, 172), Vector2(696, 172), Vector2(172, 358), Vector2(696, 358)]
	for yy in range(5):
		for xx in range(10):
			var cell := Vector2i(xx, yy)
			var r := Rect2(origin + Vector2(xx, yy) * cell_size, Vector2(cell_size - 2, cell_size - 2))
			var floor_color := Color("343b42") if (xx + yy) % 2 == 0 else Color("3b454c")
			draw_rect(r, floor_color)
			draw_rect(r.grow(-3), Color("52606a", 0.5), false, 1.0)
			if (xx * 3 + yy * 7 + stage) % 9 == 0:
				draw_line(r.position + Vector2(12, 12), r.position + Vector2(20, 18), Color("242c33", 0.75), 1.5)
			if cell in blocks:
				draw_rect(r.grow(-4), Color("24282c"))
				draw_rect(r.grow(-9), Color("7b746b"))
				draw_rect(r.grow(-13), Color("a9a093"), false, 2.0)
				draw_line(r.position + Vector2(11, 11), r.position + Vector2(34, 11), Color("d3c4a3", 0.6), 2.0)
			if dungeon_show_range and cell != dungeon_pos and cell not in blocks and absi(cell.x - dungeon_pos.x) + absi(cell.y - dungeon_pos.y) <= visible_range:
				draw_rect(r.grow(-7), Color(0.38, 0.67, 0.82, 0.24), false, 1.0)
			if cell in dungeon_auto_route:
				draw_rect(r.grow(-5), Color("e5b86a", 0.7), false, 2.0)
			if cell in dungeon_special_cells:
				var pulse: float = 0.24 + 0.16 * sin(animation_time * 14.0)
				draw_rect(r.grow(-3), Color(0.95, 0.18, 0.14, pulse), true)
				draw_rect(r.grow(-3), Color(1.0, 0.34, 0.25, 0.9), false, 2.5)
			if cell in dungeon_click_path:
				draw_rect(r.grow(-5), Color("91d3ac", 0.8), false, 2.0)
	for torch_position in torch_positions:
		var flame := 4.0 + sin(animation_time * 7.0 + torch_position.x) * 2.0
		draw_circle(torch_position, 16.0, Color(1.0, 0.55, 0.15, 0.10))
		draw_line(torch_position + Vector2(0, 5), torch_position + Vector2(0, 15), Color("886b45"), 4.0)
		draw_circle(torch_position + Vector2(0, -flame), 5.0, Color("ffc16c"))
		draw_circle(torch_position + Vector2(0, -flame - 2), 2.5, Color("fff0b1"))
	var hero_center := origin + (dungeon_hero_visual + Vector2(0.5, 0.5)) * cell_size
	var enemy_center := origin + (dungeon_enemy_visual + Vector2(0.5, 0.5)) * cell_size
	# Telegraph only an imminent melee attack. The server remains authoritative.
	var crypt_gap: int = absi(dungeon_pos.x - dungeon_enemy_pos.x) + absi(dungeon_pos.y - dungeon_enemy_pos.y)
	if dungeon_enemy_hp > 0 and crypt_gap == 1 and dungeon_enemy_attack_in <= 0.55:
		var warning_alpha: float = 0.35 + 0.25 * sin(animation_time * 18.0)
		draw_arc(enemy_center, 24.0, 0.0, TAU, 32, Color(1.0, 0.32, 0.24, warning_alpha + 0.4), 3.0)
		draw_line(enemy_center + Vector2(-8.0, -31.0), enemy_center + Vector2(8.0, -31.0), Color(1.0, 0.4, 0.27), 3.0)
	var boss_vector: Vector2 = dungeon_hero_visual - dungeon_enemy_visual
	if absf(boss_vector.x) > absf(boss_vector.y):
		dungeon_boss_facing = "right" if boss_vector.x > 0.0 else "left"
	elif absf(boss_vector.y) > 0.01:
		dungeon_boss_facing = "down" if boss_vector.y > 0.0 else "up"
	var hero_class := str(profile.get("combat_class", "Guerreiro"))
	# Usa exatamente o atlas da classe do herói utilizado no mapa exterior.
	# A posição da grelha é convertida para a âncora dos pés do personagem.
	_draw_crypt_shadow(hero_center + Vector2(0, 12), 14.0, 5.0, Color(0, 0, 0, 0.5))
	var hero_kind: String = hero_class.to_lower()
	var hero_moving: bool = dungeon_hero_visual.distance_to(Vector2(dungeon_pos)) > 0.06
	if not _draw_character_atlas(hero_kind, hero_center + Vector2(0, 19), dungeon_hero_facing, hero_moving, dungeon_attack_flash, 39.0, 48.0):
		# Fallback para classes sem atlas; evita personagem invisível.
		draw_texture_rect(hero_unarmed_sprite, Rect2(hero_center + Vector2(-19, -29), Vector2(38, 48)), false)
	_draw_crypt_shadow(enemy_center + Vector2(0, 12), 15.0, 5.0, Color(0, 0, 0, 0.5))
	if stage == 3:
		# Velkran é exclusivo da última sala; inimigos anteriores não mudam.
		var boss_attacking: bool = dungeon_enemy_attack_in > 0.0 and dungeon_enemy_attack_in < 0.42 and crypt_gap <= 2
		_draw_character_atlas("velkran", enemy_center + Vector2(0, 19), dungeon_boss_facing, not boss_attacking, dungeon_enemy_attack_in if boss_attacking else 0.0, 76.0, 83.0)
	else:
		# Soldados da cripta usam exatamente o atlas direcional do Saqueador.
		var crypt_attacking: bool = dungeon_enemy_attack_in > 0.0 and dungeon_enemy_attack_in < 0.42 and crypt_gap <= 2
		_draw_character_atlas("saqueador", enemy_center + Vector2(0, 19), dungeon_boss_facing, not crypt_attacking, dungeon_enemy_attack_in if crypt_attacking else 0.0, 42.0, 54.0)
	if dungeon_hit_flash > 0.0:
		draw_arc(enemy_center, 19.0 + (0.25 - dungeon_hit_flash) * 25.0, 0.0, TAU, 28, Color(1.0, 0.8, 0.35, dungeon_hit_flash * 3.0), 3.0)
	# Class-specific dungeon attack feedback, aligned with the target.
	if dungeon_attack_flash > 0.0:
		var progress := 1.0 - dungeon_attack_flash / 0.35
		var direction := enemy_center - hero_center
		var aim := direction.normalized() if direction.length_squared() > 1.0 else dungeon_facing
		var side := Vector2(-aim.y, aim.x)
		var opacity := clampf(dungeon_attack_flash / 0.35, 0.0, 1.0)
		if hero_class == "Guerreiro":
			var slash_center := enemy_center - aim * 14.0
			draw_line(slash_center - side * 17.0, slash_center + side * 17.0 + aim * 8.0, Color(1.0, 0.79, 0.32, opacity), 4.0)
			draw_arc(enemy_center, 13.0 + progress * 14.0, -0.9, 1.7, 16, Color(1.0, 0.65, 0.28, opacity), 3.0)
		elif hero_class == "Mago":
			var orb := hero_center.lerp(enemy_center, clampf(progress * 1.8, 0.0, 1.0))
			draw_circle(orb, 6.0 + 2.0 * sin(animation_time * 18.0), Color(0.73, 0.42, 1.0, opacity))
			draw_arc(enemy_center, 9.0 + progress * 22.0, 0.0, TAU, 28, Color(0.74, 0.48, 1.0, opacity), 2.5)
		else:
			var arrow_tip := hero_center.lerp(enemy_center, clampf(progress * 2.2, 0.0, 1.0))
			draw_line(arrow_tip - aim * 17.0, arrow_tip, Color(0.64, 0.95, 0.68, opacity), 3.0)
			draw_line(arrow_tip, arrow_tip - aim * 7.0 + side * 5.0, Color(0.96, 0.87, 0.55, opacity), 2.0)
			draw_line(arrow_tip, arrow_tip - aim * 7.0 - side * 5.0, Color(0.96, 0.87, 0.55, opacity), 2.0)
			draw_arc(enemy_center, 7.0 + progress * 14.0, 0.0, TAU, 18, Color(0.56, 0.93, 0.63, opacity), 2.0)
	var crypt_distance: int = absi(dungeon_pos.x - dungeon_enemy_pos.x) + absi(dungeon_pos.y - dungeon_enemy_pos.y)
	var crypt_class := str(profile.get("combat_class", "Guerreiro"))
	var crypt_range := 1 if crypt_class == "Guerreiro" else (3 if crypt_class == "Arqueiro" else 2)
	var in_attack_range: bool = crypt_distance <= crypt_range
	var range_text: String = "ALCANCE OK - [1] ATACAR" if in_attack_range else "FORA DE ALCANCE - aproxima-te (distancia %d; max. %d)" % [crypt_distance, crypt_range]
	draw_string(font, Vector2(125, 393), range_text, HORIZONTAL_ALIGNMENT_LEFT, 720, 16, Color("a6f4b5") if in_attack_range else Color("ffc18d"))
	var enemy_max: int = [90, 140, 190, 260][stage]
	var bar := Rect2(270, 416, 400, 14)
	draw_rect(bar, Color("382a33"))
	draw_rect(Rect2(bar.position, Vector2(bar.size.x*clampf(float(dungeon_enemy_hp)/float(enemy_max),0.0,1.0),bar.size.y)),Color("c75b60"))
	draw_rect(bar, Color("e4c7a2"),false,1.0)
	var enemy_title: String = "%s: %d/%d HP" % [dungeon_enemy_name, dungeon_enemy_hp, enemy_max]
	if dungeon_stage == 3 and dungeon_boss_phase > 0:
		enemy_title += "  |  FASE %d/3" % dungeon_boss_phase
	draw_string(font, Vector2(270, 410), enemy_title, HORIZONTAL_ALIGNMENT_LEFT, 450, 15, Color("ffb1a3"))
	draw_string(font, Vector2(125, 471), "WASD / CLIQUE MOVER   [1] ATACAR   [T] AUTO: %s   [2] POCAO   [3] SAIR" % ("ON" if auto_combat else "OFF"), HORIZONTAL_ALIGNMENT_LEFT, 720, 15, Color("d5f0cb"))
	var crypt_help: String = "PERIGO! Sai das celulas vermelhas! %.1f s" % dungeon_special_in if not dungeon_special_cells.is_empty() else "Azul: alcance | Verde: clique | Dourado: AUTO (T) | WASD interrompe."
	draw_string(font, Vector2(125, 503), crypt_help, HORIZONTAL_ALIGNMENT_LEFT, 720, 13, Color("bac4c4"))
	draw_string(font, Vector2(125, 533), "Ao vencer, avancas automaticamente para a sala seguinte | [3] sair", HORIZONTAL_ALIGNMENT_LEFT, 720, 12, Color("bac4c4"))


# MVP 1.0.5.8: presentation-only victory panel; never awards inventory locally.
func _draw_crypt_victory() -> void:
	var font: Font = ThemeDB.fallback_font
	var panel: Rect2 = Rect2(178.0, 162.0, 604.0, 240.0)
	draw_rect(panel, Color(0.055, 0.075, 0.105, 0.97))
	draw_rect(panel, Color("d4b46d"), false, 3.0)
	draw_rect(Rect2(190.0, 174.0, 580.0, 216.0), Color("766039", 0.26), false, 1.0)
	draw_string(font, Vector2(247.0, 220.0), "CRIPTA DO SINO PARTIDO", HORIZONTAL_ALIGNMENT_LEFT, 490, 25, Color("f5d994"))
	draw_string(font, Vector2(330.0, 260.0), "VITORIA!", HORIZONTAL_ALIGNMENT_LEFT, 320, 30, Color("d2f3bc"))
	if crypt_victory_first:
		draw_string(font, Vector2(235.0, 303.0), "+700 XP    +600 OURO    +3 FRAGMENTOS ANTIGOS", HORIZONTAL_ALIGNMENT_LEFT, 540, 17, Color("f6e5bd"))
	else:
		draw_string(font, Vector2(257.0, 303.0), "+80 OURO   +60 XP   |   20% FRAGMENTO RARO", HORIZONTAL_ALIGNMENT_LEFT, 510, 17, Color("f6e5bd"))
		draw_string(font, Vector2(235.0, 330.0), "Premio unico nao se repete. Confere o aviso para ver o drop.", HORIZONTAL_ALIGNMENT_LEFT, 540, 15, Color("c5cbd0"))
	draw_string(font, Vector2(340.0, 367.0), "Regressa a Valedouro", HORIZONTAL_ALIGNMENT_LEFT, 330, 16, Color("b9c5cc"))
