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

	self useVoiceIntents: {
		'translate (?P<number>\b\d+\b)' -> [ :number |
			self halt.
			self transform set: (self get localTranslatedBy: 0 @ 0 @ number)].
	} key: 'applications'.
	
	^ (self cubeVisualOfSize: 0.3 @ 0.3 @ 0.3 color: (Color r: 1 g:0 b: 0)) translation: -2 @ -1.5 @ -5
]
