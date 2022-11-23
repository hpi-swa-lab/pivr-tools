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
	
	| message head visible waitTime sound |

	message := props at: #message ifAbsent: 'Test'.
	waitTime := props at: #waitTime ifAbsent: 3.
	head := self useProvidedRef: #headTransform.
	visible := self useState: true.	
	sound := self
		useMemo: [GDResourceLoader instance loadPath: 'res://assets/attention-direction/ding.wav']
		dependencies: #().
	
	^ {GDTimer new autostart: true; oneShot: true; waitTime: waitTime; onTimeout: [visible set: false].
	GDAudioStreamPlayer3D new stream: sound; autoplay: true.
	GDLabel3D new transform: (head get localTranslatedBy: (0 @ -0.25 @ -0.5));
		visible: visible get;
		text: message}
]
