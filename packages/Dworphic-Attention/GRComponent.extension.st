Extension { #name : #GRComponent }

{ #category : #'*Dworphic-Attention' }
GRComponent >> findMe [

	^ self findMeNoDepthTest: false withSound: false repeat: false
]

{ #category : #'*Dworphic-Attention' }
GRComponent >> findMeNoDepthTest: disableDepthTest withSound: enableSound repeat: repeat [

	| world log rlog translation head radius sound angle idx playing |

	^ [
	world := self useWorldPortal.
	log := self useLog.
	rlog:= self replaceLog.
	translation := self useState: (0 @ 0 @ 0).
	head := self useProvidedRef: #headTransform.
	sound := self
		useMemo: [GDResourceLoader instance loadPath: 'res://assets/attention-direction/ding.wav']
		dependencies: #().
	idx := self useMemo: [(log value: '') value] dependencies: #().
	playing := self useState: false.
	
	radius := ((head get translation) distanceTo: (translation get)) * 0.01.	
	angle := self isInView: translation get.
		
	{
		GDTimer new onTimeout: [rlog value: idx value: head get rotation asString. "rlog value: (angle radiansToDegrees asString)"]; waitTime: 0.1; autostart: true.
		GDTimer new onTimeout: [playing set: true.]; waitTime: 2; autostart: enableSound.
		GDSpatial new subscribeTo: #'global_translation' do: [:t | translation set: t].
		CMFReactNodePortal
			child: (GDMeshInstance new mesh: 
				(GDCubeMesh new size: (radius @ 1000 @ radius); material: 
					(GDSpatialMaterial new albedoColor: Color red; flagsNoDepthTest: disableDepthTest));
"				translation: (translation get + (0 @ 500 @ 0));"
				rotation: (head get rotation x degreesToRadians * -1) @ (head get rotation y degreesToRadians) @ (head get rotation z degreesToRadians * -1);
				children: {
					GDAudioStreamPlayer3D new stream: sound; autoplay: enableSound; playing: playing get; onFinished: [repeat ifTrue: [playing set: false.]].
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
