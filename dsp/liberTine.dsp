declare name "LiberTine";
declare description "Nonlinear Modal percussive instruments";
declare author "Romain Michon (rmichon@ccrma.stanford.edu)";
declare copyright "Romain Michon";
declare version "1.0";
declare licence "STK-4.3"; // Synthesis Tool Kit 4.3 (MIT style license);
declare description "A number of different struck bar instruments. Presets numbers: 0->Marimba, 1->Vibraphone, 2->Agogo, 3->Wood1, 4->Reso, 5->Wood2, 6->Beats, 7->2Fix; 8->Clump"; 

import("music.lib");
//import("effect.lib");
import("instrument.lib");
import("filter.lib");

//==================== GUI SPECIFICATION ================
amp = hslider("amp", 10, 5, 200, 1);
que = hslider("que", 0.99999,  0.9999, 1, 0.00001);
fre = hslider("fre", 2.1,  0, 10,0.001);
b = 1; // hslider("b", 1,  1, 10, 0.001);
p = hslider("p", 1,  1, 10, 0.001);

users = hslider("users",0.5, 0.0, 1, 0.0001);
u = 512.0;
indu = users*u;
scl = 0.6;
gainA = if ((indu < 120), 3.0, 5.0) * scl;
gainT = 1.0 * scl;
btwo = fmod(indu,17.0);
bone = indu/25.0;
inca = 6.0;
incu = inca/u;
inc2xx = incu * 2.0 * btwo;
inc1xx = incu * bone;

inc1x = if ((inc1xx>1.0), 1.0, inc1xx);
inc1 = if ((inc1x<0.0), 0.0, inc1x);
inc2x = if ((inc2xx>1.0), 1.0, inc2xx);
inc2 = if ((inc2x<0.0), 0.0, inc2x);

depth = hslider("depth",0.5, 0.01, 1, 0.001);

freqA = inc1*1500;
freqT = inc2*1500;
gain = 0.8;

poke = button("poke") : *(amp) : highpass(2,100) ;
hit = button("h:Basic_Parameters/hit [1][tooltip:noteOn = 1, noteOff = 0]");
yyy = poke : nlf2(fre,que) : _,!;

gate = clip(yyy + hit)
with
{
  clip(x) = if((x>=1),1,0);
};

reson = depth; 
presetNumberAir = 2; 
presetNumberTine = 1; 

//==================== SIGNAL PROCESSING ================
directGainA = loadPreset(presetNumberAir,3,2);
loadPreset = ffunction(float loadPreset (int,int,int), <modalBar.h>,"");
biquadBankA(freq) = _ <: sum(i, 4, oneFilter(i))
	with{
		condition(x) = x<0 <: *(-x),((-(1))*-1)*x*freq :> +;
		dampCondition = (gate < 1) & (reson > 0.75); // deeper is damped
		//the filter coefficients are interpolated when changing of preset
		oneFilter(j,y) = (loadPreset(presetNumberAir,0,j : smooth(0.999)) : condition), 
loadPreset(presetNumberAir,1,j : smooth(0.999))*(1-(gain*0.03*dampCondition)), 
y*(loadPreset(presetNumberAir,2,j) : smooth(0.999)) : bandPassH;
	};

directGainT = loadPreset(presetNumberTine,3,2);
biquadBankT(freq) = _ <: sum(i, 4, oneFilter(i))
	with{
		condition(x) = x<0 <: *(-x),((-(1))*-1)*x*freq :> +;
		dampCondition = (gate < 1) & (reson > 0.75); // deeper is damped
		//the filter coefficients are interpolated when changing of preset
		oneFilter(j,y) = (loadPreset(presetNumberTine,0,j : smooth(0.999)) : condition), 
loadPreset(presetNumberTine,1,j : smooth(0.999))*(1-(gain*0.03*dampCondition)), 
y*(loadPreset(presetNumberTine,2,j) : smooth(0.999)) : bandPassH;
	};

//excitation signal
excitation = counterSamples < (marmstk1TableSize*rate) : *(marmstk1Wave*gate)
	   with{
		//readMarmstk1 and marmstk1TableSize are both declared in instrument.lib
		marmstk1 = time%marmstk1TableSize : int : readMarmstk1;
		
		dataRate(readRate) = readRate : (+ : decimal) ~ _ : *(float(marmstk1TableSize));
		
		rate = .125; 
		
		counterSamples = (*(gate)+1)~_ : -(1);
		marmstk1Wave = rdtable(marmstk1TableSize,marmstk1,int(dataRate(rate)*gate));
	   };

f1(fr) = 140.0*(.9+b/3) +fr;
f2(fr) = 700.0*(.9+b/2) +fr;
boost = 1.5;

bellA(f0) = excitation : *(.001)
  <: (biquadBankA(f0) <: -(*(directGainA))) + (directGainA*_);
bellT(f0) = excitation : *(.001)
  <: (biquadBankT(f0) <: -(*(directGainT))) + (directGainT*_);

air = (bellA(f1(freqA)) + bellA(f2(freqA))) :  *(30);
tine = (bellT(f1(freqT)) + bellT(f2(freqT))) :  *(30);

 process = (air*gainA) + (tine*gainT);
//process = bellX(111);
