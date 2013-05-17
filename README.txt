for faust: git clone git://git.code.sf.net/p/faudiostream/code faust

for subsequent faust updates:
git pull
  make
  sudo make install

or to install but not system files, say with source in faustFromGit
and faust system in /user/c/cc/faustDir/sys

git clone git://git.code.sf.net/p/faudiostream/code faustFromGit
change
./Makefile 
DESTDIR ?= /user/c/cc/faustDir
PREFIX ?= /sys

tools/faust2appls/Makefile
DESTDIR ?= /user/c/cc/faustDir
PREFIX ?= /sys
make
make install

and for faust-stk modalBar these are needed in .dsp
faust-stk
instrument.lib instrument.h
modalBar.dsp modalBar.h

______________
for clone of this work:

git clone https://github.com/cchafe/faust-pd-modalbar-bells.git faust-pd-modalbar-bells

to work on the clone:
git config --global user.name "cchafe"
git config --global user.email chafe@stanford.edu

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


