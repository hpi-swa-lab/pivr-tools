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

	| cubes |
	cubes := self useState: [Array streamContents: [:stream | 30 timesRepeat: [stream nextPut: self randomCube]]].
	
	^ GDSpatial new children: {
		GRExternalEvents new onKeyboard: [:pressed :scanCode :key | (pressed and: [scanCode = GDGlobalConstants keySpace]) ifTrue: [cubes set: [:old | old copyWith: self randomCube]]].
		GDStaticBody new children: {self cubeOfSize: 2 @ 0.05 @ 2 color: Color green}.
		GDCamera new translation: 0 @ 0.3 @ 1.
		GDTimer new autostart: true; onTimeout: []; waitTime: 1.
		cubes get collect: [:desc | GDRigidBody new key: desc second; translation: desc first; children: (self cubeOfSize: 0.1 color: desc third)]
	}
]
