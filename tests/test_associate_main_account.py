import json
import sqlite3
import sys
import tempfile
import unittest
from contextlib import closing
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "server"))
from associate_main_account import ALL_HEROES, associate, plan
from account_security import authenticate, owns_character


class MainAccountAssociationTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.db = Path(self.temp.name) / "characters.sqlite3"
        with closing(sqlite3.connect(self.db)) as conn, conn:
            conn.execute("CREATE TABLE characters (name TEXT PRIMARY KEY, data TEXT NOT NULL)")
            conn.executemany("INSERT INTO characters VALUES (?,?)",
                             [(name, json.dumps({"name": name, "level": 18})) for name in ALL_HEROES])

    def tearDown(self):
        self.temp.cleanup()

    def test_dry_run(self):
        self.assertEqual(plan(self.db)["count"], 11)
        with closing(sqlite3.connect(self.db)) as conn:
            self.assertFalse(conn.execute("SELECT name FROM sqlite_master WHERE name='accounts'").fetchone())

    def test_association_preserves_saves_and_authentication(self):
        with closing(sqlite3.connect(self.db)) as conn:
            before = dict(conn.execute("SELECT name,data FROM characters"))
        result = associate(self.db, "Principal", "senha-muito-longa-123")
        self.assertEqual(result["linked_characters"], 11)
        self.assertTrue(Path(result["backup"]).exists())
        account_id = authenticate(self.db, "principal", "senha-muito-longa-123")
        self.assertIsNotNone(account_id)
        self.assertTrue(owns_character(self.db, account_id, "Zezin"))
        with closing(sqlite3.connect(self.db)) as conn:
            self.assertEqual(before, dict(conn.execute("SELECT name,data FROM characters")))
        with self.assertRaises(RuntimeError):
            associate(self.db, "OutraConta", "senha-muito-longa-123")

    def test_missing_hero_blocks_changes(self):
        with closing(sqlite3.connect(self.db)) as conn, conn:
            conn.execute("DELETE FROM characters WHERE name='Zezin'")
        with self.assertRaises(RuntimeError):
            associate(self.db, "Principal", "senha-muito-longa-123")


if __name__ == "__main__":
    unittest.main()
