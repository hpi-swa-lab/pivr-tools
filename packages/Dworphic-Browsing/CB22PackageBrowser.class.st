Class {
	#name : #CB22PackageBrowser,
	#superclass : #CB22Browser,
	#category : #'Dworphic-Browsing'
}

{ #category : #'as yet unclassified' }
CB22PackageBrowser >> render: props [

	| packages availablePackages browserRotation activePackage cylinderMesh center sound streamPlayerRef |
	availablePackages := (Environment default packageOrganizer packages select: [:p | p name beginsWith: 'Dworphic']) collect: [:pi | pi name].
	packages := self useState: availablePackages sort.
	browserRotation := self useState: 0.
	activePackage := props at: #activePackage.
	cylinderMesh := self useCylinderMesh.
	center := props at: #center.
	streamPlayerRef := self useGodotRef.
	sound := self
		useMemo: [GDResourceLoader instance loadPath: 'res://assets/browsing/sounds/dup.wav']
		dependencies: #().
	self useMemo: [streamPlayerRef ifNotNil: [streamPlayerRef get ifNotNil: [streamPlayerRef get play]]] dependencies: {activePackage get}.
	
	
	^ GDSpatial new children: {
		GDAudioStreamPlayer3D new stream: sound; autoplay: true; ref: streamPlayerRef.
		packages get collect: [:packageName | | index angle isActive |
			index := packages get indexOf: packageName.
			angle := 360 / packages get size * index + browserRotation get \\ 360.
			isActive := angle abs < (360 / packages get size).
			isActive ifTrue: [activePackage set: packageName].
			(self methodAsComponent: #renderChoice:)
				choice: packageName;
				key: packageName;
				angle: angle;
				index: index;
				center: center;
				action: [
					Transcript showln: packageName.
					activePackage set: packageName];
				isActive: isActive].
		GDMeshInstance new
			mesh: cylinderMesh;
			translation: (self cylinderTranslation: center);
			scale: self cylinderScale.
		GRInteractiveArea new
			onAxisChange: [:e | e isStickX ifTrue: [browserRotation set: browserRotation get + (e strength * 2)]];
			transform: ((Matrix4x4 identity translatedBy: center) translatedBy: 0.3 @ 0.15 @ 0.3);
			children: {
				self cubeOfSize: 0.1 @ 0.1 @ 0.1 color: Color white.
				GDLabel3D new
					text: 'Scroll Packages';
					pixelSize: 0.002;
					billboard: GDSpatialMaterial billboardEnabled;
					transform: (Matrix4x4 withOffset: 0.3 @ 0.15 @ 0.3)}}
]

{ #category : #'as yet unclassified' }
CB22PackageBrowser >> useCylinderMesh [

	^ self
		useMemo: [GDResourceLoader instance loadPath: 'res://assets/browsing/hollow_cylinder_red.obj']
		dependencies: #()
]

{ #category : #'as yet unclassified' }
CB22PackageBrowser >> yOffset [

	^ -25 cm
]
