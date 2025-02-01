#!/usr/bin/env bash

set -e

in2csv ./examples/dummy.xls | od -c
