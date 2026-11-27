"""Auditoria e backup seguro da base de personagens. Nao altera o banco original.

Uso: python server/prepare_account_migration.py
     python server/prepare_account_migration.py --db "C:/caminho/characters.sqlite3"
"""
import argparse
import json
import sqlite3
from contextlib import closing
from datetime import datetime
from pathlib import Path


def audit_and_backup(db_path: Path, output_dir: Path | None = None) -> dict:
    db_path = Path(db_path).expanduser().resolve()
    if not db_path.is_file():
        raise FileNotFoundError(f"Base de dados nao encontrada: {db_path}")
    output_dir = Path(output_dir or (db_path.parent / "backups")).expanduser().resolve()
    output_dir.mkdir(parents=True, exist_ok=True)
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S_%f")
    backup_path = output_dir / f"characters_pre_auth_{timestamp}.sqlite3"
    # Backup online do SQLite, mesmo se o servidor estiver a utilizar WAL.
    with closing(sqlite3.connect(f"file:{db_path.as_posix()}?mode=ro", uri=True)) as src:
        with closing(sqlite3.connect(str(backup_path))) as dst:
            src.backup(dst)
    with closing(sqlite3.connect(f"file:{backup_path.as_posix()}?mode=ro", uri=True)) as db:
        integrity = db.execute("PRAGMA integrity_check").fetchone()[0]
        if integrity != "ok":
            backup_path.unlink(missing_ok=True)
            raise RuntimeError(f"Backup falhou verificacao SQLite: {integrity}")
        tables = {row[0] for row in db.execute(
            "SELECT name FROM sqlite_master WHERE type='table'"
        )}
        if "characters" not in tables:
            backup_path.unlink(missing_ok=True)
            raise RuntimeError("Tabela characters nao encontrada")
        rows = db.execute("SELECT name, data FROM characters ORDER BY name COLLATE NOCASE").fetchall()
        owned = {}
        if "character_owners" in tables:
            owned = {str(name).casefold(): account for name, account in db.execute(
                "SELECT character_name, account_id FROM character_owners"
            )}
        characters = []
        for name, raw in rows:
            try:
                payload = json.loads(raw)
                if not isinstance(payload, dict):
                    payload = {}
            except (ValueError, TypeError):
                payload = {}
            characters.append({
                "name": name,
                "level": payload.get("level"),
                "class": payload.get("combat_class"),
                "ownership": "linked" if str(name).casefold() in owned else "legacy_unlinked",
            })
    report = {"database": str(db_path), "backup": str(backup_path),
              "integrity": integrity, "character_count": len(characters),
              "characters": characters,
              "next_step": "Associar personagens legados somente apos confirmacao explicita do proprietario."}
    report_path = output_dir / f"characters_pre_auth_{timestamp}.json"
    report_path.write_text(json.dumps(report, indent=2, ensure_ascii=False), encoding="utf-8")
    report["report"] = str(report_path)
    return report


def main():
    parser = argparse.ArgumentParser(description="Backup e inventario pre-autenticacao")
    parser.add_argument("--db", type=Path, default=Path.home() / "TronoFragmentado" / "data" / "characters.sqlite3")
    parser.add_argument("--output-dir", type=Path)
    args = parser.parse_args()
    print(json.dumps(audit_and_backup(args.db, args.output_dir), indent=2, ensure_ascii=False))


if __name__ == "__main__":
    main()
