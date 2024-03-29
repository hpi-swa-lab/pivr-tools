Class {
	#name : #CB22DeleteAllButton,
	#superclass : #GRComponent,
	#category : #'Dworphic-Browsing'
}

{ #category : #rendering }
CB22DeleteAllButton >> render: props [

	| selectedMethods |
	selectedMethods := props at: #selectedMethods. 
	
	^ GRInteractiveArea new
		onButtonPress: [selectedMethods set: {}];
		children: {
			self cubeOfSize: 0.1 @ 0.1 @ 0.1 color: Color red.
			GDLabel3D new
				text: 'Delete all methods';
				pixelSize: 0.0035;
				billboard: GDSpatialMaterial billboardEnabled;
				transform: (Matrix4x4 withOffset: 0 @ 0.2 @ 0)};
		transform: (Matrix4x4 withOffset: -1 @ 1 @ 0)
]
