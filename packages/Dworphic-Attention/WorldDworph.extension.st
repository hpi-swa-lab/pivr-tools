Extension { #name : #WorldDworph }

{ #category : #'*Dworphic-Attention' }
WorldDworph >> provideTraceState [
	<provider>

	| traces |
	traces := self useState: Dictionary new.
	^ {#traces-> traces}
]
