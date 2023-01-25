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
	changePhase := [currentStage set: [:val | Transcript showln: val. val + 1]].

	^ GDSpatial new translation: 0 @ 130cm @ 0cm; children: {	
		(self cubeOfSize: 120 cm @ 120 cm @ 1 cm color: Color lightGray).
		(self methodAsComponent: ('renderPhase',currentStage get,':') asSymbol) onPhaseChange: changePhase.
	}

]

{ #category : #'as yet unclassified' }
PinchTypeTutorial >> renderContinueButton: props [
	| isHovered hasBeenUsed|
	isHovered := self useState: false.
	hasBeenUsed := self useState: false.
	^ props extract: [:onPhaseChange | 
		GRInteractiveArea new translation: 0 @ -50cm @ 1cm; onButtonPress: [
				hasBeenUsed get ifFalse:[
					hasBeenUsed set: true.
					Transcript showln: 'Button entered'.
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

	^ props extract: [:onPhaseChange | 
		{
		(self label: 'Welcome to the PinchTypev2 Tutorial! This tutorial will teach you how to use Hand Input and PinchTypev2 as an effective Input Method while also giving you some room to experiment. Try to move one hand towards the ‘CONTINUE’ button and close your fist to trigger it.').
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

	| focus focusWasActive |
	focus := (self useProvided: #textFocus) get.
	focusWasActive := self useState: false.
	self useEffect: [
			focus ifNotNil: [focusWasActive set: true.]
		] dependencies: {focus}.
	^ props extract: [:onPhaseChange | 
		{
		self label: (focus ifNil: [ 'Great! Now let us type your first words. Select the text field in front of you just like to activated the button.'] ifNotNil: ['As you can see your finger tips are now individually colored. These colors represent letter groups that you would usually type using said finger when 10 finger typing. Take a moment to familiarize yourself with it. To continue, press the X button on your wrist to close the keyboard and press continue']) .
		TextInputDworph new translation: 0 @ -25cm @ 2cm .
		focusWasActive get ifTrue: [(self methodAsComponent: #renderContinueButton:) onPhaseChange: onPhaseChange.]
		}
		
		
		
	].
]

{ #category : #'as yet unclassified' }
PinchTypeTutorial >> renderPhase3: props [

	| focus showPart1 showContinue|
	focus := (self useProvided: #textFocus) get.
	showPart1 := self useState: true.
	showContinue := self useState: false.
	^ props extract: [:onPhaseChange | 
		{
		showPart1 get ifTrue: [self label: (focus ifNil: ['Select the text field once more to get started.'] ifNotNil: ['Now try to type the word ‘hello’ by connecting the respective finger tip for each letter with the thumb of that hand, one letter at a time. You can accept the word you are currently typing by closing your fist and opening it.']) .]
		ifFalse: [
				self label: ['Awesome, now try inserting the word ‘world’ !']
			].
		
		
		TextInputDworph new translation: 0@2cm@8cm; onTextEntered: [:text | (text includesSubstring: 'hello' )  ifTrue: [
				showPart1 set: false.
				(text includesSubstring: 'world' ) ifTrue: [showContinue set: true].
				]].
		"todo: set showPart1 to false once the text contains the word 'hello' "
		"todo: only show the continue button below once the text contains the word 'hello world'"
		showContinue get ifTrue: [(self methodAsComponent: #renderContinueButton:) onPhaseChange: onPhaseChange.]
		}
		
		
		
	].
]
