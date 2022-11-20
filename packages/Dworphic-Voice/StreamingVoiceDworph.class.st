Class {
	#name : #StreamingVoiceDworph,
	#superclass : #GRComponent,
	#category : #'Dworphic-Voice'
}

{ #category : #'as yet unclassified' }
StreamingVoiceDworph >> busName [

	^ 'STREAMING_SQUEAK_VOICE_RECORDER'
]

{ #category : #'as yet unclassified' }
StreamingVoiceDworph >> render: props [

	| recordEffect player whisper |
	player := self useGodotRef.
	recordEffect := self useAudioEffectRecording: self busName playerNode: player.
	whisper := self useWhisper.
	
	^ {
		GDAudioStreamPlayer new
			ref: player;
			bus: self busName;
			stream: GDAudioStreamMicrophone new.
		GDTimer new
			autostart: true;
			waitTime: 3;
			onTimeout: [ | recording |
				recording := recordEffect get getRecording.
				self assert: recording format = GDAudioStreamSample format16Bits.
				self assert: recording stereo.
				self assert: recording mixRate = 44100.
				whisper get transcribeStereoPCMS16: recording data do: [:text | Transcript showln: text].
				recording unreference.
				"resets the buffer"
				recordEffect get setRecordingActiveRecord: true]}
]

{ #category : #'as yet unclassified' }
StreamingVoiceDworph >> useAudioEffectRecording: aBusName playerNode: aPlayerRef [

	| recordEffect |
	recordEffect := self useRef: nil.
	self
		useSingletonEffect: [ | index |
			recordEffect set: GDAudioEffectRecord externalNew.
			index := GDAudioServer instance busCount.
			GDAudioServer instance
				addBusAtPosition: index;
				setBusNameBusIdx: index name: aBusName;
				setBusMuteBusIdx: index enable: true;
				addBusEffectBusIdx: index effect: recordEffect get.
			recordEffect get setRecordingActiveRecord: true.
			aPlayerRef get playing: true.
			[recordEffect get unreference]]
		dependencies: {}.
	^ recordEffect
]

{ #category : #'as yet unclassified' }
StreamingVoiceDworph >> useWhisper [

	| whisper |
	whisper := self useRef: nil.
	self
		useSingletonEffect: [
			whisper set: WhisperCpp new.
			[whisper get destroy]]
		dependencies: {}.
	^ whisper
]
