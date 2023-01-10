Class {
	#name : #TestCubeVoice,
	#superclass : #GRComponent,
	#category : #'Dworphic-Voice'
}

{ #category : #'as yet unclassified' }
TestCubeVoice class >> appDescription [
	<home>

	^ super appDescription
]

{ #category : #'as yet unclassified' }
TestCubeVoice >> render: props [

	| x y z |
	x := self useState: -2.
	y := self useState: -2.
	z := self useState: 1.
	"
	x := self useVoiceControlledState: 1 on: 'translate x (?P<number>\b\-?d+\b)' format: #asNumber.
	x := self useVoiceControlledState: 1 on: 'translate x (?P<number>\b\-?d+\b)' format: [:string | string splitBy: 'asd'].
	"
	self
		useVoiceIntents: {
		'translate x \num' -> [:num | | xOld | 
			xOld := x get.
			x set: [:old | (num ifNil: [xOld]) asNumber]. 
			[x set: [:new | xOld]]].
		'translate y \num' -> [:num | | yOld | 
			yOld := y get.
			y set: [:old | (num ifNil: [yOld]) asNumber]. 
			[y set: [:new | yOld]]].
		'translate z \num' -> [:num | | zOld | 
			zOld := z get.
			z set: [:old | (num ifNil: [zOld]) asNumber]. 
			[z set: [:new | zOld]]].
		}
		key: 'cube'.
	
	^ (self cubeVisualOfSize: 0.5 @ 0.5 @ 0.5 color: (Color r: 0.0 g: 0.0 b: 1))
		translation: x get @ y get @ z get;
		children: {
			VoiceUI new
				key: 'cube';
				translation: -0.3 @ 0.3 @ 0}
]
