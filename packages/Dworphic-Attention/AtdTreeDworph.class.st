Class {
	#name : #AtdTreeDworph,
	#superclass : #GRComponent,
	#category : #'Dworphic-Attention-UserTest'
}

{ #category : #'as yet unclassified' }
AtdTreeDworph >> render: props [

	| highlighted |
	highlighted := self useState: false.

	^ props extract: [:scale :position :rotation |
		GDRigidBody new
			mode: GDRigidBody modeKinematic;
			scale: scale;
			rotationDegrees: rotation;
			translation: position x @ 0 @ position y;
			contactMonitor: true;
			contactsReported: 10;
			onBodyEntered: [:body | highlighted set: true];
			children: {HighlightDworph new active: highlighted get; children: {
				(self cubeOfSize: 0.6 @ 1.8 @ 0.6 color: (Color r: 0.108 g: 0.656 b: 0.108)) translation: 0 @ (0.9 + 0.2) @ 0.
				(self cubeVisualOfSize: 0.2 asVector3 color: (Color r: 0.6 g: 0.2 b: 0.0)) translation: 0 @ 0.1 @ 0.
				}}]
]
