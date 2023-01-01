#!/bin/sh
make -f Makefile.binary PROJECT=projects/cobble
cd projects/cobble
./app

# COBBLE is (c) 2022-2023 Ben Ferguson
