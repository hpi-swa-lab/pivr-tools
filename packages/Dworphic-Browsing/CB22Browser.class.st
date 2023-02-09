Class {
	#name : #CB22Browser,
	#superclass : #GRComponent,
	#category : #'Dworphic-Browsing'
}

{ #category : #constants }
CB22Browser >> circleRadius [

	^ 1
]

{ #category : #constants }
CB22Browser >> cylinderScale [

	^1.8 @ 0.5 @ 1.8
]

{ #category : #transform }
CB22Browser >> cylinderTranslation: center [

	^ center x @ (center y + self yOffset) @ center z
]

{ #category : #transform }
CB22Browser >> pointOnCircle: radius angle: degs center: c [

	| angle |
	angle := degs degreesToRadians.
	^ (c x + angle sin * radius) @ c y @ (c z + (angle cos * radius))
]

{ #category : #rendering }
CB22Browser >> renderChoice: props [

	| transform center |
	center := props at: #center.
	transform := (Matrix4x4 withOffset: (self pointOnCircle: self circleRadius angle: (props at: #angle) center: center)) translatedBy: 0 @ (((props at: #index) \\ 2 == 0 ifTrue: [-0.05] ifFalse: [0.05]) + self yOffset) @ 0. 
	^ GDSpatial new
		children: {
			GDLabel3D new
				horizontalAlignment: GDGlobalConstants halignRight;
				pixelSize: 0.002;
				text: (props at: #choice) value;
				doubleSided: true;
				transform: ((Matrix4x4 lookAt: center from: transform translation up: 0 @ 1 @ 0)
					rotatedLocalBy: 180
					around: 0 @ 1 @ 0).
			ButtonDworph new
				onPress: (props at: #action);
				translation: 0.02 @ 0 @ 0;
				color: ((props at: #isActive) ifTrue: [Color red] ifFalse: [Color green]);
				transform: transform};
		yourself
]

{ #category : #rendering }
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

{ #category : #resources }
CB22Browser >> useCylinderMesh [

	self subclassResponsibility
]

{ #category : #resources }
CB22Browser >> useCylinderShape [

	^ self
		useMemo: [GDResourceLoader instance loadPath: 'res://assets/browsing/hollow_cylinder_convex_polygon_shape.tres']
		dependencies: #()
]

{ #category : #constants }
CB22Browser >> yOffset [
 	 self subclassResponsibility
]
