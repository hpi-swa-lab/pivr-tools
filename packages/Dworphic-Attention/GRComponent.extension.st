Extension { #name : #GRComponent }

{ #category : #'*Dworphic-Attention' }
GRComponent >> distanceVectorInView: targetPosition [

	| head objectDirection |
	
	head := self useProvidedRef: #headTransform.
	objectDirection := (targetPosition - head get translation) normalized.

	^ head get orientation productFromVector3: objectDirection.
]

{ #category : #'*Dworphic-Attention' }
GRComponent >> findMe [

	^ self findMeNoDepthTest: false withSound: false repeat: false showDistance: true
]

{ #category : #'*Dworphic-Attention' }
GRComponent >> findMeNoDepthTest: disableDepthTest withSound: enableSound repeat: repeat showDistance: showDistance [

	| head targetPosition world log rlog radius sound angle idx audioIsPlaying indicatorTranslation indicatorTranslationWorld indicatorText arrow targetDistance distanceVectorInView indicatorRotationWorld |

	^ [
		world := self useWorldPortal.
	
		log := self useLog.
		rlog:= self replaceLog.
		idx := self useMemo: [(log value: '') value] dependencies: #().
	
		head := self useProvidedRef: #headTransform.
		targetPosition := self useState: (0 @ 0 @ 0).
		targetDistance := head get translation distanceTo: targetPosition get.
	
		sound := self
			useMemo: [GDResourceLoader instance loadPath: 'res://assets/attention-direction/ding.wav']
			dependencies: #().
		audioIsPlaying := self useState: false.
		"arrow := self
			useMemo: [GDResourceLoader instance loadPath: 'res://assets/attention-direction/arrow.tres']
			dependencies: #()."
	
		radius := 0.01 * ((head get translation) distanceTo: (targetPosition get)).	
		angle := self getViewAngle: targetPosition get.
	
		distanceVectorInView := self distanceVectorInView: targetPosition get.
		indicatorTranslation := Vector3 x: (
			distanceVectorInView x * (
				distanceVectorInView z > 0 "Object is behind head -> should lock to peripheral vision"
					ifTrue: [10000]
					ifFalse: [1]
				) min: 0.5 max: -0.5
			)
			y: (distanceVectorInView y min: 0.25 max: -0.25) "height relative to head lookAt"
			z: -1. "1m away from head"
		indicatorTranslationWorld := (head get localTranslatedBy: indicatorTranslation) translation.
		indicatorRotationWorld := (0 @ 0 @ 0).
		indicatorText := showDistance ifTrue: [
				('{1}', String crlf, '{2}m') format: {self className. (targetPosition get - head get translation) length printShowingMaxDecimalPlaces: 1}
			] ifFalse: [
				self className
			].

		{
			GDTimer new onTimeout: [rlog value: idx value: [distanceVectorInView asString]]; waitTime: 0.1; autostart: true. "Debug logging"
			GDTimer new onTimeout: [audioIsPlaying set: true.]; waitTime: 2; autostart: enableSound.
			GDSpatial new subscribeTo: #'global_translation' do: [:t | targetPosition set: t].
			CMFReactNodePortal
				child: (
					angle > 40
						ifTrue:
						[
							{
								GDLabel3D new text: indicatorText; 
									transform: (head get localTranslatedBy: indicatorTranslation + (0 @ 0.1 @ 0));
									billboard: true;
									noDepthTest: true;
									font: (GDDynamicFont new
										fontData: (GDDynamicFontData new fontPath: 'res://assets/attention-direction/NotoSans.ttf');
										size: 48);
										pixelSize: 0.001.
					
								(GDMeshInstance new
									mesh: 
										(GDCubeMesh new size: (Vector3 value: 0.05); material: 
											(GDSpatialMaterial new albedoColor: Color red; flagsNoDepthTest: true)
										);
									translation: indicatorTranslationWorld;
									rotation: indicatorRotationWorld).
								
									"rotation: ((0 @ 1 @ 0) rotationTo: (translation get - (head get localTranslatedBy: indicatorTranslation) translation normalized)) forwardRay direction)."
							 }
						]
						"TODO also render beam / finder when object is not being looked at for 2d spectators?"
						ifFalse:
						[
						GDMeshInstance new mesh: 
							(GDCubeMesh new
								size: (radius @ 1000 @ radius);
								material: 
									(GDSpatialMaterial new albedoColor: Color red; flagsNoDepthTest: disableDepthTest));
								translation: (targetPosition get + (0 @ 500 @ 0));
								children: {
									GDAudioStreamPlayer3D new stream: sound; autoplay: enableSound; playing: audioIsPlaying get; onFinished: [repeat ifTrue: [audioIsPlaying set: false.]].
								}
						]
				)
				in: world.
		}
	] asComponent.
]

{ #category : #'*Dworphic-Attention' }
GRComponent >> getViewAngle: targetPosition [

	| head objectDirection cameraDirection |

	head := self useProvidedRef: #headTransform.
	objectDirection := (targetPosition - head get translation) normalized.
	cameraDirection := head get forwardRay direction.
	
	^ (objectDirection angleTo: cameraDirection) radiansToDegrees.
]
