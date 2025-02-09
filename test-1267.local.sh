#!/usr/bin/env bash

set -e

function validate() {

  title="$1"
  command="$2"

  command="eval $command"

  printf "%-24.24s : " "$title"

  if ! $command > /dev/null ; then
    setterm --background red --foreground white --bold on --blink on
    printf "FAIL"
    setterm --default
    printf "\n"
    exit 1
  fi

  result="$($command | file -i -)"
  if [[ "$result" =~ utf-8 ]]; then isUtf8=1 ; else isUtf8=0; fi

  result="$($command | od -h -N 3 | head -n 1 | grep -o --perl-regexp '0000000 \K.*' | tr -d ' ')"
  if [[ "$result" =~ bbef00 ]]; then isBOM=1 ; else isBOM=0; fi

  if [[ "$isUtf8" -eq 1 ]] && [[ "$isBOM" -eq 1 ]]; then
      setterm --foreground green
      printf "PASS"
  else
      setterm --background red --foreground white --bold on --blink on
      printf "FAIL"
  fi

  setterm --default
  printf "\n"

}

function AUTOMATED() {

printf "======= Automated Validation =======\n"

validate "In2csv"  "in2csv  --add-bom ./examples/dummy.xls"
validate "In2csv (UTF-16BE)"  "in2csv -e utf-16  --add-bom ./examples/test_utf16_big.csv"
validate "In2csv (UTF-16LE)"  "in2csv -e utf-16  --add-bom ./examples/test_utf16_little.csv"

validate "In2csv (Pipeline)"  "in2csv --add-bom ./examples/dummy.xls | in2csv --add-bom --format csv -"

validate "CSVClean" "in2csv -e utf-16  --add-bom ./examples/test_utf16_little.csv |  csvclean  --add-bom --enable-all-checks -"
validate "CSVCut" "in2csv -e utf-16  --add-bom ./examples/test_utf16_little.csv |  csvcut  --add-bom --columns a"
validate "CSVFormat" "in2csv -e utf-16  --add-bom ./examples/test_utf16_little.csv |  csvformat  --add-bom -D '|' -"
validate "CSVGrep" "in2csv -e utf-16  --add-bom ./examples/test_utf16_little.csv |  csvgrep  --add-bom --column a -m 1.0 -"
validate "CSVJoin" "in2csv -e utf-16  --add-bom ./examples/test_utf16_little.csv |  csvjoin  --add-bom "
validate "CSVJson" "in2csv -e utf-16  --add-bom ./examples/test_utf16_little.csv |  csvjson  --add-bom -"
validate "CSVLook" "in2csv -e utf-16  --add-bom ./examples/test_utf16_little.csv |  csvlook  --add-bom -"

validate "CSVSort" "in2csv -e utf-16  --add-bom ./examples/test_utf16_little.csv |  csvsort  --add-bom -"
validate "CSVSQL" "in2csv -e utf-16  --add-bom ./examples/test_utf16_little.csv |  csvsql  --add-bom"
validate "CSVStack" "in2csv -e utf-16  --add-bom ./examples/test_utf16_little.csv |  csvstack  --add-bom -n NEWCOL -"
validate "CSVStat" "in2csv -e utf-16  --add-bom ./examples/test_utf16_little.csv |  csvstat  -d , --add-bom -"

printf "====================================\n"

}

function MANUAL() {

printf "========= Manual Validation =========\n"

in2csv  --add-bom ./examples/dummy.xls

echo ""

in2csv -e utf-16  --add-bom ./examples/test_utf16_big.csv

echo ""

in2csv -e utf-16  ./examples/test_utf16_big.csv

echo ""

in2csv -e utf-16  --add-bom ./examples/test_utf16_little.csv

printf "=====================================\n"

}

function MAIN() {

  AUTOMATED
  MANUAL

}

MAIN
