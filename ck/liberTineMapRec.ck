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

class Map { 
  0.1 => float val;                  
  fun void setVal( float f ){f => val;}
  3.75 => float heat;                  
  fun void setHeat( float f ){f => heat;}
  fun float poly( float x, float r){return r * x * (1.0 - x);}
  fun float interp( float lo, float hi, float x){return lo + (x * (hi - lo));}
  fun float clip( float lo, float hi, float x){return Math.min (Math.max (x , lo), hi);}
  fun float tick(){poly(val, heat) => val; return val;}
}
Map m,n,o;
  5000 => float tableDelay;
for (0=> int j; j<512; j++)
{
  (n.tick()*4)$int+1 => int l;
  int pit[l];
  float rhy[l];
  for (0=> int i; i<l; i++)
  {
    //<<<(n.val*4+1)$int,i,(m.tick()*512)$int,(o.tick()*1)>>>;
    (m.tick()*512)$int => pit[i];
    Math.pow((o.tick()*1.1),2.0) => rhy[i];
  }
  true => rec;
  spork ~reco(j,tableDelay);
for (0=> int k; k<1; k++)
{  for (0=> int i; i<l; i++)
  {
    spork ~hit( pit[i], 4.0); //rhy[i] );
    rhy[i]::second => now;
  }
  1.0 => cur;
  while (cur > thresh) 20::ms => now;
  false => rec;
  20::ms => now;
<<<"done recording">>>;
}
}

fun void hit(int ind, float s)
{
  LiberTine mb => Gain g => dac; // patch 2
  tableDelay::samp => now; // to write table?
  mb.users(ind/512.0  );
  mb.hit(1);
  128::samp => now; // max stick len
  mb.hit(0);
  s::second => now;
  mb =< dac;
  2::ms => now;
}  

fun void reco(int i, float tableDelay)
{
  dir + "liberTineLicks" + i + ".wav" => string filename0;
  <<< "recording mono sound files ",filename0>>>;
  tableDelay::samp => now; // to write table?
  dac.chan(0) => WvOut w0 => blackhole;
  filename0 => w0.wavFilename;
  while (rec) 1::ms => now;
  w0.closeFile();
 }
