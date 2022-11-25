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

	| methods currentClass selectedMethods |
	currentClass := BrowsingDworph.
	methods := self useState: (currentClass methodDict values collect: [:sth | sth selector]).
	selectedMethods := props at: #methods.
	
	^ GDSpatial new children: {
		GDLabel3D new text: 'Here be the Browser'.
		
		methods get collect: [:methodName |
			(self methodAsComponent: #renderChoice:)
				choice: methodName;
				key: methodName;
				angle: 360 / methods get size * (methods get indexOf: methodName);
				action: [selectedMethods set: [:old | old copyWith: ((currentClass methodDict at: methodName) getSource asString)]]]}
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
				color: Color green};
		transform: (Matrix4x4 withOffset: (self pointOnCircle: self circleRadius angle: (props at: #angle) center: self circleCenter));
		yourself
]
