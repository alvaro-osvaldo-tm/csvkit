#!/usr/bin/env bash

set -e

for major in $(seq 8 12); do

	version="3.$major"

	printf "Python %-6.6s " "$version"
	python.venv --organisation csvkit --module development --version "$version"


	pip3 install -e . > /dev/null 2> /dev/null

	installed=$(python --version | cut -d ' ' -f 2)
	printf "%-12.12s : " "$installed"

	if ! pytest > /dev/null && ./test-1267.local.sh > /dev/null ; then
    setterm --foreground green
      printf "PASS"
  else
      setterm --background red --foreground white --bold on --blink on
      printf "FAIL"
	fi

  setterm --default
  printf "\n"


done;
