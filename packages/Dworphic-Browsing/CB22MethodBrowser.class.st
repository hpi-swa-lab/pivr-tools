Class {
	#name : #CB22MethodBrowser,
	#superclass : #CB22Browser,
	#category : #'Dworphic-Browsing'
}

{ #category : #utilities }
CB22MethodBrowser class >> getClassNamed: name [

	^ Environment current classNamed: name 
]

{ #category : #transform }
CB22MethodBrowser >> activeMethodTransform: angle center: center [
	"(Matrix4x4 withOffset: (self pointOnCircle: self circleRadius angle: angle center: center)) translatedBy: 0 @ self methodYOffset @ 0"

	| translation |
	translation := self pointOnCircle: self circleRadius angle: angle center: center.
	
	^ (Matrix4x4
		lookAt: center
		from: translation x @ (translation y + self methodYOffset) @ translation z
		up: 0 @ 1 @ 0)
		rotatedLocalBy: 180
		around: 0 @ 1 @ 0
]

{ #category : #constants }
CB22MethodBrowser >> methodYOffset [
	
	^ self yOffset + 20cm
]

{ #category : #rendering }
CB22MethodBrowser >> render: props [

	| methods activeClass selectedMethods method browserRotation cylinderMesh center activeMethod sound streamPlayerRef newMethodSpec |
	activeClass := props at: #activeClass.
	methods := self
		useMemo: [activeClass ifNotNil: [((CB22MethodBrowser getClassNamed: activeClass) methodDict values collect: [:sth | sth selector]) sort]]
		dependencies: {activeClass}.
	selectedMethods := props at: #selectedMethods.
	activeMethod := props at: #activeMethod.
	browserRotation := self useState: 0.
	cylinderMesh := self useCylinderMesh.
	
	streamPlayerRef := self useGodotRef.
	sound := self
		useMemo: [GDResourceLoader instance loadPath: 'res://assets/browsing/sounds/dup.wav']
		dependencies: #().
	self
		useMemo: [streamPlayerRef ifNotNil: [streamPlayerRef get ifNotNil: [streamPlayerRef get play]]]
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
						method := (self class getClassNamed: activeClass) methodDict at: methodName.
						newMethodSpec := CB22MethodSpec new
							key: 0;
							className: activeClass;
							name: method selector;
							text: method getSource;
							initialTransform: (self activeMethodTransform: angle center: center);
							yourself.
						selectedMethods set: ((selectedMethods get reject: [:desc | desc key = 0]) copyWith: newMethodSpec).
						activeMethod set: methodName]].
				(self methodAsComponent: #renderChoice:)
					choice: methodName;
					key: methodName;
					angle: angle;
					center: center;
					index: index;
					action: [
						method := (CB22MethodBrowser getClassNamed: activeClass) methodDict at: methodName.
						selectedMethods set: ((selectedMethods get reject: [:desc | (desc at: #key) = 0]) copyWith: (CB22MethodSpec fromKey: 0 class: activeClass name name: method selector text: method getSource)).
						activeMethod set: methodName];
					isActive: isActive]].
		self renderCylinder: (Dictionary withAll: {
			#center -> center.
			#browserRotation -> browserRotation get.
			#browserRotationSetter -> browserRotation setter})}
]

{ #category : #resources }
CB22MethodBrowser >> useCylinderMesh [

	^ self
		useMemo: [GDResourceLoader instance loadPath: 'res://assets/browsing/hollow_cylinder_red3.obj']
		dependencies: #()
]

{ #category : #constants }
CB22MethodBrowser >> yOffset [

	^ 15 cm+ self class browserYOffset
]
