#!/usr/bin/env bash

cd "$WS_ROOT_UNIX"/workstation1 || exit 1
python -m unittest
