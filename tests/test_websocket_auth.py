"""Testes de integracao WebSocket: sem tocar na base real do jogador."""
import json
import os
import sqlite3
import sys
import tempfile
import unittest
from contextlib import closing
from pathlib import Path
from unittest.mock import patch

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "server"))

class WebSocketAuthenticationTests(unittest.TestCase):
    def test_requires_login_before_world_or_hero_list(self):
        try:
            from fastapi.testclient import TestClient
            import main
            from account_security import init_accounts, create_account
        except ImportError as exc:
            self.skipTest(f"Dependencia de teste indisponivel: {exc}")
        with tempfile.TemporaryDirectory() as directory:
            db_path = Path(directory) / "characters.sqlite3"
            with closing(sqlite3.connect(db_path)) as db, db:
                db.execute("CREATE TABLE characters (name TEXT PRIMARY KEY, data TEXT NOT NULL)")
                db.execute("INSERT INTO characters VALUES (?,?)", ("Zezin", json.dumps({"name":"Zezin","combat_class":"Mago"})))
            init_accounts(db_path)
            account = create_account(db_path, "principal", "senha-muito-forte-123")
            with closing(sqlite3.connect(db_path)) as db, db:
                db.execute("INSERT INTO character_owners VALUES (?,?)", ("Zezin", account))
            with patch.object(main, "DB_PATH", db_path), patch.dict(os.environ, {"TRONO_REQUIRE_AUTH":"1"}):
                # O lifespan do jogo pode depender do mundo real; nao iniciar o servidor de simulacao.
                with TestClient(main.app) as client:
                    with client.websocket_connect("/ws") as ws:
                        self.assertEqual(ws.receive_json()["type"], "auth_required")
                        ws.send_json({"type":"list_heroes"})
                        self.assertEqual(ws.receive_json()["type"], "auth_required")
                        ws.send_json({"type":"auth_login","username":"principal","password":"errada"})
                        self.assertEqual(ws.receive_json()["type"], "auth_error")
                        ws.send_json({"type":"auth_login","username":"principal","password":"senha-muito-forte-123"})
                        response = ws.receive_json()
                        self.assertEqual(response["type"], "auth_ok")
                        self.assertTrue(response.get("token"))
                        self.assertEqual(ws.receive_json()["type"], "welcome")
                        # Mensagens iniciais de notice/status/join podem seguir.
                        for _ in range(8):
                            ws.send_json({"type":"list_heroes"})
                            message = ws.receive_json()
                            if message.get("type") == "hero_list":
                                self.assertEqual([h["name"] for h in message["heroes"]], ["Zezin"])
                                break
                        else:
                            self.fail("hero_list nao recebida")

if __name__ == "__main__":
    unittest.main()
