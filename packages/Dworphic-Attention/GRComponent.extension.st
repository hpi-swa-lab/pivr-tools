Extension { #name : #GRComponent }

{ #category : #'*Dworphic-Attention' }
GRComponent >> christmasFindMe [

	| head targetPosition world log rlog radius sound angle idx audioIsPlaying indicatorTranslation indicatorTranslationWorld indicatorText arrow targetDistance distanceVectorInView snowflake distanceVectorInWorld |

	^ [
		world := self useWorldPortal.
	
		log := self useLog.
		rlog:= self replaceLog.
		idx := self useMemo: [(log value: '') value] dependencies: #().
	
		head := self useProvidedRef: #headTransform.
		targetPosition := self useState: (0 @ 0 @ 0).
		targetDistance := head get translation distanceTo: targetPosition get.
	
		sound := self
			useMemo: [GDResourceLoader instance loadPath: 'res://assets/attention-direction/jingle.wav']
			dependencies: #().
		audioIsPlaying := self useState: false.
		arrow := self
			useMemo: [GDResourceLoader instance loadPath: 'res://assets/attention-direction/christmas_tree.tres']
			dependencies: #().
		snowflake := self
			useMemo: [GDResourceLoader instance loadPath: 'res://assets/attention-direction/snowflake.tres']
			dependencies: #().
	
		radius := 0.01 * ((head get translation) distanceTo: (targetPosition get)).	
		angle := self getViewAngle: targetPosition get.
	
		distanceVectorInWorld := (targetPosition get - head get translation).
		distanceVectorInView := head get orientation productFromVector3: distanceVectorInWorld normalized.
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
		indicatorText :=
				('{1}', String crlf, '{2}m') format: {self className. (targetPosition get - head get translation) length printShowingMaxDecimalPlaces: 1}.


		{
			"GDTimer new onTimeout: [rlog value: idx value: [distanceVectorInView asString]]; waitTime: 0.1; autostart: true." "Debug logging"
			GDTimer new onTimeout: [audioIsPlaying set: true.]; waitTime: 2; autostart: true.
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
									mesh: arrow;
									"scale: 0.05;" "<- scale doesn't work, arrow object needs to be scaled instead"
									transform: (Matrix4x4 lookAt: targetPosition get from: indicatorTranslationWorld up: (0 @ 1 @ 0))).
								
									"rotation: ((0 @ 1 @ 0) rotationTo: (translation get - (head get localTranslatedBy: indicatorTranslation) translation normalized)) forwardRay direction)."
							 }
						]
						"TODO also render beam / finder when object is not being looked at for 2d spectators?"
						ifFalse:
						[
						GDParticles new
								processMaterial: (
									GDParticlesMaterial new
										emissionShape: GDParticlesMaterial emissionShapeBox;
										emissionBoxExtents: (0.5 @ 0.1 @ 0.5);
										color: Color white;
										gravity: (0 @ -1 @ 0)
								);
								lifetime: 10;
								amount: 100;
								drawPass1: snowflake "(GDCubeMesh new size: (Vector3 value: 0.02))";
								translation: (targetPosition get + (0 @ 1 @ 0));
								children: {
									GDAudioStreamPlayer3D new stream: sound; autoplay: true; playing: audioIsPlaying get; onFinished: [false ifTrue: [audioIsPlaying set: false.]].
								}
						]
				)
				in: world.
		}
	] asComponent.
]

{ #category : #'*Dworphic-Attention' }
GRComponent >> findMe [

	^ self findMeNoDepthTest: false withSound: false repeat: false showDistance: true
]

{ #category : #'*Dworphic-Attention' }
GRComponent >> findMeNoDepthTest: disableDepthTest withSound: enableSound repeat: repeat showDistance: showDistance [

	| head targetPosition world sound angle audioIsPlaying indicatorTranslation indicatorTranslationWorld indicatorText arrow targetDistance distanceVectorInView distanceVectorInWorld |

	^ [
		world := self useWorldPortal.
	
		head := self useProvidedRef: #headTransform.
		targetPosition := self useState: (0 @ 0 @ 0).
		targetDistance := head get translation distanceTo: targetPosition get.
	
		sound := self
			useMemo: [GDResourceLoader instance loadPath: 'res://assets/attention-direction/ding.wav']
			dependencies: #().
		audioIsPlaying := self useState: false.
		arrow := self
			useMemo: [GDResourceLoader instance loadPath: 'res://assets/attention-direction/arrow.tres']
			dependencies: #().
	
		angle := self getViewAngle: targetPosition get.
	
		distanceVectorInWorld := (targetPosition get - head get translation).
		distanceVectorInView := head get orientation productFromVector3: distanceVectorInWorld normalized.
		indicatorTranslation := Vector3 x: (
			distanceVectorInView x * (
				distanceVectorInView z > 0 "Object is behind head -> should lock to peripheral vision"
					ifTrue: [10000]
					ifFalse: [1]
				) min: 0.5 max: -0.5
			)
			y: (distanceVectorInWorld y min: 0.25 max: -0.25) "height relative to head lookAt"
			z: -1. "1m away from head"
		indicatorTranslationWorld := (head get localTranslatedBy: indicatorTranslation) translation.
		indicatorText := showDistance ifTrue: [
				('{1}', String crlf, '{2}m') format: {self className. (targetPosition get - head get translation) length printShowingMaxDecimalPlaces: 1}
			] ifFalse: [
				self className
			].

		{
			GDTimer new onTimeout: [audioIsPlaying set: true.]; waitTime: 2; autostart: enableSound.
			GDSpatial new subscribeTo: #'global_translation' do: [:t | targetPosition set: t].
			GDAudioStreamPlayer3D new stream: sound; autoplay: enableSound; playing: audioIsPlaying get; onFinished: [repeat ifTrue: [audioIsPlaying set: false.]].
			self showMeNoDepthTest: disableDepthTest.
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
									mesh: arrow;
									"scale: 0.05;" "<- scale doesn't work, arrow object needs to be scaled instead"
									transform: (Matrix4x4 lookAt: targetPosition get from: indicatorTranslationWorld up: (0 @ 1 @ 0))).
								
									"rotation: ((0 @ 1 @ 0) rotationTo: (translation get - (head get localTranslatedBy: indicatorTranslation) translation normalized)) forwardRay direction)."
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

{ #category : #'*Dworphic-Attention' }
GRComponent >> showMe [

	^ self showMeNoDepthTest: false
]

{ #category : #'*Dworphic-Attention' }
GRComponent >> showMeNoDepthTest: disableDepthTest [

	| head targetPosition world radius |

	^ [
		world := self useWorldPortal.
		targetPosition := self useState: (0 @ 0 @ 0).
		head := self useProvidedRef: #headTransform.
		radius := 0.01 * ((head get translation) distanceTo: (targetPosition get)).

		{
			GDSpatial new subscribeTo: #'global_translation' do: [:t | targetPosition set: t].
			CMFReactNodePortal
				child: (
					GDMeshInstance new mesh: 
							(GDCubeMesh new
								size: (radius @ 1000 @ radius);
								material: 
									(GDSpatialMaterial new albedoColor: Color red; flagsNoDepthTest: disableDepthTest));
								translation: (targetPosition get + (0 @ 500 @ 0))
						)
				in: world.
		}
	] asComponent.
]
