import json
import sqlite3
import sys
import tempfile
import unittest
from contextlib import closing
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "server"))
from recover_legacy_characters import EXPECTED, recover


class RecoveryTests(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        self.source = Path(self.tmp.name) / "old.sqlite3"
        self.target = Path(self.tmp.name) / "current.sqlite3"
        for path in (self.source, self.target):
            with closing(sqlite3.connect(path)) as db, db:
                db.execute("CREATE TABLE characters (name TEXT PRIMARY KEY, data TEXT NOT NULL)")
        with closing(sqlite3.connect(self.source)) as db, db:
            for name in EXPECTED:
                db.execute("INSERT INTO characters VALUES (?,?)",
                           (name, json.dumps({"name": name, "level": 10, "inventory": {"item": 2}})))
            db.execute("INSERT INTO characters VALUES (?,?)", ("", json.dumps({"name": "", "level": 1})))
        with closing(sqlite3.connect(self.target)) as db, db:
            db.execute("INSERT INTO characters VALUES (?,?)",
                       ("Zezin", json.dumps({"name": "Zezin", "level": 18})))

    def tearDown(self):
        self.tmp.cleanup()

    def test_dry_run_no_changes(self):
        plan = recover(self.source, self.target)
        self.assertEqual(plan["target_after"], 11)
        with closing(sqlite3.connect(self.target)) as db:
            self.assertEqual(db.execute("SELECT COUNT(*) FROM characters").fetchone()[0], 1)

    def test_import_preserves_zezin_and_excludes_blank(self):
        plan = recover(self.source, self.target, apply=True)
        self.assertTrue(plan["verified"])
        self.assertTrue(Path(plan["backup"]).exists())
        with closing(sqlite3.connect(self.target)) as db:
            rows = dict(db.execute("SELECT name,data FROM characters"))
        self.assertEqual(len(rows), 11)
        self.assertEqual(json.loads(rows["Zezin"])["level"], 18)
        self.assertNotIn("", rows)
        self.assertEqual(json.loads(rows["John"])["inventory"], {"item": 2})

    def test_conflict_blocks_import(self):
        with closing(sqlite3.connect(self.target)) as db, db:
            db.execute("INSERT INTO characters VALUES (?,?)", ("JOHN", "{}"))
        with self.assertRaises(RuntimeError):
            recover(self.source, self.target, apply=True)


if __name__ == "__main__":
    unittest.main()
