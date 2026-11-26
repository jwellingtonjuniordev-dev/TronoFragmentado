"""Contas isoladas para integração futura. Não modifica a tabela characters existente."""
import hashlib
import hmac
import os
import secrets
import sqlite3
import time
import uuid

ITERATIONS = 600_000

def _password_hash(password, salt):
    return hashlib.pbkdf2_hmac("sha256", password.encode("utf-8"), salt, ITERATIONS)

def init_accounts(db_path):
    """Adiciona apenas tabelas novas; não migra saves automaticamente."""
    with sqlite3.connect(db_path) as db:
        db.execute("PRAGMA foreign_keys=ON")
        db.execute("""CREATE TABLE IF NOT EXISTS accounts (
            id TEXT PRIMARY KEY, username TEXT UNIQUE NOT NULL COLLATE NOCASE,
            salt BLOB NOT NULL, password_hash BLOB NOT NULL, created_at INTEGER NOT NULL)""")
        db.execute("""CREATE TABLE IF NOT EXISTS character_owners (
            character_name TEXT PRIMARY KEY COLLATE NOCASE,
            account_id TEXT NOT NULL REFERENCES accounts(id))""")
        db.execute("""CREATE TABLE IF NOT EXISTS account_sessions (
            token_hash TEXT PRIMARY KEY, account_id TEXT NOT NULL REFERENCES accounts(id),
            expires_at INTEGER NOT NULL)""")

def create_account(db_path, username, password):
    username = username.strip()
    if not (3 <= len(username) <= 32 and username.replace("_", "").isalnum()):
        raise ValueError("Nome de conta inválido")
    if not (12 <= len(password) <= 1024):
        raise ValueError("Senha deve ter entre 12 e 1024 caracteres")
    account_id = str(uuid.uuid4())
    salt = os.urandom(16)
    with sqlite3.connect(db_path) as db:
        db.execute("INSERT INTO accounts VALUES (?,?,?,?,?)",
                   (account_id, username, salt, _password_hash(password, salt), int(time.time())))
    return account_id

def authenticate(db_path, username, password):
    with sqlite3.connect(db_path) as db:
        row = db.execute("SELECT id,salt,password_hash FROM accounts WHERE username=?",
                         (username.strip(),)).fetchone()
    if row is None:
        _password_hash(password, bytes(16))
        return None
    return row[0] if hmac.compare_digest(_password_hash(password, row[1]), row[2]) else None

def issue_session(db_path, account_id, ttl_seconds=3600):
    if not 60 <= ttl_seconds <= 86400:
        raise ValueError("TTL inválido")
    token = secrets.token_urlsafe(32)
    digest = hashlib.sha256(token.encode("ascii")).hexdigest()
    with sqlite3.connect(db_path) as db:
        db.execute("INSERT INTO account_sessions VALUES (?,?,?)",
                   (digest, account_id, int(time.time()) + ttl_seconds))
    return token

def resolve_session(db_path, token):
    if not isinstance(token, str) or len(token) > 256:
        return None
    digest = hashlib.sha256(token.encode("utf-8")).hexdigest()
    with sqlite3.connect(db_path) as db:
        row = db.execute("SELECT account_id FROM account_sessions WHERE token_hash=? AND expires_at>?",
                         (digest, int(time.time()))).fetchone()
    return row[0] if row else None

def claim_new_character(db_path, account_id, name):
    """Somente personagens novos; legados precisam de migração controlada."""
    with sqlite3.connect(db_path) as db:
        db.execute("PRAGMA foreign_keys=ON")
        db.execute("INSERT INTO character_owners VALUES (?,?)", (name, account_id))

def owns_character(db_path, account_id, name):
    with sqlite3.connect(db_path) as db:
        return db.execute("SELECT 1 FROM character_owners WHERE account_id=? AND character_name=?",
                          (account_id, name)).fetchone() is not None
