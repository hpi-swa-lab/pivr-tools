Class {
	#name : #AttentionDworph,
	#superclass : #GRComponent,
	#category : #'Dworphic-Attention'
}

{ #category : #rendering }
AttentionDworph >> render: props [

	| target |
	target := props at: #target.
	
	^ (self cubeOfSize: 1 color: Color orange) translation: target
]
