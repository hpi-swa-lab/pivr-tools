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
	^ GDLabel3D new text: aText; pixelSize:  0.5 cm; translation: 0 @ 10 cm @ 2cm; width: 1; autowrap: true
]

{ #category : #'as yet unclassified' }
PinchTypeTutorial >> render: props [
	| currentStage changePhase |
	currentStage := self useState: 1.
	changePhase := [currentStage set: [:val | val + 1]].

	^{
		(self cubeOfSize: 120 cm @ 120 cm @ 1 cm color: Color lightGray).
		(self methodAsComponent: #renderPhase1:) onPhaseChange: changePhase.
	}

]

{ #category : #'as yet unclassified' }
PinchTypeTutorial >> renderPhase1: props [

	| isHovered |
	isHovered := self useState: false.
	^ props extract: [:onPhaseChange | 
		{
		(self label: 'Welcome to the PinchTypev2 Tutorial! This tutorial will teach you how to use Hand Input and PinchTypev2 as an effective Input Method while also giving you some room to experiment. Try to move one hand towards the ‘CONTINUE’ button and close your fist to trigger it.').
		GRInteractiveArea new translation: 0 @ 130cm @ 1cm; onButtonPress: [
			Transcript showln: 'Button entered'.
			onPhaseChange value.
			]; 
			point: true;
			touch: true;
			onHover: [isHovered set: true];
			onBlur: [isHovered set: false];
			children: {
					(GDLabel3D new text: 'Continue') pixelSize: 0.2cm; translation: 0 @ -0.5 cm @ 4cm.
					(self cubeOfSize: 30 cm @ 30 cm @1 cm color: (isHovered ifTrue: [ Color orange] ifFalse: [Color lightOrange]))
				}.
		GRGrabbableArea new translation: 0 @ 130cm @ 10cm; children: {
					(GDLabel3D new text: 'GRAB ME') pixelSize: 0.2cm; translation: 0 @ -0.5 cm @ 4cm.
					(self cubeOfSize: 100 cm @ 100 cm @ 15 cm color: Color lightRed)
				}.
		}.
		
	]
]

{ #category : #'as yet unclassified' }
PinchTypeTutorial >> renderPhase2: props [

	| isHovered focus |
	isHovered := self useState: false.
	focus := (self useProvided: #textFocus) get.
	^ props extract: [:onPhaseChange | 
		{
		self label: (focus ifNil: [ 'Great! Now let us type your first words. Select the text field in front of you just like to activated the button.'] ifNotNil: ['As you can see your finger tips are now individually colored. These colors represent letter groups that you would usually type using said finger when 10 finger typing. Take a moment to familiarize yourself with it. To continue, press the X button on your wrist to close the keyboard and press continue']) .
		}
		TextInputDworph new.
		GRInteractiveArea new translation: 0 @ 130cm @ 1cm; onButtonPress: [
			Transcript showln: 'Button entered'.
			onPhaseChange value.
			]; 
			point: true;
			touch: true;
			onHover: [isHovered set: true];
			onBlur: [isHovered set: false];
			children: {
					(GDLabel3D new text: 'Continue') pixelSize: 0.2cm; translation: 0 @ -0.5 cm @ 4cm.
					(self cubeOfSize: 30 cm @ 30 cm @1 cm color: (isHovered ifTrue: [ Color orange] ifFalse: [Color lightOrange]))
				}.
	].
]
