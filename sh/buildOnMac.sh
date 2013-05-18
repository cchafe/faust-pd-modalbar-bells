cd ../dsp
cp ../../faustFromGit/examples/faust-stk/instrument.* .
cp ../../faustFromGit/examples/faust-stk/modalBar.h .
cp -r ../../faustDir/sys/include/faust .

../../faustDir/sys/bin/faust -a puredata.cpp -o $1.cpp $1.dsp

c++ -DPD -O2 -funroll-loops -fomit-frame-pointer -fPIC -Wall -msse -I/Applications/Pd-extended.app/Contents/Resources/include/  -I/opt/local/include -bundle -m32 -undefined suppress -flat_namespace -I ./ -Dmydsp=$1 $1.cpp -o $1~.pd_darwin

cp $1~.pd_darwin ../pd/
