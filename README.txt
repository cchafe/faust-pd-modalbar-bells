For the piece:
water sound for web buttons = modalBarUI
water sound for installation speakers & radio = clapPend
oil sound for web buttons, installation speakers & radio = liberTine
____________________________________________________________________
This'll bring in and compile faust, bring in and compile for Pd the polartide bells, for linux and mac

pwd
mkdir <project>
cd <project>

1) git clone https://github.com/cchafe/faust-pd-modalbar-bells.git faust-pd-modalbar-bells
2) git clone git://git.code.sf.net/p/faudiostream/code faustFromGit
3) edit faustFromGit/Makefile 
e.g., <pwd> = /user/c/cc/<project>
DESTDIR ?= /user/c/cc/<project>/faustDir
PREFIX ?= /sys

tools/faust2appls/Makefile
DESTDIR ?= /user/c/cc/<project>/faustDir
PREFIX ?= /sys
make
make install

4)
cd faust-pd-modalbar-bells/sh
chmod +x build*
<build whichever> modalBarUI
<build whichever> clapPend
<build whichever> liberTine

buildOnLinux is a two-stage process with intermediate edits, see the script
________________________
________________________

to work on the clone:
git config --global user.name "user"
git config --global user.email usermailname@domain

example edit/commit/push
[edit README.md]
git commit -m "change README.md" -a
git push https://github.com/cchafe/faust-pd-modalbar-bells.git master
[user]
[pass]

example add:
git add README.txt
git commit -m "add README.txt" -a
git push https://github.com/cchafe/faust-pd-modalbar-bells.git master

start structuring directories:
mkdir ck
[put stuff in it]
git commit -m "add ck/*" -a
git push https://github.com/cchafe/faust-pd-modalbar-bells.git master

________________________
________________________
for faust: git clone git://git.code.sf.net/p/faudiostream/code faust

for subsequent faust updates:
git pull
  make
  sudo make install



