// pick and output directory and give bell #1 as series of 5 sec hits up a series of 512 pitches 

"/tmp/" => string dir;
false => int rec;
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

go(1,16);

fun void go(int bell, float u)
{
    for (0=>int i; i<512; i++) hit(i%25,i/32,i,u,bell);
}


fun void hit(int btwo, int bone, int ind, float u, int bell)
{
  ModalBar mb => dac;
  ModalBar mb2 => dac;
  5000 => float tableDelay;
  mb.gain(10.0);
  mb.b(bell);
  mb2.gain(2.0);
  mb2.b(bell);
  1 => float inc;
  u /=> inc;
  inc/4 => float b2inc;
  true => rec;
  spork ~reco(bell,ind,tableDelay);
  tableDelay::samp => now; // to write table?
  mb.users(bone*inc);
  mb.hit(1);
  mb2.users(btwo*b2inc);
  mb2.hit(1);
  128::samp => now; // max stick len
  mb.hit(0);
  mb2.hit(0);

  1.0 => cur;
  while (cur > thresh) 20::ms => now;
  false => rec;
  mb =< dac;
  mb2 =< dac;
  20::ms => now;
<<<"done recording">>>;
}  

fun void reco(int bell, int tone, float tableDelay)
{
  dir + "bell" + bell + "tone" + tone + ".wav" => string filename0;
  <<< "recording mono sound files ",filename0>>>;
  tableDelay::samp => now; // to write table?
  dac.chan(0) => WvOut w0 => blackhole;
  filename0 => w0.wavFilename;
  while (rec) 1::ms => now;
  w0.closeFile();
 }
