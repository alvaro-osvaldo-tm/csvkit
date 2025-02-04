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

  content="$(eval "$COMMAND" | od -h -N 3 | head -n 1 | grep -o --perl-regexp '0000000 \K.*')"
  printf " %-28.28s " "$content"

  if printf "%s\n" "$content" | grep "$BOM" > /dev/null ; then
    setterm --foreground green
    printf "PASS"
    setterm --default
  else
    setterm --background red --foreground white --bold on --blink on
    printf "FAIL"
    setterm --default
  fi

  printf "\n"


}
{
  validate "As Parameter" "in2csv --add-bom ./examples/dummy.xls" "bbef"
  validate "As Pipeline" "cat ./examples/dummy.xls | in2csv --add-bom  --format xls -" "bbef"

  validate "CSVClean" "in2csv --add-bom ./examples/dummy.xls | csvclean --add-bom --enable-all-checks -" "bbef"
  validate "CSVCut" "in2csv --add-bom ./examples/dummy.xls | csvcut --add-bom --columns a" "bbef"
  validate "CSVFormat" "in2csv --add-bom ./examples/dummy.xls | csvformat --add-bom -D '|' -" "bbef"
  validate "CSVGrep" "in2csv --add-bom ./examples/dummy.xls | csvgrep --add-bom --column a -m 1.0 -" "bbef"
  validate "CSVJoin" "in2csv --add-bom ./examples/dummy.xls | csvjoin --add-bom " "bbef"
  validate "CSVJson" "in2csv --add-bom ./examples/dummy.xls | csvjson --add-bom -" "bbef"
  validate "CSVlook" "in2csv --add-bom ./examples/dummy.xls | csvlook --add-bom -" "bbef"

  validate "CSVSort" "in2csv --add-bom ./examples/dummy.xls | csvsort --add-bom -" "bbef"
  validate "CSVSQL" "in2csv --add-bom ./examples/dummy.xls | csvsql --add-bom" "bbef"
  validate "CSVStack" "in2csv --add-bom ./examples/dummy.xls | csvstack --add-bom -n NEWCOL -" "bbef"
  validate "CSVStat" "in2csv --add-bom ./examples/dummy.xls | csvstat -d , --add-bom -" "bbef"

  # validate "CSVPy" "in2csv --add-bom ./examples/dummy.xls | csvformat" "bbef"
  # validate "SQL2csv" "in2csv --add-bom ./examples/dummy.xls | csvformat" "bbef"

  validate "Without BOM" "in2csv ./examples/dummy.xls" "2c61 0062"

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



