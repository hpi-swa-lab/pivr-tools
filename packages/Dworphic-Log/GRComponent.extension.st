Extension { #name : #GRComponent }

{ #category : #'*Dworphic-Log' }
GRComponent >> replaceLog [
	"Usage: repLog := self replaceLog. repLog value: idxToReplace value: valueToReplaceWith"

	| log |
	log := self useProvidedRef: #logEntries.
	
	^ [:anIndex :aBlock | log get set: [:entries | entries at: anIndex put: (aBlock cull: (entries at: anIndex)). entries]]
	
]

{ #category : #'*Dworphic-Log' }
GRComponent >> useLog [

	| log |
	log := self useProvidedRef: #logEntries.
	^ [:message | log get set: [:entries | entries copyWith: message]. (log get get size)]
]
