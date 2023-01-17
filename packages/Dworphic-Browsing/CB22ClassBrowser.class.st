Class {
	#name : #CB22ClassBrowser,
	#superclass : #CB22Browser,
	#category : #'Dworphic-Browsing'
}

{ #category : #'as yet unclassified' }
CB22ClassBrowser >> render: props [

	| classes browserRotation activeClass activePackage cylinderMesh center |
	browserRotation := self useState: 0.
	activeClass := props at: #activeClass.
	activePackage := props at: #activePackage.
	classes := self
		useMemo: [activePackage ifNotNil: [((PackageInfo named: activePackage) classes collect: [:class | class name]) sort]]
		dependencies: {activePackage}.
	cylinderMesh := self useCylinderMesh.
	center := props at: #center.
	
	^ GDSpatial new children: {
		classes ifNotNil: [
			classes collect: [:className | | index angle isActive |
				index := classes indexOf: className.
				angle := 360 / classes size * index + browserRotation get \\ 360.
				isActive := angle abs < (360 / classes size).
				isActive ifTrue: [activeClass set: className].
				(self methodAsComponent: #renderChoice:)
					choice: className;
					key: className;
					center: center;
					angle: angle;
					index: index;
					action: [activeClass set: className];
					isActive: isActive]].
		GDMeshInstance new
			mesh: cylinderMesh;
			translation: (self cylinderTranslation: center);
			scale: self cylinderScale.
		GRInteractiveArea new
			onAxisChange: [:e | e isStickX ifTrue: [browserRotation set: browserRotation get + (e strength * 2)]];
			point: true;
			transform: ((Matrix4x4 identity translatedBy: center) translatedBy: 0.3 @ 0.3 @ 0.3);
			children: {
				self cubeOfSize: 0.1 @ 0.1 @ 0.1 color: Color white.
				GDLabel3D new
					text: 'Scroll Classes';
					pixelSize: 0.002;
					billboard: GDSpatialMaterial billboardEnabled;
					transform: (Matrix4x4 withOffset: 0 @ 0.2 @ 0)}}
]

{ #category : #'as yet unclassified' }
CB22ClassBrowser >> useCylinderMesh [

	^ self
		useMemo: [GDResourceLoader instance loadPath: 'res://assets/browsing/hollow_cylinder_red2.obj']
		dependencies: #()
]

{ #category : #'as yet unclassified' }
CB22ClassBrowser >> yOffset [

	^ -5 cm
]
