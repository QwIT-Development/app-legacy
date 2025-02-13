cd refilc && flutter pub upgrade --major-versions && cd ..
cd refilc_kreta_api && flutter pub upgrade --major-versions && cd ..
cd refilc_mobile_ui && flutter pub upgrade --major-versions && cd ..
# cd refilc_desktop_ui && flutter pub upgrade && cd ..
cd refilc_plus && flutter pub upgrade --major-versions && cd ..

echo "Upgraded pub (major)."
