#!/usr/bin/env bash

set -euo pipefail -x

npm run compile

# -D: delete original and excluded files
# -i: use included Initializable
# -x: exclude all proxy contracts except Clones library
# -p: emit public initializer
npx @openzeppelin/upgrade-safe-transpiler -D \
  -i contracts/proxy/utils/Initializable.sol \
  -x 'contracts/proxy/**/*' \
  -x '!contracts/proxy/Clones.sol' \
  -x '!contracts/proxy/ERC1967/ERC1967{Storage,Upgrade}.sol' \
  -x '!contracts/proxy/utils/UUPSUpgradeable.sol' \
  -x '!contracts/proxy/beacon/IBeacon.sol' \
  -p 'contracts/**/presets/**/*'

for p in scripts/upgradeable/patch/*.patch; do
  git apply "$p"
done
