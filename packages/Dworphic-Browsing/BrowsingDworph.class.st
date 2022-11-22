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
BrowsingDworph >> getTextMorphShape: morph [

	| extent |
	extent := morph imageForm extent.
	^ (self godot: #BoxShape) extents: 0.015 @ (extent x * 0.0005) @ (extent y * 0.0005)
]

{ #category : #'as yet unclassified' }
BrowsingDworph >> pinpoardCenter [

	^ 0 @ 1.5 @ 0
]

{ #category : #'as yet unclassified' }
BrowsingDworph >> pinpoardRadius [

	^ 2
]

{ #category : #'as yet unclassified' }
BrowsingDworph >> render: props [

	| methods areaRef debugPosition |
	methods := self useState: {'self start'}.
	areaRef := self useGodotRef.
	debugPosition := self useState: 0 @ 0 @ 0.
	^ GRProvider values: {#areaRef -> areaRef} children: {
		GDSpatial new children: {
			methods get collect: [:desc |
				(self methodAsComponent: #renderMethod:)
					text: desc;
					key: desc].
			GRInteractiveArea new
				onButtonPress: [:e | e isTrigger ifTrue: [methods set: [:old | old copyWith: (CMFFiber methodDict values at: (ThreadSafeRandom nextInt: 40)) value getSource asString]]];
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
		self renderSphere: 5}
]

{ #category : #'as yet unclassified' }
BrowsingDworph >> renderMethod: props [

	| grabbed text pressed morph debugPosition world transform t et onPinboard |
	grabbed := self useState: false.
	pressed := self useState: false.
	world := self useWorldPortal.
	text := (props at: #text) value.
	morph := self useStyledTextMorph: text.
	debugPosition := self useState: 0 @ 0 @ 0.
	transform := self useState: (Matrix4x4 identity
		rotation: -180 around: 1 @ 0 @ 0;
		rotation: 180 around: 0 @ 1 @ 0;
		translation: 0 @ 1.5 @ 0.5).
	
	onPinboard := self useState: false.
	
	et := self useProvided: #rightControllerTransform.
	t := (et forwardRay intersectSphere: self pinpoardCenter radius: self pinpoardRadius)
		ifNotNil: [:i | (Matrix4x4 lookAt2: i from: self pinpoardCenter up: 0 @ 1 @ 0) translation: i]
		ifNil: [Matrix4x4 identity].
	
	^ GRGrabbableArea new
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
		onButtonPress: [:e | e button = GDGlobalConstants joyOculusBy ifTrue: [onPinboard set: onPinboard get not]];
		onButtonRelease: [:e | e isTrigger ifTrue: [pressed set: false]];
		onGrab: [grabbed set: true];
		onRelease: [:e |
			onPinboard get ifTrue: [transform set: t] ifFalse: [transform set: e transform].
			"transform set: e transform"
			grabbed set: false]
]

{ #category : #'as yet unclassified' }
BrowsingDworph >> renderSphere: radius [ 
	^ GDCollisionShape new
		shape: (GDSphereShape new radius: radius);
		
		children: (GDMeshInstance new mesh: (GDSphereMesh new material: (GDSpatialMaterial new albedoTexture: self useSkyTexture;
						 paramsCullMode: GDSpatialMaterial cullFront);
					 radius: radius;
					 height: radius * 2))
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
