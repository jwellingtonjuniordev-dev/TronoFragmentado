"""Uso unico: adiciona 6 fragmentos ao John na SQLite ativa. Executar com servidor fechado."""
import json
import os
import sqlite3
from pathlib import Path

ROOT = Path(__file__).resolve().parent
SERVER = ROOT / 'server' / 'main.py'

def active_db():
    override = os.environ.get('TRONO_DATA_DIR')
    if override:
        return Path(override).expanduser().resolve() / 'characters.sqlite3'
    for parent in SERVER.parents:
        if parent.name.lower() == 'tronofragmentado':
            return parent / 'data' / 'characters.sqlite3'
    return Path.home() / 'TronoFragmentado' / 'data' / 'characters.sqlite3'

def main():
    db_path = active_db()
    print('Base de dados:', db_path)
    if not db_path.is_file():
        print('ERRO: Base nao encontrada. Confirma a pasta de dados do servidor. Nenhuma alteracao feita.')
        return
    backup = db_path.with_name('characters_backup_antes_6_fragmentos.sqlite3')
    if backup.exists():
        print('ERRO: Ja existe um backup com este nome:', backup)
        print('Renomeia o backup existente antes de executar novamente.'); return
    with sqlite3.connect(db_path) as db:
        row = db.execute('SELECT data FROM characters WHERE name=?', ('John',)).fetchone()
        if row is None:
            print('ERRO: Personagem John nao encontrado. Nenhuma alteracao feita.'); return
        data = json.loads(row[0])
        inv = data.setdefault('inventory', {})
        current = int(inv.get('Fragmento de metal antigo', 0))
        print('John tem atualmente:', current, 'fragmentos antigos')
        if input('Adicionar exatamente 6 fragmentos ao John? (SIM): ').strip().upper() != 'SIM':
            print('Cancelado.'); return
        # SQLite online backup antes de modificar, com servidor desligado.
        with sqlite3.connect(backup) as dest:
            db.backup(dest)
        inv['Fragmento de metal antigo'] = current + 6
        with db:
            db.execute('UPDATE characters SET data=? WHERE name=?', (json.dumps(data,ensure_ascii=False), 'John'))
        print('SUCESSO: John agora tem', current+6, 'fragmentos antigos.')
        print('Backup guardado em:', backup)

if __name__ == '__main__':
    main()
