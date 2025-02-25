
# Hozzájárulási útmutató
Köszönjük, ha programozással segíted a munkánkat!\
A folytatáshoz szükséged lesz egy MacOS-t, Linux-ot vagy Windows-t futtató számítógépre, minimális programozási tapasztalatra és egy kis angoltudásra.\
Segít, ha már gyakorlottabb vagy a programozásban, és ha ismered a [Git](https://git-scm.com/) működését. ;)

## Miben segítsek?
Kérünk, olyan dologgal járulj hozzá a **Firká**hoz, ami valószínűleg **sok embernek hasznos lehet**. Szeretnénk egy minél teljeskörűbb iskolai asszisztenst létrehozni, de az iskolaspecifikus, vagy külön neked hasznos funkciók helye inkább legyen a saját Fork-od.

Fontos, hogy **mielőtt egy nagyobb méretű projektbe belekezdenél, futtasd meg ötletedet a [Discord szerverünkön](https://discord.gg/6DvjyPAw2T)**, ahol még azelőtt tudunk tanácsot adni, hogy sok-sok órát beleöltél volna egy esetleg felesleges dologba.

A legjobban annak örülünk, ha az [Issues](https://github.com/QwIT-Development/app-legacy/issues) oldalról szemezgetsz. Ha még új vagy a Flutterben, ajánljuk figyelmedbe a viszonlyak könnyen javítható hibákat, ha éppen van ilyen.

## Hogyan segítsek?
Nem ígérhetünk itt sem programozás-, sem Git-kurzust, de a projektspecifikus dolgokat leírjuk, és segítünk a Flutter telepítésében.

A **Firka** a Google által pár éve létrehozott **[Flutter](https://flutter.dev/)** keretrendszert használja, aminek nyelve a **[Dart](https://dart.dev/)**. Ha ismered a JavaScript, C#, Java, C++, vagy egyéb hasonló programnyelvek működését, **nem fog nagy gondot okozni a használata.** A felhasználói felület létrehozásában az is segíthet, ha foglalkoztál már korábban weboldalakkal vagy alkalmazásfejlesztéssel.
Ha még nem használtad a Flutter-t, mindenképp böngészd át a [YouTube csatornájukat](https://www.youtube.com/channel/UCwXdFgeE9KYzlDdR7TG9cMw).
Kód vagy UI teszteléséhez Flutter telepítése nélkül is használhatod a [DartPad](https://dartpad.dev/)-et.

### Segédlet a flutter telepítéshez
Az alkalmazással kompatibilis flutter verziót (**3.27.1**) itt találod:
- [Windows](https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_3.27.1-stable.zip)
- [Linux](https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.27.1-stable.tar.xz)
- [MacOS x64](https://storage.googleapis.com/flutter_infra_release/releases/stable/macos/flutter_macos_3.27.1-stable.zip)
- [MacOS arm64](https://storage.googleapis.com/flutter_infra_release/releases/stable/macos/flutter_macos_arm64_3.27.1-stable.zip)

Ha nem értesz a Git-hez, akkor olvasd el a következő [cikket](https://freedium.cfd/https://medium.com/envienta-magyarorsz%C3%A1g/git-%C3%A9s-github-gyorstalpal%C3%B3-f2d78a732deb), viszont arra kérünk, hogy tapasztalataidat először egy új repoban próbáld ki. Ha már nagyjából értesz a Githez, akkor várjuk hozzájárulásodat.

Készíts egy Fork-ot a saját GitHub fiókod alá.
A **Firka** legfrissebb, verzióját a [master](https://github.com/QwIT-Development/app-legacy)-en találod. Kérjük ide Commit-olj és ide célozd a Fork-odból a Pull Request-edet. Írd le benne, hogy mit változtattál és ha lehet, csatolj képernyőképet is a működő építésedből.\
Minél gyakrabban készíts minél részletesebben elnevezett Commit-okat, hogy mások is el tudjanak igazodni az általad beküldött kódban.

### Segédlet az app építéséhez

1. Forráskód letöltése:
    ```sh
    git clone https://github.com/QwIT-Development/app-legacy.git
    cd app-legacy
    ```

2. Csomagok telepítése:\
    Windowson futtasd a következő scriptet: `fix-pub.bat`\
    Linuxon és MacOS-en pedig ezt: `fix-pub.sh`

3. Java feltelepítése\
    Az app nem tud megépülni, ha nincs telepítve **JDK 17**.\
    Töltsd le innét a [JDK-t](https://adoptium.net/temurin/releases/?version=17&package=jdk) és telepítsd fel.\
    (Ne felejtsd el kiválasztani a rendszeredet és a architektúrát)

4. Signkey generálása:\
    A `refilc/android` mappában futtasd a következő parancsot: `keytool -genkey -v -keystore key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias key`\
    Majd töltsd ki a `key.properties` fájlt a következővel:
    ```properties
    storePassword=<A jelszó amit megadtál a script futtatásakor>
    keyPassword=<A jelszó amit megadtál a script futtatásakor>
    keyAlias=key
    storeFile=key.jks
    ```
    Majd ezt a fájlt másold le és illeszd be ebbe is: `debugkey.properties`\
    **FONTOS:** A `key.jks` és a `key.properties` fájlokat ne tedd közzé!

5. Az alkalmazás építése:\
    Menj be a `refilc` mappába
    - Ha Androidra építesz, futtasd windowson a `build.bat`-ot, Linuxon és MacOS-en pedig a `build.sh`-t.\
    - Ha iOS-re építesz, akkor futtasd a `build-ipa.sh`-t.\
    **FONTOS:** Az iOS építéshez szükséged lesz egy MacOS rendszerre és egy Apple fejlesztői fiókra.

---

Az általad fejlesztett funkciók mellé a Változásnaplóba bekerül a GitHub felhasználóneved.\
Ha jelentős és rendszeres hozzájáruló vagy, Discord-on megkaphatod a `Contributor` rangot!

Ha bárhol elakadtál vagy kérdésed van, keress bátran Discord-on!
**Jó fejlesztést kívánunk!**
