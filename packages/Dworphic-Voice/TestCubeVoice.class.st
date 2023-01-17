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

	| x y z hovered voiceIntents size |
	x := self useState: -2.
	y := self useState: -2.
	z := self useState: 1.
	size := self useState: 0.5.
	
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
			size set: [:old | old * 2].
			[size set: [:old | old / 2]]].
		'smaller' -> [
			size set: [:old | old / 2].
			[size set: [:old | old * 2]]].
		}.
		
	self useVoiceIntents: voiceIntents key: (hovered get ifTrue: [' '] ifFalse: ['cube']).
	
	^ GRInteractiveArea new point: true; 
		onHover: [hovered set: true];
		onBlur: [hovered set: false];
		translation: x get @ y get @ z get;
		children: {
			(self cubeOfSize: size get color: (Color r: 1.0 g: 0.0 b: 1)).
			VoiceUI new
					voiceIntents: voiceIntents;
					key: (hovered get ifTrue: [' '] ifFalse: ['cube']);
					hovered: hovered get;
					translation: -0.3 @ 0.3 @ 0
		}
]
