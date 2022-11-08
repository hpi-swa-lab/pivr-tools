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

| methods areaRef |
	methods := self useState: {'self start'}.
	areaRef:= self useGodotRef.

	^ GRProvider values: {#areaRef -> areaRef} children: {
		GDSpatial new children: {
		methods get collect: [:desc | (self methodAsComponent: #renderMethod:)  text: desc; key: desc ].
		GRInteractiveArea new onButtonPress: [:e | e isTrigger ifTrue: [methods set: [:old | old copyWith: 'a ', ThreadSafeRandom next asString]]] ; children: {
		self cubeOfSize: 0.3 @ 0.3 @ 0.1 color: Color bubblegum}; transform: (Matrix4x4 withOffset: 0 @ 0.7 @ -0.5) 
		}
	}
	
	
	
]

{ #category : #'as yet unclassified' }
BrowsingDworph >> renderMethod: props [

 | grabbed text pressed morph |

grabbed := self useState: false.
	pressed := self useState: false.
	"self halt."
	text := (props at: #text) value.
	morph:= self useStyledTextMorph: text.

^ GRGrabbableArea new
    children: {GDCollisionShape new shape: self collisionShape.
		"GDLabel3D new
			text: text;"
			FormDworph new morph: morph;
			rotationDegrees: 90 @ 0 @ 0.};
    onButtonPress: [:e | e isTrigger ifTrue: [pressed set: true]];
    onButtonRelease: [:e | e isTrigger ifTrue: [pressed set: false]];
    onGrab: [grabbed set: true];
    onRelease: [grabbed set: false];
translate: (Matrix4x4 withOffset: 0 @ 0.75 @ 0.1)
]

{ #category : #'as yet unclassified' }
BrowsingDworph >> useStyledTextMorph: text [

	
	^ self useMemo: [(SHTextStylerST80 new
				classOrMetaClass: UndefinedObject;
				styledTextFor: text asText) asMorph
				backgroundColor: Color white;
				yourself] dependencies: {text}
]
