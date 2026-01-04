# Registro Patch

> Elenco di tutte le patch create, applicate e gestite nel progetto

---

## Patch Applicate

| ID | Nome | Descrizione | Data | Stato |
|----|------|-------------|------|-------|
| - | - | Nessuna patch ancora applicata | - | - |

---

## Patch Pendenti

| ID | Nome | Descrizione | Priorità |
|----|------|-------------|----------|
| - | - | Nessuna patch pendente | - |

---

## Come Aggiungere una Patch

1. Crea la patch: `git format-patch -1 HEAD --stdout > patches/pending/NNN-nome.patch`
2. Aggiungi entry in questa tabella
3. Applica: `git apply patches/pending/NNN-nome.patch`
4. Se successo, sposta in `patches/applied/` e aggiorna stato

---
