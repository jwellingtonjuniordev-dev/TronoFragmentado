"""Testes de segurança sem modificar a base de dados real."""
import os
import sqlite3
from contextlib import closing
import sys
import tempfile
import unittest
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "server"))
from account_security import (init_accounts, create_account, authenticate,
                              issue_session, resolve_session, claim_new_character, owns_character)

class AccountSecurityTests(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        self.db = os.path.join(self.tmp.name, "characters.sqlite3")
        with closing(sqlite3.connect(self.db)) as conn, conn:
            conn.execute("CREATE TABLE characters (name TEXT PRIMARY KEY, data TEXT NOT NULL)")
            conn.execute("INSERT INTO characters VALUES ('John', '{}')")
        init_accounts(self.db)

    def tearDown(self):
        self.tmp.cleanup()

    def test_preserves_legacy_character(self):
        with closing(sqlite3.connect(self.db)) as conn, conn:
            self.assertEqual(conn.execute("SELECT name FROM characters").fetchone()[0], "John")

    def test_password_and_case_insensitive_username(self):
        account = create_account(self.db, "ContaUm", "Senha-longa-1234!")
        self.assertEqual(authenticate(self.db, "contaum", "Senha-longa-1234!"), account)
        self.assertIsNone(authenticate(self.db, "contaum", "senha-incorreta"))
        with self.assertRaises(sqlite3.IntegrityError):
            create_account(self.db, "CONTAUM", "Outra-senha-1234!")

    def test_session_and_character_isolation(self):
        a = create_account(self.db, "ContaA", "Senha-longa-1234!")
        b = create_account(self.db, "ContaB", "Senha-longa-1234!")
        token = issue_session(self.db, a)
        self.assertEqual(resolve_session(self.db, token), a)
        self.assertIsNone(resolve_session(self.db, "token-invalido"))
        claim_new_character(self.db, a, "Athena")
        self.assertTrue(owns_character(self.db, a, "athena"))
        self.assertFalse(owns_character(self.db, b, "Athena"))
        with self.assertRaises(sqlite3.IntegrityError):
            claim_new_character(self.db, b, "ATHENA")

    def test_password_policy(self):
        with self.assertRaises(ValueError):
            create_account(self.db, "abc", "curta")

if __name__ == "__main__":
    unittest.main()
