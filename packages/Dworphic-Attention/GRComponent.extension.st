Extension { #name : #GRComponent }

{ #category : #'*Dworphic-Attention' }
GRComponent >> findMe [

	| world log translation |

	^ [
	world := self useWorldPortal.
	log := self useLog.
	translation := self useState: (0 @ 0 @ 0).
	
	{
		GDSpatial new subscribeTo: #'global_translation' do: [:t | translation set: t].
		CMFReactNodePortal
			child: ((self cubeOfSize: (0.1 @ 1000 @ 0.1) color: (Color red)) translation: translation get) 
			in: world.
	}
	] asComponent.
]
