#!/bin/bash
# alias commands to run inside docker
alias npm="docker-compose run --rm npm"
alias bower="docker-compose run --rm bower"
# ember is a more complex alias, since the command depends on whether
# the user runs `server`
ember() {
  if [[ $@ == "server" ]]; then
    command docker-compose up server
  else
    command docker-compose run --rm ember "$@"
  fi
}
