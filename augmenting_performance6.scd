
s.quit;
s.options.memSize = 65536;  // e.g., could be different for you
s.boot;

NetAddr.langPort;
thisProcess.openPorts;
thisProcess.openUDPPort(57120);
(
SynthDef(\mod1, {
	arg freq=40, rthm=0.6, amp=0.5, idk=100;
	var sig, resfreq, sig2;
	sig = Saw.ar(freq); // freq
	// resfreq = SinOsc.kr(rthm) * idk + 100; // kr(2.7) = tempo
	resfreq = rthm * idk + 100; // kr(2.7) = tempo
	sig = RLPF.ar(sig, resfreq, 0.1);
	sig = sig * amp;
	sig2 = RLPF.ar(sig, resfreq, 0.1);
	sig2 = sig2 * (SinOsc.kr(amp));
	Out.ar(1, sig);
}).add;
)

(
SynthDef(\mod2, {
	arg freq=40, rthm=0.6, amp=0.5, idk=100;
	var sig, resfreq, sig2;
	sig = Saw.ar(freq); // freq
	// resfreq = SinOsc.kr(rthm) * idk + 100; // kr(2.7) = tempo
	resfreq = rthm * idk + 100; // kr(2.7) = tempo
	sig = RLPF.ar(sig, resfreq, 0.1);
	sig = sig * amp;
	sig2 = RLPF.ar(sig, resfreq, 0.1);
	sig2 = sig2 * (SinOsc.kr(amp));
	Out.ar(1, sig2);
	Out.ar(0, sig);
}).add;
)


(
SynthDef(\filtSaw, {
	arg freq=440, detune=3.0, atk=6, sus=4, rel=6, curve1=1, curve2=(-1),
				minCf=30, maxCf=6000, minRq=0.005, maxRq=0.04,
				minBpfHz=0.02, maxBpfHz=0.25,
				lowShelf=220, rs=0.85, db=6,
				gate=1, amp=2, spread=1.0, out=0;
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
)


// +++ liVE
(l = Synth.new(\filtSaw, [
		\freq, 1, // try 2-3, small
	    \detune, 9.0,
	    \atk, 20,
	    \lowShelf, 10,
	    \amp, 4.2,
	    \spread, 10.0
	]);)


(h = Synth.new(\mod1, [
		\freq, 50,
		\rthm, 0.2,
		\amp, 0.0,
		\idk, 100 // not too much!!
	]);)
h.set(\freq, 30);
k.set(\amp, 1.2);
k.set(\freq, 10);
k.set(\rthm, 0.05);
k.free

(k = Synth.new(\mod1, [
		\freq, 10,
		\rthm, 0.2,
		\amp, 0.5,
		\idk, 30 // not too much!!
	]);)


(g = Synth.new(\mod2, [
		\freq, 50,
		\rthm, 0.2,
		\amp, 0.3,
		\idk, 100 // not too much!!
	]);)
g.set(\rthm, 0.2); // 0.01 - 0.9
g.set(\freq, 20); // 10 - 50
g.free

OSCFunc({
	arg msg, time, addr, recvPort;
	msg[1].postln;
	g.set(\rthm, msg[1]);
	g.set(\freq, msg[2]);
},
'/base2');

n = NetAddr.new("127.0.0.1", 7771);
OSCFunc({
	arg msg, time, addr, recvPort;
	msg[1].postln;
	Synth.new(\filtSaw, [
	\freq, msg[1], // try 2-3, small
	\detune, 9.0,
	\atk, 5,
	\lowShelf, 10,
	\amp, 5.2,
	\spread, 10.0
	]).play
},
'/split'); // 2 - 30


