Class {
	#name : #VoiceNoteDworph,
	#superclass : #GRComponent,
	#category : #'Dworphic-Voice'
}

{ #category : #'as yet unclassified' }
VoiceNoteDworph class >> appDescription [
	<home>

	^ super appDescription
]

{ #category : #'as yet unclassified' }
VoiceNoteDworph >> render: props [

	| log |
	log := self useLog.
		
	self useVoiceIntents: {
		'create \rest' -> [:note | log value: note].
	} key: 'note'.
	
	^ GDSpatial new children: {
		LogDworph new
	}
]
