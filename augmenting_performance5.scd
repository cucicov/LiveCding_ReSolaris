
------// oau - synth, creepy
// pulse
// g h j f
(h = Synth.new(\mod, [
	\freq, 50,
	\rthm, 0.2,
	\amp, 0.2,
	\idk, 90.linrand // not too much!!
]);)

s.version.reply
s.status

h.free;
h.set(\rthm, 0.1);
h.set(\freq, 50);
h.set(\amp, 0.4);
h.set(\idk, 90);


SynthDef(\tutorialRand, { Out.ar(0, SinOsc.ar(LFNoise1.kr(0.2) * 440, 0, 0.2)); Out.ar(1, SinOsc.ar(LFNoise1.kr(0.2) * 440, 0, 0.2))}).send(s);
x = Synth(\tutorialRand);
x.free;

90.linrand;

s.quit

------- // siren
(c = Synth.new(\filtSaw, [
	\freq, 2, // try 2-3, small
	\detune, 2.0,
	\atk, 29,
	\lowShelf, 10,
	\amp, 1.2,
	\spread,220.0
]);)


s.n_free 1000;


/// bring some screetchin noise maybe
// some whirling sound like in N.19
// some dirty beats maybe?


------// OK. dramatic, melodic synth/piano
(
e =
Pbind(
\degree, Prand([-4, -9, -6, -2, -3, -2, 3, 1, 2], inf),
\dur, 0.20,
\amp, 0.1,
\legato, 6.0,
\ctranspose, 0
).play;
)

e.free

// q w e r
e.stop;
e.set(\dur, 0.15);

w.stop;
q.stop;
r.stop;

------// // OK, persia
(
var time = 1.2;
// l k m
m = Pbind(
			\instrument, \sin,
			\dur,  Prand([time/2, time/2, time/2, time/8, time/4, time/8], inf),
	        \amp, 1.0,
			\scale, Scale.harmonicMinor,
			\degree, Pbrown(-2, 20, Prand([1, 2], inf)), // pitch
			\octave, 5,
		).play;
)
k.stop;
l.stop;
m.stop;


------ // atmospheric screeching
f = (10.do { arg i; ///more signals
	{ Pan2.ar(
		// freq interval (try reverse interval)
		SinOsc.ar(exprand(300.0, 100.0) * LFNoise2.kr(rrand(0.1, 0.2)).range(0.95, 1.1), 0,
			LFNoise2.kr(rrand(0.3, 9.7)).range(0,0.5) ** 3), 1.0.rand2)
	}.play
})

// hitting sounds
(
{
    var z;
    z = Decay.ar(Dust.ar(1,0.5), 0.1, WhiteNoise.ar);
    8.do { z = AllpassL.ar(z, 0.04, 0.04.rand, 2) };
    z
}.scope(1);
)






---------------------------------
~myDust = {[Resonz.ar([[Dust, Dust2].choose.ar(ChaosGen.allSubclasses.choose.ar(0.1).abs * 10), [Dust, Dust2].choose.ar(ChaosGen.allSubclasses.choose.ar(0.1).abs * 10)], rrand(30, 1200), 0.05)*60FreeVerb.ar(Resonz.ar([[Dust, Dust2].choose.ar(ChaosGen.allSubclasses.choose.ar(0.1).abs * 10), [Dust, Dust2].choose.ar(ChaosGen.allSubclasses.choose.ar(0.1).abs * 10)], rrand(30, 1200), 0.05)*60)]};

(
~mySine={var a, b, c, d;
a={[SinOsc.ar(rrand(30, 75), mul: ChaosGen.allSubclasses.choose.ar(rrand(1, 30))), SinOsc.ar(rrand(30, 75), mul: ChaosGen.allSubclasses.choose.ar(rrand(1, 30)))] * 0.3};
b={[SinOsc.ar(rrand(220, 440), mul: ChaosGen.allSubclasses.choose.ar(rrand(1, 30))), SinOsc.ar(rrand(220, 440), mul: ChaosGen.allSubclasses.choose.ar(rrand(1, 30)))] * 0.1};
c={[SinOsc.ar(rrand(880, 2200), mul: ChaosGen.allSubclasses.choose.ar(rrand(1, 30))), SinOsc.ar(rrand(880, 2200), mul: ChaosGen.allSubclasses.choose.ar(rrand(1, 30)))] * 0.064};
d={[SinOsc.ar(rrand(8800, 22000), mul: ChaosGen.allSubclasses.choose.ar(rrand(1, 30))), SinOsc.ar(rrand(8800, 22000), mul: ChaosGen.allSubclasses.choose.ar(rrand(1, 30)))] * 0.064};
	Out.ar(0, (a+b+c+d)*0.4);
};
)

~dustM1={CmdPeriod.run; ~myDust.play; ~mySine.play}
~dustM2={CmdPeriod.run; ~myDust.play;}
~dustM3={CmdPeriod.run; ~mySine.play}

[~dustM1, ~dustM2, ~dustM3].choose.value









SynthDef(\filtSaw, {
	arg freq=440, detune=3.0, atk=6, sus=4, rel=6, curve1=1, curve2=(-1),
				minCf=30, maxCf=6000, minRq=0.005, maxRq=0.04,
				minBpfHz=0.02, maxBpfHz=0.25,
				lowShelf=220, rs=0.85, db=6,
				gate=1, amp=1, spread=1.0, out=0;
		var sig, env;
		env = EnvGen.kr(Env([0,1,1,0],[atk,sus,rel],[curve1,0,curve2]), gate, levelScale:amp, doneAction:2);
		sig = Saw.ar(
			freq +
			LFNoise1.kr({LFNoise1.kr(0.5).range(0.15,0.4)}!8).range(detune.neg,detune));
		sig = BPF.ar(
			sig,
			LFNoise1.kr({LFNoise1.kr(0.13).exprange(minBpfHz,maxBpfHz)}!8).exprange(minCf, maxCf),
			LFNoise1.kr({LFNoise1.kr(0.08).exprange(0.08,0.35)}!8).range(minRq, maxRq)
		);
		sig = BLowShelf.ar(sig, lowShelf, rs, db);
		sig = SplayAz.ar(4, sig, spread);
	sig = FreeVerb.ar(sig, 0.7, 0.8, 0.25);
		sig = sig * env * 2;
		Out.ar(out, sig);
	}).add;




(
SynthDef(\sin, {arg freq=10, out=0, amp=0.9, gate=1;
		var sig;
		sig = SinOsc.ar(freq, 0, amp)*Env.adsr.kr(2, gate);
		sig = RHPF.ar(sig, LFDNoise3.ar(Rand(0.01, 16), freq).abs, LFDNoise3.ar(Rand(0.01, 3), 1).abs)*0.1;
		sig = Pan2.ar(sig, Rand(-0.9, 0.9)).softclip;
		Out.ar(out, sig);
	}).add;
)



(
SynthDef(\mod, {
	arg freq=40, rthm=0.6, amp=0.5, idk=100;
	var sig, resfreq, sig2;
	sig = Saw.ar(freq); // freq
	resfreq = SinOsc.kr(rthm) * idk + 100; // kr(2.7) = tempo
	sig = RLPF.ar(sig, resfreq * 1.3, 0.1);
	sig = sig * amp;
	sig2 = RLPF.ar(sig, resfreq, 2.1);
	sig2 = sig * amp;
	Out.ar(0, sig);
	Out.ar(1, sig2);
}).add;
)

