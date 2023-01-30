"
This class automatically support some geometric voice commands, such as 'move x', for a mesh
"
Class {
	#name : #VoiceWorldBuilderGeometryMesh,
	#superclass : #GRComponent,
	#instVars : [
		'key'
	],
	#category : #'Dworphic-Voice'
}

{ #category : #'as yet unclassified' }
VoiceWorldBuilderGeometryMesh >> render: props [

	| key delete meshUrl hovered voiceIntents x y z mesh aabb scale yRotation other xRotation zRotation ref |
	key := props at: #key.
	delete := props at: #delete.
	meshUrl := props at: #meshUrl.
	
	other := (props at: #other) asDictionary.
	scale := self useState: (other at: #scale ifAbsent: [0.2 asVector3]).
	x := self useState: (other at: #x ifAbsent: [-3]).
	y := self useState: (other at: #y ifAbsent: [0]).
	z := self useState: (other at: #z ifAbsent: [-3]).
	xRotation := self useState: (other at: #xRotation ifAbsent: [0]).
	yRotation := self useState: (other at: #yRotation ifAbsent: [0]).
	zRotation := self useState: (other at: #zRotation ifAbsent: [0]).
	
	mesh := self useMemo: [GDResourceLoader instance loadPath: meshUrl] dependencies: #().
	aabb := self useMemo: [(mesh grAsClass: #GDMesh) getAabb * scale get] dependencies: {mesh}.
	
	hovered := self useState: false.
	
	voiceIntents := {
		'x \num' -> [:num | | xOld |
			xOld := x get.
			x set: [:old | (num ifNil: [xOld]) asNumber].
			[x set: [:new | xOld]]].
		'y \num' -> [:num | | yOld |
			yOld := y get.
			y set: [:old | (num ifNil: [yOld]) asNumber].
			[y set: [:new | yOld]]].
		'z \num' -> [:num | | zOld |
			zOld := z get.
			z set: [:old | (num ifNil: [zOld]) asNumber].
			[z set: [:new | zOld]]].
		'move x \num' -> [:num | | xOld |
			xOld := x get.
			x set: [:old | xOld + (num ifNil: [xOld]) asNumber].
			[x set: [:new | xOld]]].
		'move y \num' -> [:num | | yOld |
			yOld := y get.
			y set: [:old | yOld + (num ifNil: [yOld]) asNumber].
			[y set: [:new | yOld]]].
		'move z \num' -> [:num | | zOld |
			zOld := z get.
			z set: [:old | zOld + (num ifNil: [zOld]) asNumber].
			[z set: [:new | zOld]]].
		'bigger' -> [
			scale set: [:old | old * 2].
			[scale set: [:old | old / 2]]].
		'smaller' -> [
			scale set: [:old | old / 2].
			[scale set: [:old | old * 2]]].
		'delete' -> delete.
		'rotate \num' -> [:num | | rotationOld |
			rotationOld := yRotation get.
			yRotation set: [:old | (num ifNil: [0]) asNumber degreesToRadians + rotationOld].
			[yRotation set: [:old | rotationOld - (num ifNil: [0]) asNumber degreesToRadians]]]}.
	
	self useVoiceIntents: voiceIntents key: (hovered get ifTrue: [' '] ifFalse: [key]).
	
	ref := self useGodotRef.
	
	^ {
		GRInteractiveArea new
			point: true;
			onHover: [hovered set: true];
			onBlur: [hovered set: false];
			areaRef: ref;
			children: {
				GDCollisionShape new
					shape: (GDBoxShape new extents: aabb extents);
					translation: aabb position + aabb extents.
				GDMeshInstance new
					mesh: mesh;
					scale: scale get.
				VoiceUI new
					voiceIntents: voiceIntents;
					key: (hovered get ifTrue: [' '] ifFalse: [key]);
					hovered: hovered get;
					translation: aabb extents;
					scale: 1 / scale get;
					rotation: xRotation get negated @ 0 @ 0.
				(self animate: #translation of: ref get to: x get @ y get @ z get) duration: 0.7.
				(self animate: #scale of: ref get to: scale get) duration: 0.7.
				(self animate: #rotation of: ref get to: xRotation get @ yRotation get @ zRotation get) duration: 0.7}}
]
