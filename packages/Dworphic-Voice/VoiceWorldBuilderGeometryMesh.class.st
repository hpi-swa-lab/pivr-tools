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
"renders a given mesh and provicdes some voice utilities for transforming it."

	| key delete meshUrl hovered voiceIntents mesh aabb scale yRotation other xRotation zRotation ref controllerTransform floorRef position |
	key := props at: #key.
	delete := props at: #delete.
	meshUrl := props at: #meshUrl.
	
	other := (props at: #other) asDictionary.
	scale := self useState: (other at: #scale ifAbsent: [0.2 asVector3]).
	position := self useState: ((other at: #x ifAbsent: [-3]) @ (other at: #y ifAbsent: [0]) @ (other at: #z ifAbsent: [-3])).
	xRotation := self useState: (other at: #xRotation ifAbsent: [0]).
	yRotation := self useState: (other at: #yRotation ifAbsent: [0]).
	zRotation := self useState: (other at: #zRotation ifAbsent: [0]).
	
	mesh := self useMemo: [GDResourceLoader instance loadPath: meshUrl] dependencies: #().
	aabb := self useMemo: [(mesh grAsClass: #GDMesh) getAabb * scale get] dependencies: {mesh}.
	
	hovered := self useState: false.
	
	controllerTransform := self useProvided: #rightControllerTransform.
	floorRef := self useProvided: #floorRef.
	
	voiceIntents := {
		'move over there' -> [ | intersection |
				intersection := floorRef get getWorld directSpaceState intersectRayFrom: controllerTransform forwardRay origin to: (controllerTransform forwardRay pointFromOrigin: 30 m).
				intersection ifNotEmpty: [:is | position set: (is at: 'position')] ifEmpty: [Transcript showln: 'no intersection for moving']
			].
"		'x \num' -> [:num | | oldPosition |
			oldPosition := position get copy.
			position set: [:old | old copy x: (num ifNil: [oldPosition]) asNumber].
			[position set: oldPosition]].
		'y \num' ->  [:num | | oldPosition |
			oldPosition := position get copy.
			position set: [:old | old copy y: (num ifNil: [oldPosition]) asNumber].
			[position set: oldPosition]].
		'z \num' -> [:num | | oldPosition |
			oldPosition := position get copy.
			position set: [:old | old copy z: (num ifNil: [oldPosition]) asNumber].
			[position set: oldPosition]]."
		'move x \num' -> [:num | | oldPosition |
			oldPosition := position get copy.
			position set: [:old | old copy x: (old x + (num ifNil: ['0']) asNumber)].
			[position set: oldPosition]].
		'move y \num' ->[:num | | oldPosition |
			oldPosition := position get copy.
			position set: [:old | old copy y: (old y + (num ifNil: ['0']) asNumber)].
			[position set: oldPosition]].
		'move z \num' -> [:num | | oldPosition |
			oldPosition := position get copy.
			position set: [:old | old copy z: (old z + (num ifNil: ['0']) asNumber)].
			[position set: oldPosition]].
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
				(self animate: #translation of: ref get to: position get) duration: 0.7.
				(self animate: #scale of: ref get to: scale get) duration: 0.7.
				(self animate: #rotation of: ref get to: xRotation get @ yRotation get @ zRotation get) duration: 0.7}}
]
