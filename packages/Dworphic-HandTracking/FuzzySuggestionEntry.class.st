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
FuzzySuggestionEntry class >> newFrom: aString withMapping: aDict [
	| result |
	result := self new.
	result chars: aString mapping: aDict.
	^ result.
]

{ #category : #'as yet unclassified' }
FuzzySuggestionEntry >> chars [
	^ chars
]

{ #category : #'as yet unclassified' }
FuzzySuggestionEntry >> chars: aString mapping: aDict [
	chars := aString.
	group := aString asArray collect: [:c | aDict at: c asLowercase ifAbsent: [8]]
]

{ #category : #'as yet unclassified' }
FuzzySuggestionEntry >> group [
	 ^ group
]
