Extension { #name : #GRComponent }

{ #category : #'*Dworphic-Attention' }
GRComponent >> findMe [

	| world log translation head radius |

	^ [
	world := self useWorldPortal.
	log := self useLog.
	translation := self useState: (0 @ 0 @ 0).
	head := self useProvidedRef: #headTransform.
	
	radius := ((head get translation) distanceTo: (translation get)) * 0.01.	
		
	{
		GDSpatial new subscribeTo: #'global_translation' do: [:t | translation set: t].
		CMFReactNodePortal
			child: ((self cubeOfSize: (radius @ 1000 @ radius) color: (Color red)) translation: translation get) 
			in: world.
	}
	] asComponent.
]
