declare name "ModalBar";
declare description "Nonlinear Modal percussive instruments";
declare author "Romain Michon (rmichon@ccrma.stanford.edu)";
declare copyright "Romain Michon";
declare version "1.0";
declare licence "STK-4.3"; // Synthesis Tool Kit 4.3 (MIT style license);
declare description "A number of different struck bar instruments. Presets numbers: 0->Marimba, 1->Vibraphone, 2->Agogo, 3->Wood1, 4->Reso, 5->Wood2, 6->Beats, 7->2Fix; 8->Clump"; 

import("music.lib");
import("effect.lib");
import("instrument.lib");
import("filter.lib");

//==================== GUI SPECIFICATION ================
amp = hslider("amp", 10, 5, 200, 1);
que = hslider("que", 0.99999,  0.9999, 1, 0.00001);
fre = hslider("fre", 2.1,  0, 10,0.001);
b = hslider("b", 1,  1, 10, 0.001);

// stickhardness disconnected from users (= 0.125)
users = hslider("users",0.5, 0.0, 1, 0.0001);
depth = hslider("depth",0.5, 0.01, 1, 0.001);

freq = users*1500; //hslider("freq", 440.0,  0.0, 1000.0, 1.0);
gain = 0.8;

poke = button("poke") : *(amp) : highpass(2,100) ;
hit = button("h:Basic_Parameters/hit [1][tooltip:noteOn = 1, noteOff = 0]");
yyy = poke : nlf2(fre,que) : _,!;
//resonbp(fre,que,amp);

//gate = max(0,min(1,((yyy) + hit))); 

gate = clip(yyy + hit)
with
{
  clip(x) = if((x>=1),1,0);
};

stickHardness = 0.05 + 0.9*(1.0-users);
reson = depth; 
presetNumber = 4; 
typeModulation = 0; 
nonLinearity = 0;
frequencyMod = 220; 
nonLinAttack = 0.1;

vibratoFreq = 6; 
vibratoGain = 0.1;

//==================== SIGNAL PROCESSING ================

//stereoizer is declared in instrument.lib and implement a stereo spacialisation in function of 
//the frequency period in number of samples 
stereo = stereoizer(SR/freq);

//filter bank output gain
directGain = loadPreset(presetNumber,3,2);

//modal values for the filter bank 
loadPreset = ffunction(float loadPreset (int,int,int), <modalBar.h>,"");
 
//filter bank using biquad filters
biquadBank(freq) = _ <: sum(i, 4, oneFilter(i))
	with{
		condition(x) = x<0 <: *(-x),((-(1))*-1)*x*freq :> +;
		dampCondition = (gate < 1) & (reson > 0.75); // deeper is damped
		
		//the filter coefficients are interpolated when changing of preset
		oneFilter(j,y) = (loadPreset(presetNumber,0,j : smooth(0.999)) : condition), 
loadPreset(presetNumber,1,j : smooth(0.999))*(1-(gain*0.03*dampCondition)), 
y*(loadPreset(presetNumber,2,j) : smooth(0.999)) : bandPassH;
	};

//one pole filter with pole set at 0.9 for pre-filtering, onePole is declared in instrument.lib 
sourceFilter = onePole(b0,a1)
	with{
		b0 = 1 - 0.9;
		a1 = -0.9;
	};

//excitation signal
excitation = counterSamples < (marmstk1TableSize*rate) : *(marmstk1Wave*gate)
	   with{
		//readMarmstk1 and marmstk1TableSize are both declared in instrument.lib
		marmstk1 = time%marmstk1TableSize : int : readMarmstk1;
		
		dataRate(readRate) = readRate : (+ : decimal) ~ _ : *(float(marmstk1TableSize));
		
		//the reading rate of the stick table is defined in function of the stickHardness
		rate = .125; // stickHardness;//0.25*pow(4,stickHardness);
		
		counterSamples = (*(gate)+1)~_ : -(1);
		marmstk1Wave = rdtable(marmstk1TableSize,marmstk1,int(dataRate(rate)*gate));
	   };

wellReverb = _,_ <: *(reverbGain),*(reverbGain),*(1 - reverbGain),*(1 - reverbGain) : 
zita_rev1_stereo(rdel,f1,f2,t60dc,t60m,fsmax),_,_ <: _,!,_,!,!,_,!,_ : +,+
       with{
       reverbGain = depth; // hslider("v:Reverb/reverbGain",0.137,0,1,0.01) : smooth(0.999);
       roomSize = 2*depth; // hslider("v:Reverb/roomSize",0.72,0.01,2,0.01);
       rdel = 20;
       f1 = 200;
       f2 = 6000;
       t60dc = roomSize*3;
       t60m = roomSize*2;
       fsmax = 48000;
       };

wellComb = _,_ <: *(combGain),*(combGain),*(1 - combGain),*(1 - combGain) : 
comb,comb,_,_ <: _,!,_,!,!,_,!,_ : +,+
       with{
       combGain = 0.1 + depth*0.6;
       comb = ffbcombfilter(4096,300 + depth*3000,0.93 + depth*0.05);
       };
f1 = 140.0*(.9+b/3) +freq;
f2 = 700.0*(.9+b/2) +freq;
boost = 1.5;
bell(f0) = excitation : *(.001) //: sourceFilter : *(.1);
<: (biquadBank(f0) <: -(*(directGain))) + (directGain*_);
process = (bell(f1) + bell(f2)) : 
 *(30);
//   <: wellReverb : *(boost),*(boost) : wellComb;
