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
	| key delete meshUrl hovered voiceIntents x y z mesh aabb scale rotation |
	key := props at: #key.
	delete := props at: #delete.
	meshUrl := props at: #meshUrl.
	mesh := self useMemo: [GDResourceLoader instance loadPath: meshUrl] dependencies: #().
	scale := self useState: (0.2 asVector3).
	aabb := self useMemo: [(mesh grAsClass: #GDMesh) getAabb * (scale get)] dependencies: {mesh}.
	
	x := self useState: -3.
	y := self useState: -2.
	z := self useState: 1.
	rotation := self useState: 0.
	
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
		'bigger' -> [
			scale set: [:old | old * 2].
			[scale set: [:old | old / 2]]].
		'smaller' -> [
			scale set: [:old | old / 2].
			[scale set: [:old | old * 2]]].
		'delete' ->  delete.
		'rotate \num' -> [:num | | rotationOld |
			rotationOld := rotation get.
			rotation set: [:old | (num ifNil: [0]) asNumber + rotationOld].
			[rotation set: [:old | rotationOld - ((num ifNil: [0]) asNumber)]]]
		}.

	self useVoiceIntents: voiceIntents key: (hovered get ifTrue: [' '] ifFalse: [key]).
	
	^ GRInteractiveArea new point: true; 
		onHover: [hovered set: true];
		onBlur: [hovered set: false];
		translation: x get @ y get @ z get;
		children: {
			GDCollisionShape new
				shape: (GDBoxShape new extents: aabb extents);
				translation: aabb position + aabb extents.
			GDMeshInstance new
						mesh: mesh;
						scale: scale get;
						rotation: 0 @ (rotation get) @0.
			VoiceUI new
					voiceIntents: voiceIntents;
					key: (hovered get ifTrue: [' '] ifFalse: [key]);
					hovered: hovered get;
					translation: 0 @ 3 @ 1.5
		}
]
