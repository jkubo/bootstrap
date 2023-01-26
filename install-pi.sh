my_dir="$(dirname "$0")"

"$my_dir/library.sh"

# Installs the latest software releases for:
# * Visual Studio Code
# * Docker
# * https://github.com/pi-hole/docker-pi-hole
# * https://github.com/linuxserver/docker-wireguard

[[ ! "$cwd:t" == 'Documents' ]] && cecho 31 "Not in correct directory.. exiting." && exit
[[ ! $(whoami) == 'root' ]] && cecho 31 "Need to run as root.. exiting." && exit

cecho 33 'Dist Upgrade'
apt --yes dist-upgrade

# cecho 34 '[VSCode] Installing code'
# murl="https://packages.microsoft.com"
# mgpg="microsoft.gpg"
# apt-install curl gpg gnupg2 software-properties-common apt-transport-https
# curl --silent $murl/keys/microsoft.asc | gpg --dearmor > $mgpg
# install -o $(whoami) -g $(whoami) -m 644 $mgpg /etc/apt/trusted.gpg.d/
# echo "deb [arch=amd64] $murl/repos/vscode stable main" | tee /etc/apt/sources.list.d/vscode.list
# apt update
# apt-install code

cecho 34 '[Docker] Installing docker'
apt-install docker.io
systemctl enable docker --now
usermod -aG docker $(id -nu 1000)

repo="pi-hole/docker-pi-hole"
cecho 35 "[$repo] Network Ad Blocker"
drepo $repo
cd $cwd

repo="linuxserver/docker-wireguard"
cecho 35 "[$repo] VPN"
drepo $repo
cd $cwd

apt autoremove --yes