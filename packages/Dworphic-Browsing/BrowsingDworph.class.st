Class {
	#name : #BrowsingDworph,
	#superclass : #GRComponent,
	#category : #'Dworphic-Browsing'
}

{ #category : #'as yet unclassified' }
BrowsingDworph class >> appDescription [ 

<home>

^ super appDescription
]

{ #category : #'as yet unclassified' }
BrowsingDworph >> render: props [

| m |
	m := self
		useMemo: [ "Wird nur einmal ausgeführt"
			(SHTextStylerST80 new
				classOrMetaClass: UndefinedObject;
				styledTextFor: 'abc self terminate' asText) asMorph
				backgroundColor: Color white;
				yourself]
		dependencies: {}.
	^ WorldDworph new children: (FormDworph new
		morph: m;
		rotationDegrees: 90 @ 0 @ 0)
]
