Class {
	#name : #NotificationDworph,
	#superclass : #GRComponent,
	#category : #'Dworphic-Attention'
}

{ #category : #'as yet unclassified' }
NotificationDworph class >> appDescription [
	<home>

	^ super appDescription
]

{ #category : #'as yet unclassified' }
NotificationDworph >> render: props [
	
	| message head shouldDisappear waitTime sound label ref |

	message := props at: #message ifAbsent: 'Test'.
	waitTime := props at: #waitTime ifAbsent: 3.
	head := self useProvidedRef: #headTransform.
	shouldDisappear := self useState: false.	
	sound := self
		useMemo: [GDResourceLoader instance loadPath: 'res://assets/attention-direction/ding.wav']
		dependencies: #().
	label := GDLabel3D new.
	ref := self useGodotRef.
	label ref: ref.
	
	^ {GDTimer new autostart: true; oneShot: true; waitTime: waitTime; onTimeout: [shouldDisappear set: true].
	GDAudioStreamPlayer3D new stream: sound; autoplay: true.
	label transform: (head get localTranslatedBy: (0 @ -0.25 @ -0.5));
		font: (GDDynamicFont new
			fontData: (GDDynamicFontData new fontPath: 'res://assets/attention-direction/NotoSans.ttf');
			size: 72);
		pixelSize: 0.001;
		text: message.
	shouldDisappear get ifTrue: [(self animate: #modulate of: ref get to: (Color r: 1.0 g: 1.0 b: 1.0 alpha: 0)) duration: 1.0.]. }
]
