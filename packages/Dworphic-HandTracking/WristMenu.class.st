Class {
	#name : #WristMenu,
	#superclass : #GRComponent,
	#category : #'Dworphic-HandTracking'
}

{ #category : #'as yet unclassified' }
WristMenu >> render: props [
	| allFingerRefs focus |
	allFingerRefs := self useProvided: #allFingerRefs.
	focus := self useProvided: #textFocus.
	^ props extract: [:onButtonPress :onButtonRelease :pos |
		  pos = Vector3 zero ifFalse: {
			GDArea new children: {
				(GDLabel3D new text: 'X') pixelSize: 0.1cm; rotationDegrees: 90 @ 0 @ 180; translation: 0 @ -0.5 cm @ 0.
				(self cubeOfSize: 3 cm @ 1 cm @3 cm color: Color lightBlue)}; 
					translation: 2cm @ -2cm @ 0 cm; 
					onAreaEntered: [: other | (allFingerRefs get anySatisfy: [:ref | ref get = other]) ifTrue: [ 
						focus set: GRTextFocus none]].
			GDArea new children: {
				(GDLabel3D new text: 'AppControl') pixelSize: 0.05cm; rotationDegrees: 90 @ 0 @ 180; translation: 0 @ -0.5 cm @ 0.
				(self cubeOfSize: 3 cm @ 1 cm @3 cm color: Color lightGreen)};
					translation: -2cm @ -2cm @ 0 cm;
					onAreaEntered: [: other | (allFingerRefs get anySatisfy: [:ref | ref get = other]) ifTrue: [
						onButtonPress value: GDGlobalConstants joyOculusAx.]].
		}
		]
	
]
