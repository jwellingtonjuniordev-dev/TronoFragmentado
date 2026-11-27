"""Recupera 10 personagens legados sem substituir a base atual.

Por padrao: simulacao SEM escrita. --apply faz backup e importa em transacao.
Executar com o jogo e servidor fechados.
"""
import argparse
import json
import re
import sqlite3
from contextlib import closing
from pathlib import Path

from prepare_account_migration import audit_and_backup

EXPECTED = frozenset({"John", "Jonh", "Agon", "Athena", "Morgana",
                      "Mistery", "Merlin", "Pixel", "Junin", "Junior"})
NAME_RE = re.compile(r"^[A-Za-z0-9_]{3,20}$")


def _read_rows(path):
    path = Path(path).expanduser().resolve()
    if not path.is_file():
        raise FileNotFoundError(path)
    with closing(sqlite3.connect(f"file:{path.as_posix()}?mode=ro", uri=True)) as db:
        if db.execute("PRAGMA integrity_check").fetchone()[0] != "ok":
            raise RuntimeError(f"SQLite com falha de integridade: {path}")
        return db.execute("SELECT name, data FROM characters").fetchall()


def recover(source, target, apply=False):
    source, target = Path(source).expanduser().resolve(), Path(target).expanduser().resolve()
    if source == target:
        raise ValueError("Origem e destino nao podem ser iguais")
    source_rows, target_rows = _read_rows(source), _read_rows(target)
    source_names = [name for name, _ in source_rows]
    if len(source_names) != len(set(n.casefold() for n in source_names)):
        raise RuntimeError("Nomes duplicados na origem, ignorando maiusculas/minusculas")
    candidates = {}
    for name, raw in source_rows:
        if name not in EXPECTED:
            continue
        if not NAME_RE.fullmatch(name):
            raise RuntimeError(f"Nome invalido: {name!r}")
        data = json.loads(raw)
        if not isinstance(data, dict) or data.get("name") != name:
            raise RuntimeError(f"Dados inconsistentes do personagem {name!r}")
        candidates[name] = raw
    if set(candidates) != EXPECTED:
        raise RuntimeError(f"Personagens esperados ausentes: {sorted(EXPECTED-set(candidates))}")
    existing = {name.casefold() for name, _ in target_rows}
    collisions = sorted(name for name in candidates if name.casefold() in existing)
    if collisions:
        raise RuntimeError(f"Conflito de nomes; nenhuma importacao efetuada: {collisions}")
    if "zezin" not in existing:
        raise RuntimeError("Zezin nao encontrado no destino; abortado por seguranca")
    plan = {"source": str(source), "target": str(target),
            "characters_to_import": sorted(candidates),
            "excluded_unnamed": sum(not str(name).strip() for name in source_names),
            "target_before": len(target_rows), "target_after": len(target_rows) + len(candidates),
            "mode": "apply" if apply else "dry_run"}
    if not apply:
        return plan
    # O backup e criado antes de abrir qualquer transacao de escrita.
    backup = audit_and_backup(target)
    plan["backup"] = backup["backup"]
    plan["backup_report"] = backup["report"]
    with closing(sqlite3.connect(str(target), timeout=15)) as db:
        db.execute("BEGIN IMMEDIATE")
        try:
            current_rows = db.execute("SELECT name, data FROM characters").fetchall()
            if current_rows != target_rows:
                raise RuntimeError("A base mudou desde a simulacao; importacao cancelada")
            for name, raw in candidates.items():
                db.execute("INSERT INTO characters(name, data) VALUES (?,?)", (name, raw))
            new_rows = db.execute("SELECT name, data FROM characters").fetchall()
            if len(new_rows) != plan["target_after"]:
                raise RuntimeError("Contagem inesperada apos importacao")
            before = dict(target_rows)
            after = dict(new_rows)
            if any(after.get(name) != raw for name, raw in before.items()):
                raise RuntimeError("Personagem existente foi alterado")
            if any(after.get(name) != raw for name, raw in candidates.items()):
                raise RuntimeError("Falha na verificacao de personagem importado")
            if db.execute("PRAGMA quick_check").fetchone()[0] != "ok":
                raise RuntimeError("Verificacao de integridade falhou")
            db.commit()
        except Exception:
            db.rollback()
            raise
    plan["verified"] = True
    return plan


def main():
    parser = argparse.ArgumentParser(description="Recuperacao segura dos 10 herois legados")
    parser.add_argument("--source", type=Path, default=Path(r"C:\Projects\TronoFragmentado\data\characters.sqlite3"))
    parser.add_argument("--target", type=Path, default=Path.home() / "TronoFragmentado" / "data" / "characters.sqlite3")
    parser.add_argument("--apply", action="store_true", help="Efetiva a importacao apos backup; padrao e simular")
    args = parser.parse_args()
    print(json.dumps(recover(args.source, args.target, args.apply), ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
