#!/bin/bash

cd refilc
flutter clean
flutter pub get

cd ../refilc_kreta_api
flutter clean
flutter pub get

cd ../refilc_mobile_ui
flutter clean
flutter pub get

cd ../refilc_plus
flutter clean
flutter pub get

cd ..