//05.12.2024
//synthesis class
//additive
//subtractive

//additive
//sine tones added together as partials of a complex tone
//decide how many partials we want?
//what are the parameters to control?
//frequency, phase and amplitude of each partial

(
Ndef(\complexTone, { //comment on the same line as code
	//another comment on its own line
});
);

//argument declaration
(
Ndef(\complexTone, {
	//partial frequencies
	arg freq1, freq2, freq3, freq4, freq5, freq6,
	//partial amplitudes
	amp1, amp2, amp3, amp4, amp5, amp6;

});
);

//argument declaration shortcut using | pipe symbol
(
Ndef(\complexTone, {
	//arguments declaration
	//partial frequencies
	|freq1 = 440, freq2 = 440, freq3 = 440, freq4 = 440, freq5 = 440, freq6 = 440,
	//partial amplitudes
	amp1 = 0.9, amp2 = 0.9, amp3 = 0.9, amp4 = 0.9, amp5 = 0.9, amp6 = 0.9,
	//partial phases
	ph1 = 0, ph2 = 0, ph3 = 0, ph4 = 0, ph5 = 0, ph6 = 0|

	//variables
	var part1, part2, part3, part4, part5, part6;

	//partial one
	part1 = SinOsc.ar(freq: freq1, phase: ph1) * amp1;
	//partial 2
	part2 = SinOsc.ar(freq: freq2, phase: ph2) * amp2;
	//partial 3
	part3 = SinOsc.ar(freq: freq3, phase: ph3) * amp3;
	//partial 4
	part4 = SinOsc.ar(freq: freq4, phase: ph4) * amp4;
	//partial 5
	part5 = SinOsc.ar(freq: freq5, phase: ph5) * amp5;
	//partial 6
	part6 = SinOsc.ar(freq: freq6, phase: ph6) * amp6;

	//add partials together
	part1 + part2 + part3 + part4 + part5 + part6;
	//shortcut
	[part1, part2, part3, part4, part5, part6].sum * 0.1;
});
);

//to change the ndef proxy from control to audio do Ndef.clear
Ndef.clear;

//check Ndef(\complextone)
//channels
Ndef(\complexTone).numChannels;

//to hear the Ndef(\complexTone) boot the server first
s.boot;

Ndef(\complexTone).play;
//open level monitor
//cmd+m
Ndef(\complexTone).set(\freq1, 1200);
Ndef(\complexTone).set(\freq2, 340, \freq3, 567, \freq4, 769, \freq5, 1345, \freq6, 2345);
Ndef(\complexTone).set(\amp1, 0.2, \amp2, 0.7, \amp3, 0.1, \amp4, 0.5, \amp5, 0.15);

//shortcut for additive definition using arrays

(
Ndef(\complexTone, {|fundFreq = 440, pan = 0|
	var numOfPartials = 12;
	var amplitudes = numOfPartials.collect{|i| 1/(1+i)}.normalizeSum;

	var partialSum = numOfPartials.collect{|i|
		DelayN.ar(SawBL.ar(fundFreq * (1 + i)), 1 + i, 0.1 + i)   * amplitudes[i]
	}.sum;

	Pan2.ar(partialSum, pan)

});
);

Ndef(\complexTone).play;


Ndef(\complexTone).set(\fundFreq, 23);
Ndef(\complexTone).set(\pan, -1);

(
Ndef(\fundGen, { LatoocarfianC.ar(
    2.03,
    LFNoise2.kr(2,1.5,1.5),
    LFNoise2.kr(2,1.5,1.5),
    LFNoise2.kr(2,0.5,1.5),
    LFNoise2.kr(2,0.5,1.5)
).range(25, 345)});
)

(
Ndef(\panGen, { LatoocarfianC.ar(
    12,
    LFNoise2.kr(2,1.5,1.5),
    LFNoise2.kr(2,1.5,1.5),
    LFNoise2.kr(2,0.5,1.5),
    LFNoise2.kr(2,0.5,1.5)
).range(-1, 1)});
)

Ndef(\complexTone).set(\fundFreq, Ndef(\fundGen), \pan, Ndef(\panGen));


