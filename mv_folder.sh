#!/bin/bash


for dir in */; do
  if [ "$dir" != ".github/" ] && [ "$dir" != "gitbook/" ]; then
    mv "$dir" gitbook/
  fi
done