Class {
	#name : #CB22RandomMethodButton,
	#superclass : #GRComponent,
	#category : #'Dworphic-Browsing'
}

{ #category : #rendering }
CB22RandomMethodButton >> render: props [

	| lastCreationEvent nextMethodId selectedMethods sourceClass |
	lastCreationEvent := props at: #lastCreationEvent.
	nextMethodId := props at: #nextMethodId.
	selectedMethods := props at: #selectedMethods.
	sourceClass := CMFFiber.
	
	^ GRInteractiveArea new
		onButtonPress: [:e |
			e isGrip ifTrue: [
				lastCreationEvent set: e.
				selectedMethods set: [:old | | method |
					nextMethodId set: nextMethodId get + 1.
					method := (CMFFiber methodDict values at: (ThreadSafeRandom nextInt: 40)) value.
					old CB22MethodSpec fromKey: nextMethodId get Class: sourceClass name Name: method selector text: method getSource asString]]];
		children: {
			self cubeOfSize: 0.2 @ 0.3 @ 0.1 color: Color bubblegum.
			GDLabel3D new
				text: 'Create new random method';
				pixelSize: 0.0035;
				billboard: GDSpatialMaterial billboardEnabled;
				transform: (Matrix4x4 withOffset: 0 @ 0.2 @ 0)};
		transform: (Matrix4x4 withOffset: 0 @ 1 @ 0)
]
