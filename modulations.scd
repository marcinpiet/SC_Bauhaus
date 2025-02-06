//amplitude modulation

(
Ndef(\ampMod, {

	arg modFreq = 150, sigFreq = 750;

	var modulator = SinOsc.ar(modFreq).range(0, 1);
	var sig = SinOsc.ar(sigFreq, mul: modulator);

	//var sig = SinOsc.ar(sigFreq, mul: 1);

	sig;
})
)

{ SinOsc.ar(1.5).range(0, 1) }.plot(5)

{ SinOsc.ar(7.5) }.plot(5);

{ SinOsc.ar(7.5, mul: SinOsc.ar(1.5).range(0, 1)) }.plot(5)

Ndef(\ampMod).play;
s.freqscope

//ring modulation
(
Ndef(\ringMod, {

	arg modFreq = 189, sigFreq = 2250;

	var modulator = SinOsc.ar(modFreq).range(-1, 1);
	var sig = SinOsc.ar(sigFreq, mul: modulator);

	//var sig = SinOsc.ar(sigFreq, mul: 1);

	sig;
})
)

Ndef(\ringMod).play;
s.freqscope

{ SinOsc.ar(1.5).range(-1, 1) }.plot(5)

{ SinOsc.ar(7.5) }.plot(5);

{ SinOsc.ar(7.5, mul: SinOsc.ar(1.5).range(-1, 1)) }.plot(5)

//simple frequency modulation
(
Ndef(\fm, {
	arg modFreq = 5, sigFreq = 750, modulationAmp = 2000, pos = 0;

	var modulator = SinOsc.ar(modFreq, mul: modulationAmp);
	var sig = SinOsc.ar(sigFreq + modulator);

	//var sig = SinOsc.ar(sigFreq, mul: 1);

	//sig ! 2;

	Pan2.ar(sig, pos)
})
)

Ndef(\fm).reshaping = 'elastic';

Ndef(\fm).play;

//high modulator amplitude = high number of sidebands
//low modulator amplitude = low number of sidebands
Ndef(\fm).set(\modulationAmp, 1000);
//high modulation frequency = wider spacings between sidebands
Ndef(\fm).set(\modFreq, 80);
//signal (carrier) frequency = center mass of frequency
Ndef(\fm).set(\sigFreq, 2234);

//get GUI

Ndef(\fm).gui
Ndef(\fm).addSpec(\modFreq, [0.1, 2000, 'exp']);
Ndef(\fm).addSpec(\modulationAmp, [0, 5000, 'lin']);
Ndef(\fm).addSpec(\sigFreq, [20, 15000, 'exp'])

//control parameyters in time
(
Ndef(\fm)[2] = \pset -> Pbind(
    \dur, Pseq([0.1, 0.3, 0.8, 2], inf),
	\modFreq, Pseq([34, 103, 78, 12], inf),
    \modulationAmp, Pseq([134, 93, 68, 20], inf),
    \sigFreq, Pseq([434, 423, 468, 400], inf)
)
);

Ndef(\fm)[2] = nil

(
Ndef(\fm)[3] = \filterIn -> {|in| PitchShift.ar(in, 0.02, LFSaw.kr(0.01).exprange(0.1, 7.0), 0, 0.1)}
);

Ndef(\fm)[3] = nil

(
Ndef(\fm)[4] = \filterIn -> {|in| GVerb.ar(in, 3, 3, 0.9) * 0.5}
);

