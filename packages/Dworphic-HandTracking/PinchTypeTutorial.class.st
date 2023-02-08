Class {
	#name : #PinchTypeTutorial,
	#superclass : #GRComponent,
	#category : #'Dworphic-HandTracking'
}

{ #category : #'as yet unclassified' }
PinchTypeTutorial class >> appDescription [
	<home>
	^super appDescription
]

{ #category : #'as yet unclassified' }
PinchTypeTutorial >> label: aText [
	^ GDLabel3D new text: aText; pixelSize:  0.25 cm; translation: 0 @ 10 cm @ 2cm; width: 400; autowrap: true
]

{ #category : #'as yet unclassified' }
PinchTypeTutorial >> render: props [
	| currentStage changePhase |
	currentStage := self useState: 1.
	changePhase := [currentStage set: [:val | val. val + 1]].

	^ GDSpatial new translation:-40cm @ 170cm @ 0cm; rotation: 0@1.6@0;children: {	
		(self cubeOfSize: 120 cm @ 120 cm @ 1 cm color: Color lightGray).
		"Using methodAsComponent allows us to dynamically render tutorial phases based on the defined value in currentStage."
		(self methodAsComponent: ('renderPhase',currentStage get,':') asSymbol) onPhaseChange: changePhase.
	}

]

{ #category : #'as yet unclassified' }
PinchTypeTutorial >> renderContinueButton: props [
	| isHovered hasBeenUsed|
	isHovered := self useState: false.
	hasBeenUsed := self useState: false.
	^ props extract: [:onPhaseChange | 
		"The continueButton serves as a one-time-use trigger to switch to a new tutorial phase."
		GRInteractiveArea new translation: 0 @ -50cm @ 1cm; onButtonPress: [
				hasBeenUsed get ifFalse:[
					"We want to avoid triggering the button multiple times."
					hasBeenUsed set: true.
					onPhaseChange value.
					].
				
				]; 
				point: true;
				touch: true;
				onHover: [isHovered set: true];
				onBlur: [isHovered set: false];
				children: {
						(GDLabel3D new text: 'Continue') pixelSize: 0.2cm; translation: 0 @ -0.5 cm @ 1cm.
						(self cubeOfSize: 30 cm @ 10 cm @1 cm color: (isHovered get ifTrue: [ Color orange] ifFalse: [Color lightOrange]))
					}.
		]

]

{ #category : #'as yet unclassified' }
PinchTypeTutorial >> renderPhase1: props [
"Move to next phase once user activates the continueButton"

	^ props extract: [:onPhaseChange | 
		{
		(self label: 'Welcome to the PinchTypev2 Tutorial! This tutorial will teach you how to use Hand Input and PinchTypev2 as an effective Input Method while also giving you some room to experiment. Try to grab the block labelled GRAB ME to move it out of the way. Then press the CONTINUE button by aiming at it with one hand and touching your thumb and index finger (this is called pinching) ').
		(self methodAsComponent: #renderContinueButton:) onPhaseChange: onPhaseChange.
		GRGrabbableArea new translation: 0 @ -0cm @ 0cm; children: {
					(GDLabel3D new text: 'GRAB ME') pixelSize: 0.2cm; translation: 0 @ -50.5 cm @ 18cm.
					((self cubeOfSize: 30 cm @ 10 cm @ 15 cm color: Color lightRed) translation: 0 @ -50cm @ 10cm)
				}.
		}.
		
	]
]

{ #category : #'as yet unclassified' }
PinchTypeTutorial >> renderPhase2: props [
"Move to next phase once user learns about TextFocus and activates the continueButton"

	| focus focusWasActive |
	focus := (self useProvided: #textFocus) get.
	focusWasActive := self useState: false.
	self useEffect: [
			focus notNone ifTrue: [focusWasActive set: true.]
		] dependencies: {focus}.
	^ props extract: [:onPhaseChange | 
		{
		self label: (focus notNone 
			ifFalse: [ 'Great! Now let us type your first words. Select the text field in front of you just like to activated the button.'] 
			ifTrue:
 ['As you can see your finger tips are now individually colored. These colors represent letter groups that you would usually type using said finger when 10 finger typing. Take a moment to familiarize yourself with it. To continue, press the X button on your wrist to close the keyboard and press continue']) .
		self textbox.
		focusWasActive get ifTrue: [(self methodAsComponent: #renderContinueButton:) onPhaseChange: onPhaseChange.]
		}
		
		
		
	].
]

{ #category : #'as yet unclassified' }
PinchTypeTutorial >> renderPhase3: props [
"Move to next phase once user types the words 'Hello World' and activates the continueButton"

	| focus showPart1 showContinue|
	focus := (self useProvided: #textFocus) get.
	showPart1 := self useState: true.
	showContinue := self useState: false.
	^ props extract: [:onPhaseChange | 
		{
		showPart1 get ifTrue: [self label: (focus notNone ifFalse: ['Select the text field once more to get started.']
			ifTrue: ['Now try to type the word "hello" by pinching the finger tip with the correct color for each letter with the thumb of that hand, one letter at a time. You will see which character you entered at the top. To delete a character, touch your thumbs together. When hello is the only word in the suggestion list on your left, close your first to send the word. ']) .].
			(showPart1 get not and: showContinue get not) ifTrue: [
				self label: 'Awesome, now try inserting the word "world" !'.
			].
		showContinue get ifTrue: [self label: 'Fantastic! Now close the keyboard again and press continue'.].
		self textbox onTextEntered: [:text |
			 (text includesSubstring: 'hello' )  ifTrue: [
				showPart1 set: false.
				(text includesSubstring: 'world' ) ifTrue: [
					showContinue set: true].
				]].
		"todo: set showPart1 to false once the text contains the word 'hello' "
		"todo: only show the continue button below once the text contains the word 'hello world'"
		showContinue get ifTrue: [(self methodAsComponent: #renderContinueButton:) onPhaseChange: onPhaseChange.]
		}
		
		
		
	].
]

{ #category : #'as yet unclassified' }
PinchTypeTutorial >> renderPhase4: props [
"Move to next phase once user enteres the word candidate, preferably through the suggestion panel and activates the continueButton"

	| hasTypedCorrectWord |
	hasTypedCorrectWord := self useState: false.
	^ props extract: [:onPhaseChange | {
		self label: (hasTypedCorrectWord get ifFalse: [ 'To make typing more comfortable and faster, PinchTypev2 provides a list of suggestions for each input you make. In order to select one from the list close your hand into a fist like before. This time, you do not open it again immediately, but move it up or down to navigate the suggestion panel on the left of the keyboard. Once you open your fist the word highlighted with >>> will be chosen. Try it by typing "candidate" without typing the entire word'.]
		ifTrue: ['Awesome! This is the end for now.']).
		self textbox onTextEntered: [:t | (t includesSubstring: 'candidate') ifTrue: [hasTypedCorrectWord set: true].].
		hasTypedCorrectWord get ifTrue:  [(self methodAsComponent: #renderContinueButton:)onPhaseChange: onPhaseChange.].
	}]
]

{ #category : #'as yet unclassified' }
PinchTypeTutorial >> renderPhase5: props [
"End of tutorial"

	| hasTypedCorrectWord |
	hasTypedCorrectWord := self useState: false.
	^ props extract: [:onPhaseChange | {
		self label: 'Finally, let"s try to write an entire sentence. Plase write the following sentence. Use the first box for testing, and then let us see how fast you can go!',Character linefeed, Character linefeed, 'The quick brown fox jumps over the lazy dog'.
		self textbox.
		TextInputDworph new translation: 0 @ -40cm @ 2cm 
	}]
]

{ #category : #'as yet unclassified' }
PinchTypeTutorial >> textbox [
	^ TextInputDworph new translation: 0 @ -25cm @ 2cm .
]
