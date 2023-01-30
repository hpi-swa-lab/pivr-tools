Class {
	#name : #VoiceWorldBuilderDworph,
	#superclass : #GRComponent,
	#category : #'Dworphic-Voice'
}

{ #category : #'as yet unclassified' }
VoiceWorldBuilderDworph class >> appDescription [
	<home>

	^ super appDescription
]

{ #category : #'as yet unclassified' }
VoiceWorldBuilderDworph >> render: props [

	| showTutorial elements keyIndex creationBlock |
	showTutorial := self useState: true.
	self useVoiceIntents: {
		'finish' -> [showTutorial set: false].
		'open' -> [showTutorial set: true].
	} key: 'tutorial'.
	
	keyIndex := self useState: 1.
	elements := self useState: {}.
	
	"This is a block which returns a block suitable as voice intent action. The voice intent action block returned returns a block itself
	which does the teardown."
	creationBlock := [:keyBase :meshUrl :other | |oldIndex mesh|
				[oldIndex := keyIndex get.
				keyIndex set: [:o | o + 1].
				
				elements set: [:oldElements |
					mesh := VoiceWorldBuilderGeometryMesh new key: (keyBase, oldIndex); meshUrl: meshUrl; other: other;
						delete: [
							elements set: [:old | old copyWithout: mesh].
							[elements set: [:old | old copyWith: mesh]]].
					oldElements copyWith: mesh].
				
				[elements set: [:oldElements | oldElements copyWithout: mesh]]]
			].
	
	self useVoiceIntents: {
		'create cow' -> (creationBlock value: 'cow ' value: 'res://assets/voice/cow/cow.mesh' value: {
			#xRotation -> (Float halfPi negated). #y -> 0. #scale -> 0.35 asVector3.}).
		'create american barn' -> (creationBlock value: 'american barn ' value: 'res://assets/voice/american_old_barn/american_old_barn.mesh' value: {
			#xRotation -> (Float halfPi negated).
			#y -> -1.
			#x -> 20.
			#z -> 20}).
		'create sheep' -> (creationBlock value: 'sheep ' value: 'res://assets/voice/sheep/sheep.mesh' value: {#scale -> 0.1 asVector3.}).
	} key: 'world'. "global commands"
	
	^ {
	showTutorial get ifTrue: [VoiceTutorialDworph new.].
	elements get
	}
]
