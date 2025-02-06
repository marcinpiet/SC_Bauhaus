//midi initialise
MIDIClient.init;
//print out the sources, input and output
MIDIClient.sources;

//connects all midi input devices
MIDIIn.connectAll;

//function to print out data from a midi controller
(
MIDIdef.cc(\cc, {|val, num, chan, src|

	//print out values and number from midi device
	[val, num, chan, src].postln;

	//map to synthesis
	switch (num,

		70,   {Ndef(\fm).set(\modFreq, val.linlin(0,127, 0.01, 345))},
		71,   {Ndef(\fm).set(\sigFreq, val.linlin(0,127, 20, 3345))},
		72,   {Ndef(\fm).set(\modulationAmp, val.linlin(0,127, 0, 3345))},

)


}).permanent_(true) // with this set to true the definition will survive CMD + .
)


Ndef(\fm).set(\modFreq, 40)


MIDIIn