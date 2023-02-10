Class {
	#name : #AtdTreeDworph,
	#superclass : #GRComponent,
	#category : #'Dworphic-Attention-UserTest'
}

{ #category : #rendering }
AtdTreeDworph >> render: props [

	| highlight |
	highlight := true.
	
	^ highlight
		ifTrue: [self renderWithHighlight: props]
		ifFalse: [self renderWithoutHighlight: props]
]

{ #category : #rendering }
AtdTreeDworph >> renderWithHighlight: props [

	| highlighted lastHit onHitCallback |
	onHitCallback := props at: #onHitCallback.
	highlighted := self useState: true.
	lastHit := self useState: Time millisecondClockValue.
	
	(Time millisecondsSince: lastHit get) > 1000 ifTrue: [highlighted set: true].
	
	^ props extract: [:scale :position :rotation |
		GDRigidBody new
			mode: GDRigidBody modeKinematic;
			scale: scale;
			rotationDegrees: rotation;
			translation: position x @ 0 @ position y;
			contactMonitor: true;
			contactsReported: 10;
			onBodyEntered: [:body |
				((body grAsClass: #GDObject) getMetaName: 'atd_arrow') notNil ifTrue: [
					Transcript showln: (body grAsClass: #GDRigidBody) linearVelocity length.
					highlighted set: true.
					lastHit set: Time millisecondClockValue.
					onHitCallback value]];
			children: {
				HighlightDworph new
					active: highlighted get;
					children: {
						(self cubeOfSize: 0.6 @ 1.8 @ 0.6 color: (Color r: 0.108 g: 0.656 b: 0.108)) translation: 0 @ (0.9 + 0.2) @ 0.
						(self cubeVisualOfSize: 0.2 asVector3 color: (Color r: 0.6 g: 0.2 b: 0.0)) translation: 0 @ 0.1 @ 0}}]
]

{ #category : #rendering }
AtdTreeDworph >> renderWithoutHighlight: props [

	| onHitCallback |
	onHitCallback := props at: #onHitCallback.
	^ props extract: [:scale :position :rotation |
		GDRigidBody new
			mode: GDRigidBody modeKinematic;
			scale: scale;
			rotationDegrees: rotation;
			translation: position x @ 0 @ position y;
			contactMonitor: true;
			contactsReported: 10;
			onBodyEntered: [:body | ((body grAsClass: #GDObject) getMetaName: 'atd_arrow') notNil ifTrue: [onHitCallback value]];
			children: {
				(self cubeOfSize: 0.6 @ 1.8 @ 0.6 color: (Color r: 0.108 g: 0.656 b: 0.108)) translation: 0 @ (0.9 + 0.2) @ 0.
				(self cubeVisualOfSize: 0.2 asVector3 color: (Color r: 0.6 g: 0.2 b: 0.0)) translation: 0 @ 0.1 @ 0}]
]
