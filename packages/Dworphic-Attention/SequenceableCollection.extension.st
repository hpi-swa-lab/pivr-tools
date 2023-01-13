Extension { #name : #SequenceableCollection }

{ #category : #'*Dworphic-Attention' }
SequenceableCollection >> highlight [

	^ {HighlightDworph new children: self}
]
