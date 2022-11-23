Extension { #name : #GRComponent }

{ #category : #'*Dworphic-Attention' }
GRComponent >> findMe [

	^ self findMeNoDepthTest: false
]

{ #category : #'*Dworphic-Attention' }
GRComponent >> findMeNoDepthTest: disableDepthTest [

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
			child: (GDMeshInstance new mesh: 
				(GDCubeMesh new size: (radius @ 1000 @ radius); material: 
					(GDSpatialMaterial new albedoColor: Color red; flagsNoDepthTest: disableDepthTest));
				translation: (translation get + (0 @ 500 @ 0))
			)
			"((self cubeOfSize: (radius @ 1000 @ radius) color: (Color red)) translation: translation get)" 
			in: world.
	}
	] asComponent.
]
