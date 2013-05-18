// pick and output directory and give bell #1 as series of 5 sec hits up a series of 512 pitches 

"/tmp/" => string dir;
go(1,16,5);

fun void go(int bell, float u, float s)
{
//  spork ~reco(bell,0,s*512,0);
    for (0=>int i; i<512; i++)
    {
//<<<i%25,i/32>>>;
      spork ~hit(i%25,i/32,i,u,bell,s);
      s::second => now;
    }

}

// connect bell, record to individual file
// hit at pitch i of u, linearly interpolated
// disconnect after s seconds
fun void hit(int btwo, int bone, int ind, float u, int bell, float s)
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
  spork ~reco(bell,ind,s,tableDelay);
  tableDelay::samp => now; // to write table?
(  (btwo+bone+(u$int)/2) % (u$int) )*inc => float init;
  mb.users(bone*inc);
  mb.hit(1);
  mb2.users(btwo*b2inc);
  mb2.hit(1);
  128::samp => now; // max stick len
  mb.hit(0);
  mb2.hit(0);

  (s)::second => now;
<<<"done recording">>>;
}  

fun void reco(int bell, int tone, float s, float tableDelay)
{
  dir + "bell" + bell + "tone" + tone + ".wav" => string filename0;
  <<< "recording mono sound files ",filename0>>>;
  tableDelay::samp => now; // to write table?
  dac.chan(0) => WvOut w0 => blackhole;
  filename0 => w0.wavFilename;
  s::second => now;
  w0.closeFile();
}
