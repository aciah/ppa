# Installation-de-Aciah-Linux
Une installation façon Debian

## Install
```bash
sudo curl -Ssl -o /etc/apt/trusted.gpg.d/aciah.asc https://aciah-linux-os.github.io/ppa/ppa/KEY.asc
sudo echo "deb [signed-by=/etc/apt/trusted.gpg.d/aciah.asc] https://aciah-linux-os.github.io/ppa/ppa ./" > /etc/apt/sources.list.d/aciah.list
sudo apt update
sudo apt install aciah
```

## Build
See Makefile
