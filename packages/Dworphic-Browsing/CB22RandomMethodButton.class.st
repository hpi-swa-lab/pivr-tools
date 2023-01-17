Class {
	#name : #CB22RandomMethodButton,
	#superclass : #GRComponent,
	#category : #'Dworphic-Browsing'
}

{ #category : #'as yet unclassified' }
CB22RandomMethodButton >> render: props [

| lastCreationEvent nextMethodId methods| 

lastCreationEvent := props at: #lastCreationEvent.
nextMethodId := props at: #nextMethodId.
methods := props at: #methods.

^GRInteractiveArea new
				onButtonPress: [:e |
					e isGrip ifTrue: [
						lastCreationEvent set: e.
						methods set: [:old | | method |
							nextMethodId set: nextMethodId get + 1.
							method := (CMFFiber methodDict values at: (ThreadSafeRandom nextInt: 40)) value.
							old copyWith: {nextMethodId get. CMFFiber name. method selector. method getSource asString}]]];
				children: {
					self cubeOfSize: 0.2 @ 0.3 @ 0.1 color: Color bubblegum.
					GDLabel3D new
						text: 'Create new random method';
						pixelSize: 0.0035;
						billboard: GDSpatialMaterial billboardEnabled;
						transform: (Matrix4x4 withOffset: 0 @ 0.2 @ 0)};
				transform: (Matrix4x4 withOffset: 0 @ 1 @ 0).

]