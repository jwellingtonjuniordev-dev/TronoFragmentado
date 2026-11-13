"""MVP 0.3 - authoritative demo combat, quests and loot; in-memory, not production auth."""
import asyncio
import json
import math
import heapq
import random
import time
import uuid
import sqlite3
import os
from pathlib import Path
from contextlib import asynccontextmanager, suppress
from fastapi import FastAPI, WebSocket, WebSocketDisconnect

WIDTH, HEIGHT = 1920., 1280.
SPEED_PER_TICK, RADIUS = 14., 11.
OBSTACLES = [(115, 100, 155, 115), (620, 110, 190, 135), (100, 410, 180, 135), (685, 420, 170, 120)]
OBSTACLES += [(1110.0, 115.0, 155.0, 115.0), (1450.0, 125.0, 190.0, 135.0), (1100.0, 440.0, 180.0, 135.0), (1500.0, 430.0, 170.0, 120.0), (120.0, 825.0, 155.0, 115.0), (640.0, 825.0, 190.0, 135.0), (120.0, 1070.0, 180.0, 135.0), (685.0, 1070.0, 170.0, 120.0)]
# Shared scenery coordinates: tree center is the trunk's collision point.
TREE_TRUNKS = [(45., 103.), (315., 148.), (550., 88.), (885., 128.),
               (45., 493.), (350., 548.), (610., 538.), (925., 503.)]
TREE_TRUNKS += [(1020.0, 100.0), (1330.0, 110.0), (1720.0, 100.0), (1850.0, 450.0), (1040.0, 520.0), (1370.0, 565.0), (1710.0, 575.0), (40.0, 790.0), (340.0, 810.0), (580.0, 795.0), (905.0, 815.0), (45.0, 1190.0), (350.0, 1190.0), (620.0, 1210.0), (940.0, 1180.0), (1030.0, 810.0), (1370.0, 830.0), (1710.0, 820.0), (1850.0, 1190.0)]
TREE_TRUNKS += [(1070.0, 760.0), (1225.0, 860.0), (1435.0, 830.0), (1580.0, 835.0), (1790.0, 840.0), (1850.0, 810.0), (1100.0, 930.0), (1280.0, 910.0), (1480.0, 920.0), (1640.0, 895.0), (1810.0, 950.0), (1080.0, 1100.0), (1230.0, 1160.0), (1410.0, 1110.0), (1600.0, 1150.0), (1800.0, 1150.0)]
TREE_RADIUS = 13.
TESSA = (350., 300.)
BLACKSMITH = (550., 310.)
SMITH_STOCK = {'Espada de ferro', 'Escudo de ferro', 'Armadura de placas reais', 'Escudo reforcado de aco', 'Escudo de madeira', 'Lamina real de Valedouro', 'Espada de cavaleiro', 'Armadura de couro', 'Armadura do trono', 'Escudo da muralha', 'Armadura de ferro', 'Espada de aco do Guardiao'}
SPAWNS = [(570., 210., 'lobo'), (755., 270., 'lobo'), (590., 395., 'lobo'), (375., 460., 'lobo'), (820., 385., 'saqueador')]
SPAWNS += [(1220., 345., 'lobo'), (1620., 345., 'lobo'),
           (420., 925., 'lobo'), (900., 1060., 'saqueador'),
           (1380., 965., 'lobo'), (1770., 1030., 'saqueador')]
SPAWNS += [(1180., 850., 'lobo'), (1450., 860., 'lobo'), (1710., 1080., 'lobo'), (1520., 1190., 'saqueador')]
SPAWNS += [(1560., 1050., 'guardiao')]
# World resource geometry is shared and authoritative; harvested objects disappear
# entirely (visual and collision) for 40 seconds, then respawn at safe new sites.
CHEST_POSITIONS = [(1735.,1060.), (1170.,1010.), (1030.,665.)]
RESOURCE_WORLD = {}  # id -> {x,y,kind,ready_at,radius}
RESOURCE_VERSION = 0

def safe_resource(x, y, radius=22., exclude=None):
    if not (65+radius < x < WIDTH-65-radius and 85+radius < y < HEIGHT-65-radius): return False
    if any(rx-radius-28 < x < rx+rw+radius+28 and ry-radius-28 < y < ry+rh+radius+28 for rx,ry,rw,rh in OBSTACLES): return False
    if 1390-radius < x < 1700+radius and 950-radius < y < 1215+radius: return False
    if any(math.hypot(x-cx,y-cy)<radius+85 for cx,cy in CHEST_POSITIONS): return False
    if any(math.hypot(x-nx,y-ny)<radius+50 for nx,ny in (TESSA,BLACKSMITH)): return False
    # Keep main roads, forest gate and market stalls free.
    if (260-radius < y < 375+radius and x < 950) or (435-radius < x < 530+radius and y < 635): return False
    if any(math.hypot(x-bx,y-by)<radius+br+14 for bx,by,br in BARRELS): return False
    if any(rx-radius-12 < x < rx+rw+radius+12 and ry-radius-12 < y < ry+rh+radius+12 for rx,ry,rw,rh in FENCES): return False
    if any(math.hypot(x-p['x'], y-p['y']) < radius+35 for p in players.values()): return False
    if any(m['alive'] and math.hypot(x-m['x'], y-m['y']) < radius+35 for m in monsters.values()): return False
    for node_id, other in RESOURCE_WORLD.items():
        if node_id != exclude and other['ready_at'] <= time.time() and math.hypot(x-other['x'],y-other['y']) < radius+other['radius']+30: return False
    return True

def random_resource_position(radius=22., exclude=None, previous=None):
    for _ in range(900):
        x = random.uniform(85+radius, WIDTH-85-radius)
        y = random.uniform(95+radius, HEIGHT-80-radius)
        if previous and math.hypot(x-previous[0], y-previous[1]) < 150: continue
        if safe_resource(x,y,radius,exclude): return round(x,1),round(y,1)
    raise RuntimeError('Sem posicao segura para recurso: mapa cheio')

def init_resources():
    RESOURCE_WORLD.clear()
    # All trees plus additional random mineral rocks.
    kinds = [('wood',13.,[(x,y) for x,y in TREE_TRUNKS]),
             ('ore',21.,[(x,y) for x,y,_ in ROCKS]+[None]*14),
             ('herb',13.,[(x,y) for x,y,_ in BUSHES]+[None]*5)]
    for kind, radius, seeds in kinds:
        for i, seed in enumerate(seeds):
            x,y = seed if seed and safe_resource(*seed,radius) else random_resource_position(radius)
            RESOURCE_WORLD[f'{kind}_{i}']={'x':x,'y':y,'kind':kind,'radius':radius,'ready_at':0.}

def available_nodes(p=None):
    now=time.time()
    return [{'id':node_id,'x':node['x'],'y':node['y'],'kind':node['kind'],
             'chance':100 if node['kind']=='wood' else (70 if node['kind']=='ore' else 20),
             'radius':node['radius']}
            for node_id,node in RESOURCE_WORLD.items() if node['ready_at']<=now]

def save_world():
    with sqlite3.connect(DB_PATH) as db:
        db.execute('CREATE TABLE IF NOT EXISTS world_state (key TEXT PRIMARY KEY, data TEXT NOT NULL)')
        db.execute('INSERT INTO world_state(key,data) VALUES (?,?) ON CONFLICT(key) DO UPDATE SET data=excluded.data', ('resources',json.dumps(RESOURCE_WORLD)))

def load_world():
    with sqlite3.connect(DB_PATH) as db:
        db.execute('CREATE TABLE IF NOT EXISTS world_state (key TEXT PRIMARY KEY, data TEXT NOT NULL)')
        row=db.execute('SELECT data FROM world_state WHERE key=?',('resources',)).fetchone()
    if row:
        try:
            saved=json.loads(row[0])
            if isinstance(saved,dict) and saved and all(isinstance(v,dict) for v in saved.values()):
                RESOURCE_WORLD.clear()
                RESOURCE_WORLD.update(saved)
                return
        except (ValueError,TypeError,KeyError): pass
    init_resources()
    save_world()

COMBAT_CLASSES = {'Guerreiro': {'attack': 8, 'defense': 7, 'skill_mult': 1.65}, 'Mago': {'attack': 3, 'defense': 1, 'skill_mult': 2.10}, 'Arqueiro': {'attack': 6, 'defense': 3, 'skill_mult': 1.85}}

SUBCLASS_TOOLS = {'Machado de lenhador':'lenhador','Picareta de mineiro':'mineiro','Kit de herbalista':'herbalista', 'Machado de aco':'lenhador', 'Picareta de aco':'mineiro', 'Kit botanico':'herbalista'}

CRAFT_RECIPES = {
    'iron_bar': ({'Minerio de ferro':3}, 'Barra de ferro', 0.80),
    'stone_block': ({'Fragmento de rocha':6}, 'Bloco de pedra', 0.80),
    'wood_plank': ({'Fragmento de madeira':6}, 'Tabua de madeira', 0.80),
    'wood_shield': ({'Tabua de madeira':2,'Pele de lobo':3}, 'Escudo reforcado', 0.65),
    'stone_armor': ({'Bloco de pedra':2,'Barra de ferro':1}, 'Armadura de pedra', 0.40),
    'fang_blade': ({'Presa de lobo':2, 'Barra de ferro':1}, 'Lamina de presas', 0.60),
    'medium_potion': ({'Erva rara':1, 'Pocao pequena':2}, 'Pocao media', 0.55),
    'full_potion': ({'Erva rara':3, 'Pocao media':2, 'Fragmento de metal antigo':1}, 'Pocao completa', 0.15),
    'raider_shield': ({'Adaga enferrujada':4,'Barra de ferro':3,'Tabua de madeira':2}, 'Escudo do saqueador', 0.25),
    'raider_sword': ({'Adaga enferrujada':6,'Barra de ferro':4,'Presa de lobo':3}, 'Espada do saqueador', 0.12),
    'lumber_axe': ({'Fragmento de madeira':12,'Barra de ferro':2}, 'Machado de lenhador', 0.80),
    'mining_pick': ({'Fragmento de rocha':12,'Barra de ferro':3}, 'Picareta de mineiro', 0.75),
    'herbal_kit': ({'Erva rara':2,'Tabua de madeira':2}, 'Kit de herbalista', 0.65),
    'steel_axe': ({'Fragmento de madeira':24,'Barra de ferro':5,'Adaga enferrujada':2}, 'Machado de aco', 0.55),
    'steel_pick': ({'Fragmento de rocha':24,'Barra de ferro':6,'Minerio de ferro':5}, 'Picareta de aco', 0.50),
    'botanical_kit': ({'Erva rara':5,'Tabua de madeira':4,'Fragmento de metal antigo':1}, 'Kit botanico', 0.45),
    'ancient_blade': ({'Fragmento de metal antigo':5, 'Barra de ferro':6, 'Presa de lobo':8, 'Fragmento de madeira':12}, 'Espada ancestral', 0.03),
}
# Common materials, shop equipment, and these four crafted items can be sold.
# Other protected rare drops remain unsellable.
SELL_PRICES = {'Pele de lobo':5,'Retalho de tecido':8,'Madeira':3,
               'Fragmento de madeira':2,'Fragmento de rocha':2,'Minerio de ferro':12,
               'Barra de ferro':25,'Bloco de pedra':14,'Tabua de madeira':14,
               'Espada de ferro':32,'Escudo de madeira':22,'Armadura de couro':45,
               'Pocao pequena':8, 'Lamina de presas':110, 'Escudo reforcado':95, 'Armadura de pedra':180, 'Escudo do saqueador':240, 'Machado de lenhador':60, 'Picareta de mineiro':75, 'Kit de herbalista':85, 'Machado de aco':140, 'Picareta de aco':170, 'Kit botanico':190, 'Armadura de ferro':325, 'Escudo reforcado de aco':425, 'Espada de aco do Guardiao':625}
