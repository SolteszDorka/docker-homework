# Gyakorlati Megvalósítás - Docker Alapú Megközelítés

Ez a dokumentum bemutatja, hogyan lehet Windows környezetben (Docker Desktop-tal) 
végrehajtani a feladatot: image letöltése, módosítása és származtatott image létrehozása.

## A Folyamat Áttekintése

```
┌─────────────────────┐     ┌─────────────────────┐     ┌─────────────────────┐
│  1. Image letöltés  │ ──► │  2. Módosítások    │ ──► │  3. Új image       │
│    (docker pull)    │     │   végrehajtása     │     │    létrehozása     │
└─────────────────────┘     └─────────────────────┘     └─────────────────────┘
                                    │                            │
                                    ▼                            ▼
                            ┌───────────────┐           ┌───────────────┐
                            │  Dockerfile   │           │ docker commit │
                            │    alapú      │           │    alapú      │
                            └───────────────┘           └───────────────┘
```

## 1. Módszer: Dockerfile használata (ajánlott)

### 1.1 Base image kiválasztása és letöltése

```powershell
# Alpine Linux - kisméretű, egyszerű
docker pull alpine:latest

# Ubuntu - teljes funkcionalitású
docker pull ubuntu:22.04
```

### 1.2 Dockerfile létrehozása

Hozzuk létre a Dockerfile-t:

```dockerfile
# Alap image megadása
FROM alpine:latest

# Metaadatok
LABEL maintainer="Az Én Nevem"
LABEL description="Módosított Alpine image"

# Módosítások végrehajtása
RUN echo "Ez egy egyéni üzenet!" > /custom-message.txt
RUN apk add --no-cache curl vim

# Egyéni script hozzáadása
COPY my-script.sh /usr/local/bin/my-script.sh
RUN chmod +x /usr/local/bin/my-script.sh

# Alapértelmezett parancs
CMD ["/bin/sh"]
```

### 1.3 Származtatott image építése

```powershell
# A Dockerfile könyvtárában:
docker build -t my-custom-alpine:v1 .
```

### 1.4 Az új image futtatása

```powershell
# Interaktív futtatás
docker run -it my-custom-alpine:v1

# Vagy a custom message megtekintése
docker run my-custom-alpine:v1 cat /custom-message.txt
```

---

## 2. Módszer: Docker commit használata (gyors prototípus)

### 2.1 Konténer indítása az eredeti image-ből

```powershell
docker run -it --name modify-container alpine:latest /bin/sh
```

### 2.2 Módosítások végrehajtása a konténerben

```bash
# A konténeren belül:
echo "Egyéni módosítás!" > /my-custom-file.txt
apk add --no-cache python3
exit
```

### 2.3 A módosított konténer mentése új image-ként

```powershell
docker commit -m "Egyéni módosítások" -a "Szerző neve" modify-container my-custom-image:v1
```

### 2.4 Az új image futtatása

```powershell
docker run -it my-custom-image:v1 /bin/sh
```

### 2.5 Takarítás

```powershell
docker rm modify-container
```

---

## 3. Módszer: Image exportálás és importálás (fájlszintű módosítás)

### 3.1 Konténer fájlrendszerének exportálása

```powershell
# Létrehozunk egy konténert
docker create --name temp-container alpine:latest

# Exportáljuk a fájlrendszert
docker export temp-container -o image-filesystem.tar
```

### 3.2 Fájlrendszer módosítása

```powershell
# Kicsomagolás
mkdir extracted
tar -xf image-filesystem.tar -C extracted

# Módosítások (például új fájl hozzáadása)
echo "Modified at $(Get-Date)" > extracted\custom.txt

# Újracsomagolás
tar -cf modified-filesystem.tar -C extracted .
```

### 3.3 Új image importálása

```powershell
docker import modified-filesystem.tar my-modified-image:v1
```

### 3.4 Takarítás

```powershell
docker rm temp-container
Remove-Item -Recurse extracted
Remove-Item image-filesystem.tar, modified-filesystem.tar
```

---

## Összehasonlítás

| Módszer | Előnyök | Hátrányok |
|---------|---------|-----------|
| **Dockerfile** | Reprodukálható, verziókezelhető | Több lépés szükséges |
| **Docker commit** | Gyors, egyszerű | Nem dokumentált változások |
| **Export/Import** | Teljes kontroll a fájlok felett | Metadata elvész |

---

## Hasznos Parancsok

```powershell
# Image-ek listázása
docker images

# Konténerek listázása (futók és állók)
docker ps -a

# Image törlése
docker rmi image-name:tag

# Image részleteinek megtekintése
docker inspect image-name:tag

# Image history (rétegek)
docker history image-name:tag
```
