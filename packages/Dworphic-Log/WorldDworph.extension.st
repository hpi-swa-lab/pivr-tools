Extension { #name : #WorldDworph }

{ #category : #'*Dworphic-Log' }
WorldDworph >> provideLogState [
	<provider>

	| logEntries |
	logEntries := self useState: {}.
	^ {#logEntries -> logEntries}
]
