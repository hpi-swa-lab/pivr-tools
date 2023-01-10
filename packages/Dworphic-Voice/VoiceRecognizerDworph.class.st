Class {
	#name : #VoiceRecognizerDworph,
	#superclass : #GRComponent,
	#category : #'Dworphic-Voice'
}

{ #category : #'as yet unclassified' }
VoiceRecognizerDworph class >> appDescription [
	<home>

	^ super appDescription
]

{ #category : #'as yet unclassified' }
VoiceRecognizerDworph >> gdSource [
	^ '## This script records audio and returns a transcribed version of the spoken voice using an 
## external Python server.
##
## ProjectSettings.audio/enable_audio_input must be true for audio input to work. If you are
## using a Mac, you will likely need to change some system settings, see: 
## https://github.com/godotengine/godot/issues/64583
## 
## Godot needs an AudioStreamPlayer in the scene that streams the microphone input to the 
## custom audio bus, which is recorded using a recording effect, attached to the bus by this script.

extends AudioStreamPlayer

class_name GRVoiceRecognizer

const bus_name = "SQUEAK_VOICE_RECORDER"
const host = "http://', self url, ':', self port, '/transcribe"

var is_recording setget set_recording

## a connection to an audio bus (=audio-channel) which records all audio on this bus
var recordEffect: AudioEffectRecord
var http: HTTPRequest

signal text_recognized(text)
	
# run this manually and not in _render oder _init because in squeak the script is applied 
# post-creation so far.
func init():
	var idx = AudioServer.bus_count
	AudioServer.add_bus(idx)
	AudioServer.set_bus_name(idx, bus_name)
	AudioServer.set_bus_mute(idx, true)
	recordEffect = AudioEffectRecord.new()
	AudioServer.add_bus_effect(idx, self.recordEffect)
	
	self.bus = bus_name
	self.stream = AudioStreamMicrophone.new()
	self.playing  = true
	
	http = HTTPRequest.new()
	add_child(http)
	http.connect("request_completed", self, "_transcription_completed")

# Called when the HTTP request is completed.
func _transcription_completed(result, response_code, headers, body):
	var bodyString = body.get_string_from_utf8()
	#var response = parse_json(bodyString)
	# Will print the user agent string used by the HTTPRequest node (as recognized by httpbin.org).
	emit_signal("text_recognized", bodyString)
	
func set_recording(var is_recording: bool):
	if recordEffect == null:
		init()
	if is_recording:
		recordEffect.set_recording_active(true)
		print("recording now..")
	else:
		var recording: AudioStreamSample = recordEffect.get_recording()
		if not recording:
			return
		recordEffect.set_recording_active(false)
		var localSavePath = "res://voicerecording.wav"
		recording.save_to_wav(localSavePath)
		print("saved recording")
		var globalSavePath = ProjectSettings.globalize_path(localSavePath)
		print(globalSavePath)
		var body = to_json({"path": globalSavePath})
		var error = http.request(host, [], false, HTTPClient.METHOD_POST, body)
		if error != OK:
			push_error("An error occurred in the HTTP request.")
'
]

{ #category : #'as yet unclassified' }
VoiceRecognizerDworph >> intentHandlersKeys: aCollectionOfIntentHandlerCollections [
	| intentHandlerKeys |
	intentHandlerKeys := {}.
	aCollectionOfIntentHandlerCollections get do: 
		[:aCollectionOfIntentHandlers | | intentGroup |
			intentGroup := ''.
			aCollectionOfIntentHandlers get keys do: [:intentString | 
				intentGroup := (intentGroup, (intentGroup isEmpty ifTrue: [''] ifFalse: [', ']), intentString)].
				intentHandlerKeys := intentHandlerKeys copyWith: intentGroup.
		].
	^ intentHandlerKeys
]

{ #category : #'as yet unclassified' }
VoiceRecognizerDworph >> match: aVoiceServerResultMatch on: aCollectionOfIntentHandlerCollections [
"triggers the matching intent of aCollectionOfIntentHandlerCollections and saves it for undo."

	| undoBlocks |
	undoBlocks := {}.

	aCollectionOfIntentHandlerCollections get do: [:aCollectionOfIntentHandlers | 
		aCollectionOfIntentHandlers get keysAndValuesDo: [:intentString :callback | 
			aVoiceServerResultMatch intent = intentString 
				ifTrue: [ | undo |
					"voice intent handlers potentially return a block that undos its changes"
					undo := callback valueWithEnoughArguments: aVoiceServerResultMatch params.
					undo ifNotNil: [undoBlocks := (undoBlocks copyWith: undo)].
					]
			]
		].
	
	^ undoBlocks
]

{ #category : #'as yet unclassified' }
VoiceRecognizerDworph >> match: aString withParams: aCollection on: aCollectionOfIntentHandlerCollections [

	aCollectionOfIntentHandlerCollections get do: [:aCollectionOfIntentHandlers | aCollectionOfIntentHandlers get keysAndValuesDo: [:intentString :callback | aString = intentString ifTrue: [callback valueWithEnoughArguments: aCollection]]]
]

{ #category : #'as yet unclassified' }
VoiceRecognizerDworph >> port [
	^ 5000
]

{ #category : #components }
VoiceRecognizerDworph >> recordingIndicator: aBoolean [
	^ GDMeshInstance new  translation: -1.6 @ -0.3 @ -5; mesh: (GDSphereMesh new
					radius: 0.06;
					height: 0.06 * 2;
					material: (GDSpatialMaterial new
						albedoColor: (aBoolean ifTrue: [Color red] ifFalse: [Color green]);
						flagsUnshaded: true;
						flagsNoDepthTest: true)).
]

{ #category : #'as yet unclassified' }
VoiceRecognizerDworph >> render: props [

	| isRecording script lastText head right distance shouldRecord headPortal intentHandlers visible isVisible undoStackState |
	isRecording := self useState: false.
	script := self useState: nil.
	lastText := self useState: {'Say "show" to show applications, and "hide" to hide them.'}.
	 
	intentHandlers := self useProvided: #voiceIntentHandlers.
	visible := self useState: false.
	
	undoStackState := self useState: OrderedCollection new.
	
	self
		useSingletonEffect: [
			script set: (GDGDScript externalNew
				sourceCode: self gdSource withUnixLineEndings;
				reload;
				yourself).
			[script get unreference]]
		dependencies: {}.
	
	head := self useHeadTransform.
	right := self useProvided: #rightControllerTransform.
	headPortal := self useProvided: #headPortal.
	distance := head translation distanceTo: right translation.
	shouldRecord := distance < (0.2 m).
	isVisible := shouldRecord or: [visible get].
	
	self useEffect: [isRecording set: shouldRecord] dependencies: {shouldRecord}.
	self useEffect: [self setIntentHandlersOnServer: intentHandlers] dependencies: {shouldRecord}.
	
	self
		useButtonPress: [:e | e button = GDGlobalConstants joyOculusBy ifTrue: [isRecording set: true]]
		release: [:e | e button = GDGlobalConstants joyOculusBy ifTrue: [isRecording set: false]]
		axisChange: [:e | ]
		side: #right.
		
	self useVoiceIntents: {
		'help' -> [lastText set: (self intentHandlersKeys: intentHandlers)].
		'undo' -> [undoStackState set: [:s | s ifNotEmpty: [s removeLast value. s copy]]].
	} key: ''.
	
	^ script get ifNotNil: [
		GDSpatial new children: {
			GDAudioStreamPlayer new
				call: 'set_script' arguments: {script get};
				set: #'is_recording' to: isRecording get;
				set: #'text_recognized' to: [:text | | json matches |
					visible get ifFalse: [visible set: true].
					json := Json readFrom: text utf8ToSqueak readStream.
					lastText set: {(json at: #text)}.
					matches := (json at: #matches) collect: [:j | VoiceServerResultMatch fromJson: j].
					(matches isEmpty not and: [matches first accuracy > 50]) 
						ifTrue: [|undoBlocks| 
							undoBlocks := self match: matches first on: intentHandlers.
							undoBlocks do: [:block |
								undoStackState set: [:s | s add: block. s copy]].
							]].
			CMFReactNodePortal
				child: (GDSpatial new children: (isVisible
					ifTrue: [
						{self recordingIndicator: isRecording get},
						{lastText get collectWithIndex: [:t :i |
							GDLabel3D new
								text: t;
								noDepthTest: true;
								translation: -1.50 @ (-0.2 - (i m / 8)) @ -5;
								horizontalAlignment: 0;
								verticalAlignment: 0;
								width: 400;
								shaded: true;
								autowrap: ((i = 0) ifTrue: [true] ifFalse: [false]).
							]}]
					ifFalse: [{}]))
				in: headPortal.
			visible get ifTrue: [
				GDTimer new
					autostart: true;
					waitTime: 10;
					onTimeout: [visible set: false]]}]
]

{ #category : #'as yet unclassified' }
VoiceRecognizerDworph >> setIntentHandlersOnServer: aCMFReactHookUseState [

	| intents |
	intents := aCMFReactHookUseState get gather: [:handlerRef | handlerRef get keys].
	[
		WebClient new
			httpPost: 'http://', self url, ':', self port, '/initIntents'
			content: (JsonObject fromAssociations: {#intents -> intents}) asJsonString
			type: 'application/json'] fork
]

{ #category : #'as yet unclassified' }
VoiceRecognizerDworph >> url [
	^ '127.0.0.1'
]
