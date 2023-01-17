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
PinchTypeTutorial >> render: props [
	| currentStage |
	currentStage := self useState: 1.

	^(self methodAsComponent: #renderPhase1:) onPhaseChange: [].

]

{ #category : #'as yet unclassified' }
PinchTypeTutorial >> renderPhase1: props [

	| isHovered |
	isHovered := self useState: false.
	^ props extract: [:onPhaseChange | 
		{
		(GDLabel3D new text: 'HAHAWOIDHAOHIWDOBAIWDOHIAWD',Character linefeed,'IAWDIGAWDIUIA') pixelSize:  0.5 cm; translation: 0 @ 10 cm @ 2cm.
		(self cubeOfSize: 120 cm @ 120 cm @ 1 cm color: Color lightGray).
		
		GRInteractiveArea new translation: 0 @ 130cm @ 1cm; onButtonPress: [
			Transcript showln: 'Button entered'.
			]; 
			point: true;
			touch: true;
			onHover: [isHovered set: true];
			onBlur: [isHovered set: false];
			children: {
					(GDLabel3D new text: 'Continue') pixelSize: 0.2cm; translation: 0 @ -0.5 cm @ 4cm.
					(self cubeOfSize: 30 cm @ 30 cm @1 cm color: Color lightOrange)
				}.
		GRGrabbableArea new translation: 0 @ 130cm @ 10cm; children: {
					(GDLabel3D new text: 'GRAB ME') pixelSize: 0.2cm; translation: 0 @ -0.5 cm @ 4cm.
					(self cubeOfSize: 100 cm @ 100 cm @ 15 cm color: Color lightRed)
				}.
		}.
		
	]
]
