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

{ #category : #'*Dworphic-Voice' }
GRComponent >> useVoiceIntents: aCollection key: aString [

	| handlers handlerRef commands |
	handlers := self useProvided: #voiceIntentHandlers.
	
	commands := Dictionary new.
	aCollection do: [:association | commands at: (aString, ' ', association key) put: association value].
	"add a default help command which shows all commands of this object"
	commands at: 'help' put: [ Transcript showln: 'TODO' ].
	handlerRef := self useRef: commands.
	
	self useEffect: [
		handlers set: [:h | h copyWith: handlerRef].
		[handlers set: [:h | h copyRemove: handlerRef]]] dependencies: {}.
]
