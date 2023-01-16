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

	| methods areaRef debugPosition browserVisible highQuality os lastCreationEvent nextMethodId grabbedMethod activePackage activeClass browserCenter headTransformRef |
	methods := self useState: {{0. 'NoClass'. 'debug'. 'self halt'}}.
	browserVisible := self useState: false.
	areaRef := self useGodotRef.
	debugPosition := self useState: 0 @ 0 @ 0.
	lastCreationEvent := self useRef: nil.
	nextMethodId := self useState: 0.
	grabbedMethod := self useState: nil.
	activePackage := self useState: nil.
	activeClass := self useState: nil.
	browserCenter := self useState: nil.
	headTransformRef := self useProvidedRef: #headTransform.
	
	self
		useButtonPress: [:e |
			e button = GDGlobalConstants joyOculusBy ifTrue: [
				browserCenter set: headTransformRef get translation.
				browserVisible set: browserVisible get not]]
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
					grabbedMethod: grabbedMethod;
					lastCreationEvent: lastCreationEvent get]}.
		CB22RandomMethodButton new
			methods: methods;
			nextMethodId: nextMethodId;
			lastCreationEvent: lastCreationEvent.
		CB22TrashCan new
			methods: methods;
			grabbedMethod: grabbedMethod.
		CB22DeleteAllButton new methods: methods.
		self renderSphere: 5 highQuality: highQuality.
		browserVisible get ifTrue: [
			CB22PackageBrowser new
				activePackage: activePackage;
				center: browserCenter get.].
		browserVisible get ifTrue: [CB22ClassBrowser new
				activePackage: activePackage get;
				activeClass: activeClass;
				center: browserCenter get.].
			browserVisible get ifTrue: [CB22MethodBrowser new
				activeClass: activeClass get;
				methods: methods;
				nextMethodId: nextMethodId;
				center: browserCenter get]}
]

{ #category : #'as yet unclassified' }
BrowsingDworph >> renderSphere: radius highQuality: highQuality [

	^ GDCollisionShape new
		shape: (GDSphereShape new radius: radius);
		children: (GDMeshInstance new mesh: (GDSphereMesh new
			material: (GDSpatialMaterial new
				albedoTexture: (self useSkyTexture: highQuality);
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
