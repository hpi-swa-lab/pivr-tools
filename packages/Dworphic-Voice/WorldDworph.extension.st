Extension { #name : #WorldDworph }

{ #category : #'*Dworphic-Voice' }
WorldDworph >> provideVoiceIntentHandlers [
	<provider>

	| voiceIntentHandlers |
	voiceIntentHandlers := self useState: {}.
	^ {#voiceIntentHandlers -> voiceIntentHandlers}
]
