sudo -E apt install -y python3-pip python3-setuptools libffi-dev python3-dev libssl-dev
# Ubuntu version >= 20.04

set +e
vercomp "$VERSION_ID" "19.10"
case $? in
    0) op='=';;
    1) op='>';;
    2) op='<';;
esac
set -e

if [ "$DISTRO" == "ubuntu" ] && [ "$op" == ">" ]; then
    echo "Automated Docker install"
    sudo -E apt-get install -y docker-compose
else
    echo "Manual Docker installation"
    source ./scripts/manual_docker.sh
fi

# set docker-compose path used in Mistborn
if [ ! -f /usr/local/bin/docker-compose ]; then
    sudo -E ln -s $(which docker-compose) /usr/local/bin/docker-compose
fi