Class {
	#name : #AtdArrowDworph,
	#superclass : #GRComponent,
	#category : #'Dworphic-Attention-UserTest'
}

{ #category : #rendering }
AtdArrowDworph >> render: props [

	^ GDRigidBody new
		meta: #'atd_arrow' set: '';
		children: (self cubeOfSize: 0.01 @ 0.01 @ 0.1 color: (Color r: 0.6 g: 0.2 b: 0.0));
		transform: (props at: #transform);
		linearVelocity: ((props at: #transform) transform: 0 @ 0 @ (-50 * (props at: #strength)))
]
