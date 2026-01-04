# Registro Patch

> Elenco di tutte le patch create, applicate e gestite nel progetto

---

## Patch Applicate

| ID | Nome | Descrizione | Data | Stato |
|----|------|-------------|------|-------|
| 001 | cenc-multikey-decrypt | Supporto multi-key CENC (KID:KEY,KID2:KEY2) | 2026-01-04 | Applicata |
| 002 | http-proxy-preemptive-auth | Fix autenticazione proxy preemptive | 2026-01-04 | Applicata |

---

## Patch Pendenti

| ID | Nome | Descrizione | Priorità |
|----|------|-------------|----------|
| - | - | Nessuna patch pendente | - |

---

## Dettagli Patch

### 001-cenc-multikey-decrypt.patch

**Descrizione:** Aggiunge supporto per decryption CENC con chiavi multiple.

**Formato:** `KID1:KEY1,KID2:KEY2`
- `:` separa KID da KEY
- `,` separa le coppie

**File modificati:**
- `libavformat/dashdec.c` - Parsing multi-key per DASH demuxer
- `libavformat/mov.c` - Funzione `get_key_from_kid()` e modifiche a cenc/cbc1/cens/cbcs
- `libavformat/isom.h` - Aggiunto campo `decryption_keys` a MOVContext

**Uso:**
```bash
# DASH con chiavi multiple
./ffmpeg -cenc_decryption_key "KID1:KEY1,KID2:KEY2" -i input.mpd -c copy output.mp4

# Singola chiave (retrocompatibile)
./ffmpeg -cenc_decryption_key "0123456789abcdef0123456789abcdef" -i input.mpd -c copy output.mp4
```

---

### 002-http-proxy-preemptive-auth.patch

**Descrizione:** Fix per autenticazione HTTP proxy con invio preemptive delle credenziali.

**Problema risolto:** Alcuni proxy inviano `Proxy-Authenticate: Basic` senza spazio finale, causando fallimento del parser reattivo di FFmpeg.

**Soluzione:** Invio preemptivo dell'header `Proxy-Authorization` alla prima richiesta CONNECT.

**File modificati:**
- `libavformat/http.c` - Aggiunta logica preemptive auth in `http_proxy_open()`

**Uso:**
```bash
./ffmpeg -http_proxy 'http://user:pass@proxy:port' -i https://... -c copy output.mp4
```

---

## Come Aggiungere una Patch

1. Crea la patch: `git format-patch -1 HEAD --stdout > patches/pending/NNN-nome.patch`
2. Aggiungi entry in questa tabella
3. Applica: `git apply patches/pending/NNN-nome.patch`
4. Se successo, sposta in `patches/applied/` e aggiorna stato

---
