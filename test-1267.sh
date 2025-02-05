#!/usr/bin/env bash

set -e

function validate {

  TITLE="$1"
  COMMAND="$2"

  declare -A CHECKS
  declare -A WITHOUT
  declare -a ORDER

  CHECKS["UTF8"]="bbef 00"
  CHECKS["UTF-16"]="fffe 00"
  CHECKS["UTF-16BE"]="fffe 00"
  CHECKS["UTF-16LE"]="feff 00"
  #CHECKS["UTF32"]="bbef 00"
  #CHECKS["UTF-32BE"]="bbef 00"
  #CHECKS["UTF-32LE"]="bbef 00"
  #CHECKS["Without"]=""

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

  #ORDER=(
  #"UTF8" "UTF-16" "UTF-16BE" "UTF-16LE" "UTF32" "UTF-32BE" "UTF-32LE" "Without"
  #)

  ORDER=(
  "UTF8" "UTF-16" "UTF-16BE" "UTF-16LE"
  )


  if [[ "$TITLE" != "CSVClean" ]]; then
    # return
    :
  fi


  setterm --bold on
  printf "%-16.16s\n" "$TITLE"
  setterm --default


  for check in ${ORDER[*]} ; do

    if [ "$check" != "UTF-16BE" ]; then
      :
      #continue
    fi

    printf " · %-12.12s : " "$check"

    toExecute="eval $COMMAND"
    toVerify="od -h -N 3 | head -n 1 | grep -o --perl-regexp '0000000 \K.*'"
    expectedResult="${CHECKS[$check]}"
    encoding="$check"

    if [ "$check" == "Without" ]; then

      toExecute="$(printf "%s" "$toExecute" | sed 's/--add-bom//g')"
      expectedResult="${WITHOUT[$TITLE]}"
      encoding=""

    fi

    if  [ "$encoding" != "" ]; then
      toExecute="$(printf "%s" "$toExecute" | sed "s/{ENCODING}/$encoding/g")"
    else
      toExecute="$(printf "%s" "$toExecute" | sed "s/-e {ENCODING}//g")"
    fi

    if ! $toExecute > /dev/null 2> /dev/null ; then

      printf " %-10.10s " " "
      setterm --background red --foreground yellow --bold on --blink on
      printf "%s" "ERROR"
      setterm --default
      printf " "

      $toExecute | tr -d '[:cntrl:]' | tr -d '\n' | tr -d '\r'

      printf "\n"
      continue
    fi

    found="$($toExecute | od -h -N 3 | head -n 1 | grep -o --perl-regexp '0000000 \K.*')"


    if [[  "$found" =~ "$expectedResult" ]]; then valid=1; else valid=0; fi
    if [[  -z "$expectedResult" ]]; then valid=0; fi
    if [[  -z "$found" ]]; then valid=0; fi

    printf " %-10.10s " "$found";

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
  validate "Parameter" "PYTHONIOENCODING={ENCODING} in2csv  --add-bom ./examples/dummy.xls"
  # validate "Pipeline" "cat ./examples/dummy.xls |  in2csv -e {ENCODING} --add-bom  --format xls -"

  # validate "CSVClean" " in2csv -e {ENCODING} --add-bom ./examples/dummy.xls |  csvclean -e {ENCODING} --add-bom --enable-all-checks -"
  # validate "CSVCut" " in2csv -e {ENCODING} --add-bom ./examples/dummy.xls |  csvcut -e {ENCODING} --add-bom --columns a"
  # validate "CSVFormat" " in2csv -e {ENCODING} --add-bom ./examples/dummy.xls |  csvformat -e {ENCODING} --add-bom -D '|' -"
  # validate "CSVGrep" " in2csv -e {ENCODING} --add-bom ./examples/dummy.xls |  csvgrep -e {ENCODING} --add-bom --column a -m 1.0 -"
  # validate "CSVJoin" " in2csv -e {ENCODING} --add-bom ./examples/dummy.xls |  csvjoin -e {ENCODING} --add-bom "
  # validate "CSVJson" " in2csv -e {ENCODING} --add-bom ./examples/dummy.xls |  csvjson -e {ENCODING} --add-bom -"
  # validate "CSVLook" " in2csv -e {ENCODING} --add-bom ./examples/dummy.xls |  csvlook -e {ENCODING} --add-bom -"

  # validate "CSVSort" " in2csv -e {ENCODING} --add-bom ./examples/dummy.xls |  csvsort -e {ENCODING} --add-bom -"
  # validate "CSVSQL" " in2csv -e {ENCODING} --add-bom ./examples/dummy.xls |  csvsql -e {ENCODING} --add-bom"
  # validate "CSVStack" " in2csv -e {ENCODING} --add-bom ./examples/dummy.xls |  csvstack -e {ENCODING} --add-bom -n NEWCOL -"
  # validate "CSVStat" " in2csv -e {ENCODING} --add-bom ./examples/dummy.xls |  csvstat -e {ENCODING} -d , --add-bom -"

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
#MANUAL
printf "=================================== \n"

}

MAIN
