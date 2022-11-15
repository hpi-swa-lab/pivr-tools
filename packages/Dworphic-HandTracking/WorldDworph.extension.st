Extension { #name : #WorldDworph }

{ #category : #'*Dworphic-HandTracking' }
WorldDworph >> provideHandtrackingState [
	| word suggestions currentNode rootNode |
	<provider>
	
	suggestions := self useState: {}.
	rootNode := self useState: {}.
	currentNode := self useState: {}.
	word := self useState: {}.
	^ {#pinchtypeSuggestions -> suggestions. #pinchtypeWord -> word. #rootNode -> rootNode. #currentNode -> currentNode}
]
