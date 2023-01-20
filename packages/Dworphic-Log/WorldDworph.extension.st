Extension { #name : #WorldDworph }

{ #category : #'*Dworphic-Log' }
WorldDworph >> provideLogState [
	<provider>

	| logEntries |
	logEntries := self useState: {}.
	^ {#logEntries -> logEntries}
]

{ #category : #'*Dworphic-Log' }
WorldDworph >> provideTraceState [
	<provider>

	| traces |
	traces := self useState: {}.
	^ {#traces-> traces}
]
