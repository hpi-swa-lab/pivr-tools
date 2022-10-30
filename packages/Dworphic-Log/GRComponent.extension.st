Extension { #name : #GRComponent }

{ #category : #'*Dworphic-Log' }
GRComponent >> useLog [

	| log |
	log := self useProvidedRef: #logEntries.
	^ [:message | log get set: [:entries | entries copyWith: message]]
]
