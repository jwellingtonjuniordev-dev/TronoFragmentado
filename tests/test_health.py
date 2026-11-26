"""Teste de fumaça do servidor local. Biblioteca padrão; não altera SQLite.

Uso (servidor já iniciado):
    python -m unittest discover -s tests -p 'test_health.py' -v
Opcional: TRONO_BASE_URL=http://127.0.0.1:8000
"""
import json
import os
import unittest
from urllib.error import HTTPError, URLError
from urllib.request import urlopen


class HealthSmokeTest(unittest.TestCase):
    def test_health_reports_ok_and_nonnegative_players(self):
        base_url = os.environ.get("TRONO_BASE_URL", "http://127.0.0.1:8000").rstrip("/")
        try:
            with urlopen(base_url + "/health", timeout=5) as response:
                self.assertEqual(response.status, 200)
                payload = json.load(response)
        except (HTTPError, URLError) as exc:
            self.fail("Servidor indisponível. Inicie-o antes do teste: " + str(exc))

        self.assertEqual(payload.get("status"), "ok")
        self.assertIsInstance(payload.get("players"), int)
        self.assertGreaterEqual(payload["players"], 0)
        self.assertIsInstance(payload.get("version"), str)
        self.assertTrue(payload["version"])


if __name__ == "__main__":
    unittest.main()
