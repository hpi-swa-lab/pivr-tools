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

| m grabbed pressed areaRef |
	m := self
		useMemo: [self createStyledTextMorph: 'self halt.']
		dependencies: {}.
	grabbed := self useState: false.
	pressed := self useState: false.
	areaRef:= self useGodotRef.

	^ GRProvider values: {#areaRef -> areaRef} children: { GDSpatial new children: {
	self renderMethod: {1 -> m}.
	GRInteractiveArea new onButtonPress: [Transcript show: 'Pressed']; children: {
	self cubeOfSize: 0.3 @ 0.3 @ 0.1 color: Color bubblegum}; transform: (Matrix4x4 withOffset: 0 @ 0 @0) 
	}.
	self renderSphere: 5 }
	
	
]

{ #category : #'as yet unclassified' }
BrowsingDworph >> renderMethod: props [

 | grabbed m pressed |

grabbed := self useState: false.
	pressed := self useState: false.
	"self halt."
	m := (props at: 1) value.


^ GRGrabbableArea new
    children: {GDCollisionShape new shape: self collisionShape.
		FormDworph new
			morph: m;
			rotationDegrees: 90 @ 0 @ 0.};
    onButtonPress: [:e | e isTrigger ifTrue: [pressed set: true]];
    onButtonRelease: [:e | e isTrigger ifTrue: [pressed set: false]];
    onGrab: [grabbed set: true];
    onRelease: [grabbed set: false]
]

{ #category : #'as yet unclassified' }
BrowsingDworph >> renderSphere: radius [

	^ GDCollisionShape new 
		shape: (GDSphereShape new radius: radius);
		children: (GDMeshInstance new mesh: (GDSphereMesh new material: 
		(GDSpatialMaterial new albedoTexture: ("GDImageTexture new call: 'load' arguments: {'res://assets/browsing/sky.jpg'}" self useSkyTexture); paramsCullMode: GDSpatialMaterial cullFront ); radius: radius; height: (radius * 2)))
]

{ #category : #'as yet unclassified' }
BrowsingDworph >> useSkyTexture [

	^ self
		useMemo: [GDResourceLoader instance loadPath: 'res://assets/browsing/sky.jpg']
		dependencies: #()
]
