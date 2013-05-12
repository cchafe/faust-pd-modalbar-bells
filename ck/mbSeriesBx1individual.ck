"/home/cc/Desktop/maldives/ck/" => string dir;
fun void hit(int i, float u, int bell, float s)
{
  ModalBar mb => dac;
  5000 => float tableDelay;
  mb.gain(15.0);
  mb.b(1);
  1 => float inc;
  u /=> inc;
  spork ~reco(bell,i+1,s,tableDelay);
  tableDelay::samp => now; // to write table?
  mb.users(i*inc);
  mb.hit(1);
  128::samp => now; // max stick len
  mb.hit(0);
  s::second => now;
<<<"done recording">>>;
}  

fun void go(int bell, float u, float s)
{
  for (0=>int i; i<(u$int); i++)
  {
    spork ~hit(i,u,bell,s);
    s::second => now;
  }
}
go(1,16,5);

fun void reco(int bell, int tone, float s, float tableDelay)
{
  dir + "bells" + bell + "tone" + tone + ".wav" => string filename0;
  <<< "recording mono sound files ",filename0>>>;
  tableDelay::samp => now; // to write table?
  dac.chan(0) => WvOut w0 => blackhole;
  filename0 => w0.wavFilename;
  s::second => now;
  w0.closeFile();
}

