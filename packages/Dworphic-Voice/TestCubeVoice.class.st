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

	| x y z hovered |
	x := self useState: -2.
	y := self useState: -2.
	z := self useState: 1.
	
	hovered := self useState: false.
	
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
		key: (hovered get ifTrue: [' '] ifFalse: ['cube']).
	
	^ GRInteractiveArea new point: true; 
		onHover: [hovered set: true];
		onBlur: [hovered set: false];
		translation: x get @ y get @ z get;
		children: {
			(self cubeOfSize: 0.5 color: (hovered get ifTrue: [Color r: 1.0 g: 0.0 b: 1] ifFalse: [Color r: 0.0 g: 0.0 b: 1])).
			VoiceUI new
					key: (hovered get ifTrue: [' '] ifFalse: ['cube']);
					hovered: hovered get;
					translation: -0.3 @ 0.3 @ 0
		}
]
