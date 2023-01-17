Class {
	#name : #CB22ClassBrowser,
	#superclass : #CB22Browser,
	#category : #'Dworphic-Browsing'
}

{ #category : #'as yet unclassified' }
CB22ClassBrowser >> render: props [

	| classes browserRotation activeClass activePackage cylinderMesh center sound streamPlayerRef |
	browserRotation := self useState: 0.
	activeClass := props at: #activeClass.
	activePackage := props at: #activePackage.
	classes := self
		useMemo: [activePackage ifNotNil: [((PackageInfo named: activePackage) classes collect: [:class | class name]) sort]]
		dependencies: {activeClass get}.
	cylinderMesh := self useCylinderMesh.
	center := props at: #center.
	streamPlayerRef := self useGodotRef.
	sound := self
		useMemo: [GDResourceLoader instance loadPath: 'res://assets/browsing/sounds/dup.wav']
		dependencies: #().
	self
		useMemo: [streamPlayerRef ifNotNil: [streamPlayerRef get ifNotNil: [streamPlayerRef get play]]]
		dependencies: {activeClass get}.
	
	^ GDSpatial new children: {
		GDAudioStreamPlayer3D new
			stream: sound;
			autoplay: true;
			ref: streamPlayerRef.
		classes ifNotNil: [
			classes collect: [:className | | index angle isActive |
				index := classes indexOf: className.
				angle := 360 / classes size * index + browserRotation get \\ 360.
				isActive := angle abs < (360 / classes size).
				isActive ifTrue: [
					activeClass set: className].
				(self methodAsComponent: #renderChoice:)
					choice: className;
					key: className;
					center: center;
					angle: angle;
					index: index;
					action: [activeClass set: className];
					isActive: isActive]].
		self renderCylinder: (Dictionary withAll: {
			#center -> center.
			#browserRotation -> browserRotation get.
			#browserRotationSetter -> browserRotation setter}).
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
