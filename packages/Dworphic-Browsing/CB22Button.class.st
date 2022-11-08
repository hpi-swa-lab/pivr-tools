Class {
	#name : #CB22Button,
	#superclass : #GRComponent,
	#category : #'Dworphic-Browsing'
}

{ #category : #'as yet unclassified' }
CB22Button >> render: props [

	| areaRef |
	areaRef := self useProvided: #areaRef.
	
	^ GDArea new
	transform: (props at: #transform ifAbsent: [Matrix4x4 identity]);
		children: (self cubeOfSize: 0.2 @ 0.05 @ 0.05 color: Color bubblegum);
		onAreaEntered: [:other| other = areaRef get ifTrue: [(props at: #onPressed) value ]]
]
