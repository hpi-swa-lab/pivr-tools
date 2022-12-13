Class {
	#name : #VoiceServerResultMatch,
	#superclass : #Object,
	#instVars : [
		'intent',
		'params',
		'accuracy'
	],
	#category : #'Dworphic-Voice'
}

{ #category : #'as yet unclassified' }
VoiceServerResultMatch class >> fromJson: j [
	^ self new intent: (j at: 'intent'); params: (j at: 'params'); accuracy: (j at: 'accuracy'); yourself
]

{ #category : #'as yet unclassified' }
VoiceServerResultMatch >> accuracy [
	^ accuracy
]

{ #category : #'as yet unclassified' }
VoiceServerResultMatch >> accuracy: aString [
	accuracy := aString asNumber.
]

{ #category : #'as yet unclassified' }
VoiceServerResultMatch >> intent [
	^ intent
]

{ #category : #'as yet unclassified' }
VoiceServerResultMatch >> intent: aString [
	intent := aString.
]

{ #category : #'as yet unclassified' }
VoiceServerResultMatch >> params [
	^ params
]

{ #category : #'as yet unclassified' }
VoiceServerResultMatch >> params: aCollection [
	params := aCollection.
]
