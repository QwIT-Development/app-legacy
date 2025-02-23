<p align=center>
  <img src="https://github.com/user-attachments/assets/cbffc8b4-cfb4-4055-894c-af9e979c8ea6" width=150>
  <h1 align=center><b>Firka - reFilc legacy</b></h1>
</p>

#### Nem hivatalos e-napló alkalmazás az e-KRÉTA rendszerhez - tanulóktól, tanulóknak.

(Ameddig nincs kész a rewrite ezt használjuk...)

[![Downloads](https://img.shields.io/github/downloads-pre/QwIT-Development/app-legacy/total?&logo=github&label=Downloads)](https://github.com/QwIT-Development/app-legacy/releases) &nbsp; [![Discord](https://img.shields.io/discord/1111649116020285532?logo=discord&label=Discord)](https://discord.gg/6DvjyPAw2T)

## Környezet felállítása

### Flutter beállítása

Az alkalmazás építéséhez a Flutter **3.27.1**-es változatára lesz szükséged.

- [Windows](https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_3.27.1-stable.zip)
- [Linux](https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.27.1-stable.tar.xz)
- [MacOS x64](https://storage.googleapis.com/flutter_infra_release/releases/stable/macos/flutter_macos_3.27.1-stable.zip)
- [MacOS arm64](https://storage.googleapis.com/flutter_infra_release/releases/stable/macos/flutter_macos_arm64_3.27.1-stable.zip)

### Forráskód letöltése

```sh
git clone https://github.com/QwIT-Development/app-legacy.git
cd app-legacy
```

### Csomagok telepítése

Menj be minden mappába és futtasd a következő parancsokat:
```sh
flutter clean
flutter pub get
```

### Alkalmazás építése

```sh
cd refilc
flutter build apk --release
```

*Ez egy apk fájlt fog építeni*

*Ipa építéshez macOS szükséges egy fejlesztői fiókkal...*

### Contribution

**Nézd meg a [Contribution guide](CONTRIBUTING.md)-ot!**

Az összes (ugyan azon verzióhoz tartozó) contribution meg fog jelenni a kiadásnál. Kérjük, írd le a Discord nevedet a pull request leírásába, hogy adhassunk rangot.

-------

# Csapatunk

**Management**
- Zypherift
- hayn
- Pearoo
- Zizi
- mnus
- xou

**Designerek**
- dwe
- xou

**vrolandd, TMarccci:** head developer

**Péter:** video editor

***annon:** a régi Filc Napló fejlesztője (ez az app, ha bár sokban változott, alapjaiban a Filc-re, valamint a reFilc-re épül)*
