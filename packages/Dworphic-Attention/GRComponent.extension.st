Extension { #name : #GRComponent }

{ #category : #'*Dworphic-Attention' }
GRComponent >> findMe [

	^ self findMeNoDepthTest: false withSound: false repeat: false
]

{ #category : #'*Dworphic-Attention' }
GRComponent >> findMeNoDepthTest: disableDepthTest withSound: enableSound repeat: repeat [

	| world log rlog translation head radius sound angle idx playing indicatorTranslation |

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
	indicatorTranslation := Vector3 x: (angle second x min: 0.5 max: -0.5) y: (angle second y min: 0.25 max: -0.25) z: -1.
		
	{
		GDTimer new onTimeout: [rlog value: idx value: angle asString]; waitTime: 0.1; autostart: true.
		GDTimer new onTimeout: [playing set: true.]; waitTime: 2; autostart: enableSound.
		GDSpatial new subscribeTo: #'global_translation' do: [:t | translation set: t].
		CMFReactNodePortal
			child: (angle first ifTrue: [(GDMeshInstance new mesh: 
				(GDCubeMesh new size: (radius @ 1000 @ radius); material: 
					(GDSpatialMaterial new albedoColor: Color red; flagsNoDepthTest: disableDepthTest));
				translation: (translation get + (0 @ 500 @ 0));
				children: {
					GDAudioStreamPlayer3D new stream: sound; autoplay: enableSound; playing: playing get; onFinished: [repeat ifTrue: [playing set: false.]].
				}
			)] ifFalse: [
				(self cubeOfSize: 0.1 color: Color red) transform: (head get localTranslatedBy: indicatorTranslation).
			])
			in: world.}
	] asComponent.
]

{ #category : #'*Dworphic-Attention' }
GRComponent >> isInView: aPosition [

	| head objectDirection cameraDirection objectAngle transformedDirection |
	
	head := self useProvidedRef: #headTransform.
	objectDirection := aPosition - (head get translation).
	cameraDirection := head get forwardRay direction.
	objectAngle := (objectDirection angleTo: cameraDirection) radiansToDegrees.
	transformedDirection := head get productFromVector3: objectDirection "(head get transform: objectDirection normalized)".
	
	^ {objectAngle < 40. Vector3 x: transformedDirection x * -1 y: transformedDirection y * -1 z: 0.}
	
	
	
]
