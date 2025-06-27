#!/usr/bin/env bash

echo "[$(git symbolic-ref --short HEAD | grep -Poi '(?<=(-|/))\w+-\d+(?=(-|$))')] $(cat $1)" > $1
