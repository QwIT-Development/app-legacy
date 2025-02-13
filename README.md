<p align=center>
  <img src="https://raw.githubusercontent.com/Laky2k8/Refilc-2-Episode-1/refs/heads/master/refilc-2-real.png" width=150>
  <h1 align=center><b>reFilc</b></h1>
</p>

#### Nem hivatalos e-napló alkalmazás az e-KRÉTA rendszerhez - tanulóktól, tanulóknak.

[![Downloads](https://img.shields.io/github/downloads-pre/refilc/naplo/total?&logo=github&label=Downloads)](https://github.com/refilc/naplo/releases) &nbsp; [![Discord](https://img.shields.io/discord/1111649116020285532?logo=discord&label=Discord)](https://discord.gg/refilc-1111649116020285532)

## Környezet felállítása

### Source code letöltése

<em>Az építhéshez szükséged lesz a refilc_plus repora is, amit itt találsz: [student-plus](https://git.qwit.cloud/refilc/student-plus)</em>

```sh
git clone --branch dev https://git.qwit.cloud/refilc/student-legacy.git
cd naplo
rm -rf refilc_plus
git clone https://git.qwit.cloud/refilc/student-plus.git refilc_plus
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
flutter run apk --release
```

*Ez egy apk fájlt fog építeni*

### Contribution

**Nézd meg a [Contribution guide](CONTRIBUTING.md)-ot!**

Az összes (ugyan azon verzióhoz tartozó) contribution meg fog jelenni a release-nél. Kérjük, írd le a Discord nevedet a Description-be, hogy adhassunk rangot.

-------

# Team

**Reiner, pdf, Pearoo, Zizi:** community- and project manager / developer

**vrolandd, TMarccci:** head developer

**dwe., xou:** designer

**Péter:** video editor

<em>**annon:** a régi Filc Napló fejlesztője (ez az app, ha bár sokban változott, alapjaiban a Filc-re épül)</em>
