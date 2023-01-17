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
		self renderCylinder: (Dictionary withAll: {
			#center -> center.
			#browserRotation -> browserRotation get.
			#browserRotationSetter -> browserRotation setter}).
		}
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
