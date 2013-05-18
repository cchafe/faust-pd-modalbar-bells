cd ../dsp
cp ../../faustFromGit/examples/faust-stk/instrument.* .
cp ../../faustFromGit/examples/faust-stk/modalBar.h .

# 2 stages because I haven't written the sed to correct the .cpp file yet

################################
# generate the .cpp
../../faustDir/sys/bin/faust -a puredata.cpp -o $1.cpp $1.dsp

# edit it -- obviously these are not comments really but includes
# include "instrument.h"
# include <math.h>
# include "modalBar.h"

# include "/usr/include/pdextended/m_pd.h"

################################
# then comment the faust cmd above and switch to this
# g++ -fPIC -DPD -Wall -g -shared -Dmydsp=$1 -o $1~.pd_linux  $1.cpp


cp $1~.pd_linux ../pd/

cd ../pd
pdextended $1.pd &
