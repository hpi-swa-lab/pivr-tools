"
A FuzzySuggestionEntry is a dataclass used to store information about a word that can be suggested by FuzzySuggestions

Instance Variables
	chars:		An array of characters, the characters that make up the word
	group:		An array of numbers that represent pinchtype character groups


"
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
