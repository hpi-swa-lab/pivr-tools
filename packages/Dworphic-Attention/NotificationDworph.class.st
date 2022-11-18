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
	
	| message head |

	message := props at: #message ifAbsent: 'Test'.
	head := self useProvidedRef: #headTransform.
	
	^ GDLabel3D new transform: (head get localTranslatedBy: (0 @ -0.25 @ -0.5));
		text: message
]
