Class {
	#name : #FuzzySuggestions,
	#superclass : #Object,
	#instVars : [
		'list'
	],
	#category : #'Dworphic-HandTracking'
}

{ #category : #'as yet unclassified' }
FuzzySuggestions class >> newFrom: aListOfWords [
	 | result |
	result := self new.
	result list: aListOfWords.
	^ result.
]

{ #category : #'as yet unclassified' }
FuzzySuggestions >> entry: aSuggestionEntry at: anIndex matches: aCharacter [
		aCharacter isNumber 
			ifTrue: [^ aCharacter = (aSuggestionEntry group at: anIndex)]
			ifFalse: [^ aCharacter = (aSuggestionEntry chars at: anIndex)].
		
	
]

{ #category : #'as yet unclassified' }
FuzzySuggestions >> entry: aSuggestionEntry matches: query [
		^ self entry: aSuggestionEntry matches: query  exactFirst: 3.	
	
]

{ #category : #'as yet unclassified' }
FuzzySuggestions >> entry: aSuggestionEntry matches: query exactFirst: aNumber [
| queryIndex minLength |

	minLength := {aSuggestionEntry chars size. query size} min.
	(minLength < aNumber) ifTrue: [^ self entry: aSuggestionEntry matches: query exactFirst: minLength].
	
	1 to: aNumber do: [:index |
		(self entry: aSuggestionEntry  at: index matches: (query at: index)) ifFalse: [^false]].
	queryIndex := aNumber + 1.
	
	queryIndex to: aSuggestionEntry chars size do: [:entryIndex |
		queryIndex = (query size + 1) ifTrue: [^true].
		(self entry: aSuggestionEntry at: entryIndex matches: (query at: queryIndex)) ifTrue: [ queryIndex := queryIndex + 1]].
	^ queryIndex = (query size +1)
]

{ #category : #'as yet unclassified' }
FuzzySuggestions >> list [
	^ list
]

{ #category : #'as yet unclassified' }
FuzzySuggestions >> list: aListOfWords [

	list := aListOfWords collect: [:word | FuzzySuggestionEntry newFrom: word.].
]

{ #category : #'as yet unclassified' }
FuzzySuggestions >> search: aQuery [
	^ list select: [:entry | self entry: entry matches: aQuery] 
		thenCollect: [: entry | entry chars]
]
