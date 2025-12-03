# Feladat Megoldás Összefoglaló

## ✅ SIKERESEN ELVÉGZETT FELADAT

### A feladat:
1. Konténer image letöltése publikus repository-ból
2. Az image kicsomagolása és módosítása
3. Származtatott image létrehozása a módosításokkal és elindítása

---

## Végrehajtott lépések:

### 1. ✅ Alap image letöltése
```
Image: alpine:latest
Méret: ~13 MB
```

### 2. ✅ Módosítások előkészítése
Létrehoztuk:
- `Dockerfile` - az image építési utasításokat tartalmazza
- `my-script.sh` - egyéni script ami a konténerben fut

### 3. ✅ Származtatott image létrehozása
```
docker build -t my-custom-alpine:v1 .
```
A módosítások:
- bash és curl telepítése
- `/MODIFIED.txt` fájl hozzáadása
- Egyéni script bemásolása
- Metaadatok beállítása

### 4. ✅ Az új konténer futtatása
A konténer sikeresen futott és a következő kimenetet adta:

```
==========================================
  Üdvözöl a módosított Alpine konténer!
==========================================

Készítve: Wed Dec  3 15:42:31 UTC 2025
Hostname: a0c2d2c4afea

Ez a script bizonyítja, hogy sikeresen:
  1. Letöltöttük az eredeti image-et
  2. Kicsomagoltuk és módosítottuk
  3. Létrehoztuk a származtatott image-et
```

---

## Létrehozott fájlok:

| Fájl | Leírás |
|------|--------|
| `DOKUMENTACIO.md` | Részletes elméleti dokumentáció |
| `GYAKORLATI_MEGVALOSITAS.md` | Gyakorlati útmutató |
| `Dockerfile` | Az image építési utasításai |
| `my-script.sh` | Egyéni script a konténerben |
| `OSSZEFOGLALO.md` | Ez a fájl |

---

## Image-ek összehasonlítása:

| Image | Méret | Leírás |
|-------|-------|--------|
| `alpine:latest` | 13 MB | Eredeti, módosítatlan |
| `my-custom-alpine:v1` | 24 MB | Módosított verzió (bash, curl, egyéni fájlok) |

---

## Hasznos parancsok a továbbiakhoz:

```powershell
# Az új image futtatása interaktív módban
docker run -it my-custom-alpine:v1 /bin/bash

# A MODIFIED.txt tartalmának megtekintése
docker run my-custom-alpine:v1 cat /MODIFIED.txt

# Az image rétegeinek megtekintése
docker history my-custom-alpine:v1

# Takarítás
docker rm demo-modified-container
docker rmi my-custom-alpine:v1
```
