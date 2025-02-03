#!/usr/bin/env bash

set -e

printf "======== Automated Testing ======== \n"

function validate {

  TITLE="$1"
  COMMAND="$2"
  BOM="$3"

  setterm --bold on
  printf "%-16.16s:" "$TITLE"
  setterm --default

  content="$(eval "$COMMAND" | od -h -N 3 | head -n 1)"
  printf " %-28.28s " "$content"

  if printf "%s\n" "$content" | grep "$BOM" > /dev/null ; then
    setterm --foreground green
    printf "PASS\n"
  else
    setterm --foreground red --blink on
    printf "FAIL\n"
  fi

  setterm --default

}
{
  validate "As Parameter" "in2csv --add-bom ./examples/dummy.xls" "bbef"
  validate "As Pipeline" "cat ./examples/dummy.xls | in2csv --add-bom  --format xls -" "bbef"

  # validate "CSVClean" "in2csv --add-bom ./examples/dummy.xls | csvformat" "bbef"
  # validate "CSVCut" "in2csv --add-bom ./examples/dummy.xls | csvformat" "bbef"
  # validate "CSVFormat" "in2csv --add-bom ./examples/dummy.xls | csvformat" "bbef"
  # validate "CSVGrep" "in2csv --add-bom ./examples/dummy.xls | csvformat" "bbef"
  # validate "CSVJoin" "in2csv --add-bom ./examples/dummy.xls | csvformat" "bbef"
  # validate "CSVJson" "in2csv --add-bom ./examples/dummy.xls | csvformat" "bbef"
  # validate "CSVlook" "in2csv --add-bom ./examples/dummy.xls | csvformat" "bbef"
  # validate "CSVPy" "in2csv --add-bom ./examples/dummy.xls | csvformat" "bbef"
  # validate "CSVSort" "in2csv --add-bom ./examples/dummy.xls | csvformat" "bbef"
  # validate "CSVSQL" "in2csv --add-bom ./examples/dummy.xls | csvformat" "bbef"
  # validate "CSVStack" "in2csv --add-bom ./examples/dummy.xls | csvformat" "bbef"
  validate "CSVStat" "in2csv --add-bom ./examples/dummy.xls | csvstat -d , --add-bom -" "bbef"
  # validate "SQL2csv" "in2csv --add-bom ./examples/dummy.xls | csvformat" "bbef"

}
printf "\n"
printf "======== Manual validation ======== \n"
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



