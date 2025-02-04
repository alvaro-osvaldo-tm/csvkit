#!/usr/bin/env bash

set -e

function validate {

  TITLE="$1"
  COMMAND="$2"

  declare -A CHECKS
  declare -A WITHOUT
  declare -a ORDER

  CHECKS["UTF8"]="bbef 00"
  CHECKS["UTF-16"]="bbef 00"
  CHECKS["UTF-16BE"]="bbef 00"
  CHECKS["UTF-16LE"]="bbef 00"
  CHECKS["UTF32"]="bbef 00"
  CHECKS["UTF-32BE"]="bbef 00"
  CHECKS["UTF-32LE"]="bbef 00"
  CHECKS["Without"]=""

  WITHOUT["Parameter"]="2c61 0062"
  WITHOUT["Pipeline"]="2c61 0062"
  WITHOUT["CSVClean"]="2c61 0062"
  WITHOUT["CSVCut"]="0a61 0031"
  WITHOUT["CSVFormat"]="7c61 0062"
  WITHOUT["CSVGrep"]="2c61 0062"
  WITHOUT["CSVJoin"]="2c61 0062"
  WITHOUT["CSVJson"]="7b5b 0022"
  WITHOUT["CSVLook"]="207c 0061"
  WITHOUT["CSVSort"]="2c61 0062"
  WITHOUT["CSVSQL"]="5243 0045"
  WITHOUT["CSVStack"]="2c61 0062"
  WITHOUT["CSVStat"]="2020 0031"

  ORDER=(
  "UTF8" "UTF-16" "UTF-16BE" "UTF-16LE" "UTF32" "UTF-32BE" "UTF-32LE" "Without"
  )


  setterm --bold on
  printf "%-16.16s\n" "$TITLE"
  setterm --default


  for check in ${ORDER[*]} ; do

    printf " · %-12.12s : " "$check"

    toExecute="eval "$COMMAND" | od -h -N 3 | head -n 1 | grep -o --perl-regexp '0000000 \K.*'"
    expectedResult="${CHECKS[$check]}"
    encoding="$check"

    if [ "$check" == "Without" ]; then

      toExecute="$(printf "%s" "$toExecute" | sed 's/--add-bom//g')"
      expectedResult="${WITHOUT[$TITLE]}"
      encoding=""

    fi

    toExecute="$(printf "%s" "$toExecute" | sed "s/{ENCODING}/$encoding/g")"

    FOUND="$($toExecute)"


    if [[  "$FOUND" =~ "$expectedResult" ]]; then valid=1; else valid=0; fi
    if [[  -z "$expectedResult" ]]; then valid=0; fi


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

function AUTOMATED()
{
  validate "Parameter" "PYTHONIOENCODING={ENCODING} in2csv --add-bom ./examples/dummy.xls"
  validate "Pipeline" "cat ./examples/dummy.xls | PYTHONIOENCODING={ENCODING} in2csv --add-bom  --format xls -"

  validate "CSVClean" "PYTHONIOENCODING={ENCODING} in2csv --add-bom ./examples/dummy.xls | PYTHONIOENCODING={ENCODING} csvclean --add-bom --enable-all-checks -"
  validate "CSVCut" "PYTHONIOENCODING={ENCODING} in2csv --add-bom ./examples/dummy.xls | PYTHONIOENCODING={ENCODING} csvcut --add-bom --columns a"
  validate "CSVFormat" "PYTHONIOENCODING={ENCODING} in2csv --add-bom ./examples/dummy.xls | PYTHONIOENCODING={ENCODING} csvformat --add-bom -D '|' -"
  validate "CSVGrep" "PYTHONIOENCODING={ENCODING} in2csv --add-bom ./examples/dummy.xls | PYTHONIOENCODING={ENCODING} csvgrep --add-bom --column a -m 1.0 -"
  validate "CSVJoin" "PYTHONIOENCODING={ENCODING} in2csv --add-bom ./examples/dummy.xls | PYTHONIOENCODING={ENCODING} csvjoin --add-bom "
  validate "CSVJson" "PYTHONIOENCODING={ENCODING} in2csv --add-bom ./examples/dummy.xls | PYTHONIOENCODING={ENCODING} csvjson --add-bom -"
  validate "CSVLook" "PYTHONIOENCODING={ENCODING} in2csv --add-bom ./examples/dummy.xls | PYTHONIOENCODING={ENCODING} csvlook --add-bom -"

  validate "CSVSort" "PYTHONIOENCODING={ENCODING} in2csv --add-bom ./examples/dummy.xls | PYTHONIOENCODING={ENCODING} csvsort --add-bom -"
  validate "CSVSQL" "PYTHONIOENCODING={ENCODING} in2csv --add-bom ./examples/dummy.xls | PYTHONIOENCODING={ENCODING} csvsql --add-bom"
  validate "CSVStack" "PYTHONIOENCODING={ENCODING} in2csv --add-bom ./examples/dummy.xls | PYTHONIOENCODING={ENCODING} csvstack --add-bom -n NEWCOL -"
  validate "CSVStat" "PYTHONIOENCODING={ENCODING} in2csv --add-bom ./examples/dummy.xls | PYTHONIOENCODING={ENCODING} csvstat -d , --add-bom -"

  # validate "CSVPy" "in2csv --add-bom ./examples/dummy.xls | csvpy"
  # validate "SQL2csv" "in2csv --add-bom ./examples/dummy.xls | sql2csv"

}

function MANUAL() {
  CODINGS=(
  "UTF8" "UTF-16" "UTF-16BE" "UTF-16LE" "UTF32" "UTF-32BE" "UTF-32LE" "Without"
  )

  for coding in ${CODINGS[*]}; do

    if [[ $coding != "Without" ]]; then ENCODING="$coding" ; else ENCODING=""; fi

    printf "\n"
    printf " ---------------- %-12.12s ---------------- \n" "$coding"


    printf " · With BOM\n"
    PYTHONIOENCODING=$ENCODING in2csv --add-bom ./examples/dummy.xls

    printf "\n"

    printf " · Without BOM\n"
    PYTHONIOENCODING=$ENCODING in2csv ./examples/dummy.xls

    printf " ---------------------------------------------- \n"
    printf "\n"



    continue

    setterm --bold on
    printf  "%-8.8s Raw Output With Bom\n" "$coding"
    setterm --default
    in2csv --add-bom ./examples/dummy.xls

    printf "\n"

    setterm --bold on
    printf  "%-8.8s Raw Output Without Bom\n" "$coding"
    setterm --default
    in2csv ./examples/dummy.xls


  done

  }

MAIN() {


printf "======== Automated Testing ======== \n"
AUTOMATED
printf "=================================== \n"

printf "\n"
printf "======== Manual validation ======== \n"
MANUAL
printf "=================================== \n"

}

MAIN
