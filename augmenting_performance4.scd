
// «lazerdrone» by Callum Goddard

NetAddr.langPort;thisProcess.openPorts;
thisProcess.openUDPPort(57120);


(
SynthDef(\lazerdrone, {
	arg freqq = 100, amp = 0.3;
	var in, freq, hasFreq;

	in = SinOsc.ar(freqq * LFSaw.kr(100, 100));

	# freq, hasFreq = Pitch.kr(
					in,
					ampThreshold: 0.09,
					median: 1);
	freq = freq * hasFreq;
	//freq.poll;

	SinOsc.kr(freq).poll;

	Out.ar(0, in + SinOsc.ar(freqq, 0, Clip.kr(SinOsc.kr(freq), 0)) * amp);
}).add;
)


h.free
r.free

(r = Synth.new(\lazerdrone, [
		\amp, 0.5,
		\freqq, 10
	]);)


h.set(\amp, 0.0);
r.free


OSCFunc({
	arg msg, time, addr, recvPort;
	msg[1].postln;
	r.set(\amp, msg[1]);
},
'/knob5');


OSCFunc({
	arg msg, time, addr, recvPort;
	msg[1].postln;
	r.set(\freqq, msg[1] * 10000);
},
'/knob6');


