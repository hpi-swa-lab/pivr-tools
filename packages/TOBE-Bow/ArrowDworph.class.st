Class {
	#name : #ArrowDworph,
	#superclass : #GRComponent,
	#category : #'TOBE-Bow'
}

{ #category : #'as yet unclassified' }
ArrowDworph >> render: props [

	^ GDRigidBody new
		children: (self cubeOfSize: 0.01 @ 0.01 @ 0.1 color: (Color r: 0.6 g: 0.2 b: 0.0));
		transform: (props at: #transform);
		linearVelocity: ((props at: #transform) transform: 0 @ 0 @ (-50 * (props at: #strength)))
]
