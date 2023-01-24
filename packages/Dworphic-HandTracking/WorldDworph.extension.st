Extension { #name : #WorldDworph }

{ #category : #'*Dworphic-HandTracking' }
WorldDworph >> provideHandtrackingState [
	| word logIndices thumbRef scrollPos suggestionEntries |
	<provider>
	
	logIndices := self useState: Dictionary new.
	thumbRef := self useState: nil.
	word := self useState: {}.
	scrollPos := self useState: 0.
	suggestionEntries := self useState: {}.
	
	^ {#currentWord -> word. #logIndices -> logIndices. #thumbRef -> thumbRef. #scrollPos -> scrollPos. #suggestionEntries -> suggestionEntries}.
]
