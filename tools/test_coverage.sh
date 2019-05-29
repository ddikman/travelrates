#!/bin/bash

flutter test --coverage
genhtml coverage/lcov.info --output=coverage
open coverage/index.html