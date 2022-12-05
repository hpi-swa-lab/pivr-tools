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

	| yTranslation |
	yTranslation := self useState: 0.

	self useVoiceIntents: {
		'translate (?P<number>\b\d+\b)' -> [ :params |
			yTranslation set: [:y | (params at: 'number') asNumber]]
	} key: 'cube'.
	
	^ GDSpatial new children: {
	(self cubeVisualOfSize: 1 @ 1 @ 1 color: (Color r: 0 g:0 b: 1)) translation: -2 @ -1.5 @ (yTranslation get).
	VoiceUI new translation: -2.5 @ -1.5 @ (yTranslation get + 0.5); key: 'cube'.
	}
]
