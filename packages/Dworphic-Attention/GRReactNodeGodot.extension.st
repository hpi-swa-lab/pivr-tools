Extension { #name : #GRReactNodeGodot }

{ #category : #'*Dworphic-Attention' }
GRReactNodeGodot >> highlight [

	^ HighlightDworph new children: {self}
]

{ #category : #'*Dworphic-Attention' }
GRReactNodeGodot >> traceMe [

	^ TraceCollectorDworph new child: self
]
