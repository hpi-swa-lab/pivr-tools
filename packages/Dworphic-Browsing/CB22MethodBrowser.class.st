Class {
	#name : #CB22MethodBrowser,
	#superclass : #CB22Browser,
	#category : #'Dworphic-Browsing'
}

{ #category : #'as yet unclassified' }
CB22MethodBrowser class >> getClassNamed: name [

	^ Environment current classNamed: name 
]

{ #category : #'as yet unclassified' }
CB22MethodBrowser >> render: props [

	| methods activeClass selectedMethods method nextMethodId browserRotation cylinderMesh center activeMethod sound streamPlayerRef |
	activeClass := props at: #activeClass.
	methods := self
		useMemo: [activeClass ifNotNil: [((CB22MethodBrowser getClassNamed: activeClass) methodDict values collect: [:sth | sth selector]) sort]]
		dependencies: {activeClass}.
	selectedMethods := props at: #methods.
	nextMethodId := props at: #nextMethodId.
	activeMethod := props at: #activeMethod.
	browserRotation := self useState: 0.
	cylinderMesh := self useCylinderMesh.
	
	streamPlayerRef := self useGodotRef.
	sound := self
		useMemo: [GDResourceLoader instance loadPath: 'res://assets/browsing/sounds/dup.wav']
		dependencies: #().
	self
		useMemo: [
			Transcript showln: 'play Sound'.
			streamPlayerRef ifNotNil: [streamPlayerRef get ifNotNil: [streamPlayerRef get play]]]
		dependencies: {activeMethod get}.
	
	center := props at: #center.
	
	^ GDSpatial new children: {
		GDAudioStreamPlayer3D new
			stream: sound;
			autoplay: true;
			ref: streamPlayerRef.
		methods ifNotNil: [
			methods collect: [:methodName | | index angle isActive |
				index := methods indexOf: methodName.
				angle := 360 / methods size * index + browserRotation get \\ 360.
				isActive := angle abs < (360 / methods size).
				isActive ifTrue: [
					activeMethod get = methodName ifFalse: [
						method := (CB22MethodBrowser getClassNamed: activeClass) methodDict at: methodName.
						selectedMethods set: ((selectedMethods get reject: [:desc | desc first == 0]) copyWith: {0. activeClass name. method selector. method getSource}).
						activeMethod set: methodName]].
				(self methodAsComponent: #renderChoice:)
					choice: methodName;
					key: methodName;
					angle: angle;
					center: center;
					index: index;
					action: [
						method := (CB22MethodBrowser getClassNamed: activeClass) methodDict at: methodName.
						selectedMethods set: ((selectedMethods get reject: [:desc | desc first == 0]) copyWith: {0. activeClass name. method selector. method getSource}).
						activeMethod set: methodName];
					isActive: isActive]].
		self renderCylinder: (Dictionary withAll: {
			#center -> center.
			#browserRotation -> browserRotation get.
			#browserRotationSetter -> browserRotation setter})}
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
