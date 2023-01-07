Class {
	#name : #CB22Browser,
	#superclass : #GRComponent,
	#category : #'Dworphic-Browsing'
}

{ #category : #'as yet unclassified' }
CB22Browser >> circleCenter [

	| center |
	center := self useState: ((self useProvidedRef: #headTransform) get translation).
	^ center get
]

{ #category : #'as yet unclassified' }
CB22Browser >> circleRadius [

	^ 1
]

{ #category : #'as yet unclassified' }
CB22Browser >> pointOnCircle: radius angle: degs  center: c [


     | angle |
angle := degs degreesToRadians.
	^ c first + angle sin * radius @ 1.2 @ (c third + (angle cos * radius))
]

{ #category : #'as yet unclassified' }
CB22Browser >> render: props [

	| methods currentClass selectedMethods method nextMethodId browserRotation |
	currentClass := CB22Browser.
	methods := self useState: (currentClass methodDict values collect: [:sth | sth selector]) sort.
	selectedMethods := props at: #methods.
	nextMethodId := props at: #nextMethodId.
	browserRotation := self useState: 0.
	"activeMethod := self useState: nil."
	
	^ GDSpatial new children: {		
		methods get collect: [:methodName | | index angle isActive |
			index :=  (methods get indexOf: methodName).
			angle := (360 / methods get size * index + browserRotation get) \\ 360.
			isActive:= angle abs < ((360 / methods get size)).
			"isActive ifTrue: [activeMethod set: {nextMethodId .  currentClass name . methodName. (currentClass methodDict at: methodName) getSource asString}]."
			(self methodAsComponent: #renderChoice:)
				choice: methodName;
				key: methodName;
				angle: angle;
				index: index;
				action: [selectedMethods set: [:old | method := (currentClass methodDict at: methodName).
						nextMethodId set: nextMethodId get + 1.
						 old copyWith: {nextMethodId get. currentClass name. method selector. method getSource asString}]];
				isActive: isActive].
			
			GRInteractiveArea new onAxisChange: [:e | e isStickX ifTrue: [browserRotation set: (browserRotation get) + (e strength * 2)]]; transform:( Matrix4x4 identity translatedBy: self circleCenter); children: {self cubeOfSize: 0.1 @ 0.1 @ 0.1 color: Color white
			"activeMethod get ifNotNil: [ |m | m:= activeMethod get.
				(CB22Method new methodAsComponent: #render:)
					key: m first;
					class: m second;
					name: m third;
					text: m fourth;
					lastCreationEvent: nil]
					}"}}
]

{ #category : #'as yet unclassified' }
CB22Browser >> renderChoice: props [

	^ GDSpatial new
		children: {
			GDLabel3D new
				horizontalAlignment: GDGlobalConstants halignRight;
				pixelSize: 0.002;
				billboard: GDSpatialMaterial billboardEnabled;
				text: (props at: #choice) value.
			ButtonDworph new
				onPress: (props at: #action);
				translation: 0.02 @ 0 @ 0;
				color: ((props at: #isActive) ifTrue: [Color red] ifFalse: [Color green])};
		transform: ((Matrix4x4 withOffset:
		 (self pointOnCircle: self circleRadius angle: (props at: #angle) center: self circleCenter))
		 translatedBy: (0 @ (((props at: #index) \\ 2 == 0) ifTrue: [-0.05] ifFalse: [0.05]) @ 0));
		yourself
]
