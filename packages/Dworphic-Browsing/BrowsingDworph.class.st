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
		GRInteractiveArea new onButtonPress: [:e | e isTrigger ifTrue: [methods set: [:old | old copyWith: (CMFFiber methodDict values at: (ThreadSafeRandom nextInt: 40)) value getSource asString]]] ; children: {
		self cubeOfSize: 0.3 @ 0.3 @ 0.1 color: Color bubblegum}; transform: (Matrix4x4 withOffset: 0 @ 0.7 @ -0.5) 
		}.
		self renderSphere: 5
	}
	
]

{ #category : #'as yet unclassified' }
BrowsingDworph >> renderMethod: props [
| grabbed text pressed morph debugPosition |

grabbed := self useState: false.
	pressed := self useState: false.
	"self halt."
	text := (props at: #text) value.
	morph:= self useStyledTextMorph: text.
	 debugPosition := self useState: 0@0@0.

^ GRGrabbableArea new
    children: {GDCollisionShape new shape: self collisionShape.
		"GDLabel3D new
			text: text;"
			FormDworph new morph: morph;
			rotationDegrees: 90 @ 0 @ 0.
			DebugDworph new point: debugPosition get};
    onButtonPress: [:e | e isTrigger ifTrue: [pressed set: true]. e button = GDGlobalConstants joyOculusBy ifTrue: [debugPosition set: (e transform forwardRay intersectSphere: 0 @ 0 @ 0 radius: 5) second]];
    onButtonRelease: [:e | e isTrigger ifTrue: [pressed set: false]];
    onGrab: [grabbed set: true];
    onRelease: [grabbed set: false];
translate: (Matrix4x4 withOffset: 0 @ 0.75 @ 0.1)

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
		useMemo: [GDResourceLoader instance loadPath: 'res://assets/browsing/sky_slim_low_res.png']
		dependencies: #()
]

{ #category : #'as yet unclassified' }
BrowsingDworph >> useStyledTextMorph: text [

	^ self useMemo: [(SHTextStylerST80 new
				classOrMetaClass: UndefinedObject;
				styledTextFor: text asText) asMorph
				backgroundColor: Color white;
				yourself] dependencies: {text}
]
