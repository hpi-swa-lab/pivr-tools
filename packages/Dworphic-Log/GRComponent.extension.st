Extension { #name : #GRComponent }

{ #category : #'*Dworphic-Log' }
GRComponent >> replaceLog [
	"Usage: repLog := self replaceLog. repLog value: idxToReplace value: valueToReplaceWith"

	| log |
	log := self useProvidedRef: #logEntries.
	
	^ [:anIndex :aValue | log get set: [:entries | entries at: anIndex put: aValue. entries]]
	
]

{ #category : #'*Dworphic-Log' }
GRComponent >> useLog [

	| log |
	log := self useProvidedRef: #logEntries.
	^ [:message | log get set: [:entries | entries copyWith: message]. (log get get size)]
]
