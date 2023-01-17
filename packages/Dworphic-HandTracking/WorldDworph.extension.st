Extension { #name : #WorldDworph }

{ #category : #'*Dworphic-HandTracking' }
WorldDworph >> provideHandtrackingState [
	| word logIndices thumbRef scrollPos |
	<provider>
	
	logIndices := self useState: Dictionary new.
	thumbRef := self useState: nil.
	word := self useState: {}.
	scrollPos := self useState: 0.
	
	^ {#currentWord -> word. #logIndices -> logIndices. #thumbRef -> thumbRef. #scrollPos -> scrollPos}.
]
