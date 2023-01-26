#!/bin/zsh
# Anti-Copyright
# The author of this work hereby waives all claim of copyright (economic and moral) in this work and immediately places it in the public domain; it may be used, distorted or destroyed in any manner whatsoever without further attribution or notice to the creator.

cwd=$(pwd)
mhome=~$(id -nu 1000)

alias apt-install="apt install --yes"
alias su-magic="su - $(id -nu 1000) -c"

function cecho {
	case $1 in
		30)
			echo "\e[1;30m$2\e[0m";;
		31)
			echo "\e[1;31m$2\e[0m";;
		32)
			echo "\e[1;32m$2\e[0m";;
		33)
			echo "\e[1;33m$2\e[0m";;
		34)
			echo "\e[1;34m$2\e[0m";;
		35)
			echo "\e[1;35m$2\e[0m";;
		36)
			echo "\e[1;36m$2\e[0m";;
		37)
			echo "\e[1;37m$2\e[0m";;
		*) ;;
	esac
}

function drepo {
	repo=$1
	[ ! -d $repo:t ] && git clone https://github.com/$repo.git
	cd $repo:t
	git pull
	cecho 32 "CWD:$(pwd). Run 'cd $cwd' to go back"
}