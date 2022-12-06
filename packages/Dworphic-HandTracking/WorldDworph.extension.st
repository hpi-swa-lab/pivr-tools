Extension { #name : #WorldDworph }

{ #category : #'*Dworphic-HandTracking' }
WorldDworph >> provideHandtrackingState [
	| word logIndices thumbRef |
	<provider>
	
	logIndices := self useState: Dictionary new.
	thumbRef := self useState: nil.
	word := self useState: {}.
	
	^ {#currentWord -> word. #logIndices -> logIndices. #thumbRef -> thumbRef}.
]
