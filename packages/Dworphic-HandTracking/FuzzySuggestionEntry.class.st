Class {
	#name : #FuzzySuggestionEntry,
	#superclass : #Object,
	#instVars : [
		'group',
		'chars'
	],
	#category : #'Dworphic-HandTracking'
}

{ #category : #'as yet unclassified' }
FuzzySuggestionEntry class >> newFrom: aString [
	| result |
	result := self new.
	result chars: aString.
	^ result.
]

{ #category : #'as yet unclassified' }
FuzzySuggestionEntry >> chars [
	^ chars
]

{ #category : #'as yet unclassified' }
FuzzySuggestionEntry >> chars: aString [
	chars := aString.
	group := aString asArray collect: [:c | CharGroupNode fingerCharacterMapping at: (c asLowercase asString) ifAbsent: [8]]
]

{ #category : #'as yet unclassified' }
FuzzySuggestionEntry >> group [
	 ^ group
]
