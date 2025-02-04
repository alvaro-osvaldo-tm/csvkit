#!/usr/bin/env bash

for major in $(seq 8 12); do  

	version="3.$major"

	printf "Selecting Python version '%s'\n" "$version"
	python.venv --organisation csvkit --module development --version "$version"

	pip3 install -e .
	pip3 install -e '.[test]'

	pytest

	exit 0

done;
