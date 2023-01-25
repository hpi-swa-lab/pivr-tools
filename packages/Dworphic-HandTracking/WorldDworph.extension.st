Extension { #name : #WorldDworph }

{ #category : #'*Dworphic-HandTracking' }
WorldDworph >> provideHandtrackingState [
	| word thumbRef scrollPos suggestionEntries allFingerRefs currentCharGroup areFistsClosed |
	<provider>
	
	thumbRef := self useState: nil.
	word := self useState: {}.
	scrollPos := self useState: 0.
	suggestionEntries := self useState: {}.
	currentCharGroup := self useState: nil.
	allFingerRefs := self useState: {}.
	areFistsClosed := self useState: Dictionary new.
	
	^ {#currentWord -> word. #thumbRef -> thumbRef. #scrollPos -> scrollPos. #suggestionEntries -> suggestionEntries. #allFingerRefs -> allFingerRefs. #currentCharGroup -> currentCharGroup. #areFistsClosed -> areFistsClosed}.
]
