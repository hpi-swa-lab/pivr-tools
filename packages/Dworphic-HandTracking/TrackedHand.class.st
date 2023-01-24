Class {
	#name : #TrackedHand,
	#superclass : #GRComponent,
	#classVars : [
		'HandGripOnlyMode'
	],
	#category : #'Dworphic-HandTracking'
}

{ #category : #'as yet unclassified' }
TrackedHand class >> handsGripOnlyMode [
	<preference: 'Mark hands as in grip-only mode' category: 'GReaSe' description: 'When enabled, handtracking assumes that the hand is not fully tracked but only the degree of gripping the controller is.' type: #Boolean>

	^ HandGripOnlyMode ifNil: [false]
]

{ #category : #'as yet unclassified' }
TrackedHand class >> handsGripOnlyMode: aBoolean [
	
	HandGripOnlyMode := aBoolean
]

{ #category : #'as yet unclassified' }
TrackedHand >> area [
	^ self area: Color red ref: nil.
]

{ #category : #'as yet unclassified' }
TrackedHand >> area: aColor ref: aRef [
	^ GDArea new children: {self cubeOfSize: 0.015 color: aColor}; ref: aRef.
]

{ #category : #'as yet unclassified' }
TrackedHand >> fingerColorForName: name side: side isTyping: isTyping [
	^isTyping
		ifTrue: [ HandTracking fingerColor at: (self oldFingerCharacterMapping indexOf: (name, side)).] 
		ifFalse: [Color gray.]
]

{ #category : #'as yet unclassified' }
TrackedHand >> node [
	^ GDMeshInstance new
				mesh: (GDCubeMesh new size: 0.01 asVector3)
]

{ #category : #'as yet unclassified' }
TrackedHand >> oldFingerCharacterMapping [

	^ {
		'Littleleft'. 
		'Ringleft'.
		'Middleleft'.
		'Indexleft'. 
		'Indexright'.
		'Middleright'. 
		'Ringright'. 
		'Littleright'. 
	}
]

{ #category : #'as yet unclassified' }
TrackedHand >> render: props [ 
	| finger rootRef tipRefs metacarpalPos proximalPos tipPos waitForRelease angle log suggestions handRef eventReceivers onButtonPress transform currentWord replaceLog logIndices searchResults onButtonRelease focus scrollPos startPos |
	
	self useInitLogForSide: (props at: #side).
	handRef := self useRef: nil.
	eventReceivers := self useProvided: #eventReceivers.
	transform := self useState: Matrix4x4 new.
	startPos := self useState: Vector3 zero.
	onButtonPress := self useCallback: [:button | | event |
		event := GRInteractiveAreaEventButton new
			side: (props at: #side);
			transform: transform get;
			button: button;
			handRef: handRef get.
		eventReceivers get do: [:r | (r get at: #onButtonPress) cull: event]] dependencies: {}.
	onButtonRelease := self useCallback: [:button | | event |
		event := GRInteractiveAreaEventButton new
			side: (props at: #side);
			transform: transform get;
			button: button;
			handRef: handRef get.
		eventReceivers get do: [:r | (r get at: #onButtonRelease) cull: event]] dependencies: {}.
	self useRegisterHand: handRef.
	
	focus := (self useProvided: #textFocus) get.
	
	scrollPos := self useProvided: #scrollPos.
	
	suggestions := self useMemo: [FuzzySuggestions newFrom: FuzzySuggestions a1001CommonEnglishWordList] dependencies: #().
	
	tipRefs := self
				useState: (Dictionary newFromPairs: {'Index'. self useGodotRef. 'Middle'. self useGodotRef. 'Ring'. self useGodotRef. 'Little'. self useGodotRef}).
	
	 "log := [:message | currentWordRef get set: [:word | word, message]]."
	log := [:text | Transcript showln: text].
	"log := self useLog."
	logIndices := self useProvided: #logIndices.
	replaceLog := self replaceLog.
	
	
	currentWord := self useProvided: #currentWord.
	self useEffect: [(props at: #side) = 'left' ifTrue: [
			searchResults := suggestions search: currentWord get.
			log value: currentWord get.
			searchResults ifEmpty: [replaceLog value: (logIndices get at: #suggestions) value: ['No words found for this query']] ifNotEmpty: [replaceLog value: (logIndices get at: #suggestions) value: [(searchResults take: 10) asString]]].
			replaceLog value: (logIndices get at: #input) value: [currentWord get asString].
		.] dependencies: {currentWord get}.
	
	tipPos := self useState: Vector3 zero.
	proximalPos := self useState: Vector3 zero.
	metacarpalPos := self useState: Vector3 zero.
	waitForRelease := self useState: false.
	angle := self useMemo: [(tipPos get - proximalPos get) angleTo: (metacarpalPos get - proximalPos get)] dependencies: {proximalPos get. metacarpalPos get. tipPos get.}.
	"Transcript showln: (angle < 1 and: waitForRelease get not) asString, ' ', (angle < 1) asString, ' ', (waitForRelease get) asString."
	self useEffect: [

		(angle < 1 and: waitForRelease get not) ifTrue: [
			waitForRelease set: true.
			startPos set: metacarpalPos get.
			onButtonPress value: GDGlobalConstants joyVrTrigger.
			onButtonPress value: GDGlobalConstants joyVrGrip.
					log value: 'Suggestions recieved for input: ', currentWord get , 'are: ', (suggestions search: currentWord get) .
		focus notNone ifTrue: 	[focus textEnteredCallback get value: (((suggestions search: currentWord get) at: 1 ifAbsent: ''), ' ').].
		replaceLog value: (logIndices get at: #result) value: [:prev | prev , ' ' ,((suggestions search: currentWord get) at: 1 ifAbsent: '')].
		log value: 'resetting'.
		currentWord set: [:old | {}].].
		(angle > 2 and: waitForRelease get) ifTrue: [
			waitForRelease set: false.
			onButtonRelease value: GDGlobalConstants joyVrTrigger.
			onButtonRelease value: GDGlobalConstants joyVrGrip]] dependencies: {angle}.
	
	
	self useEffect: [(waitForRelease get) ifTrue: [
			((metacarpalPos get y - startPos get y) < 0.1) ifTrue: [scrollPos set: ((scrollPos get + 1) clampLow: 1 high: 13)]. 
			((metacarpalPos get y - startPos get y) > -0.1) ifTrue: [scrollPos set: ((scrollPos get - 1) clampLow: 1 high: 13)].
			]] dependencies: {metacarpalPos get}.
		
	finger := [:name | self node name: name , 'Metacarpal';
				subscribeTo: #'global_transform' do: [:pos | name = 'Middle' ifTrue: [metacarpalPos set: pos translation] ];
				 children: {self node name: name , 'Proximal';
					 subscribeTo: #'global_transform' do: [:pos | name = 'Middle' ifTrue: [proximalPos set: pos translation] ];
					 children: {self node name: name , 'Intermediate';
						 children: {self node name: name , 'Distal';
							 children: {self node name: name , 'Tip';
								subscribeTo: #'global_transform' do: [:pos | name = 'Middle' ifTrue: [tipPos set: pos translation] ];
								 children: {
											self area: (self fingerColorForName: name side: (props at: #side) isTyping: focus notNone)
									ref: (tipRefs get at: name).
									GDLabel3D new 
										billboard: GDSpatialMaterial billboardEnabled;
										noDepthTest: true;
										fixedSize: true;
										pixelSize: 0.005;
										translation: 0 @ 0.01 @ 0; text: (self oldFingerCharacterMapping indexOf: (name, (props at: #side)))}}}}}].
	rootRef := self useGodotRef.
	
	self useRegisterHandsSide: (props at: #side) ref: rootRef.
	
	^ GDSpatial new children: {
		GDSpatial new ref: rootRef; children: {
			self node
				ref: handRef;
				subscribeTo: #global_transform do: transform setter;
				name: 'Wrist';
				children: {
					GRActingArea new point: false; touch: true; handRef: handRef; children: (GDCollisionShape new shape: (GDSphereShape new radius: 5 cm)).
					GRPointer new handRef: handRef.
					(self methodAsComponent: #renderThumb:)
						log: log;
						tipRefs: tipRefs;
						proximalPos: proximalPos;
						side: (props at: #side).
					"((props at: #side) = 'right') ifTrue: [
						(self methodAsComponent: #renderRightIndex:)
							log: log;
							tipRefs: tipRefs;
							proximalPos: proximalPos;
							side: (props at: #side).	
					]; ifFalse: [finger value: 'Index'.]."
					finger value: 'Index'.
					finger value: 'Middle'.
					finger value: 'Ring'.
					finger value: 'Little'}}}
]

{ #category : #'as yet unclassified' }
TrackedHand >> renderRightIndex: props [

	|currentWord cooldown ref thumbRef |
	
	cooldown := self useState: TimeStamp now.

	currentWord := self useProvided: #currentWord.
	ref := self useGodotRef.
	thumbRef := self useProvided: #thumbRef.

	self useEffect: [(props at: #side) = 'right' ifTrue: [thumbRef set: ref].]	dependencies: #().

	^ props extract: [:log :tipRefs :side :proximalPos |
		
		self node name: 'IndexMetacarpal';
				 children: {self node name: 'IndexProximal';
					 children: {self node name: 'IndexDistal';
						 children: {self node name: 'IndexTip';
							 children: {
								self area
								ref: ref;
									onAreaExited: [:other | Transcript showln: 'Area exited'];
									onAreaEntered: [:other | Transcript showln: 'Area entered']
					}}}}
		].

]

{ #category : #'as yet unclassified' }
TrackedHand >> renderThumb: props [

	|currentWord cooldown ref thumbRef focus isTracked |
	
	cooldown := self useState: TimeStamp now.

	currentWord := self useProvided: #currentWord.
	ref := self useGodotRef.
	thumbRef := self useProvided: #thumbRef.
	focus := (self useProvided: #textFocus) get.
	isTracked := self useState: true.

	self useEffect: [(props at: #side) = 'right' ifTrue: [thumbRef set: ref].]	dependencies: #().
	
	^ props extract: [:log :tipRefs :side :proximalPos | | detector fingerBones |
		detector :=  GDArea new
			children: {self class handsGripOnlyMode ifTrue: [(self cubeOfSize: 0.1 @ 0.02 @ 0.02 color: Color gray) translation: 0 @ -0.03 @ -0.06] ifFalse: [self cubeOfSize: 0.015 color: Color gray]};
			ref: ref;
			subscribeTo: #'global_transform' do: [:pos | isTracked set: (pos = Vector3 zero) not];
			onAreaExited: [:other | focus notNone ifTrue: [ (((tipRefs get
					associationsSelect: [:asc | asc value get = other]) associations
					isEmpty not) or: (other = thumbRef get get)) ifTrue: [ cooldown set: TimeStamp now.]]
					];
			onAreaEntered: [:other | 
				isTracked get  ifTrue: [
				focus notNone ifTrue: [
					((TimeStamp now - cooldown get > (Duration milliSeconds: 100)) and: (proximalPos get = Vector3 zero) not)
						ifTrue: [
							(other = thumbRef get get ) ifTrue: [
								currentWord get ifNotEmpty: [currentWord set: [:c | c allButLast]].].
				(tipRefs get
					associationsSelect: [:asc | asc value get = other]) associations
					ifNotEmpty: [:list |
						|inputString |
						 inputString :=  list first key, side.
						currentWord set: [:c | c copyWith: (self oldFingerCharacterMapping indexOf: inputString)].]]].
					].
			].
		
		fingerBones := self node name: 'ThumbMetacarpal';
			 children: {self node name: 'ThumbProximal';
				 children: {self node name: 'ThumbDistal';
					 children: {self node name: 'ThumbTip';
						 children: {self class handsGripOnlyMode ifTrue: [nil] ifFalse: [detector]}}}}.
		
		self class handsGripOnlyMode ifTrue: [{fingerBones. detector}] ifFalse: [fingerBones]]
]

{ #category : #'as yet unclassified' }
TrackedHand >> useInitLogForSide: side [
| log logIndices|
log := self useLog.
logIndices := self useProvided: #logIndices.
	self useEffect: [
			| inputIIndex resultIndex suggestionsIndex |
	side = #left ifTrue: [
		logIndices get at: #suggestions ifAbsent: [
			suggestionsIndex := (log value: 'Start typing to see suggestions here') value.
	inputIIndex := (log value: 'Start typing to see your input here') value.	
	resultIndex := (log value: '') value.
	logIndices set: {#suggestions -> suggestionsIndex. #input -> inputIIndex. #result -> resultIndex} asDictionary.]]
	] dependencies: #().
	 
]

{ #category : #'as yet unclassified' }
TrackedHand >> useRegisterHandsSide: side ref: rootRef [
	^ self
		useEffect: [rootRef get
				setScript: (GRReactCurrentSession value loadResource: 'res://addons/godot-openxr/config/OpenXRHand.gdns').
			GRReactCurrentSession value
				callOn: rootRef get
				method: 'set_hand'
				arguments: {side
							= #left
						ifTrue: [0]
						ifFalse: [1]}.
			GRReactCurrentSession value
				callOn: rootRef get
				method: '_ready'
				arguments: {}.
			rootRef get setPhysicsProcessEnable: true]
		dependencies: {}.
]
