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
	self subclassResponsibility
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
		 translatedBy: (0 @ (((props at: #index) \\ 2 == 0) ifTrue: [-0.05] ifFalse: [0.05]) + self yOffset @ 0));
		yourself
]

{ #category : #'as yet unclassified' }
CB22Browser >> yOffset [
 	 self subclassResponsibility
]
