# Konténer Image Módosítás - Dokumentáció

## Feladat összefoglalása

1. Konténer image letöltése publikus repository-ból
2. Az image kicsomagolása és módosítása
3. Származtatott image létrehozása a módosításokkal és elindítása

## Használt eszközök

### 1. Skopeo
- **Cél**: Docker image-ek letöltése és OCI formátumra konvertálása
- **Weboldal**: https://github.com/containers/skopeo
- **Leírás**: Parancssori eszköz konténer image-ek másolására különböző registry-k és formátumok között

### 2. Umoci
- **Cél**: OCI image-ek kicsomagolása, módosítása és újracsomagolása
- **Weboldal**: https://umo.ci/
- **Leírás**: Az OCI image specifikáció referencia implementációja

---

## Lépésről lépésre útmutató

### 1. lépés: Eszközök telepítése

#### Skopeo telepítése (Windows/WSL alatt vagy Linux)
```bash
# Ubuntu/Debian
sudo apt-get update
sudo apt-get install skopeo

# Vagy Go-val
go install github.com/containers/skopeo@latest
```

#### Umoci telepítése
```bash
# Go-val történő telepítés
go install github.com/opencontainers/umoci/cmd/umoci@latest

# Vagy GitHub releases-ről letöltve
# https://github.com/opencontainers/umoci/releases
```

---

### 2. lépés: Konténer image letöltése

Használjuk a skopeo-t egy Docker image letöltésére és OCI formátumra konvertálására:

```bash
# Szintaxis: skopeo copy docker://[registry]/[image]:[tag] oci:[local_directory]:[local_tag]

# Példa: Alpine Linux image letöltése
skopeo copy docker://alpine:latest oci:my-image:latest

# Példa: Ubuntu image letöltése
skopeo copy docker://ubuntu:22.04 oci:my-image:ubuntu
```

**Eredmény**: Létrejön egy `my-image` nevű könyvtár, ami az OCI image layout-ot tartalmazza.

---

### 3. lépés: Image kicsomagolása

Az umoci segítségével kicsomagoljuk az image-et egy runtime bundle-be:

```bash
# Szintaxis: umoci unpack --image [image_dir]:[tag] [bundle_dir]

# Példa
sudo umoci unpack --image my-image:latest bundle

# Eredmény: A bundle könyvtárban megjelenik:
# - rootfs/     - az image fájlrendszere
# - config.json - futtatási konfiguráció
# - umoci.json  - umoci metaadatok
```

**Megjegyzés**: Rootless módban (--rootless) nem szükséges sudo:
```bash
umoci unpack --rootless --image my-image:latest bundle
```

---

### 4. lépés: Az image módosítása

Most bármilyen módosítást végezhetünk a `bundle/rootfs` könyvtárban:

```bash
# Példa 1: Új fájl hozzáadása
echo "Hello from custom image!" > bundle/rootfs/custom-message.txt

# Példa 2: Konfiguráció módosítása
echo "Custom config" >> bundle/rootfs/etc/motd

# Példa 3: Új script létrehozása
cat > bundle/rootfs/usr/local/bin/my-script.sh << 'EOF'
#!/bin/sh
echo "Ez egy egyéni script!"
date
EOF
chmod +x bundle/rootfs/usr/local/bin/my-script.sh
```

---

### 5. lépés: Új (származtatott) image létrehozása

A módosítások után újracsomagoljuk az image-et:

```bash
# Szintaxis: umoci repack --image [image_dir]:[new_tag] [bundle_dir]

# Példa: Új tag létrehozása a módosított tartalommal
sudo umoci repack --image my-image:modified bundle

# Rootless módban:
umoci repack --rootless --image my-image:modified bundle
```

#### Image konfiguráció módosítása (opcionális)

```bash
# Szerző beállítása
umoci config --author="Az Én Nevem <email@example.com>" --image my-image:modified

# Munkakönyvtár beállítása
umoci config --config.workingdir="/app" --image my-image:modified

# Belépési pont beállítása
umoci config --config.entrypoint="/usr/local/bin/my-script.sh" --image my-image:modified

# Környezeti változó hozzáadása
umoci config --config.env="MY_VAR=ertek" --image my-image:modified
```

---

### 6. lépés: Az új image elindítása

#### a) runc használatával (OCI runtime)

```bash
# Kicsomagoljuk az új image-et
sudo umoci unpack --image my-image:modified run-bundle

# runc-cal futtatjuk
cd run-bundle
sudo runc run my-container
```

#### b) Docker-be importálás

Az OCI image visszakonvertálható Docker formátumra és betölthető:

```bash
# Skopeo-val konvertálás Docker daemon-ba
skopeo copy oci:my-image:modified docker-daemon:my-custom-image:latest

# Ezután Docker-rel futtatható
docker run -it my-custom-image:latest /bin/sh
```

#### c) Podman használatával

```bash
# Podman közvetlenül tudja kezelni az OCI image-eket
podman run -it oci:my-image:modified /bin/sh
```

---

## Garbage Collection (tisztítás)

Ha már nem szükséges régi rétegek, futtathatunk garbage collection-t:

```bash
umoci gc --layout my-image
```

---

## Teljes példa script

```bash
#!/bin/bash

# 1. Image letöltése
echo "Image letöltése..."
skopeo copy docker://alpine:latest oci:myimage:original

# 2. Kicsomagolás
echo "Image kicsomagolása..."
umoci unpack --rootless --image myimage:original bundle

# 3. Módosítás
echo "Módosítások végrehajtása..."
echo "Custom modification at $(date)" > bundle/rootfs/MODIFIED.txt

# 4. Újracsomagolás
echo "Új image létrehozása..."
umoci repack --rootless --image myimage:custom bundle

# 5. Konfiguráció
echo "Konfiguráció beállítása..."
umoci config --image myimage:custom \
    --author="Custom Builder" \
    --config.env="MODIFIED=true"

# 6. Docker-be exportálás
echo "Docker-be exportálás..."
skopeo copy oci:myimage:custom docker-daemon:my-custom-alpine:latest

echo "Kész! Futtasd: docker run -it my-custom-alpine:latest cat /MODIFIED.txt"
```

---

## Hasznos linkek

- **umoci dokumentáció**: https://umo.ci/
- **umoci quick start**: https://umo.ci/quick-start/
- **skopeo**: https://github.com/containers/skopeo
- **OCI image spec**: https://github.com/opencontainers/image-spec
- **runc**: https://github.com/opencontainers/runc

---

## Hibakeresés

### Gyakori problémák:

1. **Permission denied**: Használj `sudo`-t vagy `--rootless` flaget
2. **Image not found**: Ellenőrizd a tag nevét az `umoci ls --layout [image_dir]` paranccsal
3. **Skopeo hiba**: Ellenőrizd, hogy a registry elérhető-e és a kép létezik-e
