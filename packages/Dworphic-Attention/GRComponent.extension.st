Extension { #name : #GRComponent }

{ #category : #'*Dworphic-Attention' }
GRComponent >> findMe [

	^ self findMeNoDepthTest: false withSound: false repeat: false showDistance: true
]

{ #category : #'*Dworphic-Attention' }
GRComponent >> findMeNoDepthTest: disableDepthTest withSound: enableSound repeat: repeat showDistance: showDistance [

	| world log rlog translation head radius sound angle idx playing indicatorTranslation indicatorText arrow |

	^ [
	world := self useWorldPortal.
	log := self useLog.
	rlog:= self replaceLog.
	translation := self useState: (0 @ 0 @ 0).
	head := self useProvidedRef: #headTransform.
	sound := self
		useMemo: [GDResourceLoader instance loadPath: 'res://assets/attention-direction/ding.wav']
		dependencies: #().
	"arrow := self
		useMemo: [GDResourceLoader instance loadPath: 'res://assets/attention-direction/arrow.tres']
		dependencies: #()."
	idx := self useMemo: [(log value: '') value] dependencies: #().
	playing := self useState: false.
	
	radius := 0.01 * ((head get translation) distanceTo: (translation get)).	
	angle := self isInView: translation get.
	indicatorTranslation := Vector3 x: (angle second x * (angle second z > 0 ifTrue: [10000] ifFalse: [1]) min: 0.5 max: -0.5) y: (angle second y min: 0.25 max: -0.25) z: -1.
	indicatorText := showDistance ifTrue: [
			('{1}', String crlf, '{2}m') format: {self className. angle third printShowingMaxDecimalPlaces: 1}
		] ifFalse: [
			self className].
		
	{
		"GDTimer new onTimeout: [rlog value: idx value: angle asString]; waitTime: 0.1; autostart: true."
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
				{GDLabel3D new text: indicatorText; 
				transform: (head get localTranslatedBy: indicatorTranslation + (0 @ 0.1 @ 0));
				billboard: true;
				noDepthTest: true;
				font: (GDDynamicFont new
					fontData: (GDDynamicFontData new fontPath: 'res://assets/attention-direction/NotoSans.ttf');
					size: 48);
				pixelSize: 0.001.
				
				(GDMeshInstance new mesh: 
					(GDCubeMesh new size: (Vector3 value: 0.05); material: 
						(GDSpatialMaterial new albedoColor: Color red; flagsNoDepthTest: true));
				transform: (head get localTranslatedBy: indicatorTranslation)).
					"rotation: ((0 @ 1 @ 0) rotationTo: (translation get - (head get localTranslatedBy: indicatorTranslation) translation normalized)) forwardRay direction)."
					}
			])
			in: world.}
	] asComponent.
]

{ #category : #'*Dworphic-Attention' }
GRComponent >> isInView: aPosition [

	| head objectDistance objectDirection cameraDirection objectAngle transformedDirection |
	
	head := self useProvidedRef: #headTransform.
	objectDirection := (aPosition - head get translation) normalized.
	objectDistance := (aPosition - head get translation) length.
	cameraDirection := head get forwardRay direction.
	objectAngle := (objectDirection angleTo: cameraDirection) radiansToDegrees.
	transformedDirection := head get orientation productFromVector3: objectDirection.
	
	^ {objectAngle < 40. Vector3 x: transformedDirection x y: transformedDirection y z: transformedDirection z. objectDistance}
	
	
	
]
