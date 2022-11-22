Extension { #name : #GRComponent }

{ #category : #'*Dworphic-Voice' }
GRComponent >> useVoiceIntent: anIntent do: aBlock [

	| handlers handlerRef |
	handlers := self useProvided: #voiceIntentHandlers.
	handlerRef := self useRef: nil.
	handlerRef set: anIntent -> aBlock.
	
	self useEffect: [
		handlers set: [:h | h copyWith: handlerRef].
		[handlers set: [:h | h copyRemove: handlerRef]]] dependencies: {}
]
