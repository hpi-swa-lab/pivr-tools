Extension { #name : #WorldDworph }

{ #category : #'*Dworphic-HandTracking' }
WorldDworph >> provideHandtrackingState [
	| word logIndices |
	<provider>
	
	logIndices := self useState: Dictionary new.
	
	word := self useState: {}.
	
	^ {#currentWord -> word. #logIndices -> logIndices}.
]
