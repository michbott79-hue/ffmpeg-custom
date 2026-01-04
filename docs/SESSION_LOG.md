# Session Log

> Cronologia delle sessioni di lavoro sul progetto FFmpeg Custom

---

## 2026-01-04 - Sessione 1: Setup Iniziale

### Obiettivi
- [x] Creare repository GitHub
- [x] Configurare struttura progetto
- [x] Clonare FFmpeg ufficiale
- [x] Prima compilazione di test

### Attività Svolte
- Installato GitHub CLI (`gh`) con Homebrew
- Creato repository `ffmpeg-custom` su GitHub: https://github.com/michbott79-hue/ffmpeg-custom
- Inizializzata struttura directory (patches/, docs/, scripts/, tests/)
- Configurato CLAUDE.md con istruzioni progetto
- Clonato FFmpeg ufficiale (master)
- Installate dipendenze: nasm, yasm, x264, x265, libvpx, opus, openssl, libxml2
- Prima compilazione completata con successo

### Build Info
```
ffmpeg version git-2026-01-04-521209b
Configuration: --enable-gpl --enable-version3 --enable-nonfree
               --enable-libx264 --enable-libx265 --enable-libvpx
               --enable-libopus --enable-openssl --enable-libxml2
```

### Funzionalità Verificate
- DASH muxer/demuxer: ✓
- HLS muxer/demuxer: ✓
- Codec: x264, x265, libvpx, opus

### Stato Fine Sessione
- **Branch attivo:** `main`
- **FFmpeg compilato:** `ffmpeg/ffmpeg`
- **Prossimi step:** Aggiungere supporto CENC decryption

### Note
Setup iniziale completato. FFmpeg compila correttamente.

---

## 2026-01-04 - Sessione 2: CENC Multi-Key Decryption

### Obiettivi
- [x] Implementare supporto CENC multi-key
- [x] Formato chiavi: KID:KEY,KID2:KEY2
- [x] Compilare e verificare

### Attività Svolte
- Creata patch `001-cenc-multikey-decrypt.patch`
- Modificato `libavformat/dashdec.c` per parsing multi-key
- Modificato `libavformat/mov.c` con funzione `get_key_from_kid()`
- Aggiunto campo `decryption_keys` a `MOVContext` in `isom.h`
- Supporto per tutti gli schemi: cenc, cbc1, cens, cbcs
- Compilazione completata con successo

### Patch Applicata
```
001-cenc-multikey-decrypt.patch (269 righe)
```

### Uso
```bash
# Multi-key
./ffmpeg -cenc_decryption_key "KID1:KEY1,KID2:KEY2" -i input.mpd -c copy out.mp4

# Singola key (retrocompatibile)
./ffmpeg -cenc_decryption_key "0123456789abcdef" -i input.mpd -c copy out.mp4
```

### Stato Fine Sessione
- **Branch attivo:** `main`
- **Patch applicate:** 1 (001-cenc-multikey-decrypt)
- **Prossimi step:** Test con contenuti reali, eventuali fix

### Note
Prima funzionalità custom implementata. Il sistema multi-key seleziona automaticamente la chiave corretta in base al KID del sample.

---
