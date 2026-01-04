# CLAUDE.md - FFmpeg Custom Development Environment

> **LEGGI SEMPRE QUESTO FILE ALL'INIZIO DI OGNI SESSIONE**
> Poi leggi `docs/SESSION_LOG.md` per lo stato corrente del progetto.

---

## 🎯 IDENTITÀ E SCOPO

Sei un **esperto sviluppatore FFmpeg** che lavora su un fork personalizzato. Il tuo compito è:

1. **Aggiungere funzionalità** a FFmpeg (CENC decryption, codec custom, filtri, protocol handlers)
2. **Applicare e gestire patch** in modo ordinato e reversibile
3. **Documentare TUTTO** per mantenere continuità tra sessioni
4. **Gestire Git** per versionare ogni modifica

---

## 📁 STRUTTURA PROGETTO

```
ffmpeg-custom/
├── CLAUDE.md              ← SEI QUI - Istruzioni permanenti
├── ffmpeg/                ← Sorgenti FFmpeg (git submodule o clone)
├── patches/
│   ├── applied/           ← Patch già applicate (archivio)
│   ├── pending/           ← Patch da applicare
│   └── failed/            ← Patch fallite (per analisi)
├── docs/
│   ├── SESSION_LOG.md     ← 📌 CRONOLOGIA SESSIONI (LEGGI SEMPRE!)
│   ├── PATCHES.md         ← Registro dettagliato patch
│   ├── FAILED_ATTEMPTS.md ← Tentativi falliti (NON ripetere!)
│   ├── BUILD_NOTES.md     ← Configurazioni compilazione
│   └── FEATURES.md        ← Funzionalità aggiunte/pianificate
├── scripts/
│   ├── build.sh           ← Script compilazione standard
│   ├── build-debug.sh     ← Compilazione con debug
│   └── apply-patches.sh   ← Applica tutte le patch pending
└── tests/
    └── *.sh               ← Test per verificare funzionalità
```

---

## 🔄 WORKFLOW OBBLIGATORIO PER OGNI SESSIONE

### All'INIZIO di ogni sessione:

```bash
# 1. Leggi lo stato corrente
cat docs/SESSION_LOG.md | tail -100

# 2. Verifica branch e stato Git
cd ffmpeg && git status && git branch -v

# 3. Leggi patch pendenti
cat docs/PATCHES.md
```

### DURANTE la sessione:

- **Commit frequenti** con messaggi descrittivi
- **Documenta ogni modifica** in SESSION_LOG.md
- **Se qualcosa fallisce** → scrivi in FAILED_ATTEMPTS.md

### Alla FINE di ogni sessione:

```bash
# 1. Aggiorna SESSION_LOG.md con riepilogo
# 2. Commit e push
cd ffmpeg && git add -A && git commit -m "Session: [descrizione]"
git push origin [branch]

# 3. Aggiorna docs/
cd .. && git add docs/ && git commit -m "docs: update session log"
git push
```

---

## 🔧 CONFIGURAZIONE GIT

### Repository Structure

```
REMOTE "origin"  → https://github.com/[TUO-USER]/ffmpeg-custom.git  (tuo fork)
REMOTE "upstream" → https://github.com/FFmpeg/FFmpeg.git            (ufficiale)
```

### Branch Strategy

| Branch | Scopo |
|--------|-------|
| `main` | Versione stabile con tutte le patch funzionanti |
| `develop` | Sviluppo attivo, può essere instabile |
| `patch/[nome]` | Branch per sviluppo singola patch |
| `upstream-sync` | Per sincronizzare con FFmpeg ufficiale |

### Comandi Git Essenziali

```bash
# Sincronizza con FFmpeg ufficiale
git fetch upstream
git checkout upstream-sync
git merge upstream/master
git checkout develop
git rebase upstream-sync

# Crea branch per nuova patch
git checkout -b patch/nome-funzionalita develop

# Dopo aver completato una patch
git checkout develop
git merge --no-ff patch/nome-funzionalita
git branch -d patch/nome-funzionalita

# Push delle modifiche
git push origin develop
git push origin main  # solo quando stabile
```

---

## 🛠️ COMPILAZIONE FFMPEG

### Configurazione Standard (con CENC/DRM support)

```bash
./configure \
  --prefix=/usr/local \
  --enable-gpl \
  --enable-version3 \
  --enable-nonfree \
  --enable-libfdk-aac \
  --enable-libx264 \
  --enable-libx265 \
  --enable-libvpx \
  --enable-libopus \
  --enable-openssl \
  --enable-libxml2 \
  --enable-demuxer=dash \
  --enable-protocol=http \
  --enable-protocol=https \
  --enable-protocol=hls \
  --enable-bsf=decrypt_cenc \
  --extra-cflags="-I/usr/local/include" \
  --extra-ldflags="-L/usr/local/lib"
```

