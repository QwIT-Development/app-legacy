# <img src="https://github.com/user-attachments/assets/dadb8ed3-7073-4591-a004-0d4c646fa963" alt width="100px"> A Firka IPA fájlainak telepítéséhez kövesd ezt a útmutatót.

## WSF metódus (**FONTOS**: az iPhoneodon csináld.)

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
- Töltsd le a Firka IPA fájlt a Firka [Github repojából](https://github.com/QwIT-Development/app-legacy/releases/latest)
- Nyisd meg az **ESignt**
- Az `Import` gombbal importáld a Firka IPA fájlt
- Nyomj rá a fájlra, majd válaszd az `Import App Library` opciót
- Menj az `Apps` fülre
- Nyomj a Firka appra, majd a `Signature` opcióra
- Kapcsold be az `Install After Signed` opciót
- Nyomj a piros `Signature` gombra
- Amikor megjelenik az "*esign.yyyue.xyz* would like to Install **Firka**" üzenet, nyomj a **Telepítés/Install** gombra
- Várj, amíg befejeződik a telepítés
- Menj a kezdőképernyőre és nyisd meg a Firkát

## Kreditek
- **A Firka csapat**: Az app zöld verziójának fejlesztői
    - Discord: [https://discord.gg/6awUPSMFKe](https://discord.gg/6awUPSMFKe)
    - GitHub: [https://github.com/QwIT-Development/app-legacy](https://github.com/QwIT-Development/app-legacy)
- **WSF**: A Permanent Signing lehetővé tétele
    - X (korábban Twitter): [https://x.com/wsf_team](https://x.com/wsf_team)