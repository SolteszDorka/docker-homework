# 🐳 Docker Image Módosítás - Házi Feladat

> Konténer image letöltése, módosítása és származtatott image létrehozása

---

## 📋 Feladat

1. ✅ Konténer image letöltése publikus repository-ból
2. ✅ Az image kicsomagolása és módosítása
3. ✅ Származtatott image létrehozása és elindítása

---

## 🛠️ Használt Eszközök

| Eszköz | Verzió | Leírás |
|--------|--------|--------|
| Docker | latest | Konténer kezelés |
| Alpine Linux | latest | Alap image (~13 MB) |

### Alternatív eszközök (dokumentálva):
- **[umoci](https://umo.ci/)** - OCI image manipuláció
- **[skopeo](https://github.com/containers/skopeo)** - Image másolás registry-k között

---

## 🚀 Gyors Indítás

### 1. Repository klónozása
```bash
git clone https://github.com/SolteszDorka/docker-homework.git
cd docker-homework
```

### 2. Származtatott image építése
```bash
docker build -t my-custom-alpine:v1 .
```

### 3. Konténer futtatása
```bash
docker run my-custom-alpine:v1
```

### Várt kimenet:
```
==========================================
  Üdvözöl a módosított Alpine konténer!
==========================================

Készítve: [dátum]
Hostname: [container-id]

Ez a script bizonyítja, hogy sikeresen:
  1. Letöltöttük az eredeti image-et
  2. Kicsomagoltuk és módosítottuk
  3. Létrehoztuk a származtatott image-et
```

---

## 📁 Projekt Struktúra

```
docker-homework/
├── README.md                    # Ez a fájl
├── Dockerfile                   # Image építési utasítások
├── my-script.sh                 # Egyéni script a konténerben
├── DOKUMENTACIO.md              # Részletes elméleti dokumentáció
├── GYAKORLATI_MEGVALOSITAS.md   # Gyakorlati útmutató
└── OSSZEFOGLALO.md              # Feladat összefoglaló
```

---

## 🔧 Dockerfile Magyarázat

```dockerfile
# Alap image
FROM alpine:latest

# Metaadatok
LABEL maintainer="Felhasználó"
LABEL description="Módosított Alpine image"

# Csomagok telepítése
RUN apk update && apk add --no-cache bash curl

# Egyéni fájlok hozzáadása
RUN echo "Ez a fájl bizonyítja, hogy az image módosítva lett!" > /MODIFIED.txt
COPY my-script.sh /usr/local/bin/my-script.sh
RUN chmod +x /usr/local/bin/my-script.sh

# Alapértelmezett parancs
CMD ["/usr/local/bin/my-script.sh"]
```

---

## 📊 Image Összehasonlítás

| Image | Méret | Módosítások |
|-------|-------|-------------|
| `alpine:latest` | ~13 MB | Eredeti |
| `my-custom-alpine:v1` | ~24 MB | + bash, curl, egyéni scriptek |

---

## 📚 További Dokumentáció

- [DOKUMENTACIO.md](DOKUMENTACIO.md) - Részletes elméleti háttér (umoci, skopeo)
- [GYAKORLATI_MEGVALOSITAS.md](GYAKORLATI_MEGVALOSITAS.md) - Docker-alapú megvalósítás részletei

---

## 🔗 Hasznos Linkek

- [umoci dokumentáció](https://umo.ci/)
- [skopeo GitHub](https://github.com/containers/skopeo)
- [OCI Image Specification](https://github.com/opencontainers/image-spec)
- [Docker dokumentáció](https://docs.docker.com/)

---

## 📝 Licenc

MIT License
