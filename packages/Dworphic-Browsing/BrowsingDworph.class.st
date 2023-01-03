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
BrowsingDworph class >> pinboardCenter [

	^ 0 @ 2 @ 0
]

{ #category : #'as yet unclassified' }
BrowsingDworph class >> pinboardRadius [

	^ 1.5
]

{ #category : #'as yet unclassified' }
BrowsingDworph >> render: props [

	| methods areaRef debugPosition browserVisible highQuality os lastCreationEvent nextMethodId trashCanMesh |
	methods := self useState: {{0. 'NoClass'. 'debug'. 'self halt'}}.
	browserVisible := self useState: false.
	areaRef := self useGodotRef.
	debugPosition := self useState: 0 @ 0 @ 0.
	lastCreationEvent := self useRef: nil.
	nextMethodId := self useState: 0.
	trashCanMesh := self useTrashCanMesh.
	self
		useButtonPress: [:e | e button = GDGlobalConstants joyOculusBy ifTrue: [browserVisible set: browserVisible get not]]
		release: [:e | ]
		axisChange: [:e | ]
		side: #right.
	
	os := self useMemo: [GDOS instance getName] dependencies: {}.
	highQuality := os ~= 'Android'.
	
	^ GRProvider values: {#areaRef -> areaRef} children: {
		GDSpatial new children: {
			methods get collect: [:desc |
				(CB22Method new methodAsComponent: #render:)
					key: desc first;
					class: desc second;
					name: desc third;
					text: desc fourth;
					lastCreationEvent: lastCreationEvent get].
			GRInteractiveArea new
				onButtonPress: [:e |
					e isGrip ifTrue: [
						lastCreationEvent set: e.
						methods set: [:old | | method |
							nextMethodId set: nextMethodId get + 1.
							method := (CMFFiber methodDict values at: (ThreadSafeRandom nextInt: 40)) value.
							old copyWith: {nextMethodId get. CMFFiber name. method selector. method getSource asString}]]];
				children: {
					self cubeOfSize: 0.2 @ 0.3 @ 0.1 color: Color bubblegum.
					GDLabel3D new
						text: 'Create new random method';
						pixelSize: 0.0035;
						billboard: GDSpatialMaterial billboardEnabled;
						transform: (Matrix4x4 withOffset: 0 @ 0.2 @ 0)};
				transform: (Matrix4x4 withOffset: 0 @ 1 @ 0).
			GRInteractiveArea new
				onButtonPress: [:e | e isGrip ifTrue: [methods set: {}]];
				children: {
					self cubeOfSize: 0.2 @ 0.3 @ 0.1 color: Color red.
					GDLabel3D new
						text: 'Delete all methods';
						pixelSize: 0.0035;
						billboard: GDSpatialMaterial billboardEnabled;
						transform: (Matrix4x4 withOffset: 0 @ 0.2 @ 0)};
				transform: (Matrix4x4 withOffset: -1 @ 1 @ 0)}.
			GRInteractiveArea new
				onButtonRelease: [:e | e isGrip ifTrue: [methods set: {[:old | old copyWithoutKey: e]}]];
				children: {
				GDMeshInstance new
					mesh: trashCanMesh;
					scale: 0.0015 asVector3;
					rotation: -1.6 @ 0 @0 };
				transform: (Matrix4x4 withOffset: 0 @ 0 @ 0).
		self renderSphere: 5 highQuality: highQuality.
		browserVisible get ifTrue: [CB22Browser new methods: methods; nextMethodId: nextMethodId]}
]

{ #category : #'as yet unclassified' }
BrowsingDworph >> renderSphere: radius highQuality: highQuality [

	^ GDCollisionShape new
		shape: (GDSphereShape new radius: radius);
		children: (GDMeshInstance new mesh: (GDSphereMesh new
			material: (GDSpatialMaterial new
				albedoTexture: (self useWinterTexture: true image: 'landscape');
				paramsCullMode: GDSpatialMaterial cullFront);
			radius: radius;
			height: radius * 2))
]

{ #category : #'as yet unclassified' }
BrowsingDworph >> useSkyTexture: highQuality [

	^ self
		useMemo: [
			GDResourceLoader instance loadPath: (highQuality
				ifFalse: ['res://assets/browsing/sky_slim_low_res.png']
				ifTrue: ['res://assets/browsing/sky.jpg'])]
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

{ #category : #'as yet unclassified' }
BrowsingDworph >> useTrashCanMesh [

	^ self
		useMemo: [GDResourceLoader instance loadPath: 'res://assets/models/trash_can/trash_can.tres']
		dependencies: #()
]

{ #category : #'as yet unclassified' }
BrowsingDworph >> useWinterTexture: highQuality [

	^ self
		useMemo: [
			GDResourceLoader instance loadPath: (highQuality
				ifFalse: ['res://assets/browsing/sky_slim_low_res.png']
				ifTrue: ['res://assets/browsing/sky.jpg'])]
		dependencies: #()
]

{ #category : #'as yet unclassified' }
BrowsingDworph >> useWinterTexture: highQuality image: image [

	^ self
		useMemo: [
			GDResourceLoader instance loadPath: (highQuality
				ifTrue: [
					image = 'landscape'
						ifTrue: ['res://assets/assets-large/winter_landscape_high_res.png']
						ifFalse: ['res://assets/assets-large/winter_church_high_res.jpg']]
				ifFalse: [
					image = 'church'
					ifTrue: ['res://assets/assets-large/winter_church_low_res.jpg']
					ifFalse: ['res://assets/assets-large/winter_landscape_low_res.jpg']]
			)
		]
		dependencies: #()
]
