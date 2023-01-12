Class {
	#name : #CB22Method,
	#superclass : #GRComponent,
	#category : #'Dworphic-Browsing'
}

{ #category : #'as yet unclassified' }
CB22Method >> collisionShape [

	^ (self godot: #BoxShape) extents: 0.06 @ 0.015 @ 0.07
]

{ #category : #'as yet unclassified' }
CB22Method >> getTextMorphExtent: morph [

	| extent |
	extent := morph fullBounds extent.
	^ 0.015 @ (extent x * 0.0005) @ (extent y * 0.0005)
]

{ #category : #'as yet unclassified' }
CB22Method >> getTextMorphShape: morph [

	^ (self godot: #BoxShape) extents: (self getTextMorphExtent: morph)
]

{ #category : #'as yet unclassified' }
CB22Method >> render: props [

| grabbed text pressed morph debugPosition world transform t et onPinboard endGrab api initialized name grabbedMethod key|
	grabbed := self useState: false.
	pressed := self useState: false.
	initialized := self useState: false.
	world := self useWorldPortal.
	text := (props at: #text) value.
	name := (props at: #name) value.
	grabbedMethod := (props at: #grabbedMethod) value.
	key := (props at: #key).
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
	t := self transformOnPinboard: et.
	self
		useEffect: [
			(props at: #lastCreationEvent) ifNotNil: [
				(api at: #startGrab) value: (props at: #lastCreationEvent).
				(api at: #setGrabOffset) value: (Matrix4x4 withRotation: -90 around: 1 @ 0 @ 0).
				grabbed set: true]]
		dependencies: {}.
	^ GRGrabbableArea new
		api: api;
		point: onPinboard get;
		children: {
			GDCollisionShape new
				shape: (self getTextMorphShape: morph);
				rotation: 4.2 @ 0 @ Float pi / 2.
			((self renderMethodDisplayFar:  name extent: (self getTextMorphExtent: morph)) visible: (onPinboard get)).
			GDSpatial new
				children: {
					(self renderMethodDisplayNear: morph) visible: (onPinboard get not).
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
			onPinboard set: false.
			grabbedMethod set: key];
		onRelease: [:e |
			onPinboard get ifTrue: [transform set: t] ifFalse: [transform set: e transform].
			grabbed set: false.
			"grabbedMethod set: nil"]

]

{ #category : #'as yet unclassified' }
CB22Method >> renderMethodDisplayFar: name extent: e [

	^ GDLabel3D new
		text: name;
		pixelSize: 0.003;
		autowrap: true;
		width: 2000000;
		translation: 0 @ 0 @ 0.02;
		rotation: 0.4 @ 0 @ 0
]

{ #category : #'as yet unclassified' }
CB22Method >> renderMethodDisplayNear: morph [

	^ FormDworph new
						morph: morph;
						rotationDegrees: 0 @ 0 @ 0;
						translation: 0 @ 0.017 @ 0.
]

{ #category : #'as yet unclassified' }
CB22Method >> transformAfterBeam [

	| head et transform |
	head := self useHeadTransform.
	et := self useProvided: #rightControllerTransform.
	transform := self transformInSphere: et center: et translation radius: 0.1.
	^ Matrix4x4 lookAt: head from: transform translate up: 0 @ 1 @ 0
]

{ #category : #'as yet unclassified' }
CB22Method >> transformInSphere: et center: c radius: r [

	^ (et forwardRay intersectSphere: c radius: r)
		ifNotNil: [:i | (Matrix4x4 lookAt: i from: c up: 0 @ 1 @ 0) translation: i]
		ifNil: [Matrix4x4 identity]
]

{ #category : #'as yet unclassified' }
CB22Method >> transformOnPinboard: handTransform [

	 ^ (handTransform forwardRay intersectSphere: BrowsingDworph pinboardCenter radius: BrowsingDworph pinboardRadius)
		ifNotNil: [:i | (Matrix4x4 lookAt: i from: BrowsingDworph pinboardCenter up: 0 @ 1 @ 0) translation: i]
		ifNil: [Matrix4x4 identity].
]

{ #category : #'as yet unclassified' }
CB22Method >> useStyledTextMorph: text [

	^ self
		useMemo: [
			(SHTextStylerST80 new
				classOrMetaClass: UndefinedObject;
				styledTextFor: text asText) asMorph
				backgroundColor: Color white;
				yourself]
		dependencies: {text}
]
