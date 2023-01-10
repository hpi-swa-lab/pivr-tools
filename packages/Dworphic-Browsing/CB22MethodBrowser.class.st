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

	| methods activeClass selectedMethods method nextMethodId browserRotation |
	activeClass := props at: #activeClass.
	methods := self
		useMemo: [activeClass ifNotNil: [((self getClassNamed: activeClass) methodDict values collect: [:sth | sth selector]) sort]]
		dependencies: {activeClass}.
	selectedMethods := props at: #methods.
	nextMethodId := props at: #nextMethodId.
	browserRotation := self useState: 0.
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
					index: index;
					action: [
						selectedMethods set: [:old |
							method := (self getClassNamed: activeClass) methodDict at: methodName.
							nextMethodId set: nextMethodId get + 1.
							old copyWith: {nextMethodId get. activeClass name. method selector. method getSource asString}]];
					isActive: isActive]].
		
		GRInteractiveArea new
			onAxisChange: [:e | e isStickX ifTrue: [browserRotation set: browserRotation get + (e strength * 2)]];
			transform: (Matrix4x4 identity translatedBy: self circleCenter);
			children: {self cubeOfSize: 0.1 @ 0.1 @ 0.1 color: Color white}}
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
CB22MethodBrowser >> yOffset [
	^ 40cm
]
