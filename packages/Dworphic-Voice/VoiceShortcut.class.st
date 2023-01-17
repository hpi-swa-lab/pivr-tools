Class {
	#name : #VoiceShortcut,
	#superclass : #GRComponent,
	#category : #'Dworphic-Voice'
}

{ #category : #'as yet unclassified' }
VoiceShortcut >> render: props [

	Transcript showln: (props at: #voiceIntents).
	self useVoiceIntents: (props at: #voiceIntents) key: ' '.

	^ GDSpatial new
]
