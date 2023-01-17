Extension { #name : #WorldDworph }

{ #category : #'*Dworphic-HandTracking' }
WorldDworph >> provideHandtrackingState [
	| word logIndices thumbRef allFingerRefs |
	<provider>
	
	logIndices := self useState: Dictionary new.
	thumbRef := self useState: nil.
	allFingerRefs := self useState: {}.
	word := self useState: {}.
	
	^ {#currentWord -> word. #logIndices -> logIndices. #thumbRef -> thumbRef. #allFingerRefs -> allFingerRefs}.
]