# Upgrade por tipo de equipamento e por personagem (nao por unidade individual).
# Nunca destrói o equipamento; falhas consomem recursos.
UPGRADE_CHANCES = (90, 80, 70, 60, 50, 40, 30, 20, 12, 5)
def upgrade_cost(level):
    return {'gold': 100*(level+1), 'Barra de ferro': 1+level//2,
            'Minerio de ferro': 2+level, 'Fragmento de metal antigo': 1 if level>=6 else 0}

GATHER_COOLDOWN = 40.0
players, connections, monsters = {}, {}, {}
# Persistent storage outside version-specific folders. Set TRONO_DATA_DIR to override.
def data_directory():
    override = os.environ.get('TRONO_DATA_DIR')
    if override:
        return Path(override).expanduser().resolve()
    for parent in Path(__file__).resolve().parents:
        if parent.name.lower() == 'tronofragmentado':
            return parent / 'data'
    return Path.home() / 'TronoFragmentado' / 'data'

DATA_DIR = data_directory()
DB_PATH = str(DATA_DIR / 'characters.sqlite3')
LEGACY_DB_PATH = Path(__file__).resolve().parent / 'characters.sqlite3'

def prepare_storage():
    DATA_DIR.mkdir(parents=True, exist_ok=True)
    if not Path(DB_PATH).exists() and LEGACY_DB_PATH.exists():
        # SQLite online backup: safely seed a new central DB, never overwrite one.
        with sqlite3.connect(f'file:{LEGACY_DB_PATH.as_posix()}?mode=ro', uri=True) as source:
            with sqlite3.connect(DB_PATH) as destination:
                source.backup(destination)
        print(f'[Trono] Base antiga migrada para: {DB_PATH}')
    print(f'[Trono] Base de dados ativa: {DB_PATH}')
