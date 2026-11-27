"""Testes de backup pre-autenticacao, usando somente SQLite temporario."""
import json
import sqlite3
import sys
import tempfile
import unittest
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "server"))
from prepare_account_migration import audit_and_backup


class MigrationBackupTests(unittest.TestCase):
    def test_backup_preserves_legacy_characters_and_original(self):
        with tempfile.TemporaryDirectory() as tmp:
            db_path = Path(tmp) / "characters.sqlite3"
            with sqlite3.connect(db_path) as db:
                db.execute("CREATE TABLE characters (name TEXT PRIMARY KEY, data TEXT NOT NULL)")
                db.execute("INSERT INTO characters VALUES (?,?)",
                           ("John", json.dumps({"level": 7, "combat_class": "Guerreiro"})))
            report = audit_and_backup(db_path)
            self.assertEqual(report["integrity"], "ok")
            self.assertEqual(report["character_count"], 1)
            self.assertEqual(report["characters"][0]["ownership"], "legacy_unlinked")
            self.assertEqual(report["characters"][0]["level"], 7)
            self.assertTrue(Path(report["backup"]).exists())
            self.assertTrue(Path(report["report"]).exists())
            with sqlite3.connect(db_path) as db:
                self.assertEqual(db.execute("SELECT COUNT(*) FROM characters").fetchone()[0], 1)

    def test_missing_database_does_not_create_database(self):
        with tempfile.TemporaryDirectory() as tmp:
            path = Path(tmp) / "missing.sqlite3"
            with self.assertRaises(FileNotFoundError):
                audit_and_backup(path)
            self.assertFalse(path.exists())


if __name__ == "__main__":
    unittest.main()
