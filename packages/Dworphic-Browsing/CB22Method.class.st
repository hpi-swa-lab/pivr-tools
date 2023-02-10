Class {
	#name : #CB22Method,
	#superclass : #GRComponent,
	#category : #'Dworphic-Browsing'
}

{ #category : #constants }
CB22Method >> collisionShape [

	^ (self godot: #BoxShape) extents: 0.06 @ 0.015 @ 0.07 
]

{ #category : #'morph handling' }
CB22Method >> getTextMorphExtent: morph [

	| extent |
	extent := morph fullBounds extent.
	^ 0.015 @ (extent x * 0.0005) @ (extent y * 0.0005) 
]

{ #category : #'morph handling' }
CB22Method >> getTextMorphShape: morph [

	^ (self godot: #BoxShape) extents: (self getTextMorphExtent: morph) 
]

{ #category : #rendering }
CB22Method >> render: props [

	| grabbed desc text pressed morph world transform pinboardTransform eventTransform onPinboard endGrab api name grabbedMethod key colorMode class initialTransform |
	grabbed := self useState: false.
	pressed := self useState: false.
	world := self useWorldPortal.
	
	desc := props at: #desc.
	text := desc text.
	key := desc key.
	class := desc className.
	name := desc name.
	initialTransform := desc initialTransform ifNil: [
		Matrix4x4 identity
			rotation: -180 around: 1 @ 0 @ 0;
			rotation: 180 around: 0 @ 1 @ 0;
			translation: 0 @ 1.5 @ 0.5].
	transform := self useState: initialTransform.
	
	grabbedMethod := (props at: #grabbedMethod) value.
	
	morph := self useStyledTextMorph: text.
	
	onPinboard := self useState: false.
	endGrab := self useRef: nil.
	api := Dictionary new.
	colorMode := self useState: 'normal'.
	
	eventTransform := self useProvided: #rightControllerTransform.
	pinboardTransform := self transformOnPinboard: eventTransform.
	
	self
		useEffect: [
			desc grabEvent ifNotNil: [:e |
				(api at: #startGrab) value: e.
				(api at: #setGrabOffset) value: (Matrix4x4 withRotation: -90 around: 1 @ 0 @ 0).
				grabbed set: true]]
		dependencies: {}.
	
	^ GRGrabbableArea new
		api: api;
		point: onPinboard get;
		children: {
			self renderCollisionShape: morph.
			GRInteractiveArea new
				children: {self renderCollisionShape: morph};
				onHover: [:e | grabbed get ifFalse: [colorMode set: 'grabbable']];
				onBlur: [:e | grabbed get ifFalse: [colorMode set: 'normal']].
			(self renderMethodDisplayFar: name extent: (self getTextMorphExtent: morph)) visible: onPinboard get.
			GDSpatial new
				children: {
					(self renderMethodDisplayNear: morph) visible: onPinboard get not.
					GDMeshInstance new
						mesh: (GDCubeMesh new
							size: (self getTextMorphExtent: morph) * 2;
							material: (GDSpatialMaterial new albedoColor: (({'normal' -> Color lightGray. 'grabbable' -> Color lightBlue. 'grabbed' -> Color lightYellow} as: Dictionary) at: colorMode get)));
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
				transform set: (self transformInSphere: eventTransform center: eventTransform translation radius: 2 cm)]];
		onButtonRelease: [:e | e isTrigger ifTrue: [pressed set: false]];
		handle: key;
		onGrab: [:e |
			key = 0
				ifTrue: [ | newId selectedMethods |
					"Method is active method by browser"
					newId := (props at: #nextMethodId) get.
					(props at: #nextMethodId) set: newId + 1.
					key := newId.
					selectedMethods := props at: #selectedMethods.
					selectedMethods set: ((selectedMethods get reject: [:d | d key = 0]) copyWith: (CB22MethodSpec new
						key: key;
						className: class;
						name: name;
						text: text;
						initialTransform: initialTransform;
						grabEvent: e;
						yourself))]
				ifFalse: [
					onPinboard get ifTrue: [
						onPinboard set: false.
						(api at: #setGrabOffset) value: (Matrix4x4 withRotation: -90 around: 1 @ 0 @ 0)].
					grabbed set: true.
					colorMode set: 'grabbed'.
					grabbedMethod set: key]];
		onRelease: [:e |
			colorMode set: 'normal'.
			onPinboard get ifTrue: [transform set: pinboardTransform] ifFalse: [transform set: e transform].
			grabbed set: false]
]

{ #category : #rendering }
CB22Method >> renderCollisionShape: morph [

	^ GDCollisionShape new
		shape: (self getTextMorphShape: morph);
		rotation: 4.2 @ 0 @ Float pi / 2
]

{ #category : #rendering }
CB22Method >> renderMethodDisplayFar: name extent: e [

	^ GDLabel3D new
		text: name;
		pixelSize: 0.003;
		autowrap: true;
		width: 2000000;
		translation: 0 @ 0 @ 0.02;
		rotation: 0.4 @ 0 @ 0 
]

{ #category : #rendering }
CB22Method >> renderMethodDisplayNear: morph [

	^ FormDworph new
		morph: morph;
		rotationDegrees: 0 @ 0 @ 0;
		translation: 0 @ 0.017 @ 0
]

{ #category : #transform }
CB22Method >> transformInSphere: et center: c radius: r [

	^ (et forwardRay intersectSphere: c radius: r)
		ifNotNil: [:i | (Matrix4x4 lookAt: i from: c up: 0 @ 1 @ 0) translation: i]
		ifNil: [Matrix4x4 identity]
]

{ #category : #transform }
CB22Method >> transformOnPinboard: handTransform [

	^ (handTransform forwardRay
		intersectSphere: BrowsingDworph pinboardCenter
		radius: BrowsingDworph pinboardRadius)
		ifNotNil: [:i | (Matrix4x4 lookAt: i from: BrowsingDworph pinboardCenter up: 0 @ 1 @ 0) translation: i]
		ifNil: [Matrix4x4 identity]
]

{ #category : #resources }
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
