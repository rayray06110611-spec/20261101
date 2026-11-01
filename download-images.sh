#!/usr/bin/env bash
# 從 Unsplash（免費商用、免標註授權）下載示意圖，覆蓋 images/ 內的佔位圖。
# 用法：在專案資料夾執行  bash download-images.sh
# 若某張下載失敗，會保留原本的佔位圖，可到 https://unsplash.com 或 https://www.pexels.com 手動替換。

set -u
cd "$(dirname "$0")/images" || exit 1

declare -A PHOTOS=(
  [hero]="photo-1519741497674-611481863552"
  [about]="photo-1452587925148-ce544e77e70d"
  [wedding-01]="photo-1511285560929-80b456fea0bc"
  [wedding-02]="photo-1606800052052-a08af7148866"
  [wedding-03]="photo-1465495976277-4387d4b0b4c6"
  [wedding-04]="photo-1522673607200-164d1b6ce486"
  [wedding-05]="photo-1583939003579-730e3918a45a"
  [wedding-06]="photo-1529636798458-92182e662485"
  [ceremony-01]="photo-1519225421980-715cb0215aed"
  [ceremony-02]="photo-1515934751635-c81c6bc9a2d8"
  [ceremony-03]="photo-1469371670807-013ccf25f16a"
  [ceremony-04]="photo-1464366400600-7168b8af9bc3"
  [ceremony-05]="photo-1525258946800-98cfd641d0de"
  [ceremony-06]="photo-1460978812857-470ed1c77af0"
  [portrait-01]="photo-1494790108377-be9c29b29330"
  [portrait-02]="photo-1507003211169-0a1dd7228f2d"
  [portrait-03]="photo-1442512595331-e89e73853f31"
  [portrait-04]="photo-1438761681033-6461ffad8d80"
  [portrait-05]="photo-1534528741775-53994a69daeb"
  [portrait-06]="photo-1522071820081-009f0129c71c"
)

for name in "${!PHOTOS[@]}"; do
  url="https://images.unsplash.com/${PHOTOS[$name]}?w=1600&q=80&fm=jpg&fit=max"
  if curl -fsSL --max-time 30 -o "${name}.tmp" "$url"; then
    mv "${name}.tmp" "${name}.jpg" && echo "✓ ${name}.jpg"
  else
    rm -f "${name}.tmp"; echo "✗ ${name}.jpg 下載失敗，保留佔位圖"
  fi
done
