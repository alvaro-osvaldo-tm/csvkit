#!/usr/bin/env bash


# PYTHONIOENCODING='UTF-16' python3 ./test.py | od -c -N 4
# python3 ./test.py | od -c -N 4
python3 ./test.py

printf "[%s] " "$(date +%H:%M:%S)"

if ! cmp --silent ./test.txt ./implementation/sample-utf16.txt ; then
  setterm --foreground red --bold on
  printf "FAIL\n"
  setterm --default

  cmp -b ./test.txt ./implementation/sample-utf16.txt

  setterm --foreground white --bold on
  printf "Result:\n"
  setterm --default
  od -N 2 -h ./test.txt

  setterm --foreground white --bold on
  printf "Sample:\n"
  setterm --default
  od  -N 2 -h ./implementation/sample-utf16.txt


  exit 0
fi

setterm --foreground green --bold on
printf "PASS\n"
setterm --default