#!/bin/bash
command_exists () {
  command -v $1 >/dev/null 2>&1 && [ -x `command -v $1` ]
}

DIR="`cd "$(dirname "${BASH_SOURCE[0]}")" && pwd`"

command_exists 'julia' && {
  echo "Running Julia bench..."
  julia "${DIR}/bench.jl"
} || { echo "julia not found, skipping tests..."; }
echo

command_exists 'nodejs' && {
  echo "Running NodeJS bench..."
  nodejs "${DIR}/bench.js"
} || { echo "nodejs not found, skipping tests..."; }
echo

(command_exists 'java' && command_exists 'javac') && {
  echo "Running Java bench..."
  javac "${DIR}/Bench.java" && java -cp "${DIR}" Bench
  rm "${DIR}/Bench.class"
} || { echo "java/javac not found, skipping tests..."; }
echo

command_exists 'gcc' && {
  echo "Running C bench... (GCC)"
  echo "(GCC with no optimization)"
  gcc "${DIR}/bench.c" -std=c99 -lm -o /tmp/bench && /tmp/bench
  rm /tmp/bench
  echo "(GCC with -O3)"
  gcc "${DIR}/bench.c" -O3 -std=c99 -lm -o /tmp/bench && /tmp/bench
  rm /tmp/bench
} || { echo "gcc not found, skipping tests..."; }
echo

command_exists 'clang' && {
  echo "Running C bench... (Clang)"
  echo "(Clang with no optimization)"
  clang "${DIR}/bench.c" -lm -o /tmp/bench && /tmp/bench
  rm /tmp/bench
  echo "(Clang with -O3)"
  clang "${DIR}/bench.c" -O3 -lm -o /tmp/bench && /tmp/bench
  rm /tmp/bench
} || { echo "clang not found, skipping tests..."; }
echo

command_exists 'ruby' && {
  echo "Running Ruby bench..."
  ruby "${DIR}/bench.rb"
} || { echo "ruby not found, skipping tests..."; }

