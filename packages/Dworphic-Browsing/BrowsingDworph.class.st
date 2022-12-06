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
BrowsingDworph >> a [

	| grabbed pressed transform |
	self
		onButtonPress: [:e |
			"TODO: Make the collision shape as big as the method"
			e isTrigger ifTrue: [pressed set: true].
			e button = GDGlobalConstants joyOculusBy ifTrue: ["transform set: ( transform get translation: (e transform forwardRay intersectSphere: 0 @ 0 @ 0 radius: 5))"
			]];
		onButtonRelease: [:e | e isTrigger ifTrue: [pressed set: false]];
		onGrab: [grabbed set: true];
		onRelease: [:e |
			"transform set: e transform"
			grabbed set: false.
			transform set: [
				(Matrix4x4
					lookAt: 0 @ 0 @ 0
					from: (e transform forwardRay intersectSphere: 0 @ 0 @ 0 radius: 2)
					up: 0 @ 1 @ 0) translation: (e transform forwardRay intersectSphere: 0 @ 0 @ 0 radius: 2)
				"transform set: (transform get
				translation: (e transform forwardRay intersectSphere: 0 @ 0 @ 0 radius: 2);
				rotation: (e transform forwardRay direction angleTo: -1 @ 0 @ 0) radiansToDegrees @ (e transform forwardRay direction angleTo: 0 @ -1 @ 0) radiansToDegrees @ (e transform forwardRay direction angleTo: 0 @ 0 @ -1) radiansToDegrees)"]]
]

{ #category : #'as yet unclassified' }
BrowsingDworph >> collisionShape [

	^ (self godot: #BoxShape) extents: 0.06 @ 0.015 @ 0.07
]

{ #category : #'as yet unclassified' }
BrowsingDworph >> getTextMorphExtent: morph [

	| extent |
	extent := morph imageForm extent.
	^ 0.015 @ (extent x * 0.0005) @ (extent y * 0.0005)
]

{ #category : #'as yet unclassified' }
BrowsingDworph >> getTextMorphShape: morph [

	^ (self godot: #BoxShape) extents: (self getTextMorphExtent: morph)
]

{ #category : #'as yet unclassified' }
BrowsingDworph >> methodTransformAfterBeam [

	| head et transform |
	head := self useHeadTransform.
	et := self useProvided: #rightControllerTransform.
	transform := self transformInSphere: et center: et translation radius: 0.1.
	^ Matrix4x4 lookAt: head from: transform translate up: (0 @ 1 @0)
]

{ #category : #'as yet unclassified' }
BrowsingDworph >> pinpoardCenter [

	^ 0 @ 2 @ 0
]

{ #category : #'as yet unclassified' }
BrowsingDworph >> pinpoardRadius [

	^ 1.5
]

{ #category : #'as yet unclassified' }
BrowsingDworph >> render: props [

	| methods areaRef debugPosition browserVisible highQuality os lastCreationEvent |
	methods := self useState: {'self halt'}.
	browserVisible := self useState: false.
	areaRef := self useGodotRef.
	debugPosition := self useState: 0 @ 0 @ 0.
	lastCreationEvent := self useRef: nil.
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
				(self methodAsComponent: #renderMethod:)
					text: desc;
					key: desc;
					lastCreationEvent: lastCreationEvent get].
			GRInteractiveArea new
				onButtonPress: [:e |
					e isTrigger ifTrue: [
						lastCreationEvent set: e.
						methods set: [:old | old copyWith: (CMFFiber methodDict values at: (ThreadSafeRandom nextInt: 40)) value getSource asString]]];
				children: {
					self cubeOfSize: 0.2 @ 0.3 @ 0.1 color: Color bubblegum.
					GDLabel3D new
						text: 'Create new random method';
						pixelSize: 0.0035;
						billboard: GDSpatialMaterial billboardEnabled;
						transform: (Matrix4x4 withOffset: 0 @ 0.2 @ 0)};
				transform: (Matrix4x4 withOffset: 0 @ 1 @ 0).
			GRInteractiveArea new
				onButtonPress: [:e | e isTrigger ifTrue: [methods set: {}]];
				children: {
					self cubeOfSize: 0.2 @ 0.3 @ 0.1 color: Color red.
					GDLabel3D new
						text: 'Delete all methods';
						pixelSize: 0.0035;
						billboard: GDSpatialMaterial billboardEnabled;
						transform: (Matrix4x4 withOffset: 0 @ 0.2 @ 0)};
				transform: (Matrix4x4 withOffset: -1 @ 1 @ 0)}.
		self renderSphere: 5 highQuality: highQuality.
		browserVisible get ifTrue: [CB22Browser new methods: methods]}
]

{ #category : #'as yet unclassified' }
BrowsingDworph >> renderMethod: props [

	| grabbed text pressed morph debugPosition world transform t et onPinboard endGrab api initialized |
	grabbed := self useState: false.
	pressed := self useState: false.
	initialized := self useState: false.
	world := self useWorldPortal.
	text := (props at: #text) value.
	morph := self useStyledTextMorph: text.
	debugPosition := self useState: 0 @ 0 @ 0.
	transform := self useState: (Matrix4x4 identity
		rotation: -180 around: 1 @ 0 @ 0;
		rotation: 180 around: 0 @ 1 @ 0;
		translation: 0 @ 1.5 @ 0.5).
	
	onPinboard := self useState: false.
	endGrab := self useRef: nil.
	api := Dictionary new.
	
	et := self useProvided: #rightControllerTransform.
	"TODO: move to method"
	t := (et forwardRay intersectSphere: self pinpoardCenter radius: self pinpoardRadius)
		ifNotNil: [:i | (Matrix4x4 lookAt: i from: self pinpoardCenter up: 0 @ 1 @ 0) translation: i]
		ifNil: [Matrix4x4 identity].
	self
		useEffect: [
			(props at: #lastCreationEvent) ifNotNil: [
				(api at: #startGrab) value: (props at: #lastCreationEvent).
				(api at: #setGrabOffset) value: (Matrix4x4 withRotation: -90 around: 1 @ 0 @ 0)]]
		dependencies: {}.
	^ GRGrabbableArea new
		api: api;
		point: onPinboard get;
		children: {
			GDCollisionShape new
				shape: (self getTextMorphShape: morph);
				rotation: 4.2 @ 0 @ Float pi / 2.
			GDSpatial new
				children: {
					FormDworph new
						morph: morph;
						rotationDegrees: 0 @ 0 @ 0;
						translation: 0 @ 0.017 @ 0.
					CMFReactNodePortal
						child: (DebugDworph new
							label: 'Intersection';
							point: ((et forwardRay intersectSphere: self pinpoardCenter radius: self pinpoardRadius) ifNil: [0 @ 0 @ 0]))
						in: world.
					GDMeshInstance new
						mesh: (GDCubeMesh new
							size: (self getTextMorphExtent: morph) * 2;
							material: (GDSpatialMaterial new albedoColor: (grabbed get ifTrue: [Color lightBlue] ifFalse: [Color lightGray])));
						rotation: 0 @ 0 @ Float pi / 2;
						scale: 1 @ 1 @ 1};
				rotation: 90 @ 0 @ 0};
		transform: transform get;
		onAxisChange: [:e |
			e isStickY ifTrue: [
				(onPinboard get not and: [e strength > 0.5]) ifTrue: [
					onPinboard set: true.
					(api at: #endGrab) value]].
			(onPinboard get and: [e strength < -0.5]) ifTrue: [
				onPinboard set: false.
				transform set: (self transformInSphere: et center: et translation radius: 2 cm)]];
		onButtonRelease: [:e | e isTrigger ifTrue: [pressed set: false]];
		onGrab: [
			grabbed set: true.
			onPinboard set: false];
		onRelease: [:e |
			onPinboard get ifTrue: [transform set: t] ifFalse: [transform set: e transform].
			grabbed set: false]
]

{ #category : #'as yet unclassified' }
BrowsingDworph >> renderMethod: props creationEvent: ce [

	| grabbed text pressed morph debugPosition world transform t et onPinboard endGrab api initialized creationEvent |
	grabbed := self useState: false.
	pressed := self useState: false.
	initialized := self useState: false.
	world := self useWorldPortal.
	text := (props at: #text) value.
	morph := self useStyledTextMorph: text.
	debugPosition := self useState: 0 @ 0 @ 0.
	transform := self useState: (Matrix4x4 identity
		rotation: -180 around: 1 @ 0 @ 0;
		rotation: 180 around: 0 @ 1 @ 0;
		translation: 0 @ 1.5 @ 0.5).
	
	creationEvent := self useRef: ce.
	
	onPinboard := self useState: false.
	endGrab := self useRef: nil.
	api := Dictionary new.
	
	et := self useProvided: #rightControllerTransform.
	"TODO: move to method"
	t := (et forwardRay intersectSphere: self pinpoardCenter radius: self pinpoardRadius)
		ifNotNil: [:i | (Matrix4x4 lookAt: i from: self pinpoardCenter up: 0 @ 1 @ 0) translation: i]
		ifNil: [Matrix4x4 identity].
	self useEffect: [(api at: #startGrab) value: creationEvent] dependencies: {}.
	^ GRGrabbableArea new
		api: api;
		point: onPinboard get;
		children: {
			GDCollisionShape new
				shape: (self getTextMorphShape: morph);
				rotation: 90 @ 0 @ 300.
			GDSpatial new
				children: {
					FormDworph new
						morph: morph;
						rotationDegrees: 0 @ 0 @ 0.
					CMFReactNodePortal
						child: (DebugDworph new
							label: 'Intersection';
							point: ((et forwardRay intersectSphere: self pinpoardCenter radius: self pinpoardRadius) ifNil: [0 @ 0 @ 0]))
						in: world};
				rotation: 90 @ 0 @ 0};
		transform: transform get;
		onAxisChange: [:e |
			e isStickY ifTrue: [
				(onPinboard get not and: [e strength > 0.5]) ifTrue: [
					onPinboard set: true.
					(api at: #endGrab) value]].
			(onPinboard get and: [e strength < -0.5]) ifTrue: [
				onPinboard set: false.
				transform set: (self transformInSphere: et center: et translation radius: 2 cm)]];
		onButtonRelease: [:e | e isTrigger ifTrue: [pressed set: false]];
		onGrab: [
			grabbed set: true.
			onPinboard set: false];
		onRelease: [:e |
			onPinboard get ifTrue: [transform set: t] ifFalse: [transform set: e transform].
			grabbed set: false]
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
BrowsingDworph >> transformInSphere: et center: c radius: r [

	^ (et forwardRay intersectSphere: c radius: r)
		ifNotNil: [:i | (Matrix4x4 lookAt: i from: c up: 0 @ 1 @ 0) translation: i]
		ifNil: [Matrix4x4 identity]
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