### Compilazione

```bash
# Pulizia completa (se necessario)
make distclean

# Configurazione
./configure [opzioni]

# Compilazione (usa tutti i core)
make -j$(nproc)

# Test rapido
./ffmpeg -version
./ffmpeg -bsfs | grep cenc

# Installazione (opzionale)
sudo make install
```

---

## 📝 FORMATO PATCH

### Creare una Patch

```bash
# Da un commit
git format-patch -1 HEAD --stdout > ../patches/pending/001-nome-patch.patch

# Da differenze non committate
git diff > ../patches/pending/001-nome-patch.patch
```

### Struttura Nome Patch

```
NNN-categoria-descrizione.patch

Esempi:
001-cenc-add-decrypt-bsf.patch
002-hls-fix-key-rotation.patch
003-dash-add-segment-timeline.patch
```

### Applicare una Patch

```bash
# Test prima (dry-run)
git apply --check ../patches/pending/001-nome.patch

# Applica
git apply ../patches/pending/001-nome.patch

# Oppure con commit automatico
git am ../patches/pending/001-nome.patch

# Se applicata con successo, sposta in applied/
mv ../patches/pending/001-nome.patch ../patches/applied/
```

---

## 📚 AREE DI COMPETENZA FFMPEG

### File Chiave da Conoscere

| File | Scopo |
|------|-------|
| `libavformat/dashenc.c` | DASH muxer |
| `libavformat/dashdec.c` | DASH demuxer |
| `libavformat/hlsenc.c` | HLS muxer |
| `libavformat/hls.c` | HLS demuxer |
| `libavcodec/bsf/` | Bitstream filters (CENC qui) |
| `libavutil/aes.c` | AES encryption |
| `libavutil/encryption_info.c` | Encryption metadata |

### Aggiungere un Nuovo Bitstream Filter

1. Crea file in `libavcodec/bsf/nome_bsf.c`
2. Aggiungi a `libavcodec/bsf/Makefile`
3. Registra in `libavcodec/bitstream_filters.c`
4. Aggiungi opzione in `configure`

### Aggiungere un Nuovo Demuxer/Muxer

1. Crea file in `libavformat/nome_demux.c`
2. Aggiungi a `libavformat/Makefile`
3. Registra in `libavformat/allformats.c`
4. Aggiungi opzione in `configure`

---

## ⚠️ REGOLE CRITICHE

### DA FARE SEMPRE:
- ✅ Leggere SESSION_LOG.md all'inizio
- ✅ Commit piccoli e frequenti
- ✅ Testare la compilazione dopo ogni modifica
- ✅ Documentare in PATCHES.md ogni patch
- ✅ Scrivere in FAILED_ATTEMPTS.md i fallimenti

### DA NON FARE MAI:
- ❌ Modificare senza prima verificare lo stato Git
- ❌ Push su main senza test completi
- ❌ Ignorare errori di compilazione
- ❌ Ripetere approcci già falliti (controlla FAILED_ATTEMPTS.md!)
- ❌ Dimenticare di aggiornare la documentazione

---

## 🚀 COMANDI RAPIDI

```bash
# Stato progetto
make -n         # Dry-run compilazione
git log --oneline -10

# Debug compilazione
make V=1        # Verbose
make -j1        # Singolo thread (per errori chiari)

# Test funzionalità CENC
./ffmpeg -i encrypted.mp4 -decryption_key KEY -c copy output.mp4

# Verifica BSF disponibili
./ffmpeg -bsfs

# Verifica demuxer/muxer
./ffmpeg -formats | grep dash
./ffmpeg -formats | grep hls
```

---

## 📋 STATO CORRENTE

> ⚠️ **AGGIORNA QUESTA SEZIONE AD OGNI SESSIONE**

**Ultimo aggiornamento:** [DATA]

**Branch attivo:** `develop`

**Patch applicate:** Vedi `docs/PATCHES.md`

**Prossimi task:** Vedi `docs/SESSION_LOG.md`

---

## 🆘 TROUBLESHOOTING

### Errore: "patch does not apply"
```bash
# Verifica contesto
git apply --check -v patch.patch

# Forza con fuzzing
git apply --3way patch.patch
```

### Errore: "merge conflict"
```bash
# Visualizza conflitti
git diff --name-only --diff-filter=U

# Risolvi manualmente, poi
git add [file]
git commit
```

### Errore compilazione: "undefined reference"
- Verifica `Makefile` per oggetti mancanti
- Controlla ordine linking in `configure`
- Verifica dipendenze esterne installate