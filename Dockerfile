# Dockerfile - Származtatott Alpine image
# 
# Ez a Dockerfile bemutatja, hogyan lehet egy alap image-ből
# egyéni, módosított image-et létrehozni.

# 1. LÉPÉS: Alap image kiválasztása
# Az alpine:latest egy minimális Linux disztribúció (~5MB)
FROM alpine:latest

# 2. LÉPÉS: Metaadatok hozzáadása
LABEL maintainer="Felhasználó"
LABEL version="1.0"
LABEL description="Módosított Alpine image - demonstrációs célra"

# 3. LÉPÉS: Rendszer frissítése és csomagok telepítése
# Ez egy új réteget hoz létre az image-ben
RUN apk update && apk add --no-cache \
    bash \
    curl \
    && rm -rf /var/cache/apk/*

# 4. LÉPÉS: Egyéni fájlok hozzáadása
# Hozzáadunk egy üzenetet, ami bizonyítja a módosítást
RUN echo "Ez a fájl bizonyítja, hogy az image módosítva lett!" > /MODIFIED.txt
RUN echo "Készült: $(date)" >> /MODIFIED.txt

# 5. LÉPÉS: Egyéni script másolása
COPY my-script.sh /usr/local/bin/my-script.sh
RUN chmod +x /usr/local/bin/my-script.sh

# 6. LÉPÉS: Munkadírektórium beállítása
WORKDIR /app

# 7. LÉPÉS: Alapértelmezett parancs beállítása
# Ez a parancs fut le, ha a konténert paraméter nélkül indítjuk
CMD ["/usr/local/bin/my-script.sh"]