ITEMS = {'Espada de ferro': {'slot':'weapon','attack':8,'price':65}, 'Escudo de madeira': {'slot':'offhand','defense':3,'price':45}, 'Armadura de couro': {'slot':'armor','defense':5,'price':90}, 'Lamina de presas': {'slot':'weapon','attack':14,'price':0}, 'Espada ancestral': {'slot':'weapon','attack':38,'price':0}, 'Escudo reforcado': {'slot':'offhand','defense':6,'price':0}, 'Armadura de pedra': {'slot':'armor','defense':10,'price':0}, 'Escudo do saqueador': {'slot':'offhand','defense':13,'price':0}, 'Espada do saqueador': {'slot':'weapon','attack':25,'price':0}, 'Armadura de ferro': {'slot':'armor','defense':16,'price':650}, 'Escudo reforcado de aco': {'slot':'offhand','defense':19,'price':850}, 'Espada de aco do Guardiao': {'slot':'weapon','attack':32,'price':1250}, 'Espada de cavaleiro': {'slot':'weapon','attack':18,'price':520}, 'Lamina real de Valedouro': {'slot':'weapon','attack':46,'price':2800}, 'Escudo de ferro': {'slot':'offhand','defense':11,'price':480}, 'Escudo da muralha': {'slot':'offhand','defense':29,'price':1950}, 'Armadura de placas reais': {'slot':'armor','defense':25,'price':1600}, 'Armadura do trono': {'slot':'armor','defense':37,'price':3400}}
SELL_PRICES.update({name: ITEMS[name]['price']//2 for name in SMITH_STOCK if name not in SELL_PRICES})
PROFESSIONS = {'wood': 'lenhador', 'ore': 'mineiro', 'herb': 'herbalista'}
PROFESSION_XP = {'wood': 12, 'ore': 16, 'herb': 20}

def profession_level(xp):
    # Each new level requires progressively more total experience.
    level = 1
    while xp >= 50 * level * (level + 1) // 2:
        level += 1
    return level

def profession_progress(xp):
    level = profession_level(xp)
    start = 50 * (level - 1) * level // 2
    end = 50 * level * (level + 1) // 2
    return {'level': level, 'xp': xp - start, 'xp_next': end - start, 'total_xp': xp}

DEFAULT_EQUIPMENT = {'weapon':None,'offhand':None,'armor':None}

# Cada unidade de equipamento recebe um identificador persistente.
ENCHANTS = {
    'Furia': {'attack': 3, 'defense': 0, 'chance': 0.65},
    'Protecao': {'attack': 0, 'defense': 3, 'chance': 0.50},
    'Runico': {'attack': 5, 'defense': 5, 'chance': 0.20},
}
def new_gear(name, level=0):
    return {'id': uuid.uuid4().hex, 'name': name, 'level': max(0,min(10,int(level))), 'enchant': ''}

def migrate_gear(p):
    # Migração idempotente: equipamentos existentes recebem o seu nível legado.
    p.setdefault('gear_bag', [])
    p.setdefault('gear_equipped', {})
    if p.get('gear_migrated','combat_class'):
        # Reconciliacao conservadora de inventarios anteriores.
        for name, count in p.get('inventory',{}).items():
            if name in ITEMS:
                missing = max(0,int(count)-sum(1 for g in p['gear_bag'] if g.get('name')==name))
                for _ in range(missing): p['gear_bag'].append(new_gear(name))
        return
    old = p.get('upgrade_levels', {})
    for slot, name in p['equipment'].items():
        if name in ITEMS:
            p['gear_equipped'][slot] = new_gear(name, old.get(name, 0))
    for name, qty in p['inventory'].items():
        if name in ITEMS:
            for _ in range(max(0,int(qty))):
                p['gear_bag'].append(new_gear(name, old.get(name, 0)))
    p['gear_migrated'] = True

def gear_take(p, name, gear_id=None):
    for i, gear in enumerate(p['gear_bag']):
        if gear.get('name') == name and (gear_id is None or gear.get('id') == gear_id):
            return p['gear_bag'].pop(i)
    return None


def gear_put(p, gear):
    if gear:
        p['gear_bag'].append(gear)

def gear_levels(p):
    return {slot: int(p.get('gear_equipped',{}).get(slot,{}).get('level',0)) for slot in DEFAULT_EQUIPMENT}


def init_db():
    prepare_storage()
    with sqlite3.connect(DB_PATH) as db:
        db.execute('CREATE TABLE IF NOT EXISTS characters (name TEXT PRIMARY KEY, data TEXT NOT NULL)')

def save_character(p):
    fields = ('hp','max_hp','level','xp','gold','inventory','quest','kills','equipment','name','opened_chests','chest_cooldowns','forest_quest','forest_quest_chests','guardian_quest','guardian_quest_kills','crypt_quest','crypt_raiders','gather_cooldowns','gather_positions','professions','subclass_tool','upgrade_levels','gear_bag','gear_equipped','gear_migrated','combat_class','mana','max_mana','mana_potion_starter','skill_mastery','skill_tree')
    data = {k:p[k] for k in fields}
    with sqlite3.connect(DB_PATH) as db:
        db.execute('INSERT INTO characters(name,data) VALUES(?,?) ON CONFLICT(name) DO UPDATE SET data=excluded.data', (p['name'],json.dumps(data)))

def load_character(name):
    with sqlite3.connect(DB_PATH) as db:
        row = db.execute('SELECT data FROM characters WHERE name=?',(name,)).fetchone()
    return json.loads(row[0]) if row else None

def bonuses(p):
    attack = 0; defense = 0
    for item in p['equipment'].values():
        if item in ITEMS:
            attack += ITEMS[item].get('attack',0)
            defense += ITEMS[item].get('defense',0)
    for slot, item in p['equipment'].items():
        if item in ITEMS:
            level = max(0, min(10, int(p.get('gear_equipped',{}).get(slot,{}).get('level', p.get('upgrade_levels', {}).get(item, 0)))))
            if ITEMS[item].get('attack',0): attack += level*2
            if ITEMS[item].get('defense',0): defense += level*2
            enchant = ENCHANTS.get(p.get('gear_equipped',{}).get(slot,{}).get('enchant',''), {})
            attack += enchant.get('attack',0)
            defense += enchant.get('defense',0)
    class_name = p.get('combat_class', 'Guerreiro')
    class_bonus = COMBAT_CLASSES.get(class_name, {})
    nodes = p.get('skill_tree', {}).get(class_name, [])
    # Bónus passivos apenas da classe ativa.
    tree_attack = 5 if 'power' in nodes else 0
    tree_defense = 5 if 'guard' in nodes else 0
    tree_attack += 7 if 'mastery' in nodes else 0
    tree_defense += 7 if 'resilience' in nodes else 0
    return attack + class_bonus.get('attack', 0) + tree_attack, defense + class_bonus.get('defense', 0) + tree_defense


def distance(a, b):
    return math.hypot(a['x'] - b['x'], a['y'] - b['y'])

# Scene geometry is authoritative on the server and mirrored in the client.
ROCKS = [(290., 368., 19.), (650., 382., 22.), (540., 480., 16.), (78., 375., 18.)]
ROCKS += [(1090.0, 355.0, 20.0), (1680.0, 380.0, 21.0), (1180.0, 1040.0, 20.0), (1580.0, 1040.0, 23.0)]
BUSHES = [(300., 255., 13.), (680., 365., 14.), (565., 510., 12.)]
BUSHES += [(1320.0, 300.0, 13.0), (1740.0, 480.0, 14.0), (380.0, 1000.0, 14.0)]
BARRELS = [(295., 220., 12.), (680., 255., 12.)]
BARRELS += [(1240.0, 265.0, 12.0), (1580.0, 280.0, 12.0), (315.0, 930.0, 12.0)]
FENCES = [(70., 382., 82., 10.), (690., 405., 65., 10.)]
FENCES += [(1150.0, 388.0, 90.0, 10.0), (1510.0, 392.0, 85.0, 10.0), (90.0, 1015.0, 90.0, 10.0)]


def blocked(x, y, radius=RADIUS, ignore_id=None, include_entities=True):
    if not (radius <= x <= WIDTH-radius and radius <= y <= HEIGHT-radius):
        return True
    for rx, ry, rw, rh in OBSTACLES + FENCES:
        cx, cy = max(rx, min(x, rx+rw)), max(ry, min(y, ry+rh))
        if (x-cx)**2 + (y-cy)**2 < radius**2:
            return True
    for tx, ty, tr in BARRELS + [(n['x'],n['y'],n['radius']) for n in RESOURCE_WORLD.values() if n['ready_at'] <= time.time()]:
        if (x-tx)**2 + (y-ty)**2 < (radius+tr)**2:
            return True
    if include_entities:
        if ignore_id != 'npc:tessa' and (x-TESSA[0])**2 + (y-TESSA[1])**2 < (radius+12.)**2:
            return True
        if ignore_id != 'npc:ferreiro' and (x-BLACKSMITH[0])**2 + (y-BLACKSMITH[1])**2 < (radius+12.)**2:
            return True
        for pid, other in players.items():
            if pid != ignore_id and (x-other['x'])**2 + (y-other['y'])**2 < (radius+RADIUS)**2:
                return True
        for mid, monster in monsters.items():
            if monster['alive'] and 'monster:'+mid != ignore_id and (x-monster['x'])**2 + (y-monster['y'])**2 < (radius+11.)**2:
                return True
    return False


def move_with_obstacles(x, y, dx, dy, ignore_id=None):
    # Swept substeps prevent tunneling across narrow trunks at high movement speed.
    steps = max(1, math.ceil(max(abs(dx),abs(dy))/4.))
    sx, sy = dx/steps, dy/steps
    for _ in range(steps):
        if not blocked(x+sx,y,ignore_id=ignore_id): x += sx
        if not blocked(x,y+sy,ignore_id=ignore_id): y += sy
    return x,y


def monster_route(m, target):
    """A* on coarse cells, ignoring dynamic entities to avoid thrashing.
    Returns an empty path for unreachable destinations.
    """
    size = 24.
    max_x, max_y = int(WIDTH//size)-1, int(HEIGHT//size)-1
    start = (min(max_x,int(m['x']//size)), min(max_y,int(m['y']//size)))
    # Find an accessible cell around the target, not the player's occupied cell.
    candidates = []
    for angle in range(16):
        theta = 2*math.pi*angle/16
        x,y = target['x']+(38. if m['kind']=='guardiao' else 43.)*math.cos(theta),target['y']+(38. if m['kind']=='guardiao' else 43.)*math.sin(theta)
        cell = (int(x//size),int(y//size))
        if 0<=cell[0]<=max_x and 0<=cell[1]<=max_y and not blocked((cell[0]+.5)*size,(cell[1]+.5)*size,include_entities=False):
            candidates.append(cell)
    if not candidates: return []
    goals = set(candidates)
    queue = [(0.,start)]; costs={start:0.}; parent={}
    found = None
    while queue:
        _,node=heapq.heappop(queue)
        if node in goals:
            found=node;break
        for dx,dy in ((0,1),(0,-1),(1,0),(-1,0)):
            nx,ny=node[0]+dx,node[1]+dy
            if not (0<=nx<=max_x and 0<=ny<=max_y):continue
            if blocked((nx+.5)*size,(ny+.5)*size,include_entities=False):continue
            nxt=(nx,ny);new_cost=costs[node]+1.
            if new_cost>=costs.get(nxt,float('inf')):continue
            costs[nxt]=new_cost;parent[nxt]=node
            heuristic=min(abs(nx-gx)+abs(ny-gy) for gx,gy in goals)
            heapq.heappush(queue,(new_cost+heuristic,nxt))
    if found is None:return []
    path=[]
    while found!=start:
        path.append(((found[0]+.5)*size,(found[1]+.5)*size))
        found=parent[found]
    path.reverse()
    return path

def move_monster(m, target, step):
    now=time.monotonic()
    # Replan at most once per 1.5 s, or if the target moves substantially.
    last=m.get('route_target',(float('inf'),float('inf')))
    if now>=m.get('next_route_at',0.) or math.hypot(target['x']-last[0],target['y']-last[1])>65.:
        m['route']=monster_route(m,target)
        m['route_target']=(target['x'],target['y'])
        m['next_route_at']=now+1.5
    path=m.get('route',[])
    if not path:return False
    before=(m['x'],m['y'])
    while path and math.hypot(m['x']-path[0][0],m['y']-path[0][1])<(5. if m['kind']=='guardiao' else 12.):
        path.pop(0)
    if not path:return False
    dx,dy=path[0][0]-m['x'],path[0][1]-m['y']
    dist=math.hypot(dx,dy)
    if dist<.01:return False
    m['x'],m['y']=move_with_obstacles(*before,dx/dist*min(step,dist),dy/dist*min(step,dist),ignore_id='monster:'+m['id'])
    moved=math.hypot(m['x']-before[0],m['y']-before[1])
    if moved<.15:
        # Wait instead of oscillating against a tree or another entity.
        m['route']=[]
        m['next_route_at']=now+1.8
    return moved>.15

# Safe, randomized spawn positions. Uses the same authoritative geometry as movement.
# Keep monsters away from the decorative ruins gateway (not part of collision data).
RUINS_VISUAL = (1410., 1010., 1625., 1180.)

def spawn_is_safe(x, y, kind, ignore_id=None):
    radius = 23. if kind == 'guardiao' else 14.
    if blocked(x, y, radius=radius, ignore_id=ignore_id):
        return False
    # Prevent creatures appearing inside the stone gateway/ruins graphics.
    x0, y0, x1, y1 = RUINS_VISUAL
    if x0-radius < x < x1+radius and y0-radius < y < y1+radius:
        return False
    return True

def safe_spawn(center_x, center_y, kind, ignore_id=None):
    # The guardian patrols a clear area north of the ruins; never starts inside them.
    if kind == 'guardiao':
        center_x, center_y = 1540., 965.
        spread = 58.
    else:
        spread = 80.
    for attempt in range(140):
        angle = random.random() * math.tau
        radius = spread * math.sqrt(random.random())
        x = round(center_x + math.cos(angle) * radius, 1)
        y = round(center_y + math.sin(angle) * radius, 1)
        if spawn_is_safe(x, y, kind, ignore_id=ignore_id):
            return x, y
    # Deterministic fallback for crowded spawn areas, no blocked placement.
    for ring in range(0, 13):
        for dx in range(-ring, ring+1):
            for dy in range(-ring, ring+1):
                if max(abs(dx), abs(dy)) != ring:
                    continue
                x, y = center_x + dx * 20., center_y + dy * 20.
                if spawn_is_safe(x, y, kind, ignore_id=ignore_id):
                    return x, y
    raise RuntimeError(f'Nao foi encontrado spawn livre para {kind} perto de {(center_x, center_y)}')

def new_monster(i, kind, x, y):
    hp = 420 if kind == 'guardiao' else (45 if kind == 'lobo' else 75)
    x, y = safe_spawn(x, y, kind)
    return {'id': str(i), 'kind': kind, 'x': x, 'y': y, 'home_x': x, 'home_y': y,
            'hp': hp, 'max_hp': hp, 'alive': True, 'respawn_at': 0., 'last_hit': 0., 'last_special': time.monotonic(), 'effects': {}, 'boss_phase': 1, 'pulse_warning': None}

async def broadcast(message):
    encoded = json.dumps(message)
    for ws in list(connections.values()):
        try:
            await ws.send_text(encoded)
        except (RuntimeError, OSError, WebSocketDisconnect):
            pass

async def send(pid, message):
    ws = connections.get(pid)
    if ws:
        await ws.send_json(message)

def public_monsters():
    return [{**{k: m[k] for k in ('id', 'kind', 'x', 'y', 'hp', 'max_hp', 'alive')}, 'boss_phase': m.get('boss_phase', 1), 'effects': {effect: max(0.0, round(data['until'] - time.monotonic(), 1)) for effect, data in m.get('effects', {}).items() if data['until'] > time.monotonic()}} for m in monsters.values()]

def public_player(p):
    return {k: p[k] for k in ('id', 'x', 'y', 'hp', 'max_hp', 'level', 'facing', 'walking', 'equipment')}

async def status(pid):
    p = players.get(pid)
    if p:
        await send(pid, {'type': 'profile', 'hp': p['hp'], 'max_hp': p['max_hp'],
                         'level': p['level'], 'xp': p['xp'], 'xp_next': p['level']*100,
                         'gold': p['gold'], 'mana':p.get('mana',100), 'max_mana':p.get('max_mana',100), 'inventory': p['inventory'],
                         'quest': p['quest'], 'kills': p['kills'], 'equipment':p['equipment'],
                         'name':p['name'], 'combat_class':p.get('combat_class','Guerreiro'), 'skill_mastery':p.get('skill_mastery',{}), 'skill_tree':p.get('skill_tree',{}), 'opened_chests':p.get('opened_chests', []), 'chest_cooldowns':p.get('chest_cooldowns', {}), 'forest_quest':p.get('forest_quest', 'locked'), 'forest_quest_chests':p.get('forest_quest_chests', []), 'guardian_quest':p.get('guardian_quest','locked'), 'guardian_quest_kills':p.get('guardian_quest_kills',0), 'crypt_quest':p.get('crypt_quest','locked'), 'crypt_raiders':p.get('crypt_raiders',0), 'gather_cooldowns':p.get('gather_cooldowns', {}), 'subclass_tool':p.get('subclass_tool'), 'upgrade_levels':p.get('upgrade_levels',{}), 'gear_equipped':p.get('gear_equipped',{}), 'gear_bag':p.get('gear_bag',[]), 'professions':{k:profession_progress(int(p.get('professions', {}).get(k, 0))) for k in ('lenhador','mineiro','herbalista')}, 'resource_nodes':available_nodes(p), 'server_time':time.time(), 'attack':17+p['level']*3+bonuses(p)[0], 'defense':bonuses(p)[1]})

# MVP 0.9.7: vantagens e resistencias calculadas exclusivamente no servidor.
# Multiplicadores aplicam-se apenas as habilidades exclusivas de classe.
CLASS_DAMAGE_AFFINITY = {
    'lobo': {'Guerreiro': 1.0, 'Mago': 1.15, 'Arqueiro': 1.0},
    'saqueador': {'Guerreiro': 1.10, 'Mago': 1.0, 'Arqueiro': 1.0},
    'guardiao': {'Guerreiro': 0.85, 'Mago': 0.75, 'Arqueiro': 0.90},
}

def class_affinity(kind, combat_class):
    return CLASS_DAMAGE_AFFINITY.get(kind, {}).get(combat_class, 1.0)


async def award_monster_kill(pid, p, m):
    """Award a confirmed kill once, whether from direct damage or burn."""
    earned_xp = 350 if m['kind']=='guardiao' else (30 if m['kind']=='lobo' else 50)
    p['xp']+=earned_xp
    gold=250 if m['kind']=='guardiao' else (random.randint(3,8) if m['kind']=='lobo' else random.randint(8,15))
    p['gold']+=gold
    item='Selo das Ruinas' if m['kind']=='guardiao' else ('Pele de lobo' if m['kind']=='lobo' else 'Retalho de tecido')
    p['inventory'][item]=p['inventory'].get(item,0)+1
    if random.random() < 0.15:
        p['inventory']['Pocao de mana'] = p['inventory'].get('Pocao de mana', 0) + 1
        await send(pid, {'type':'item_float','x':m['x'],'y':m['y']-18,'text':'+1 Pocao de mana'})
    # Quest progress is awarded only by a confirmed guardian kill.
    if m['kind'] == 'guardiao' and p.get('guardian_quest') == 'active':
        p['guardian_quest_kills'] = max(1, int(p.get('guardian_quest_kills', 0)))
        p['guardian_quest'] = 'ready'
        await send(pid, {'type':'notice', 'text':'Missao: Guardiao derrotado! Entrega um Selo a Tessa.'})
    # Independent rare loot roll per defeated monster.
    rare_item = {'lobo':'Presa de lobo', 'saqueador':'Adaga enferrujada',
                 'guardiao':'Fragmento de metal antigo'}.get(m['kind'])
    rare_chance = 0.20 if m['kind']=='saqueador' else 0.15
    rare_drop = bool(rare_item and random.random() < rare_chance)
    if rare_drop:
        p['inventory'][rare_item] = p['inventory'].get(rare_item, 0) + 1
        await send(pid, {'type':'notice', 'text':f'Loot raro ({int(rare_chance*100)}%): {rare_item}!'})
    if m['kind'] == 'saqueador' and p.get('crypt_quest') == 'investigated':
        p['crypt_raiders'] = min(3, int(p.get('crypt_raiders', 0)) + 1)
        if p['crypt_raiders'] >= 3:
            p['crypt_quest'] = 'ready'
            await send(pid, {'type':'notice', 'text':'Ecos da Cripta: 3 saqueadores derrotados. Regressa a Tessa!'})
    if m['kind']=='lobo' and p['quest']=='active': p['kills']+=1
    while p['xp']>=p['level']*100:
        p['xp']-=p['level']*100; p['level']+=1; p['max_hp']+=10; p['hp']=p['max_hp']
    await send(pid,{'type':'notice','text':f'Loot: {item}, {gold} ouro. +XP!' + (' Selo das Ruinas: entrega a Tessa na missao do Guardiao.' if m['kind']=='guardiao' else '')})
    await send(pid,{'type':'combat_reward','x':m['x'],'y':m['y'],'gold':gold,'xp':earned_xp})
    await send(pid,{'type':'item_float','x':m['x'],'y':m['y'],'text':'+' + item})
    if rare_item and p['inventory'].get(rare_item, 0) > 0 and rare_drop:
        await send(pid,{'type':'item_float','x':m['x'],'y':m['y'],'text':'+' + rare_item})
    await status(pid)
    save_character(p)

async def simulation():
    tick_count = 0
    while True:
        await asyncio.sleep(.2)
        tick_count += 1
        world_changed = False
        for resource in RESOURCE_WORLD.values():
            if resource['ready_at'] and resource['ready_at'] <= time.time():
                old=(resource['x'],resource['y'])
                nx,ny=random_resource_position(resource['radius'],previous=old)
                resource.update(x=nx,y=ny,ready_at=0.)
                world_changed=True
        if world_changed:
            save_world()
        if tick_count % 10 == 0:
            for active_pid in list(connections):
                if active_pid in players:
                    await status(active_pid)
        now = time.monotonic()
        changed = False
        for m in monsters.values():
            if not m['alive']:
                if now >= m['respawn_at']:
                    x, y = safe_spawn(m['home_x'], m['home_y'], m['kind'], ignore_id='monster:'+m['id'])
                    m.update(x=x, y=y, hp=m['max_hp'], alive=True, route=[], next_route_at=0., last_special=now, effects={}, boss_phase=1, pulse_warning=None)
                    changed = True
                    if m['kind'] == 'guardiao':
                        await broadcast({'type':'guardian_spawned', 'text':'O GUARDIAO DAS RUINAS DESPERTOU!'})
                continue
            # Boss phases: transitions are server-owned and reset on respawn.
            if m['kind'] == 'guardiao':
                health_ratio = m['hp'] / max(1, m['max_hp'])
                new_phase = 3 if health_ratio <= 0.25 else (2 if health_ratio <= 0.60 else 1)
                if new_phase > m.get('boss_phase', 1):
                    m['boss_phase'] = new_phase
                    m['last_special'] = now  # Fair warning before the next pulse.
                    await broadcast({'type': 'guardian_phase', 'phase': new_phase,
                                     'x': m['x'], 'y': m['y'],
                                     'text': ('O GUARDIAO DESPERTA A FURIA DAS RUINAS!' if new_phase == 2
                                              else 'O GUARDIAO ENTROU EM FURIA FINAL!')})
                    changed = True
            # Debuffs are resolved by the server, not the client.
            for effect_name, effect in list(m.get('effects', {}).items()):
                if now >= effect['until']:
                    del m['effects'][effect_name]
                    changed = True
                    continue
                if effect_name == 'burn' and now >= effect.get('next_tick', 0):
                    effect['next_tick'] = now + 1.0
                    dot = min(m['hp'], int(effect.get('damage', 4)))
                    m['hp'] -= dot
                    if dot:
                        await broadcast({'type':'combat_hit','target_id':m['id'],'x':m['x'],'y':m['y'],'damage':dot,'attacker_id':'burn','effect':'burn'})
                        changed = True
                    if m['hp'] <= 0:
                        # Burn kills share the exact same rewards as direct attacks.
                        owner_pid = str(effect.get('owner_pid', ''))
                        m['alive'] = False
                        m['respawn_at'] = now + (180 if m['kind']=='guardiao' else 9)
                        m['effects'] = {}
                        if owner_pid in players and players[owner_pid].get('hp', 0) > 0:
                            await award_monster_kill(owner_pid, players[owner_pid], m)
                        changed = True
                        break
            if not m['alive']:
                continue
            # Server-authoritative telegraphed guardian pulse: the boss stays in place
            # while charging, and every living hero may dodge the marked area.
            if m['kind'] == 'guardiao' and m.get('pulse_warning') is not None:
                warning = m['pulse_warning']
                if now >= warning['expires']:
                    m['pulse_warning'] = None
                    m['last_special'] = now
                    hits = []
                    for victim in players.values():
                        if victim.get('hp', 0) <= 0:
                            continue
                        if math.hypot(victim['x'] - warning['x'], victim['y'] - warning['y']) > warning['radius']:
                            continue
                        dealt = max(1, warning['damage'] - bonuses(victim)[1])
                        victim['hp'] = max(0, victim['hp'] - dealt)
                        hits.append({'target_id': victim['id'], 'target_x': victim['x'], 'target_y': victim['y'], 'damage': dealt})
                        if victim['hp'] == 0:
                            victim['x'], victim['y'], victim['hp'] = 480., 360., victim['max_hp']
                            await send(victim['id'], {'type': 'notice', 'text': 'Foste derrotado pelo pulso do Guardiao.'})
                            await broadcast({'type': 'state', 'player': public_player(victim)})
                        await status(victim['id'])
                    await broadcast({'type': 'guardian_pulse_resolved', 'x': warning['x'], 'y': warning['y'],
                                     'radius': warning['radius'], 'phase': warning['phase'], 'hits': hits})
                continue
            if 'stun' in m.get('effects', {}):
                continue
            nearest = min((p for p in players.values() if p['hp'] > 0),
                          key=lambda p: distance(p, m), default=None)
            if nearest is None:
                continue
            dist = distance(nearest, m)
            if 24 < dist < (200 if m['kind']=='guardiao' else 145):
                step = min(4., dist-24) * (1.35 if m['kind'] == 'guardiao' and m.get('boss_phase', 1) == 3 else 1.0) * ((0.70 if m['kind'] == 'guardiao' else 0.45) if 'slow' in m.get('effects', {}) else 1.0)
                changed = move_monster(m, nearest, step) or changed
            # Guardian: 3 phases; pulse frequency, radius and damage escalate.
            phase = m.get('boss_phase', 1) if m['kind'] == 'guardiao' else 1
            pulse_cooldown = {1: 9.0, 2: 7.0, 3: 5.0}[phase]
            pulse_radius = {1: 92.0, 2: 115.0, 3: 135.0}[phase]
            if m['kind'] == 'guardiao' and dist <= pulse_radius and now-m.get('last_special', now) >= pulse_cooldown:
                charge_seconds = 1.65 if phase == 1 else (1.35 if phase == 2 else 1.10)
                m['pulse_warning'] = {'x': m['x'], 'y': m['y'], 'radius': pulse_radius,
                                      'damage': {1: 28, 2: 35, 3: 43}[phase],
                                      'phase': phase, 'expires': now + charge_seconds}
                await broadcast({'type': 'guardian_pulse_warning', 'x': m['x'], 'y': m['y'],
                                 'radius': pulse_radius, 'duration': charge_seconds, 'phase': phase})
                continue
            if dist < (58 if m['kind']=='guardiao' else 31) and now-m['last_hit'] >= (({1: 2.3, 2: 1.9, 3: 1.5}[m.get('boss_phase', 1)]) if m['kind']=='guardiao' else 1.7):
                m['last_hit'] = now
                dealt = max(1, (7 if m['kind']=='lobo' else (22 if m['kind']=='guardiao' else 11))-bonuses(nearest)[1])
                nearest['hp'] = max(0, nearest['hp'] - dealt)
                await broadcast({'type':'monster_attack','attacker_id':m['id'],
                                 'target_id':nearest['id'], 'kind':m['kind'],
                                 'x':nearest['x'], 'y':nearest['y'],
                                 'damage':dealt, 'attacker_x':m['x'], 'attacker_y':m['y']})
                await status(nearest['id'])
                if nearest['hp'] == 0:
                    nearest['x'], nearest['y'], nearest['hp'] = 480., 360., nearest['max_hp']
                    await send(nearest['id'], {'type':'notice','text':'Foste derrotado e regressaste a Valedouro.'})
                    await status(nearest['id'])
                    await broadcast({'type':'state','player':public_player(nearest)})
        if changed:
            await broadcast({'type':'monsters','monsters':public_monsters()})

@asynccontextmanager
async def lifespan(_app):
    init_db()
    load_world()
    monsters.clear()
    for i, (x, y, kind) in enumerate(SPAWNS):
        monsters[str(i)] = new_monster(i, kind, x, y)
    task = asyncio.create_task(simulation())
    yield
    task.cancel()
    with suppress(asyncio.CancelledError):
        await task

app = FastAPI(title='Cronicas do Trono Fragmentado MVP 0.4', lifespan=lifespan)

@app.get('/health')
def health():
    return {'status':'ok', 'version':'0.4', 'players':len(players)}

@app.websocket('/ws')
async def socket(ws: WebSocket):
    await ws.accept()
    pid = str(uuid.uuid4())
    p = {'id':pid, 'x':480., 'y':360., 'hp':100, 'max_hp':100, 'level':1, 'xp':0,
         'gold':0, 'inventory':{}, 'quest':'not_started', 'kills':0,
         'facing':'down', 'walking':False, 'last_attack':0.,
         'name':'', 'equipment':dict(DEFAULT_EQUIPMENT), 'opened_chests':[], 'chest_cooldowns':{}, 'forest_quest':'locked', 'forest_quest_chests':[], 'guardian_quest':'locked', 'guardian_quest_kills':0, 'crypt_quest':'locked', 'crypt_raiders':0, 'gather_cooldowns':{}, 'gather_positions':{}, 'professions':{'lenhador':0,'mineiro':0,'herbalista':0}, 'subclass_tool':None, 'upgrade_levels':{}, 'gear_bag':[], 'gear_equipped':{}, 'gear_migrated':False, 'combat_class':'Guerreiro', 'mana':100, 'max_mana':100, 'mana_potion_starter':False, 'skill_mastery':{}, 'skill_tree':{}}
    for candidate in [(480.,360.), (480.,395.), (440.,395.), (520.,395.), (480.,430.), (440.,430.)]:
        if not blocked(*candidate, ignore_id=pid):
            p['x'],p['y'] = candidate
            break
    connections[pid], players[pid] = ws, p
    await send(pid, {'type':'welcome','id':pid,'players':[public_player(v) for v in players.values()],
                     'monsters':public_monsters()})
    await send(pid, {'type':'notice','text':'Escreve o nome do heroi (N) para carregar/guardar. M abre a oficina do ferreiro.'})
    await status(pid)
    await broadcast({'type':'join','player':public_player(p)})
    try:
        while True:
            msg = await ws.receive_json()
            if not isinstance(msg, dict):
                continue
            kind = msg.get('type')
            if kind == 'name':
                name = str(msg.get('name','')).strip()
                if not (3 <= len(name) <= 20 and name.replace('_','').isalnum()):
                    await send(pid,{'type':'notice','text':'Nome: 3-20 letras/numeros/underscore.'}); continue
                if any(other['name']==name for other in players.values() if other['id']!=pid):
                    await send(pid,{'type':'notice','text':'Esse heroi ja esta ligado.'}); continue
                data = load_character(name)
                if data:
                    p.update({k:v for k,v in data.items() if k in ('hp','max_hp','level','xp','gold','inventory','quest','kills','equipment','name','opened_chests','chest_cooldowns','forest_quest','forest_quest_chests','guardian_quest','guardian_quest_kills','crypt_quest','crypt_raiders','gather_cooldowns','gather_positions','professions','subclass_tool','upgrade_levels','gear_bag','gear_equipped','gear_migrated','combat_class','mana','max_mana','mana_potion_starter','skill_mastery','skill_tree')})
                    p['equipment']={**DEFAULT_EQUIPMENT,**p.get('equipment',{})}
                else:
                    p['name']=name
                    p['inventory']['Pocao pequena']=2
                    p['gold']=100
                p.setdefault('skill_mastery', {})
                p.setdefault('skill_tree', {})
                p.setdefault('max_mana', 100)
                p.setdefault('mana', p['max_mana'])
                if not p.get('mana_potion_starter', False):
                    p['inventory']['Pocao de mana'] = p['inventory'].get('Pocao de mana', 0) + 5
                    p['mana_potion_starter'] = True
                migrate_gear(p)
                save_character(p)
                await send(pid,{'type':'notice','text':f'Heroi {name} carregado e guardado.'})
                await status(pid)
                await broadcast({'type':'state','player':public_player(p)})
                continue
            if kind == 'use_mana_potion':
                if p['inventory'].get('Pocao de mana', 0) <= 0:
                    await send(pid, {'type':'notice','text':'Sem pocoes de mana no inventario.'})
                elif p.get('mana',100) >= p.get('max_mana',100):
                    await send(pid, {'type':'notice','text':'Mana ja esta cheia.'})
                else:
                    before = p.get('mana',100)
                    p['mana'] = min(p.get('max_mana',100), before + 50)
                    p['inventory']['Pocao de mana'] -= 1
                    if p['inventory']['Pocao de mana'] <= 0:
                        del p['inventory']['Pocao de mana']
                    await send(pid, {'type':'notice','text':f'Pocao de mana: +{p["mana"] - before} MP.'})
                save_character(p)
                await status(pid)
                continue
            if kind == 'unlock_skill_node':
                if not p.get('name'):
                    await send(pid, {'type':'notice','text':'Carrega primeiro o heroi.'})
                    continue
                cls = p.get('combat_class', 'Guerreiro')
                node = str(msg.get('node',''))
                nodes = p.setdefault('skill_tree', {}).setdefault(cls, [])
                mastery_level = min(5, max(0, int(p.get('skill_mastery', {}).get(cls, 0))) // 8)
                required = {'power':1, 'guard':3, 'mastery':4, 'resilience':5, 'technique':2}
                if node not in required:
                    await send(pid, {'type':'notice','text':'Talento desconhecido.'})
                elif node in nodes:
                    await send(pid, {'type':'notice','text':'Talento ja desbloqueado.'})
                elif mastery_level < required[node]:
                    await send(pid, {'type':'notice','text':f'Precisas de maestria nivel {required[node]} nesta classe.'})
                elif node in ('guard', 'mastery', 'resilience', 'technique') and 'power' not in nodes:
                    await send(pid, {'type':'notice','text':'Desbloqueia primeiro o talento de ataque.'})
                else:
                    nodes.append(node)
                    save_character(p)
                    await status(pid)
                    await send(pid, {'type':'notice','text':f'Talento {node} desbloqueado para {cls}!'})
                continue
            if kind == 'choose_class':
                if not p['name']:
                    await send(pid,{'type':'notice','text':'Carrega primeiro o teu heroi com N.'})
                    continue
                chosen = str(msg.get('class',''))
                if chosen not in COMBAT_CLASSES:
                    await send(pid,{'type':'notice','text':'Classe invalida.'})
                    continue
                p['combat_class'] = chosen
                save_character(p)
                await status(pid)
                await send(pid,{'type':'notice','text':f'Classe ativa: {chosen}. Os atributos foram atualizados.'})
                continue
            if kind in ('buy','equip','unequip','use','sell','equip_tool','unequip_tool'):
                if not p['name']:
                    await send(pid,{'type':'notice','text':'Primeiro escolhe um nome com N.'}); continue
                item = str(msg.get('item',''))
                if kind=='equip_tool' and item in SUBCLASS_TOOLS and p['inventory'].get(item,0)>0:
                    old=p.get('subclass_tool')
                    if old:
                        p['inventory'][old]=p['inventory'].get(old,0)+1
                    p['inventory'][item]-=1
                    if p['inventory'][item]<=0: del p['inventory'][item]
                    p['subclass_tool']=item
                    await send(pid,{'type':'notice','text':f'Ferramenta ativa: {item}. Apenas uma de cada vez.'})
                elif kind=='unequip_tool' and item in SUBCLASS_TOOLS and p.get('subclass_tool')==item:
                    p['subclass_tool']=None
                    p['inventory'][item]=p['inventory'].get(item,0)+1
                    await send(pid,{'type':'notice','text':f'Retiraste {item}.'})
                elif kind=='buy' and item in SMITH_STOCK and distance(p,{'x':BLACKSMITH[0],'y':BLACKSMITH[1]})<=90:
                    price=ITEMS[item]['price']
                    if p['gold']>=price:
                        p['gold']-=price; p['inventory'][item]=p['inventory'].get(item,0)+1
                        if item in ITEMS: p['gear_bag'].append(new_gear(item))
                        await send(pid,{'type':'notice','text':f'Compraste {item} por {price} ouro.'})
                    else: await send(pid,{'type':'notice','text':'Ouro insuficiente.'})
                elif kind=='equip' and item in ITEMS and p['inventory'].get(item,0)>0:
                    gear_id = str(msg.get('gear_id','')) or None
                    chosen_gear = gear_take(p,item,gear_id)
                    if chosen_gear is None:
                        await send(pid,{'type':'notice','text':'Unidade de equipamento nao encontrada.'})
                        continue
                    slot=ITEMS[item]['slot']; previous=p['equipment'][slot]
                    p['inventory'][item]-=1
                    if p['inventory'][item]==0: del p['inventory'][item]
                    if previous:
                        p['inventory'][previous]=p['inventory'].get(previous,0)+1
                        gear_put(p,p['gear_equipped'].pop(slot,None))
                    p['equipment'][slot]=item
                    p['gear_equipped'][slot]=chosen_gear
                    await send(pid,{'type':'notice','text':f'Equipaste {item}.'})
                    await broadcast({'type':'state','player':public_player(p)})
                elif kind=='unequip' and item in ITEMS and p['equipment'].get(ITEMS[item]['slot'])==item:
                    slot=ITEMS[item]['slot']
                    p['equipment'][slot]=None
                    gear_put(p,p['gear_equipped'].pop(slot,None))
                    p['inventory'][item]=p['inventory'].get(item,0)+1
                    await send(pid,{'type':'notice','text':f'Retiraste {item}.'})
                    await broadcast({'type':'state','player':public_player(p)})
                elif kind=='use' and item in ('Pocao pequena','Pocao media','Pocao completa') and p['inventory'].get(item,0)>0 and p['hp']<p['max_hp']:
                    p['inventory'][item]-=1
                    if p['inventory'][item]==0: del p['inventory'][item]
                    hp_before = p['hp']
                    p['hp']=min(p['max_hp'],p['hp']+{'Pocao pequena':35,'Pocao media':100,'Pocao completa':p['max_hp']}[item])
                    healed = p['hp'] - hp_before
                    await broadcast({'type':'healing_effect', 'target_id':pid,
                                     'x':p['x'], 'y':p['y'], 'amount':healed})
                    await send(pid,{'type':'notice','text':f'Pocao usada: +{healed} HP.'})
                elif kind=='sell' and item in SELL_PRICES and distance(p,{'x':BLACKSMITH[0],'y':BLACKSMITH[1]})<=90:
                    try: quantity=int(msg.get('quantity',1))
                    except (ValueError,TypeError): quantity=0
                    if quantity not in (1,5,10,20,50):
                        await send(pid,{'type':'notice','text':'Lote invalido: escolhe 1, 5, 10, 20 ou 50.'})
                    elif p['inventory'].get(item,0)<quantity:
                        await send(pid,{'type':'notice','text':f'So tens {p["inventory"].get(item,0)}x {item}; lote pedido: {quantity}.'})
                    else:
                        gear_id = str(msg.get('gear_id','')) or None
                        if item in ITEMS and gear_id:
                            if quantity != 1 or not any(g.get('id')==gear_id and g.get('name')==item for g in p['gear_bag']):
                                await send(pid,{'type':'notice','text':'Venda individual invalida.'})
                                continue
                        p['inventory'][item]-=quantity
                        if item in ITEMS:
                            for n in range(quantity):
                                gear_take(p,item,gear_id if n == 0 else None)
                        if p['inventory'][item]==0: del p['inventory'][item]
                        earned=SELL_PRICES[item]*quantity
                        p['gold']+=earned
                        await send(pid,{'type':'notice','text':f'Vendeste {quantity}x {item} por {earned} ouro.'})
                else:
                    await send(pid,{'type':'notice','text':'Acao indisponivel, item em falta ou longe do ferreiro.'})
                save_character(p); await status(pid)
                continue
            if kind == 'upgrade':
                if not p['name'] or distance(p,{'x':BLACKSMITH[0],'y':BLACKSMITH[1]})>90:
                    await send(pid,{'type':'notice','text':'Aproxima-te do Ferreiro para melhorar equipamentos.'}); continue
                slot = str(msg.get('slot',''))
                if slot not in DEFAULT_EQUIPMENT:
                    await send(pid,{'type':'notice','text':'Espaco de equipamento invalido.'}); continue
                item = p['equipment'].get(slot)
                if item not in ITEMS:
                    await send(pid,{'type':'notice','text':'Equipa primeiro um item neste espaco.'}); continue
                gear = p['gear_equipped'].get(slot)
                if not gear: continue
                current = max(0, min(10, int(gear.get('level',0))))
                if current >= 10:
                    await send(pid,{'type':'notice','text':f'{item} ja esta no nivel maximo +10.'}); continue
                costs = upgrade_cost(current)
                if p['gold'] < costs['gold'] or any(p['inventory'].get(k,0)<v for k,v in costs.items() if k!='gold' and v>0):
                    await send(pid,{'type':'notice','text':f'Materiais ou ouro insuficientes para melhorar {item}.'}); continue
                p['gold'] -= costs['gold']
                for material, amount in costs.items():
                    if material == 'gold' or amount == 0: continue
                    p['inventory'][material] -= amount
                    if p['inventory'][material] == 0: del p['inventory'][material]
                success = random.random() < UPGRADE_CHANCES[current]/100.
                if success:
                    gear['level'] = current + 1
                await send(pid, {'type':'craft_result','success':success,'item':f'{item} +{current+1}', 'x':p['x'],'y':p['y']})
                await send(pid,{'type':'notice','text':f'{"SUCESSO" if success else "FALHOU"}: {item} +{current+1}. Materiais consumidos; equipamento preservado.'})
                save_character(p); await status(pid)
                continue
            if kind == 'enchant':
                if not p['name'] or distance(p,{'x':BLACKSMITH[0],'y':BLACKSMITH[1]}) > 90:
                    await send(pid,{'type':'notice','text':'Aproxima-te do Ferreiro.'}); continue
                slot = str(msg.get('slot',''))
                chosen = str(msg.get('enchant',''))
                gear = p.get('gear_equipped',{}).get(slot)
                if not gear or chosen not in ENCHANTS:
                    await send(pid,{'type':'notice','text':'Seleciona um equipamento e encantamento valido.'}); continue
                if gear.get('enchant'):
                    await send(pid,{'type':'notice','text':'Este equipamento ja tem encantamento.'}); continue
                cost = {'gold': 900, 'Barra de ferro': 2, 'Fragmento de metal antigo': 1}
                if p['gold'] < cost['gold'] or any(p['inventory'].get(k,0)<v for k,v in cost.items() if k!='gold'):
                    await send(pid,{'type':'notice','text':'Encantamento requer 900 ouro, 2 barras e 1 fragmento antigo.'}); continue
                p['gold'] -= cost['gold']
                for material in ('Barra de ferro','Fragmento de metal antigo'):
                    p['inventory'][material] -= cost[material]
                    if not p['inventory'][material]: del p['inventory'][material]
                success = random.random() < ENCHANTS[chosen]['chance']
                if success: gear['enchant'] = chosen
                await send(pid,{'type':'craft_result','success':success,'item':chosen,'x':p['x'],'y':p['y']})
                await send(pid,{'type':'notice','text':('Encantamento '+chosen+' aplicado!' if success else 'Encantamento falhou; equipamento preservado.')})
                save_character(p); await status(pid)
                continue
            if kind == 'move':
                dx, dy = msg.get('dx'), msg.get('dy')
                if any(isinstance(v, bool) or not isinstance(v, (int, float)) or not math.isfinite(v) for v in (dx,dy)):
                    continue
                mag = math.hypot(dx,dy)
                if mag > 1:
                    dx,dy = dx/mag,dy/mag
                p['x'], p['y'] = move_with_obstacles(p['x'], p['y'], dx*SPEED_PER_TICK, dy*SPEED_PER_TICK, ignore_id=pid)
                p['walking']=mag>.01
                if abs(dx)>abs(dy): p['facing']='right' if dx>0 else 'left'
                elif abs(dy)>.01: p['facing']='down' if dy>0 else 'up'
                await broadcast({'type':'state','player':public_player(p)})
            elif kind == 'open_chest':
                # Cooldowns are Unix timestamps, saved per character in SQLite.
                # Old opened_chests are migrated to a fresh 5-minute cooldown once.
                chest_id = str(msg.get('chest_id', ''))
                chest_positions = {
                    'forest_ancient_01': (1735.0, 1060.0),
                    'forest_ancient_02': (1170.0, 1010.0),
                    'valley_supply_01': (1030.0, 665.0),
                }
                if not p['name']:
                    await send(pid, {'type':'notice','text':'Escolhe primeiro o nome do heroi (N).'})
                elif chest_id not in chest_positions:
                    await send(pid, {'type':'notice','text':'Bau desconhecido.'})
                elif math.hypot(p['x']-chest_positions[chest_id][0], p['y']-chest_positions[chest_id][1]) > 85.0:
                    await send(pid, {'type':'notice','text':'Aproxima-te do bau para abrir.'})
                else:
                    now = time.time()
                    cooldowns = p.setdefault('chest_cooldowns', {})
                    if chest_id in p.get('opened_chests', []) and chest_id not in cooldowns:
                        cooldowns[chest_id] = now + 300.0
                        save_character(p)
                    remaining = max(0, int(math.ceil(float(cooldowns.get(chest_id, 0)) - now)))
                    if remaining:
                        await send(pid, {'type':'notice','text':f'Bau vazio. Reaparece em {remaining//60:02d}:{remaining%60:02d}.'})
                    else:
                        cooldowns[chest_id] = now + 300.0
                        # Quest progress is only earned on a successful chest opening.
                        if p.get('forest_quest') == 'active':
                            discoveries = p.setdefault('forest_quest_chests', [])
                            if chest_id not in discoveries:
                                discoveries.append(chest_id)
                                if len(discoveries) >= 2:
                                    p['forest_quest'] = 'ready'
                                    await send(pid, {'type':'notice','text':'Exploracao concluida! Regressa a Tessa para receber a recompensa.'})
                        p['gold'] += 75
                        p['xp'] += 60
                        p['inventory']['Pocao pequena'] = p['inventory'].get('Pocao pequena', 0) + 2
                        while p['xp'] >= p['level']*100:
                            p['xp'] -= p['level']*100
                            p['level'] += 1
                            p['max_hp'] += 10
                            p['hp'] = p['max_hp']
                        save_character(p)
                        await status(pid)
                        await send(pid, {'type':'chest_reward','chest_id':chest_id,
                                         'x':chest_positions[chest_id][0],
                                         'y':chest_positions[chest_id][1],
                                         'gold':75,'xp':60,'potions':2})
                        await send(pid, {'type':'notice','text':'Bau: +75 ouro, +60 XP, +2 pocoes! Volta em 5 minutos.'})
            elif kind == 'smith_interact':
                if distance(p, {'x':BLACKSMITH[0], 'y':BLACKSMITH[1]}) <= 95:
                    await send(pid, {'type':'smith_dialog', 'name':'Ferreiro', 'text':'Bem-vindo a minha forja! Queres comprar, vender ou fabricar equipamentos e pocoes?'})
                else:
                    await send(pid, {'type':'notice', 'text':'Aproxima-te do Ferreiro para conversar.'})
            elif kind == 'interact':
                # Primeiro capitulo da Cripta do Sino Partido: pista ambiental
                # validada no servidor; nunca aceitar posicoes enviadas pelo cliente.
                if p.get('crypt_quest') == 'active' and math.hypot(p['x']-1500., p['y']-1040.) <= 175.:
                    p['crypt_quest'] = 'investigated'
                    if p['name']: save_character(p)
                    await status(pid)
                    await send(pid, {'type':'npc','name':'Ecos da Cripta','text':'Entre as pedras ha um sino partido e marcas de saqueadores. Derrota 3 saqueadores e regressa a Tessa.'})
                elif math.hypot(p['x']-TESSA[0],p['y']-TESSA[1]) > 68:
                    await send(pid,{'type':'npc','name':'Sistema','text':'Aproxima-te de Tessa.'})
                elif p['quest']=='not_started':
                    p['quest']='active'
                    await send(pid,{'type':'npc','name':'Tessa','text':'Derrota 3 lobos e regressa para receberes uma recompensa!'})
                    await status(pid)
                elif p['quest']=='active' and p['kills']>=3:
                    p['quest']='completed'; p['gold']+=50; p['xp']+=100
                    p['inventory']['Pocao pequena']=p['inventory'].get('Pocao pequena',0)+2
                    while p['xp']>=p['level']*100:
                        p['xp']-=p['level']*100; p['level']+=1; p['max_hp']+=10; p['hp']=p['max_hp']
                    await send(pid,{'type':'npc','name':'Tessa','text':'Valedouro agradece! Recebeste 100 XP, 50 ouro e 2 pocoes.'})
                    if p['name']: save_character(p)
                    await status(pid)
                elif p['quest']=='completed' and p.get('forest_quest', 'locked') == 'locked':
                    p['forest_quest'] = 'active'
                    p['forest_quest_chests'] = []
                    if p['name']: save_character(p)
                    await status(pid)
                    await send(pid,{'type':'npc','name':'Tessa','text':'Explora a floresta! Abre 2 baus diferentes e regressa para receber uma recompensa.'})
                elif p['quest']=='completed' and p.get('forest_quest') == 'ready':
                    p['forest_quest'] = 'completed'
                    p['gold'] += 150
                    p['xp'] += 200
                    p['inventory']['Pocao pequena'] = p['inventory'].get('Pocao pequena',0) + 3
                    while p['xp'] >= p['level']*100:
                        p['xp'] -= p['level']*100
                        p['level'] += 1
                        p['max_hp'] += 10
                        p['hp'] = p['max_hp']
                    if p['name']: save_character(p)
                    await status(pid)
                    await send(pid,{'type':'npc','name':'Tessa','text':'Exploracao concluida! Recebeste 200 XP, 150 ouro e 3 pocoes.'})
                elif p['quest']=='completed' and p.get('forest_quest') == 'active':
                    await send(pid,{'type':'npc','name':'Tessa','text':f'Explora mais baus diferentes: {len(p.get("forest_quest_chests", []))}/2.'})
                elif p['quest']=='completed' and p.get('forest_quest') == 'completed' and p.get('guardian_quest','locked') == 'locked':
                    p['guardian_quest'] = 'active'
                    p['guardian_quest_kills'] = 0
                    if p['name']: save_character(p)
                    await status(pid)
                    await send(pid,{'type':'npc','name':'Tessa','text':'O Guardiao das Ruinas ameaca Valedouro. Derrota-o uma vez, recolhe o Selo das Ruinas e regressa. Nao vendas a reliquia!'})
                elif p['quest']=='completed' and p.get('guardian_quest') == 'active':
                    count = int(p.get('guardian_quest_kills',0))
                    seal = int(p['inventory'].get('Selo das Ruinas',0))
                    await send(pid,{'type':'npc','name':'Tessa','text':f'Derrota o Guardiao ({min(count,1)}/1) e traz um Selo das Ruinas ({min(seal,1)}/1).'})
                elif p['quest']=='completed' and p.get('guardian_quest') == 'ready':
                    if int(p['inventory'].get('Selo das Ruinas',0)) < 1:
                        p['guardian_quest'] = 'active'
                        if p['name']: save_character(p)
                        await status(pid)
                        await send(pid,{'type':'npc','name':'Tessa','text':'Perdeste o Selo. Derrota novamente o Guardiao e traz-me um Selo das Ruinas.'})
                    else:
                        p['inventory']['Selo das Ruinas'] -= 1
                        if p['inventory']['Selo das Ruinas'] == 0:
                            del p['inventory']['Selo das Ruinas']
                        p['guardian_quest'] = 'completed'
                        p['gold'] += 500
                        p['xp'] += 450
                        p['inventory']['Pocao pequena'] = p['inventory'].get('Pocao pequena',0) + 5
                        while p['xp'] >= p['level']*100:
                            p['xp'] -= p['level']*100; p['level'] += 1; p['max_hp'] += 10; p['hp'] = p['max_hp']
                        if p['name']: save_character(p)
                        await status(pid)
                        await send(pid,{'type':'npc','name':'Tessa','text':'A reliquia foi entregue! Recebeste 450 XP, 500 ouro e 5 pocoes. A vila esta mais segura.'})
                elif p.get('guardian_quest') == 'completed' and p.get('crypt_quest','locked') == 'locked':
                    p['crypt_quest'] = 'active'
                    p['crypt_raiders'] = 0
                    if p['name']: save_character(p)
                    await status(pid)
                    await send(pid, {'type':'npc','name':'Tessa','text':'Ecos da Cripta do Sino Partido: investiga as ruinas a sudeste, perto do Guardiao. Usa E junto ao portal antigo.'})
                elif p.get('crypt_quest') == 'active':
                    await send(pid, {'type':'npc','name':'Tessa','text':'Procura o portal antigo a sudeste das ruinas e usa E para investigar.'})
                elif p.get('crypt_quest') == 'investigated':
                    await send(pid, {'type':'npc','name':'Tessa','text':f'Os saqueadores escondem a entrada. Derrota-os: {int(p.get("crypt_raiders",0))}/3.'})
                elif p.get('crypt_quest') == 'ready':
                    p['crypt_quest'] = 'completed'
                    p['gold'] += 300
                    p['xp'] += 400
                    p['inventory']['Fragmento de metal antigo'] = p['inventory'].get('Fragmento de metal antigo', 0) + 2
                    while p['xp'] >= p['level']*100:
                        p['xp'] -= p['level']*100; p['level'] += 1; p['max_hp'] += 10; p['hp'] = p['max_hp']
                    if p['name']: save_character(p)
                    await status(pid)
                    await send(pid, {'type':'npc','name':'Tessa','text':'O Sino Partido guarda um segredo. Recebeste 400 XP, 300 ouro e 2 fragmentos antigos. A Cripta sera a nossa proxima expedicao.'})
                elif p.get('crypt_quest') == 'completed':
                    await send(pid, {'type':'npc','name':'Tessa','text':'A primeira pista da Cripta foi descoberta. Prepara-te para a expedicao.'})
                elif p['quest']=='completed':
                    await send(pid,{'type':'npc','name':'Tessa','text':'Obrigada por protegeres a vila e explorares a floresta!'})
                else:
                    await send(pid,{'type':'npc','name':'Tessa','text':f'Continua a caca: {p["kills"]}/3 lobos.'})
            elif kind == 'craft':
                if not p['name']:
                    await send(pid, {'type':'notice','text':'Escolhe um nome com N antes de fabricar.'})
                    continue
                if distance(p, {'x':BLACKSMITH[0], 'y':BLACKSMITH[1]}) > 100:
                    await send(pid, {'type':'notice','text':'Para fabricar, aproxima-te do ferreiro na estrada a leste de Tessa.'})
                    continue
                recipe = CRAFT_RECIPES.get(str(msg.get('recipe', '')))
                if not recipe:
                    await send(pid, {'type':'notice','text':'Receita desconhecida.'})
                    continue
                materials, output, chance = recipe
                tool_profession = SUBCLASS_TOOLS
                if output in tool_profession and profession_level(int(p.get('professions', {}).get(tool_profession[output], 0))) < (6 if output in ('Machado de aco','Picareta de aco','Kit botanico') else 3):
                    await send(pid, {'type':'notice','text':'Nivel de profissao insuficiente para ' + output + ' (' + tool_profession[output] + ')' + ' para fabricar esta ferramenta.'})
                    continue
                if output in SUBCLASS_TOOLS and (p['inventory'].get(output,0)>0 or p.get('subclass_tool')==output):
                    await send(pid, {'type':'notice','text':'Ja possuis esta ferramenta. So podes ter uma de cada tipo; vende a antiga antes de fabricar outra.'})
                    continue
                if any(p['inventory'].get(k, 0) < v for k, v in materials.items()):
                    await send(pid, {'type':'notice','text':'Faltam materiais para ' + output + ': ' + ', '.join(f'{k} {p["inventory"].get(k,0)}/{v}' for k,v in materials.items())})
                    continue
                for k, v in materials.items():
                    p['inventory'][k] -= v
                    if p['inventory'][k] <= 0:
                        del p['inventory'][k]
                success = random.random() < chance
                if success:
                    p['inventory'][output] = p['inventory'].get(output, 0) + 1
                    if output in ITEMS: p['gear_bag'].append(new_gear(output))
                save_character(p)
                await status(pid)
                await send(pid, {'type':'notice','text':('SUCESSO! Criaste ' + output if success else 'FALHOU! Nao conseguiste criar ' + output) + f' ({int(chance*100)}% de sucesso). Materiais consumidos.'})
                await send(pid, {'type':'craft_result','success':success,'item':output,'chance':int(chance*100),'x':p['x'],'y':p['y']})
            elif kind == 'gather':
                if not p['name']:
                    await send(pid, {'type':'notice','text':'Escolhe primeiro um nome com N.'})
                    continue
                node_id = str(msg.get('node_id', ''))
                node = RESOURCE_WORLD.get(node_id)
                if node is None:
                    await send(pid, {'type':'notice','text':'Recurso desconhecido.'})
                    continue
                x,y = node['x'],node['y']
                resource_type = node['kind']
                chance = 1.0 if resource_type=='wood' else (0.70 if resource_type=='ore' else 0.20)
                tool_names = {'wood':('Machado de lenhador','Machado de aco'),'ore':('Picareta de mineiro','Picareta de aco'),'herb':('Kit de herbalista','Kit botanico')}
                active_tool = p.get('subclass_tool')
                has_tool = active_tool in tool_names[resource_type]
                advanced_tool = active_tool == tool_names[resource_type][1]
                profession_name = PROFESSIONS[resource_type]
                skill_level = profession_level(int(p.get('professions', {}).get(profession_name, 0)))
                if advanced_tool and skill_level >= 6 and resource_type != 'wood':
                    chance = min(1.0, chance + 0.20)
                elif has_tool and skill_level >= 3 and resource_type != 'wood':
                    chance = min(1.0, chance + 0.10)
                if math.hypot(p['x']-x,p['y']-y)>85.0:
                    await send(pid, {'type':'notice','text':'Aproxima-te do recurso assinalado para recolher.'})
                    continue
                if node['ready_at'] > time.time():
                    await send(pid, {'type':'notice','text':'Recurso temporariamente indisponivel.'})
                    continue
                node['ready_at']=time.time()+GATHER_COOLDOWN
                save_world()
                # Authoritative animation event: client only renders it; the server awards loot.
                await send(pid, {'type':'gather_result', 'kind':resource_type, 'x':x, 'y':y})
                inv=p['inventory']
                if resource_type=='wood':
                    item,amount='Fragmento de madeira',5 if advanced_tool and skill_level >= 6 else (4 if has_tool and skill_level >= 3 else 3)
                elif resource_type=='ore':
                    item,amount=('Minerio de ferro',1) if random.random()<chance else ('Fragmento de rocha',3)
                else:
                    item,amount=('Erva rara',1) if random.random()<chance else ('',0)
                # Extra independent drop: 30% per successful rock gathering.
                # It does not replace iron ore or common rock fragments.
                if resource_type == 'ore' and random.random() < 0.30:
                    rare_name = 'Fragmento de metal antigo'
                    inv[rare_name] = inv.get(rare_name, 0) + 1
                    await send(pid, {'type':'notice','text':'Mineracao: +1 Fragmento de metal antigo! (30% de chance).'})
                    await send(pid, {'type':'item_float','x':p['x'],'y':p['y']-18,'text':'+1 Fragmento de metal antigo'})
                if item:
                    inv[item]=inv.get(item,0)+amount
                    await send(pid, {'type':'notice','text':f'Recolheste {amount}x {item}! Probabilidade do material raro: {int(chance*100)}%.'})
                    await send(pid, {'type':'item_float','x':p['x'],'y':p['y'],'text':f'+{amount} {item}'})
                else:
                    await send(pid, {'type':'notice','text':f'Erva rara nao encontrada ({int(chance*100)}% de sucesso). Tenta novamente noutro recurso.'})
                # Professions progress for a valid gathering attempt, including rare misses.
                skill = PROFESSIONS[resource_type]
                experience = PROFESSION_XP[resource_type]
                skills = p.setdefault('professions', {})
                previous_level = profession_level(int(skills.get(skill, 0)))
                skills[skill] = int(skills.get(skill, 0)) + experience
                new_level = profession_level(skills[skill])
                await send(pid, {'type':'notice', 'text':f'{skill.capitalize()}: +{experience} XP de profissao' + (f' | NOVO NIVEL {new_level}!' if new_level > previous_level else '')})
                if new_level > previous_level:
                    await send(pid, {'type':'item_float','x':p['x'],'y':p['y']-25,'text':f'{skill.upper()} NIVEL {new_level}!'})
                save_character(p)
                await status(pid)
            elif kind in ('attack', 'skill', 'class_skill'):
                now=time.monotonic()
                special = kind in ('skill', 'class_skill')
                class_special = kind == 'class_skill'
                class_name_selected = p.get('combat_class', 'Guerreiro')
                class_specs = {'Guerreiro': ('Corte Heroico', 1.85, 80, 14.0), 'Mago': ('Explosao Arcana', 2.30, 115, 17.0), 'Arqueiro': ('Flecha Precisa', 2.00, 145, 15.0)}
                class_label, class_mult, class_range, class_cd = class_specs.get(class_name_selected, class_specs['Guerreiro'])
                if p['hp'] <= 0: continue
                if special:
                    # Cooldown is authoritative, per connected character, and cannot be bypassed by the client.
                    remaining = (class_cd - (now - p.get('last_class_skill', -1e9))) if class_special else (12.0 - (now - p.get('last_skill', -1e9)))
                    if remaining > 0:
                        await send(pid, {'type':'notice','text':f'{class_label if class_special else "Golpe Arcano"} disponivel em {remaining:.1f}s.'})
                        continue
                    if not p.get('equipment', {}).get('weapon') and not p.get('gear_equipped', {}).get('weapon'):
                        await send(pid, {'type':'notice','text':'Equipa uma arma para usar habilidades especiais.'})
                        continue
                elif now-p['last_attack']<.55:
                    continue
                candidates=[m for m in monsters.values() if m['alive'] and distance(p,m)<=(class_range if class_special else (95 if special else 65))]
                if not candidates:
                    await send(pid,{'type':'notice','text':'Nenhum inimigo ao alcance (%d px).' % (class_range if class_special else (95 if special else 65))})
                    continue
                requested_target = str(msg.get('target_id', '')) if kind == 'attack' else ''
                if requested_target:
                    matching = [enemy for enemy in candidates if str(enemy.get('id', '')) == requested_target]
                    if not matching:
                        continue
                    m = matching[0]
                else:
                    m=min(candidates,key=lambda enemy:distance(p,enemy))
                mana_cost = (25 if class_special else 15) if special else 0
                if p.get('mana', 100) < mana_cost:
                    await send(pid, {'type':'notice','text':f'Mana insuficiente: precisas de {mana_cost} MP. Usa J.'})
                    continue
                if special:
                    p['mana'] = p.get('mana', 100) - mana_cost
                    await status(pid)
                    if class_special:
                        p['last_class_skill'] = now
                    else:
                        p['last_skill'] = now
                    p['last_attack'] = now
                else:
                    p['last_attack'] = now
                damage=max(1, 17+p['level']*3+bonuses(p)[0])
                if special:
                    multiplier = class_mult if class_special else COMBAT_CLASSES.get(p.get('combat_class','Guerreiro'), COMBAT_CLASSES['Guerreiro'])['skill_mult']
                    # Maestria: +5% de dano por nivel (maximo 5).
                    # Cada 8 acertos validos aumenta um nivel, por habilidade e classe.
                    mastery_key = class_name_selected if class_special else 'Arcano'
                    mastery = p.setdefault('skill_mastery', {})
                    hits = max(0, int(mastery.get(mastery_key, 0)))
                    mastery_level = min(5, hits // 8)
                    damage = max(1, round(damage * multiplier * (1.0 + 0.05 * mastery_level)))
                    if hits < 40:
                        mastery[mastery_key] = hits + 1
                        if (hits + 1) % 8 == 0:
                            await send(pid, {'type':'notice','text':f'Maestria {mastery_key}: nivel {(hits + 1) // 8}! +{((hits + 1) // 8) * 5}% dano.'})
                    save_character(p)
                    await status(pid)
                    await broadcast({'type':'skill_cast','x':m['x'],'y':m['y'],'source_x':p['x'],'source_y':p['y'],'attacker_id':pid,'damage':damage, 'class_skill':class_special, 'class_name':class_name_selected, 'label':class_label if class_special else 'GOLPE ARCANO', 'cooldown':class_cd if class_special else 12.0})
                targets = [m]
                if class_special and class_name_selected in ('Guerreiro', 'Mago'):
                    # Server-side area targeting; all enemies must be alive and within the cast range.
                    radius = 78 if class_name_selected == 'Guerreiro' else 110
                    max_targets = 3 if class_name_selected == 'Guerreiro' else 6
                    nearby = [enemy for enemy in candidates if enemy['id'] != m['id']
                              and math.hypot(enemy['x']-m['x'], enemy['y']-m['y']) <= radius]
                    nearby.sort(key=lambda enemy: math.hypot(enemy['x']-m['x'], enemy['y']-m['y']))
                    targets.extend(nearby[:max_targets-1])
                class_nodes = p.get('skill_tree', {}).get(class_name_selected, [])
                technique_active = class_special and 'technique' in class_nodes
                if technique_active and class_name_selected == 'Mago':
                    p['mana'] = min(p.get('max_mana', 100), p.get('mana', 0) + 8)
                    await send(pid, {'type':'item_float', 'x':p['x'], 'y':p['y']-32, 'text':'+8 MP (Sinton ia Arcana)'.replace('Sinton ia', 'Sintonia')})
                for target_index, target in enumerate(targets):
                    m = target
                    target_damage = damage if target_index == 0 else max(1, round(damage * (0.75 if class_name_selected == 'Guerreiro' else 0.65)))
                    if class_special:
                        affinity = class_affinity(m['kind'], class_name_selected)
                        target_damage = max(1, round(target_damage * affinity))
                        if affinity != 1.0:
                            tag = 'VULNERAVEL' if affinity > 1.0 else 'RESISTIU'
                            await broadcast({'type':'item_float', 'x':m['x'], 'y':m['y']-40, 'text':f'{tag} {int(abs(1.0-affinity)*100)}%'})
                    if technique_active and class_name_selected == 'Arqueiro' and m['kind'] == 'guardiao':
                        target_damage = max(1, round(target_damage * 1.2))
                    if technique_active and class_name_selected == 'Guerreiro':
                        healed = min(p['max_hp'] - p['hp'], max(1, round(target_damage * 0.10)))
                        if healed > 0:
                            p['hp'] += healed
                            await send(pid, {'type':'item_float', 'x':p['x'], 'y':p['y']-32, 'text':f'+{healed} HP (Vigor)'})
                    if class_special and m['hp'] > target_damage:
                        # Guardiao resiste a atordoamento; nao fica preso em stun permanente.
                        if class_name_selected == 'Guerreiro' and m['kind'] != 'guardiao':
                            m.setdefault('effects', {})['stun'] = {'until':now + 1.3}
                        elif class_name_selected == 'Mago':
                            m.setdefault('effects', {})['burn'] = {'until':now + (2.1 if m['kind'] == 'guardiao' else 3.1), 'next_tick':now + 1.0, 'damage':max(1, round(target_damage * (0.02 if m['kind'] == 'guardiao' else 0.04))), 'owner_pid':pid}
                        elif class_name_selected == 'Arqueiro':
                            m.setdefault('effects', {})['slow'] = {'until':now + (2.0 if m['kind'] == 'guardiao' else 4.0)}
                    m['hp']=max(0,m['hp']-target_damage)
                    await send(pid,{'type':'notice','text':f'{m["kind"].capitalize()}: -{target_damage} HP'})
                    await broadcast({'type':'combat_hit','target_id':m['id'],'x':m['x'],'y':m['y'],'damage':target_damage,'attacker_id':pid})
                    if m['hp']==0:
                        m['alive']=False; m['respawn_at']=now+(180 if m['kind']=='guardiao' else 9)
                        await award_monster_kill(pid, p, m)
                if p['name']: save_character(p)
                if technique_active: await status(pid)
                await broadcast({'type':'monsters','monsters':public_monsters()})
    except (WebSocketDisconnect, RuntimeError, ValueError):
        pass
    finally:
        if p['name']: save_character(p)
        connections.pop(pid,None); players.pop(pid,None)
        await broadcast({'type':'leave','id':pid})
