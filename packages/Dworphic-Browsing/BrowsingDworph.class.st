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
BrowsingDworph >> collisionShape [

	^ (self godot: #BoxShape) extents: 0.02 @ 0.005 @ 0.03
]

{ #category : #'as yet unclassified' }
BrowsingDworph >> render: props [

| m grabbed pressed |
	m := self
		useMemo: [ "Wird nur einmal ausgeführt"
			(SHTextStylerST80 new
				classOrMetaClass: UndefinedObject;
				styledTextFor: 'abc self terminate' asText) asMorph
				backgroundColor: Color white;
				yourself]
		dependencies: {}.
	grabbed := self useState: false.
	pressed := self useState: false.

	^GRGrabbableArea new
    children: {GDCollisionShape new shape: self collisionShape.
		FormDworph new
			morph: m;
			rotationDegrees: 90 @ 0 @ 0.};
    onButtonPress: [:e | e isTrigger ifTrue: [pressed set: true]];
    onButtonRelease: [:e | e isTrigger ifTrue: [pressed set: false]];
    onGrab: [grabbed set: true];
    onRelease: [grabbed set: false]
	
	
]
