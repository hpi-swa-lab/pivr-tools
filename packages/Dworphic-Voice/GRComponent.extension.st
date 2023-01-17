Extension { #name : #GRComponent }

{ #category : #'*Dworphic-Voice' }
GRComponent >> useVoiceIntents: aCollection key: aString [

	| handlers handlerRef commands handlersKeys |
	handlers := self useProvided: #voiceIntentHandlers.
	handlersKeys := handlers get gather: [:ref | ref get keys].
	
	commands := Dictionary new.
	aCollection do: [:association | commands at: (aString, ' ', association key) put: association value].
	
	handlerRef := self useRef: commands.
	handlerRef set: commands.
	
	self
		useEffect: [
			handlers set: [:h | h copyWith: handlerRef].
			[handlers set: [:h | h copyRemove: handlerRef]]]
		dependencies: {}.
]
