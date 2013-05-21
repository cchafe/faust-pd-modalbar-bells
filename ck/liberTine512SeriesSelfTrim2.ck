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

go();

fun void go()
{
    for (0=>int i; i<512; i++) hit(i);
}


fun void hit(int ind)
{
  LiberTine mb => dac;
  5000 => float tableDelay;
  mb.gain(1.0);
  true => rec;
  spork ~reco(ind,tableDelay);
  tableDelay::samp => now; // to write table?
  mb.users(ind/512.0);
  mb.hit(1);
  128::samp => now; // max stick len
  mb.hit(0);
  1.0 => cur;
  while (cur > thresh) 20::ms => now;
  false => rec;
  mb =< dac;
  20::ms => now;
<<<"done recording">>>;
}  

fun void reco(int i, float tableDelay)
{
  dir + "liberTineSeries" + i + ".wav" => string filename0;
  <<< "recording mono sound files ",filename0>>>;
  tableDelay::samp => now; // to write table?
  dac.chan(0) => WvOut w0 => blackhole;
  filename0 => w0.wavFilename;
  while (rec) 1::ms => now;
  w0.closeFile();
 }
