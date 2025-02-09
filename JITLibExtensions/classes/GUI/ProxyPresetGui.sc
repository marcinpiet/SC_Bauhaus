
ProxyPresetGui : JITGui {

	var <setLBox, <setLPop, <storeBtn, <delBtn, <setRPop, <setRBox, <xfader;
	var <proxyGui;


	object_ { |obj|
		if (this.accepts(obj)) {
			object = obj;
			this.setProxyGui(object);
			this.checkUpdate;
		} {
			"% : object % not accepted!".format(this.class, obj).warn;
		}
	}

	setProxyGui { |obj|
		if (proxyGui.isNil) { ^this };
		if (obj.notNil) {
			proxyGui.object_(obj.proxy);
		} {
			proxyGui.object_(nil);
		};
		proxyGui.checkUpdate
	}


	setDefaults { |options|
		var minHeight;

		if (numItems > 0) {
			minHeight = (skin.headHeight * 2)
			+ (numItems + 2 * skin.buttonHeight);
		} {
			minHeight = (skin.headHeight * 2 + 8);
		};

		defPos = 10@10;
		minSize = 380 @ minHeight;
	}

	makeViews { |options|
		var butHeight = skin.headHeight;
		var flow = zone.decorator;

		// top line

		StaticText(zone, Rect(0,0, 30, butHeight)).string_("curr")
		.background_(skin.foreground)
		.font_(font).align_(\center)
		.mouseDownAction = {
			var name = setLPop.item.asSymbol;
			"%: jump to %\n".postf(object.cs, name.cs);
			// object.setCurr(name);
			object.setProxy(name); 		// sets proxy too.
			object.morphVal_(0);
		};

		setLPop = PopUpMenu(zone, Rect(0,0, 80, butHeight))
		.items_([]).font_(font)
		.background_(skin.foreground)
		.allowsReselection_(true)
		.action_({ |pop|
			object.morphVal = 0.5;
			object.setCurr(pop.item.asSymbol, false);
		});

		storeBtn = Button(zone, Rect(0, 0, 32, butHeight))
		.states_([["sto", skin.fontColor, skin.foreground]])
		.font_(font)
		.action_({ object.storeDialog(loc:
			(parent.bounds.left @ parent.bounds.top))
		});

		delBtn =  Button(zone, Rect(0,0, 32, butHeight))
		.states_([["del", skin.fontColor, skin.foreground]])
		.font_(font)
		.action_({ object.deleteDialog(loc:
			(parent.bounds.left - 100 @ parent.bounds.bottom))
		});

		Button(zone, Rect(0,0, 32, butHeight))
		.states_([["rand", skin.fontColor, skin.foreground]])
		.font_(font)
		.action_({ |but, modif|
			// cocoa and swingosc -alt mod.
			var rand = if (modif.isAlt) {
				object.setRand(exprand(0.25, 1.0))
			} {
				object.setRand(exprand(0.01, 0.25));
			};
		});

		Button(zone, Rect(0,0, 32, butHeight))
		.states_([["edit", skin.fontColor, skin.foreground]])
		.font_(font)
		.action_({ object.openSettingsFile });

		Button(zone, Rect(0,0, 32, butHeight))
		.states_([["doc", skin.fontColor, skin.foreground]])
		.font_(font)
		.action_({ object.postSettings });

		setRPop = PopUpMenu(zone, Rect(0,0, 80, butHeight))
		.items_([]).font_(font)
		.background_(skin.foreground)
		.allowsReselection_(true)
		.action_({ |pop|
			object.morphVal = 0.5;
			object.setTarg(pop.item.asSymbol, false);
		});

		StaticText(zone, Rect(0,0, 30, butHeight))
		.background_(skin.foreground)
		.string_("targ").font_(font).align_(\center)
		.mouseDownAction = {
			var name = setRPop.item.asSymbol;
			"%: jump to %\n".postf(object.cs, name.cs);
			object.setProxy(name); 		// sets proxy too.
			object.morphVal_(1);
		};

		flow.nextLine;

		// lower line

		setLBox = NumberBox(zone, Rect(0,0, 30, butHeight))
		.background_(skin.foreground)
		.font_(font).align_(\center)
		.value_(-1).step_(1)
		.action_({ |box|
			var val = box.value % setLPop.items.size;
			setLPop.valueAction_(val);
			box.value_(val)
		});

		xfader = Slider(zone, Rect(0,0, 320, butHeight))
		.action_({ |sl|
			object.morphValStep(sl.value);
		});

		setRBox = NumberBox(zone, Rect(0,0, 30, butHeight))
		.background_(skin.foreground)
		.font_(font).align_(\center)
		.value_(-1).step_(1)
		.action_({ |box|
			var val = box.value % setRPop.items.size;
			setRPop.valueAction_(val);
			box.value_(val)
		});

		if (numItems > 0) {
			flow.nextLine.shift(0, 8);
			proxyGui = this.proxyGuiClass.new(nil, numItems,
				zone, bounds: minSize - (0@42), makeSkip: false);
		};
	}

	proxyGuiClass { ^TaskProxyGui }

	getState {
		if (object.isNil) {
			^(setNames: [], morphVal: 0);
		};

		^(	object: object,
			setNames: object.settings.collect(_.key),
			currSet: object.currSet,
			currIndex: object.currIndex,
			targSet: object.targSet,
			targIndex: object.targIndex,
			morphVal: object.morphVal
		)
	}

	checkUpdate {
		var newState = this.getState;

		if (prevState[\object] != newState[\object]) {
			zone.enabled_(object.notNil);
		};

		if (prevState[\setNames] != newState[\setNames]) {
			setLPop.items = newState[\setNames];
			setRPop.items = newState[\setNames];
		};

		if (prevState[\currIndex] != newState[\currIndex]) {
			setLPop.value = newState[\currIndex] ? 0;
			setLBox.value = newState[\currIndex] ? 0;
		};

		if (prevState[\targIndex] != newState[\targIndex]) {
			setRPop.value = newState[\targIndex] ? -1;
			setRBox.value = newState[\targIndex] ? -1;
		};

		if (prevState[\morphVal] != newState[\morphVal]) {
			xfader.value_(newState[\morphVal])
		};

		if (proxyGui.notNil) { proxyGui.checkUpdate; };
		prevState = newState;
	}
}

NdefPresetGui : ProxyPresetGui {
	proxyGuiClass { ^NdefGui }
}

PdefPresetGui : ProxyPresetGui {
	proxyGuiClass { ^PdefGui }
}

TdefPresetGui : ProxyPresetGui {
	proxyGuiClass { ^TdefGui }
}