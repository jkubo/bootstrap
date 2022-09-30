#!/bin/zsh
# Anti-Copyright
# The author of this work hereby waives all claim of copyright (economic and moral) in this work and immediately places it in the public domain; it may be used, distorted or destroyed in any manner whatsoever without further attribution or notice to the creator.
#
# Installs the latest software releases for:
# * Visual Studio Code
# * Tor
# * Ghidra
# * Docker
# * Airgeddon
# * Social Engineer Toolkit
# * Proxmark3
# * Kalitorify
# * Metasploit Framework
#
# Installs the following software release versions (adjust as needed):
irel="ipinfo-2.10.0/ipinfo_2.10.0"
arel="Anaconda3-2022.05-Linux-x86_64.sh"

cwd=$(pwd)
mhome=~$(id -nu 1000)

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

while test $# -gt 0
do
	case "$1" in
		--pm3) cecho 33 "Making Proxmark3"
			pm3=true
			;;
		--bkt) cecho 33 "Making Kalitorify"
			bkt=true
			;;
		--*) cecho 31 "Option not found: $1"
			;;
		*) cecho 32 "Argument: $1"
			;;
	esac
	shift
done

function drepo {
	repo=$1
	[ ! -d $repo:t ] && git clone https://github.com/$repo.git
	cd $repo:t
	git pull
	cecho 32 "CWD:$(pwd). Run 'cd $cwd' to go back"
}

[[ ! "$cwd:t" == 'Documents' ]] && cecho 31 "Not in correct directory.. exiting." && exit
[[ ! $(whoami) == 'root' ]] && cecho 31 "Need to run as root.. exiting." && exit

alias apt-install="apt install --yes"
alias su-magic="su - $(id -nu 1000) -c"

cecho 33 'Dist Upgrade'
apt --yes dist-upgrade

cecho 34 '[VSCode] Installing code'
murl="https://packages.microsoft.com"
mgpg="microsoft.gpg"
apt-install curl gpg gnupg2 software-properties-common apt-transport-https
curl --silent $murl/keys/microsoft.asc | gpg --dearmor > $mgpg
install -o $(whoami) -g $(whoami) -m 644 $mgpg /etc/apt/trusted.gpg.d/
echo "deb [arch=amd64] $murl/repos/vscode stable main" | tee /etc/apt/sources.list.d/vscode.list
apt update
apt-install code

cecho 35 '[Tor] Installing browser'
apt-install tor torbrowser-launcher

cecho 35 '[Ghidra] Installing debugger'
apt-install ghidra

cecho 34 '[Docker] Installing docker'
apt-install docker.io
systemctl enable docker --now
usermod -aG docker $(id -nu 1000)

cecho 35 '[Airgeddon] Installing wireless'
apt-install airgeddon

cecho 35 '[Social Engineer] Installing setoolkit'
apt-install set

cecho 36 "[$irel] Installing cli"
curl --silent -LO "https://github.com/ipinfo/cli/releases/download/$irel.deb"
dpkg -i $irel:t.deb

cecho 32 "[$arel:r] Installing python"
su-magic "curl --silent -o Downloads/$arel https://repo.anaconda.com/archive/$areli"
su-magic "bash Downloads/$arel -b"

repo="RfidResearchGroup/proxmark3"
cecho 36 "[$repo] Installing cloner"
apt-install --no-install-recommends git ca-certificates build-essential \
	pkg-config libreadline-dev gcc-arm-none-eabi libnewlib-dev \
	qtbase5-dev libbz2-dev libbluetooth-dev libpython3-dev libssl-dev
drepo $repo
[[ $pm3 ]] && make accessrights && make clean && make -j && make install
cd $cwd

repo="brainfucksec/kalitorify"
cecho 35 "[$repo] Proxying transparently"
drepo $repo
[[ $bkt ]] && make install
cd $cwd

cecho 35 '[Metasploit] Syncing exploit-db'
systemctl enable postgresql --now
msfdb init
searchsploit --update

apt autoremove --yes
