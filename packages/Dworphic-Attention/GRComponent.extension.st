Extension { #name : #GRComponent }

{ #category : #'*Dworphic-Attention' }
GRComponent >> findMe [

	^ (self cubeOfSize: (0.1 @ 1000 @ 0.1) color: (Color red alpha: 0.5)) translation: (0 @ 500 @ 0)
]
