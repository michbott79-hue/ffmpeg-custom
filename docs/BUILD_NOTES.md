# Note di Compilazione

> Configurazioni e note per la compilazione di FFmpeg

---

## Dipendenze Richieste (macOS)

```bash
brew install nasm yasm pkg-config
brew install x264 x265 libvpx opus fdk-aac
brew install openssl libxml2
```

---

## Configurazione Standard

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
  --enable-protocol=hls
```

---

## Compilazione

```bash
# Pulizia (se necessario)
make distclean

# Configura
./configure [opzioni]

# Compila
make -j$(sysctl -n hw.ncpu)

# Verifica
./ffmpeg -version
```

---

## Problemi Noti

*Nessun problema ancora documentato.*

---
