#!/bin/sh

flutter build ipa --release --tree-shake-icons --split-debug-info=debug-info --obfuscate --no-code-sign
