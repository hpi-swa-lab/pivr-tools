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

{ #category : #seasonalFloor }
VoiceWorldBuilderDworph >> autumnColor [
	^ Color r: 0.643 g: 0.603 b: 0.162
]

{ #category : #seasonalFloor }
VoiceWorldBuilderDworph >> autumnSky [
	^ GDProceduralSky new skyTopColor: (Color r: 0.92 g: 0.86 b: 0.69); skyHorizonColor: (Color r: 0.91 g: 0.49 b: 0.19)
]

{ #category : #seasonalFloor }
VoiceWorldBuilderDworph >> centerSize [

	^ 20 m
]

{ #category : #seasonalFloor }
VoiceWorldBuilderDworph >> floorWithColor: aColor [

	^ (self cubeOfSize: 100m @ 1cm @ 100m color: aColor) translation: 0 @ -0.5cm @ 0
]

{ #category : #seasonalFloor }
VoiceWorldBuilderDworph >> light [

	^ GDDirectionalLight new
		shadowEnabled: true;
		transform: (Matrix4x4 lookAt: 0 @ 0 @ 0 from: 10 @ 10 @ 10 up: 0 @ 1 @ 0)
]

{ #category : #'as yet unclassified' }
VoiceWorldBuilderDworph >> render: props [

	| showTutorial elements keyIndex creationBlock floorColor sky floorRef |
	showTutorial := self useState: true.
	self
		useVoiceIntents: {'finish' -> [showTutorial set: false]. 'open' -> [showTutorial set: true]}
		key: 'tutorial'.
	
	"An always increasing counter to manage voice created instance names"
	keyIndex := self useState: 1.
	elements := self useState: {}.
	
	floorColor := self useState: self summerColor.
	sky := self useState: self summerSky.
	
	"This is a block which returns a block suitable as voice intent action. The voice intent action block returned returns a block itself
	which does the teardown."
	creationBlock := [:keyBase :meshUrl :other | | oldIndex mesh |
		[
			oldIndex := keyIndex get.
			keyIndex set: [:o | o + 1].
			
			elements set: [:oldElements |
				mesh := VoiceWorldBuilderGeometryMesh new
					key: keyBase, oldIndex;
					meshUrl: meshUrl;
					other: other;
					delete: [
						elements set: [:old | old copyWithout: mesh].
						[elements set: [:old | old copyWith: mesh]]].
				oldElements copyWith: mesh].
			
			[elements set: [:oldElements | oldElements copyWithout: mesh]]]].
	
	self
		useVoiceIntents: {
			'create cow' -> (creationBlock
				value: 'cow '
				value: 'res://assets/voice/cow/cow.mesh'
				value: {#xRotation -> Float halfPi negated. #y -> 0. #scale -> 0.35 asVector3}).
			'create american barn' -> (creationBlock
				value: 'american barn '
				value: 'res://assets/voice/american_old_barn/american_old_barn.mesh'
				value: {#xRotation -> Float halfPi negated. #y -> 0. #x -> 10. #z -> 10}).
			'create sheep' -> (creationBlock
				value: 'sheep '
				value: 'res://assets/voice/sheep/sheep.mesh'
				value: {#scale -> 0.1 asVector3}).
			'create daniel' -> (creationBlock
				value: 'daniel '
				value: 'res://assets/voice/daniel/daniel.mesh'
				value: {#y -> 1.5. #scale -> 1. #xRotation -> (-63 degreesToRadians). #yRotation -> Float halfPi. #zRotation -> Float halfPi negated.}).
			'season winter' -> [ | oldFloor oldSky |
				oldFloor := floorColor get.
				floorColor set: self winterColor.
				oldSky := sky get.
				sky set: self winterSky.
				[floorColor set: oldFloor. sky set: oldSky]].
			'season spring' -> [ | oldFloor oldSky |
				oldFloor := floorColor get.
				floorColor set: self springColor.
				oldSky := sky get.
				sky set: self summerSky. "wip todo"
				[floorColor set: oldFloor. sky set: oldSky]].
			'season summer' -> [ | oldFloor oldSky |
				oldFloor := floorColor get.
				floorColor set: self summerColor.
				oldSky := sky get.
				sky set: self summerSky.
				[floorColor set: oldFloor. sky set: oldSky]].
			'season autumn' -> [ | oldFloor oldSky |
				oldFloor := floorColor get.
				floorColor set: self autumnColor.
				oldSky := sky get.
				sky set: self autumnSky.
				[floorColor set: oldFloor. sky set: oldSky]].}
		key: 'world'.
	"global commands"
	
	floorRef := self useGodotRef.
	
	^ GRProvider values: {
		#floorRef -> floorRef.
	} children: {
		showTutorial get ifTrue: [VoiceTutorialDworph new].
		elements get.
		GDStaticBody new children: {self floorWithColor: floorColor get}; ref: floorRef.
		self light.
		GDWorldEnvironment new environment: (GDEnvironment new
			backgroundMode: 2;
			backgroundSky: sky get;
			fogColor: (Color r: 0.98 g: 0.889 b: 0.84);
			fogDepthBegin: 18.9;
			fogDepthEnd: 42.4;
			fogDepthCurve: 0.574351;
			ssaoRadius: 0.1;
			ssaoIntensity: 10.42)}
]

{ #category : #seasonalFloor }
VoiceWorldBuilderDworph >> springColor [
	^ Color r: 0.559 g: 0.93 b: 0.274
]

{ #category : #seasonalFloor }
VoiceWorldBuilderDworph >> summerColor [
	^ Color r: (24 / 255) g: (145 / 255) b: (22 / 255)
]

{ #category : #seasonalFloor }
VoiceWorldBuilderDworph >> summerSky [
	^ GDProceduralSky new skyTopColor: (Color r: 0.64 g: 0.83 b: 0.94); skyHorizonColor: (Color r: 0.83 g: 0.91 b: 0.98)
]

{ #category : #seasonalFloor }
VoiceWorldBuilderDworph >> winterColor [
	^ Color white
]

{ #category : #seasonalFloor }
VoiceWorldBuilderDworph >> winterSky [
	^ GDProceduralSky new skyTopColor: (Color r: 0.92 g: 0.98 b: 1); skyHorizonColor: (Color r: 0.46 g: 0.81 b: 0.87)
]
