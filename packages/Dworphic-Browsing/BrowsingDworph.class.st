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
BrowsingDworph >> createStyledTextMorph: text [

	^ (SHTextStylerST80 new
				classOrMetaClass: UndefinedObject;
				styledTextFor: text asText) asMorph
				backgroundColor: Color white;
				yourself
]

{ #category : #'as yet unclassified' }
BrowsingDworph >> render: props [

| methods areaRef |
	methods := self useState: [{'self start'}].
	areaRef:= self useGodotRef.

	^ GRProvider values: {#areaRef -> areaRef} children: {
		GDSpatial new children: {
		methods get collect: [:desc | self renderMethod:  {1 -> desc}].
		GRInteractiveArea new onButtonPress: [methods set: [:old | old copyWith: 'self catchOnFire.']] ; children: {
		self cubeOfSize: 0.3 @ 0.3 @ 0.1 color: Color bubblegum}; transform: (Matrix4x4 withOffset: 0 @ 0 @0) 
		}; transform: (Matrix4x4 withOffset: 0 @ 0.7 @ -0.2 )
	}
	
	
	
]

{ #category : #'as yet unclassified' }
BrowsingDworph >> renderMethod: props [

 | grabbed text pressed |

grabbed := self useState: false.
	pressed := self useState: false.
	"self halt."
	text := (props at: 1) value.

	Transcript show: 'render Button'.

^ GRGrabbableArea new
    children: {GDCollisionShape new shape: self collisionShape.
		FormDworph new
			morph: (self createStyledTextMorph: text);
			rotationDegrees: 90 @ 0 @ 0.};
    onButtonPress: [:e | e isTrigger ifTrue: [pressed set: true]];
    onButtonRelease: [:e | e isTrigger ifTrue: [pressed set: false]];
    onGrab: [grabbed set: true];
    onRelease: [grabbed set: false]
]
