Class {
	#name : #AtdRandomizedTreeDworph,
	#superclass : #GRComponent,
	#category : #'Dworphic-Attention-UserTest'
}

{ #category : #rendering }
AtdRandomizedTreeDworph >> render: props [

	^ self renderFull: props
]

{ #category : #rendering }
AtdRandomizedTreeDworph >> renderFull: props [

	| treePosition |
	treePosition := self useState: -8 @ 8.
	
	^ {
		GDSpatial new
			translation: 0 @ 1 @ -0.5;
			children: {
				GDLabel3D new
					horizontalAlignment: GDGlobalConstants halignRight;
					pixelSize: 0.002;
					text: 'Move tree'.
				ButtonDworph new
					color: Color blue;
					onPress: [treePosition set: (Point r: (5 to: 20) atRandom degrees: 360 atRandom)]}.
		(self methodAsComponent: #renderTree:) props: {#position -> treePosition get. #scale -> 1.0. #rotation -> 0} asDictionary}
]

{ #category : #rendering }
AtdRandomizedTreeDworph >> renderTree: props [

	^ props extract: [:scale :position :rotation |
		GDRigidBody new
			name: 'ColoredTree';
			mode: GDRigidBody modeKinematic;
			scale: scale;
			rotationDegrees: rotation;
			translation: position x @ 0 @ position y;
			children: {
				(self cubeOfSize: 0.6 @ 1.8 @ 0.6 color: Color fern) translation: 0 @ (0.9 + 0.2) @ 0.
				(self cubeVisualOfSize: 0.2 asVector3 color: (Color r: 0.6 g: 0.2 b: 0.0)) translation: 0 @ 0.1 @ 0}]
]
