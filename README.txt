for faust: git clone git://git.code.sf.net/p/faudiostream/code faust

git pull
  make
  sudo make install

______________
for local clone:

cd Desktop
git clone https://github.com/cchafe/faust-pd-modalbar-bells.git faust-pd-modalbar-bells

git config --global user.name "cchafe"
git config --global user.email chafe@stanford.edu
[edit README.txt]
git commit -m "change README.md" -a
git push https://github.com/cchafe/faust-pd-modalbar-bells.git master
[user]
[pass]

git add README.txt
git commit -m "add README.txt" -a
