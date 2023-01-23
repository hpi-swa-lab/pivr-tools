Class {
	#name : #CB22Browser,
	#superclass : #GRComponent,
	#category : #'Dworphic-Browsing'
}

{ #category : #'as yet unclassified' }
CB22Browser >> angle: angle isWithinInterval: i1 and: i2 [

	| lowerBound upperBound |
	lowerBound := self normalizeAngle: i1.
	upperBound := self normalizeAngle: i2.
	lowerBound < upperBound
		ifTrue: [^ angle > lowerBound and: angle < upperBound]
		ifFalse: [^ (angle > lowerBound and: angle < 360) or: angle < upperBound]
]

{ #category : #'as yet unclassified' }
CB22Browser >> circleRadius [

	^ 1
]

{ #category : #'as yet unclassified' }
CB22Browser >> cylinderScale [

	^1.8 @ 0.5 @ 1.8
]

{ #category : #'as yet unclassified' }
CB22Browser >> cylinderTranslation: center [

	^ center x @ (center y + self yOffset) @ center z
]

{ #category : #'as yet unclassified' }
CB22Browser >> normalizeAngle: angle [

	angle \\ 360 < 0 ifTrue: [^ angle + 360] ifFalse: [^ angle \\ 360]
]

{ #category : #'as yet unclassified' }
CB22Browser >> pointOnCircle: radius angle: degs center: c [

	| angle |
	angle := degs degreesToRadians.
	^ c x + angle sin * radius @ c y @ (c z + (angle cos * radius))
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
		transform: ((Matrix4x4 withOffset: (self pointOnCircle: self circleRadius angle: (props at: #angle) center: (props at: #center))) translatedBy: 0 @ (((props at: #index) \\ 2 == 0 ifTrue: [-0.05] ifFalse: [0.05]) + self yOffset )@ 0);
		yourself
]

{ #category : #'as yet unclassified' }
CB22Browser >> renderCylinder: props [

	| browserRotation center cylinderMesh browserRotationSetter |
	cylinderMesh := self useCylinderMesh.
	browserRotation := props at: #browserRotation.
	browserRotationSetter := props at: #browserRotationSetter.
	center := props at: #center.
	
	^ GRInteractiveArea new
		translation: (self cylinderTranslation: center);
		scale: self cylinderScale;
		onAxisChange: [:e | e isStickX ifTrue: [browserRotationSetter value: browserRotation + (e strength * 2)]];
		point: true;
		children: {GDMeshInstance new mesh: cylinderMesh. GDCollisionShape new shape: self useCylinderShape}
	"self renderCylinderCollisionShape: {}"
]

{ #category : #'as yet unclassified' }
CB22Browser >> renderCylinderCollisionShape: props [

	^ GDCSGCombiner new
		children: {
			GDCSGCylinder new
				radius: 0.75;
				height: 0.5;
				sides: 16.
			GDCSGCylinder new
				radius: 0.627;
				height: 0.5;
				sides: 16;
				operation: GDCSGShape operationSubtraction};
		useCollision: true;
		collisionMask: 0;
			collisionLayer: GRInteractiveArea pointLayer
]

{ #category : #'as yet unclassified' }
CB22Browser >> useCylinderShape [

	^ self
		useMemo: [GDResourceLoader instance loadPath: 'res://assets/browsing/hollow_cylinder_convex_polygon_shape.tres']
		dependencies: #()
]

{ #category : #'as yet unclassified' }
CB22Browser >> yOffset [
 	 self subclassResponsibility
]
