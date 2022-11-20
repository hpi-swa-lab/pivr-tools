Class {
	#name : #WhisperCpp,
	#superclass : #ExternalLibrary,
	#instVars : [
		'working',
		'context'
	],
	#category : #'Dworphic-Voice'
}

{ #category : #'as yet unclassified' }
WhisperCpp class >> ensureModel: aModelNameString [

	| output res |
	"Links from here: https://github.com/ggerganov/whisper.cpp/blob/master/models/download-ggml-model.sh"
	output := FileDirectory default / ('ggml-{1}.bin' format: {aModelNameString}).
	output exists ifTrue: [^ output fullName].
	
	'Fetching Whisper Model: ' displaySequentialProgress: [
		ProgressNotification signal: 0.0 extra: 'Downloading ...'.
		res := WebClient httpGet: ('https://huggingface.co/datasets/ggerganov/whisper.cpp/resolve/main/ggml-{1}.bin' format: {aModelNameString}).
		ProgressNotification signal: 0.9 extra: 'Saving ...'.
		FileStream forceNewFileNamed: output fullName do: [:s | | content |
			content := res contentWithProgress: [:total :amount |
				HTTPProgress new
					total: total;
					amount: amount;
					signal: 'Progress'].
			self halt.
			s
				binary;
				nextPutAll: content]].
	^ output fullName
]

{ #category : #'as yet unclassified' }
WhisperCpp class >> example [

	| w whisper samples s |
	w := self new.
	whisper := w init: '/home/tom/Code/squeak/whisper.cpp/models/ggml-tiny.en.bin'.
	samples := (SampledSound fromWaveFileNamed: '/home/tom/Code/squeak/whisper.cpp/samples/jfk.wav') samples
		collect: [:p | p asFloat / (2 ** 16)]
		as: Float32Array.
	Transcript showln: [
		w
			full: whisper
			params: ((w fullDefaultParams: 0)
				printProgress: false;
				printRealtime: false;
				printSpecialTokens: false;
				printTimestamps: false;
				translate: false;
				noContext: true;
				nThreads: 8;
				speedUp: true;
				yourself)
			samples: samples
			size: samples size] timeToRun.
	s := String streamContents: [:stream |
		0
			to: (w fullNSegments: whisper) - 1
			do: [:index | stream nextPutAll: (w fullGetSegmentText: whisper index: index)]].
	w free: whisper.
	^ Transcript showln: s
]

{ #category : #'as yet unclassified' }
WhisperCpp class >> exampleThread [

	| w whisper samples s |
	w := self new.
	whisper := w init: '/home/tom/Code/squeak/whisper.cpp/models/ggml-tiny.en.bin'.
	samples := (SampledSound fromWaveFileNamed: '/home/tom/Code/squeak/whisper.cpp/samples/jfk.wav') samples
		collect: [:p | p asFloat / (2 ** 16)]
		as: Float32Array.
	w
		fullThread: whisper
		params: ((w fullDefaultParams: 0)
			printProgress: false;
			printRealtime: false;
			printSpecialTokens: false;
			printTimestamps: false;
			translate: false;
			noContext: true;
			nThreads: 8;
			speedUp: true;
			yourself)
		samples: samples
		size: samples size.
	
	[
		[w fullThreadIsComplete] whileFalse: [10 milliSeconds wait].
		s := String streamContents: [:stream |
			0
				to: (w fullNSegments: whisper) - 1
				do: [:index | stream nextPutAll: (w fullGetSegmentText: whisper index: index)]].
		w free: whisper.
		Transcript showln: s] fork
]

{ #category : #'as yet unclassified' }
WhisperCpp class >> exampleTranscribe: aCollection [

	| w whisper s |
	w := self new.
	whisper := w init: '/home/tom/Code/squeak/whisper.cpp/models/ggml-tiny.en.bin'.
	w
		full: whisper
		params: ((w fullDefaultParams: 0)
			printProgress: false;
			printRealtime: false;
			printSpecialTokens: false;
			printTimestamps: false;
			translate: false;
			noContext: true;
			nThreads: 8;
			speedUp: true;
			yourself)
		samples: aCollection
		size: aCollection size.
	s := String streamContents: [:stream |
		0
			to: (w fullNSegments: whisper) - 1
			do: [:index | stream nextPutAll: (w fullGetSegmentText: whisper index: index)]].
	w free: whisper.
	^ s
]

{ #category : #'as yet unclassified' }
WhisperCpp class >> moduleName [

	^ (GRReact pivrToolsPath / 'third_party' / 'whisper.cpp' / 'build' / 'libwhisper.so') asString
]

{ #category : #utils }
WhisperCpp >> currentString [

	^ String streamContents: [:stream |
		0
			to: (self fullNSegments: context) - 1
			do: [:index | stream nextPutAll: (self fullGetSegmentText: context index: index)]]
]

{ #category : #api }
WhisperCpp >> destroy [

	(context notNil and: [context isNull not]) ifTrue: [self free: context]
]

{ #category : #utils }
WhisperCpp >> downsample: aCollection from: aNumber to: anotherNumber [

	| originalLengthSeconds output window step |
	originalLengthSeconds := aCollection size / aNumber.
	step := aNumber / anotherNumber.
	window := step ceiling.
	output := aCollection species new: (originalLengthSeconds * anotherNumber) truncated.
	1 to: output size do: [:index | | sum |
		sum := 0.
		(index - 1 * step) truncated + 1
			to: (index - 1 * step) truncated + window + 1
			do: [:indexOrig | sum := sum + (aCollection at: indexOrig ifAbsent: [0])].
		output at: index put: sum / window].
	^ output
]

{ #category : #ffi }
WhisperCpp >> free: aWhisper [

	<apicall: void whisper_free(void*)>
	^ self externalCallFailed
]

{ #category : #ffi }
WhisperCpp >> full: aWhisperContext params: aWhisperParams samples: aCollection size: aNumber [

	<apicall: int whisper_full(void*, WhisperParams, float*, int)>
	^ self externalCallFailed
]

{ #category : #ffi }
WhisperCpp >> fullDefaultParams: aSampleStrategyNumber [

	<apicall: WhisperParams whisper_full_default_params(int)>
	^ self externalCallFailed
]

{ #category : #ffi }
WhisperCpp >> fullGetSegmentText: aContext index: aNumber [

	<apicall: char* whisper_full_get_segment_text(void*, int)>
	^ self externalCallFailed
]

{ #category : #ffi }
WhisperCpp >> fullGetTokenText: aContext at: aNumber [

	<apicall: char* whisper_full_get_token_text(void*,int)>
	^ self externalCallFailed
]

{ #category : #ffi }
WhisperCpp >> fullNSegments: aContext [

	<apicall: int whisper_full_n_segments(void*)>
	^ self externalCallFailed
]

{ #category : #ffi }
WhisperCpp >> fullNTokens: aContext [

	<apicall: int whisper_full_n_tokens(void*,int)>
	^ self externalCallFailed
]

{ #category : #ffi }
WhisperCpp >> fullThread: aWhisperContext params: aWhisperParams samples: aCollection size: aNumber [

	<apicall: void whisper_full_thread(void*, WhisperParams, float*, int)>
	^ self externalCallFailed
]

{ #category : #ffi }
WhisperCpp >> fullThreadIsComplete [

	<apicall: bool whisper_full_thread_is_complete()>
	^ self externalCallFailed
]

{ #category : #ffi }
WhisperCpp >> init: aPathString [

	<apicall: void* whisper_init(char*)>
	^ self externalCallFailed
]

{ #category : #'as yet unclassified' }
WhisperCpp >> initialize [

	super initialize.
	working := false
]

{ #category : #utils }
WhisperCpp >> params [

	^ (self fullDefaultParams: 0)
		printProgress: false;
		printRealtime: false;
		printSpecialTokens: false;
		printTimestamps: false;
		translate: false;
		noContext: true;
		nThreads: 8;
		speedUp: true;
		yourself
]

{ #category : #api }
WhisperCpp >> transcribeMonoPCMF32: aCollection do: aBlock [

	working ifTrue: [self error: 'sending work too fast'].
	working := true.
	
	(context isNil or: [context isNull]) ifTrue: [context := self init: (self class ensureModel: 'tiny.en')].
	
	self fullThread: context params: self params samples: aCollection size: aCollection size.
	
	[
		[self fullThreadIsComplete] whileFalse: [10 milliSeconds wait].
		working := false.
		aBlock value: self currentString] fork
]

{ #category : #api }
WhisperCpp >> transcribeStereoPCMS16: data do: aBlock [

	| samples |
	samples := Float32Array new: data size / 4.
	0 to: data size / 4 - 1 do: [:index | | left right |
		left := data signedShortAt: index * 4 + 1.
		right := data signedShortAt: index * 4 + 3.
		samples at: index + 1 put: (left + right // 2) asFloat / (2 ** 16)].
	samples := self downsample: samples from: 44100 to: self whisperSampleRate.
	^ self transcribeMonoPCMF32: samples do: aBlock
]

{ #category : #utils }
WhisperCpp >> whisperSampleRate [

	^ 16000
]

{ #category : #utils }
WhisperCpp >> working [

	^ working
]
