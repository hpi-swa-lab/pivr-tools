Extension { #name : #GRComponent }

{ #category : #'*Dworphic-Attention' }
GRComponent >> findMe [

	^ self findMeNoDepthTest: false withSound: false
]

{ #category : #'*Dworphic-Attention' }
GRComponent >> findMeNoDepthTest: disableDepthTest withSound: enableSound [

	| world log translation head radius sound |

	^ [
	world := self useWorldPortal.
	log := self useLog.
	translation := self useState: (0 @ 0 @ 0).
	head := self useProvidedRef: #headTransform.
	sound := self
		useMemo: [GDResourceLoader instance loadPath: 'res://assets/attention-direction/ding.wav']
		dependencies: #().
	
	radius := ((head get translation) distanceTo: (translation get)) * 0.01.	
		
	{
		GDSpatial new subscribeTo: #'global_translation' do: [:t | translation set: t].
		CMFReactNodePortal
			child: (GDMeshInstance new mesh: 
				(GDCubeMesh new size: (radius @ 1000 @ radius); material: 
					(GDSpatialMaterial new albedoColor: Color red; flagsNoDepthTest: disableDepthTest));
				translation: (translation get + (0 @ 500 @ 0));
				children: {
					GDAudioStreamPlayer3D new stream: sound; autoplay: enableSound; attenuationModel: GDAudioStreamPlayer3D attenuationInverseDistance.
				}
			)
			in: world.
	}
	] asComponent.
]
