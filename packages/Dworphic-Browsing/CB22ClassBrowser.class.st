Class {
	#name : #CB22ClassBrowser,
	#superclass : #CB22Browser,
	#category : #'Dworphic-Browsing'
}

{ #category : #rendering }
CB22ClassBrowser >> render: props [

	| classes browserRotation activeClass activePackage cylinderMesh center sound streamPlayerRef |
	browserRotation := self useState: 0.
	activeClass := props at: #activeClass.
	activePackage := props at: #activePackage.
	classes := self
		useMemo: [activePackage ifNotNil: [((PackageInfo named: activePackage) classes collect: [:class | class name]) sort]]
		dependencies: {activePackage}.
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
			#browserRotationSetter -> browserRotation setter}).}
]

{ #category : #resources }
CB22ClassBrowser >> useCylinderMesh [

	^ self
		useMemo: [GDResourceLoader instance loadPath: 'res://assets/browsing/hollow_cylinder_red2.obj']
		dependencies: #()
]

{ #category : #constants }
CB22ClassBrowser >> yOffset [

	^ -5 cm
]
