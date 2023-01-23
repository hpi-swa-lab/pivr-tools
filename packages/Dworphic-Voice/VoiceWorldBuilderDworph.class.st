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
		'show' -> [showTutorial set: true].
	} key: 'tutorial'.
	
	keyIndex := self useState: 1.
	elements := self useState: {}.
	
	"This is a block which returns a block suitable as voice intent action. The voice intent action block returned returns a block itself
	which does the teardown."
	creationBlock := [:keyBase :meshUrl | |oldIndex mesh|
				[oldIndex := keyIndex get.
				keyIndex set: [:o | o + 1].
				
				elements set: [:oldElements |
					mesh := VoiceWorldBuilderGeometryMesh new key: (keyBase, oldIndex); meshUrl: meshUrl;
						delete: [
							elements set: [:old | old copyWithout: mesh].
							[elements set: [:old | old copyWith: mesh]]].
					oldElements copyWith: mesh].
				
				[elements set: [:oldElements | oldElements copyWithout: mesh]]]
			].
	
	self useVoiceIntents: {
		'create cow' -> (creationBlock value: 'cow ' value: 'res://assets/voice/cow.obj').
		'create field' -> (creationBlock value: 'field ' value: 'res://assets/voice/Farmland_Wheat.obj').
		'create windmill' -> (creationBlock value: 'windmill ' value: 'res://assets/voice/Farmland_Windmill.obj').
		'create house' -> (creationBlock value: 'house ' value: 'res://assets/voice/Farmland_House.obj').
		'create american barn' -> (creationBlock value: 'american barn ' value: 'res://assets/voice/american_barn.obj').
		'open' -> [showTutorial set: true].
		'show' -> [showTutorial set: true].
	} key: 'world'. "global commands"
	
	^ {
	showTutorial get ifTrue: [VoiceTutorialDworph new.].
	elements get
	}
]
