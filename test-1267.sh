#!/usr/bin/env bash

set -e

outputFile="$(mktemp)"

{
  setterm --bold on
  printf "Terminal output\n"
  setterm --default
  in2csv --add-bom ./examples/dummy.xls | od -h -N 3
}
printf "\n"
{
  setterm --bold on
  printf "Pipeline Input\n"
  setterm --default
  cat ./examples/dummy.xls | in2csv --add-bom  --format xls - | od -h -N 3
}
printf "\n"
{
  setterm --bold on
  printf "Raw Output With Bom\n"
  setterm --default
  in2csv --add-bom ./examples/dummy.xls
}
printf "\n"
{
  setterm --bold on
  printf "Raw Output Without Bom\n"
  setterm --default
  in2csv ./examples/dummy.xls
}

in2csv ./examples/dummy.xls > test.log



