# <img src="https://github.com/user-attachments/assets/dadb8ed3-7073-4591-a004-0d4c646fa963" alt width="100px"> A Firka IPA fájlainak telepítéséhez kövesd ezt az útmutatót.

Kettő lehetőséged van a Firka telepítésére:
- [Feather](#1-feather-metódus) - Fizetős, nem kell gép hozzá, 1 évre érvényes (a cert nem kell)
- [ESign](#2-esign-metódus) - Ingyenes, nem kell gép hozzá, örökre


## 1. Feather metódus

### 1. A .p12 és .mobileprovision beszerzése
   - Vegyél certet a [kravasign.com](https://kravasign.com) oldalon
   - Várnod kell kis időt (általában 72 óra)
   - Csatlakozz a Discord szerverükhöz és nyiss egy ticketet a rendelési számoddal

### 2. A várakozás után kapsz egy letöltési linket egy zip fájlhoz, ami három dolgot tartalmaz:
   - .p12 
   - .mobileprovision 
   - Egy mappa a tanúsítvány jelszavával

### 3. Töltsd le a legújabb Feather ipa-t innen: https://github.com/khcrysalis/Feather/releases
### 4. Telepítés:
   - Menj a sign.kravasign.com oldalra
   - Töltsd fel a szükséges fájlokat:
     - .p12
     - .mobileprovision
     - feather.ipa
     - Add meg a tanúsítvány jelszavát
   - Nyomd meg az `Upload and Sign` gombot, és várj, ez egy kis ideig eltarthat

### 5. Certificate importálása:
   - Menj a `Settings` fülre és kattints a `Add Certificate` gombra
   - Kattints a `+`-ra és importáld a .mobileprovision-t a .p12-t és írd be a .p12 jelszavát aztán kattints a `Save` gombra

### 6. Firka telepítése:
   - Amint telepített a Feather, nyisd meg és menj a `Sources` fülre alul
   - Kattints a `Add Repo` gombra és másold be hogy `https://raw.githubusercontent.com/spitkov/firkarepo/refs/heads/main/feather.json` és kattints az `Add` gombra
   - Menj a `Firka Repository` menüpontra és kattints a letöltésre
   - Ha letöltött menj a `Library` fülre és kattints a Firka appra azután `Sign Firka` aztán `Start Signing`
   - A Signed Apps alatt látni fogod a firkát kattints rá és `Install Firka`

## 2. ESign metódus

### 1. DNS profil telepítése
- Nyisd meg az [Ultimate Sideloading Guide by WSF](https://whysoooofurious.netlify.app/) weboldalt a Safariban
- Nyomj rá a `Downloads` gombra, majd a `Config Profiles` gombra
- Válaszd a `madNS` profilt
- A profil letöltése után nyisd meg a **Beállításokat**
- A neved alatt megjelenik a **Profil Letöltve** (vagy angolul: **Profile Downloaded**)
- Nyomj rá, majd nyomd meg a **Telepítés/Install** gombot
- Kövesd az utasításokat (a felugró ablakokon nyomd a **Következő/Next** gombot)
- A telepítés után görgess le az **Általános/General** menüpontra
- Nyomj a **VPN, DNS, és eszközfelügyelet** (vagy iOS 18-ban: **VPN és eszközfelügyelet**) opcióra
- Válaszd a **DNS** opciót és válassz egyet a lehetőségek közül:
    - **Sima**: Ajánlott, alap funkcionalitás
    - **AdBlock**: Letiltja a reklámokat (néhány script is letiltásra kerülhet, ami problémákat okozhat)
    - **OTA blocker**: Letiltja az Over-The-Air (rendszer) frissítéseket

### 2. Tanúsítványok telepítése
- Menj vissza a korábban megnyitott weboldalra
- Nyomj a `Certificates` gombra, majd újra a `Certificates` opcióra
- Engedélyezd a fájl letöltését
- Töltsd le és csomagold ki a ZIP fájlt

### 3. Portal telepítése
- Menj vissza a letöltési oldalra
- Nyomj a `Portal` gombra
- Próbáld meg a `Portal - Continent` opciót
- Ha "*Integritás nem ellenőrizhető*" hibát kapsz, próbáld a többi lehetőséget
- Ha az **Avex** működik, csak azt az egy appot választhatod
- Ha egyik sem működik, feketelistán lehetsz - írj a Firka Discord szerverbe segítségért

### 4. ESign telepítése
- Nyisd meg a **Portal**t
- Menj végig a beállítási folyamaton
- Navigálj a `Downloads` fülre
- Ha az **Avex**et választottad a **Portal** telepítésekor, csak az **ESign** opciót választhatod (a Firka ezt ajánlja)
- Nyomd meg az **ESign** opciót, majd telepítsd ugyanúgy, mint a **Portal**t
- Nyisd meg az **ESignt** és fogadd el a licencszerződést

### 5. Tanúsítványok importálása
- A fájlnézetben nyomj a három pontra a sarokban
- Válaszd az `Import` opciót
- Navigálj a korábban letöltött és kicsomagolt mappához
- Nyisd meg azt a mappát, ami a Portal letöltési helyének nevét viseli
- Válaszd ki a "*cert_neve.p12*" fájlt és importáld
- Nyomj újra a három pontra, válaszd az `Import` opciót
- Importáld a *.mobileprovision* fájlt is ugyanabból a mappából
- A fájlnézetben nyomj rá a "*cert_neve.p12*" fájlra
- Válaszd az `Import certificate management` opciót
- Add meg a jelszót: `WSF`

### 6. Firka telepítése
- Menj az `AppStore` fülre alul aztán bal felül kattints az `App Source` gombra azután jobb felül kattints az +-ra és másold be hogy `https://raw.githubusercontent.com/spitkov/firkarepo/refs/heads/main/esign.json`
- Menj vissza és az AppStore fülben látni fogod a Firká-t
- Kattints hogy `Download`
- A `Download` fülben láthatod a letöltést, ha letöltött kattints rá és nyomd meg a `Import App Library` gombot
- Azután menj a `Apps` fülre és válaszd ki a Firkát kattints a `Signature`-re aztán megint `Signature` (fontos ne lépj ki az esign-bol amíg nem jelentek meg az `Install` és az `Exit` gombok)
- Ha végzett kattints az `Install` gombra és fel fog jönni egy kis menü hogy esign.yyyue.xyz telepíteni akarja a Firkát akkor kattints arra hogy Telepítés
- És kész is 🎉

## Kreditek
- **A Firka csapat**: Az app zöld verziójának fejlesztői
    - Discord: [https://discord.gg/6awUPSMFKe](https://discord.gg/6awUPSMFKe)
    - GitHub: [https://github.com/QwIT-Development/app-legacy](https://github.com/QwIT-Development/app-legacy)
- **WSF**: A Permanent Signing lehetővé tétele
    - X (korábban Twitter): [https://x.com/wsf_team](https://x.com/wsf_team)
