Class {
	#name : #CB22MethodBrowser,
	#superclass : #CB22Browser,
	#category : #'Dworphic-Browsing'
}

{ #category : #'as yet unclassified' }
CB22MethodBrowser >> getClassNamed: name [
	^ Environment current classNamed: name
]

{ #category : #'as yet unclassified' }
CB22MethodBrowser >> render: props [

	| methods activeClass selectedMethods method nextMethodId browserRotation cylinderMesh center |
	activeClass := props at: #activeClass.
	methods := self
		useMemo: [activeClass ifNotNil: [((self getClassNamed: activeClass) methodDict values collect: [:sth | sth selector]) sort]]
		dependencies: {activeClass}.
	selectedMethods := props at: #methods.
	nextMethodId := props at: #nextMethodId.
	browserRotation := self useState: 0.
	cylinderMesh := self useCylinderMesh.
	
	center := props at: #center.
	
	"activeMethod := self useState: nil."
	^ GDSpatial new children: {
		methods ifNotNil: [
			methods collect: [:methodName | | index angle isActive |
				index := methods indexOf: methodName.
				angle := 360 / methods size * index + browserRotation get \\ 360.
				isActive := angle abs < (360 / methods size).
				"isActive ifTrue: [activeMethod set: {nextMethodId .  currentClass name . methodName. (currentClass methodDict at: methodName) getSource asString}]."
				(self methodAsComponent: #renderChoice:)
					choice: methodName;
					key: methodName;
					angle: angle;
					center: center;
					index: index;
					action: [
						selectedMethods set: [:old |
							method := (self getClassNamed: activeClass) methodDict at: methodName.
							nextMethodId set: nextMethodId get + 1.
							old copyWith: {nextMethodId get. activeClass name. method selector. method getSource asString}]];
					isActive: isActive]].
		GDMeshInstance new
			mesh: cylinderMesh;
			translation: (self cylinderTranslation: center);
			scale: self cylinderScale.
		GRInteractiveArea new
			onAxisChange: [:e | e isStickX ifTrue: [browserRotation set: browserRotation get + (e strength * 2)]];
			transform: ((Matrix4x4 identity translatedBy: center) translatedBy: 0.3 @ 0.45 @ 0.3);
			children: {
				self cubeOfSize: 0.1 @ 0.1 @ 0.1 color: Color white.
				GDLabel3D new
					text: 'Scroll Methods';
					pixelSize: 0.002;
					billboard: GDSpatialMaterial billboardEnabled;
					transform: (Matrix4x4 withOffset: 0 @ 0.2 @ 0)}}
	"activeMethod get ifNotNil: [ |m | m:= activeMethod get.
				(CB22Method new methodAsComponent: #render:)
					key: m first;
					class: m second;
					name: m third;
					text: m fourth;
					lastCreationEvent: nil]
					}"
]

{ #category : #'as yet unclassified' }
CB22MethodBrowser >> useCylinderMesh [

	^ self
		useMemo: [GDResourceLoader instance loadPath: 'res://assets/browsing/hollow_cylinder_red3.obj']
		dependencies: #()
]

{ #category : #'as yet unclassified' }
CB22MethodBrowser >> yOffset [

	^ 15 cm
]
