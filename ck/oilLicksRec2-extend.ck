// pick and output directory and give bell #1 as series of 5 sec hits up a series of 512 pitches 

"/tmp/" => string dir;
false => int rec;
/*
dac.chan(0) => FFT fft =^ RMS rms => blackhole;
1024 => fft.size;
Windowing.hann(1024) => fft.window;
0.001 => float thresh;
0.001 => float cur;

fun void lev() {
  while (true) {   
    fft.size()::samp => now;
    rms.upchuck() @=> UAnaBlob blob;
    blob.fval(0)*1000 => cur;
//     <<< cur >>>;
  }
} spork ~lev();
*/
true => rec;
spork ~reco();
[666,1333,500,2000] @=> int rhy[];
for (1=>int i; i<20; 1+=>i) 
{
  spork ~hit(i%rhy.cap(),4000);
  rhy[i%rhy.cap()] => float xxx;
  xxx::ms => now;
  if(!(i%rhy.cap())) 5555::ms => now;

}
4100::ms => now;
false => rec;
<<<"done recording">>>;
100::ms => now;


fun void hit(int ind, float s)
{
  ind%17 => int btwo;
  ind/25 => int bone;
  512 => float u;
  1 => int bell;
  ModalBarOther mb => Gain g => dac;
  ModalBarOther mb2 => g;
  g.gain(1 );
  5000 => float tableDelay;
if (ind < 40)
  mb.gain(3.0);
else  mb.gain(5.0);
  mb.b(bell);
  mb.p(2);
  mb2.gain(1);
  mb2.b(bell);
  mb2.p(1);
  6 => float inc;
  u /=> inc;
  inc*3 => float b2inc;
  tableDelay::samp => now; // to write table?
  mb.users(bone*inc);
  mb.hit(1);
  mb2.users(btwo*b2inc);
  mb2.hit(1);
  128::samp => now; // max stick len
  mb.hit(0);
  mb2.hit(0);

s::ms => now;
  mb =< dac;
  mb2 =< dac;
  20::ms => now;
}  


fun void reco()
{
  dir + "oilLicks2" + ".wav" => string filename0;
  <<< "recording mono sound files ",filename0>>>;
  dac.chan(0) => WvOut w0 => blackhole;
  filename0 => w0.wavFilename;
  while (rec) 1::ms => now;
  w0.closeFile();
 }
