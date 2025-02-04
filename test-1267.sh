#!/usr/bin/env bash

set -e

printf "======== Automated Testing ======== \n"

function validate {

  TITLE="$1"
  COMMAND="$2"
  BOM="$3"

  declare -A CHECKS
  declare -a ORDER

  CHECKS["UTF8"]="bbef 00"
  CHECKS["UTF16"]="bbef 00"
  CHECKS["UTF-16BE"]="bbef 00"
  CHECKS["UTF-16LE"]="bbef 00"
  CHECKS["UTF32"]="bbef 00"
  CHECKS["UTF-32BE"]="bbef 00"
  CHECKS["UTF-32LE"]="bbef 00"
  CHECKS["Without"]="2c61 0062"

  ORDER=(
  "UTF8" "UTF16" "UTF-16BE" "UTF-16LE" "UTF32" "UTF-32BE" "UTF-32LE" "Without"
  )



  setterm --bold on
  printf "%-16.16s\n" "$TITLE"
  setterm --default


  for check in ${ORDER[*]} ; do

    toExecute="eval "$COMMAND" | od -h -N 3 | head -n 1 | grep -o --perl-regexp '0000000 \K.*'"
    expectedResult="${CHECKS[$check]}"
    encoding="$check"

    if [ "$check" == "Without" ]; then
      toExecute="$(printf "%s" "$toExecute" | sed 's/--add-bom//g')"
    fi

    if [ "$encoding" == "Without" ]; then
      encoding=""
    fi


    toExecute="$(printf "%s" "$toExecute" | sed "s/{ENCODING}/$encoding/g")"

    FOUND="$($toExecute)"


    if [[  "$FOUND" =~ "$expectedResult" ]]; then valid=1; else valid=0; fi

    printf " · %-12.12s : " "$check"

    printf " %-10.10s " "$FOUND"

    if [[ $valid -eq 1 ]]; then
        setterm --foreground green
        printf "PASS";
    else
      setterm --background red --foreground white --bold on --blink on
      printf "FAIL"
    fi

    setterm --default

    printf "\n"
  done



}

{
  validate "As Parameter" "PYTHONIOENCODING={ENCODING} in2csv --add-bom ./examples/dummy.xls"
  validate "As Pipeline" "cat ./examples/dummy.xls | PYTHONIOENCODING={ENCODING} in2csv --add-bom  --format xls -"

  validate "CSVClean" "PYTHONIOENCODING={ENCODING} in2csv --add-bom ./examples/dummy.xls | PYTHONIOENCODING={ENCODING} csvclean --add-bom --enable-all-checks -"
  validate "CSVCut" "PYTHONIOENCODING={ENCODING} in2csv --add-bom ./examples/dummy.xls | PYTHONIOENCODING={ENCODING} csvcut --add-bom --columns a"
  validate "CSVFormat" "PYTHONIOENCODING={ENCODING} in2csv --add-bom ./examples/dummy.xls | PYTHONIOENCODING={ENCODING} csvformat --add-bom -D '|' -"
  validate "CSVGrep" "PYTHONIOENCODING={ENCODING} in2csv --add-bom ./examples/dummy.xls | PYTHONIOENCODING={ENCODING} csvgrep --add-bom --column a -m 1.0 -"
  validate "CSVJoin" "PYTHONIOENCODING={ENCODING} in2csv --add-bom ./examples/dummy.xls | PYTHONIOENCODING={ENCODING} csvjoin --add-bom "
  validate "CSVJson" "PYTHONIOENCODING={ENCODING} in2csv --add-bom ./examples/dummy.xls | PYTHONIOENCODING={ENCODING} csvjson --add-bom -"
  validate "CSVlook" "PYTHONIOENCODING={ENCODING} in2csv --add-bom ./examples/dummy.xls | PYTHONIOENCODING={ENCODING} csvlook --add-bom -"

  validate "CSVSort" "PYTHONIOENCODING={ENCODING} in2csv --add-bom ./examples/dummy.xls | PYTHONIOENCODING={ENCODING} csvsort --add-bom -"
  validate "CSVSQL" "PYTHONIOENCODING={ENCODING} in2csv --add-bom ./examples/dummy.xls | PYTHONIOENCODING={ENCODING} csvsql --add-bom"
  validate "CSVStack" "PYTHONIOENCODING={ENCODING} in2csv --add-bom ./examples/dummy.xls | PYTHONIOENCODING={ENCODING} csvstack --add-bom -n NEWCOL -"
  validate "CSVStat" "PYTHONIOENCODING={ENCODING} in2csv --add-bom ./examples/dummy.xls | PYTHONIOENCODING={ENCODING} csvstat -d , --add-bom -"

  # validate "CSVPy" "in2csv --add-bom ./examples/dummy.xls | csvformat"
  # validate "SQL2csv" "in2csv --add-bom ./examples/dummy.xls | csvformat"

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




}
