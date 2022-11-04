Class {
	#name : #TOBETutorialComponent,
	#superclass : #GRComponent,
	#category : #'TOBE-Tutorial'
}

{ #category : #'as yet unclassified' }
TOBETutorialComponent >> randomCube [

	^ {(ThreadSafeRandom next * 2 -1) @ 1 @ (ThreadSafeRandom next * 2 - 1). self nextGodotId. Color indexedColors atRandom}
]

{ #category : #'as yet unclassified' }
TOBETutorialComponent >> render: props [

	| cubes areaRef |
	cubes := self useState: [Array streamContents: [:stream | 30 timesRepeat: [stream nextPut: self randomCube]]].
	areaRef := self useGodotRef.
	
	^ GRProvider values: {#areaRef -> areaRef} children: {
		GDSpatial new children: {
			GRExternalEvents new onKeyboard: [:pressed :scanCode :key | (pressed and: [scanCode = GDGlobalConstants keySpace]) ifTrue: [cubes set: [:old | old copyWith: self randomCube]]].
			GDStaticBody new children: {self cubeOfSize: 2 @ 0.05 @ 2 color: Color green}.
			OrbitCameraDworph new.
			GDTimer new autostart: true; onTimeout: []; waitTime: 1.
			cubes get collect: [:desc | GDRigidBody new key: desc second; translation: desc first; children: (self cubeOfSize: 0.1 color: desc third)].
			TOBEController new areaRef: areaRef.
			TOBEButton new transform: (Matrix4x4 withOffset: 0 @ 0.01 @ 1.2); onPressed: [cubes set: {}]
		}}
]
