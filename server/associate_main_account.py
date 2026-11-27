"""Associa os 11 personagens recuperados a uma conta principal.

Por padrao, somente simula. --apply pede nome de utilizador e senha
interativamente, cria a conta e as associacoes numa unica transacao.
O login no jogo AINDA nao e ativado por este script.
"""
import argparse
import getpass
import hashlib
import hmac
import json
import os
import sqlite3
import time
import uuid
from contextlib import closing
from pathlib import Path

from prepare_account_migration import audit_and_backup
from recover_legacy_characters import EXPECTED
from account_security import ITERATIONS

ALL_HEROES = EXPECTED | {"Zezin"}


def _read_state(db_path):
    path = Path(db_path).expanduser().resolve()
    if not path.is_file():
        raise FileNotFoundError(path)
    with closing(sqlite3.connect(f"file:{path.as_posix()}?mode=ro", uri=True)) as db:
        if db.execute("PRAGMA integrity_check").fetchone()[0] != "ok":
            raise RuntimeError("Falha de integridade no banco")
        names = [r[0] for r in db.execute("SELECT name FROM characters")]
        tables = {r[0] for r in db.execute("SELECT name FROM sqlite_master WHERE type='table'")}
        linked = db.execute("SELECT character_name,account_id FROM character_owners").fetchall() if "character_owners" in tables else []
        accounts = db.execute("SELECT COUNT(*) FROM accounts").fetchone()[0] if "accounts" in tables else 0
    return names, linked, accounts


def plan(db_path):
    names, linked, accounts = _read_state(db_path)
    if len(names) != 11 or set(names) != ALL_HEROES:
        raise RuntimeError(f"Esperados exatamente 11 personagens conhecidos; encontrados: {sorted(names)}")
    if linked:
        raise RuntimeError("Ja existem associacoes de personagens; nao sobrescrever")
    if accounts:
        raise RuntimeError("Ja existem contas; associacao automatica bloqueada")
    return {"mode": "dry_run", "characters": sorted(names), "count": len(names),
            "existing_accounts": accounts, "existing_owners": len(linked)}


def associate(db_path, username, password):
    db_path = Path(db_path).expanduser().resolve()
    state = plan(db_path)
    username = username.strip()
    if not (3 <= len(username) <= 32 and username.replace("_", "").isalnum()):
        raise ValueError("Nome de utilizador invalido")
    if not (12 <= len(password) <= 1024):
        raise ValueError("Senha deve ter 12 a 1024 caracteres")
    salt = os.urandom(16)
    digest = hashlib.pbkdf2_hmac("sha256", password.encode("utf-8"), salt, ITERATIONS)
    account_id = str(uuid.uuid4())
    backup = audit_and_backup(db_path)
    with closing(sqlite3.connect(db_path, timeout=15)) as db:
        db.execute("PRAGMA foreign_keys=ON")
        db.execute("BEGIN IMMEDIATE")
        try:
            # Revalidar no lock antes de escrever; nenhuma conta existente e reaproveitada.
            current = [r[0] for r in db.execute("SELECT name FROM characters")]
            if len(current) != 11 or set(current) != ALL_HEROES:
                raise RuntimeError("Personagens mudaram durante a operacao")
            for table in ("accounts", "character_owners", "account_sessions"):
                if db.execute("SELECT 1 FROM sqlite_master WHERE type='table' AND name=?", (table,)).fetchone():
                    if db.execute(f"SELECT COUNT(*) FROM {table}").fetchone()[0]:
                        raise RuntimeError(f"Tabela {table} ja contem dados")
            db.execute("""CREATE TABLE IF NOT EXISTS accounts (
                id TEXT PRIMARY KEY, username TEXT UNIQUE NOT NULL COLLATE NOCASE,
                salt BLOB NOT NULL, password_hash BLOB NOT NULL, created_at INTEGER NOT NULL)""")
            db.execute("""CREATE TABLE IF NOT EXISTS character_owners (
                character_name TEXT PRIMARY KEY COLLATE NOCASE,
                account_id TEXT NOT NULL REFERENCES accounts(id))""")
            db.execute("""CREATE TABLE IF NOT EXISTS account_sessions (
                token_hash TEXT PRIMARY KEY, account_id TEXT NOT NULL REFERENCES accounts(id),
                expires_at INTEGER NOT NULL)""")
            db.execute("INSERT INTO accounts VALUES (?,?,?,?,?)",
                       (account_id, username, salt, digest, int(time.time())))
            db.executemany("INSERT INTO character_owners VALUES (?,?)",
                           [(name, account_id) for name in sorted(ALL_HEROES)])
            if db.execute("SELECT COUNT(*) FROM character_owners WHERE account_id=?", (account_id,)).fetchone()[0] != 11:
                raise RuntimeError("Associacao incompleta")
            if db.execute("PRAGMA quick_check").fetchone()[0] != "ok":
                raise RuntimeError("Integridade falhou")
            db.commit()
        except Exception:
            db.rollback()
            raise
    return {"mode": "applied", "username": username, "linked_characters": 11,
            "backup": backup["backup"], "backup_report": backup["report"],
            "note": "A associacao foi criada; o servidor ainda nao exige login."}


def main():
    parser = argparse.ArgumentParser(description="Associacao segura dos 11 personagens")
    parser.add_argument("--db", type=Path, default=Path.home() / "TronoFragmentado" / "data" / "characters.sqlite3")
    parser.add_argument("--apply", action="store_true")
    args = parser.parse_args()
    if not args.apply:
        print(json.dumps(plan(args.db), ensure_ascii=False, indent=2))
        return
    # Nao passar senha pela linha de comandos nem registar senha nos logs.
    username = input("Nome da conta principal: ").strip()
    password = getpass.getpass("Senha (12 ou mais caracteres): ")
    confirm = getpass.getpass("Confirma a senha: ")
    if not hmac.compare_digest(password, confirm):
        raise ValueError("Senhas diferentes; nenhuma alteracao efetuada")
    print(json.dumps(associate(args.db, username, password), ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
