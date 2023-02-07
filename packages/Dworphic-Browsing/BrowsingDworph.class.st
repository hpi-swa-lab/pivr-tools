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

	| selectedMethods areaRef browserVisible highQuality os lastCreationEvent nextMethodId grabbedMethod activePackage activeClass browserCenter headTransformRef activeMethod sphereVisible |
	selectedMethods := self useState: {CB22MethodSpec fromKey: 1 Class: 'No class' Name: 'noMethodName' text: 'self halt.'}.
	browserVisible := self useState: false.
	areaRef := self useGodotRef.
	lastCreationEvent := self useRef: nil.
	nextMethodId := self useState: 2.
	grabbedMethod := self useState: nil.
	activePackage := self useState: nil.
	activeClass := self useState: nil.
	activeMethod := self useState: nil.
	sphereVisible := self useState: true.
	browserCenter := self useState: nil.
	headTransformRef := self useProvidedRef: #headTransform.
	
	"Transcript showln: selectedMethods get."
	
	self
		useButtonPress: [:e |
			e button = GDGlobalConstants joyOculusBy ifTrue: [
				browserCenter set: headTransformRef get translation.
				browserVisible set: browserVisible get not.
				selectedMethods set: (selectedMethods get reject: [:desc | (desc key) = 0])]]
		release: [:e | ]
		axisChange: [:e | ]
		side: #right.
	
	self
		useButtonPress: [:e | e button = GDGlobalConstants joyOculusAx ifTrue: [sphereVisible set: sphereVisible get not]]
		release: [:e | ]
		axisChange: [:e | ]
		side: #left.
	
	os := self useMemo: [GDOS instance getName] dependencies: {}.
	highQuality := os ~= 'Android'.
	
	^ GRProvider values: {#areaRef -> areaRef} children: {
		GDSpatial new children: {
			selectedMethods get collect: [:desc |
				CB22Method new
					desc: desc;
					key: desc key;
					grabbedMethod: grabbedMethod;
					selectedMethods: selectedMethods;
					nextMethodId: nextMethodId;
					lastCreationEvent: lastCreationEvent get]}.
		CB22TrashCan new
			selectedMethods: selectedMethods;
			grabbedMethod: grabbedMethod.
		CB22DeleteAllButton new selectedMethods: selectedMethods.
		self renderSphere: 5 highQuality: highQuality visible: sphereVisible get.
		browserVisible get ifTrue: [
			CB22PackageBrowser new
				activePackage: activePackage;
				center: browserCenter get].
		browserVisible get ifTrue: [
			CB22ClassBrowser new
				activePackage: activePackage get;
				activeClass: activeClass;
				center: browserCenter get].
		browserVisible get ifTrue: [
			CB22MethodBrowser new
				activeClass: activeClass get;
				activeMethod: activeMethod;
				selectedMethods: selectedMethods;
				center: browserCenter get]}
]

{ #category : #'as yet unclassified' }
BrowsingDworph >> renderSphere: radius highQuality: highQuality visible: visible [

	^ GDCollisionShape new
		shape: (GDSphereShape new radius: radius);
		children: (GDMeshInstance new mesh: (GDSphereMesh new
			material: (GDSpatialMaterial new
				albedoTexture: (self useSkyTexture: highQuality);
				paramsCullMode: GDSpatialMaterial cullFront);
			radius: radius;
			height: radius * 2); visible: visible)
]

{ #category : #'as yet unclassified' }
BrowsingDworph >> useSkyTexture: highQuality [

	^ self
		useMemo: [
			GDResourceLoader instance loadPath: (highQuality
				ifFalse: ['res://assets/browsing/sky_slim_low_res.jpg']
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
