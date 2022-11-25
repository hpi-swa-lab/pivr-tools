Extension { #name : #GRComponent }

{ #category : #'*Dworphic-Attention' }
GRComponent >> findMe [

	^ self findMeNoDepthTest: false withSound: false
]

{ #category : #'*Dworphic-Attention' }
GRComponent >> findMeNoDepthTest: disableDepthTest withSound: enableSound [

	| world log translation head radius sound angle |

	^ [
	world := self useWorldPortal.
	log := self useLog.
	translation := self useState: (0 @ 0 @ 0).
	head := self useProvidedRef: #headTransform.
	sound := self
		useMemo: [GDResourceLoader instance loadPath: 'res://assets/attention-direction/ding.wav']
		dependencies: #().
	
	radius := ((head get translation) distanceTo: (translation get)) * 0.01.	
	angle := self isInView: translation get.
		
	{
		GDTimer new onTimeout: [Transcript showln: head get rotation. Transcript showln: (angle radiansToDegrees asString)]; waitTime: 0.1; autostart: true.
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

{ #category : #'*Dworphic-Attention' }
GRComponent >> isInView: aPosition [

	| head objectDirection cameraDirection objectAngle |
	
	head := self useProvidedRef: #headTransform.
	objectDirection := aPosition - (head get translation).
	cameraDirection := head get rotation.
	objectAngle := objectDirection angleTo: cameraDirection.
	
	^ objectAngle
	
	
	
]
