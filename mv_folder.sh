#!/bin/bash


for dir in */; do
  if [ "$dir" != ".github/" ]; then
    mv "$dir" gitbook/
  fi
done