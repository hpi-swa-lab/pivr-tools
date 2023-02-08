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
		ifTrue: [ HandTracking fingerColor at: (self fingerIndexOf: (name, side)).] 
		ifFalse: [Color gray.]
]

{ #category : #'as yet unclassified' }
TrackedHand >> fingerIndexOf: aFingerName [

	^ {
		'Littleleft'. 
		'Ringleft'.
		'Middleleft'.
		'Indexleft'. 
		'Indexright'.
		'Middleright'. 
		'Ringright'. 
		'Littleright'. 
	} indexOf: aFingerName
]

{ #category : #'as yet unclassified' }
TrackedHand >> node [
	^ GDMeshInstance new
				mesh: (GDCubeMesh new size: 0.01 asVector3)
]

{ #category : #'as yet unclassified' }
TrackedHand >> pinchCooldown [
	^ Duration milliSeconds: 100
]

{ #category : #'as yet unclassified' }
TrackedHand >> render: props [ 
	| finger rootRef tipRefs metacarpalPos proximalPos tipPos areFistsClosed angle suggestions handRef eventReceivers onButtonPress transform currentWord onButtonRelease focus scrollPos startPos cooldown suggestionEntries allFingerRefs isFistClosed |
	
	handRef := self useRef: nil.
	eventReceivers := self useProvided: #eventReceivers.
	transform := self useState: Matrix4x4 new.
	startPos := self useState: Vector3 zero.

	"Set the registered hand here ans pass all relevant informations for hand tracking to handRef."
	self useRegisterHand: handRef.
	
	focus := (self useProvided: #textFocus) get.
	
	scrollPos := self useProvided: #scrollPos.
	suggestions := self useMemo: [FuzzySuggestions newFrom: FuzzySuggestions a1001CommonEnglishWordList] dependencies: #().
	
	tipRefs := self
				useState: (Dictionary newFromPairs: {'Index'. self useGodotRef. 'Middle'. self useGodotRef. 'Ring'. self useGodotRef. 'Little'. self useGodotRef}).
	cooldown := self useState: 0.
	
	allFingerRefs := self useProvided: #allFingerRefs.
	self useEffect: [allFingerRefs set: [:old | old, tipRefs get values] ] dependencies: #().
	
	currentWord := self useProvided: #currentWord.
	suggestionEntries := self useProvided: #suggestionEntries.

	tipPos := self useState: Vector3 zero.
	proximalPos := self useState: Vector3 zero.
	metacarpalPos := self useState: Vector3 zero.
	areFistsClosed := self useProvided: #areFistsClosed.
	self useEffect: [areFistsClosed set: [:d | d copyAt: (props at: #side) put: false].] dependencies: #().
	isFistClosed := self useMemo: [areFistsClosed get at: (props at: #side) ifAbsent: [false].] dependencies: {areFistsClosed get}.
	angle := self useMemo: [(tipPos get - proximalPos get) angleTo: (metacarpalPos get - proximalPos get)] dependencies: {proximalPos get. metacarpalPos get. tipPos get.}.
	
	"Setup emulated button presses through handtracking gestures."
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
	
	"On closed fist set the starting position for suggestion panel scrolling and trigger the grabbing.
	On released fist set release grip well as enter the current selected word from the suggestion panel."
	self useEffect: [

		(angle < 1 and: isFistClosed not) ifTrue: [
			areFistsClosed set: [:d | d copyAt: (props at: #side) put: true].
			startPos set: metacarpalPos get.
			onButtonPress value: GDGlobalConstants joyVrGrip.
		].
		(angle > 2 and: isFistClosed) ifTrue: [
			areFistsClosed set: [:d | d copyAt: (props at: #side) put: false].
			focus notNone ifTrue: 	[focus textEnteredCallback get value: (((suggestions search: currentWord get) at: scrollPos get ifAbsent: ''), ' ').].
			onButtonRelease value: GDGlobalConstants joyVrGrip.
			currentWord set: [:old | {}].]] dependencies: {angle}.
	
	"On closed fist scroll through the menu with a deadzone of 10cm and a scrolling speed min 500ms per scroll and max instant jumping to top or bottom."
	self useEffect: [
		| deltaY duration |
		deltaY := metacarpalPos get y - startPos get y.
		duration := (50.0 / ((deltaY abs) max: 0.1)) clampLow: 0 high: 500.
		((isFistClosed) and: (TimeStamp now - cooldown get > (Duration milliSeconds: duration))) ifTrue: [
			(deltaY < 0.05) ifTrue: [scrollPos set: ((scrollPos get + 1) clampLow: 1 high: (suggestionEntries get size))]. 
			(deltaY > -0.05) ifTrue: [scrollPos set: ((scrollPos get - 1) clampLow: 1 high: (suggestionEntries get size))].
		cooldown set: TimeStamp now.
		]] dependencies: {metacarpalPos get}.
	
	"On a new text entry (triggered by change of currentWord) reset scrolling list of suggestion panel to first element and search for new entries based on current input. Limit to 15 entries max."
	self useEffect: [
		| sugg |
		scrollPos set: 1.
		sugg := suggestions search: currentWord get.
		suggestionEntries set: ((sugg) first: (sugg size min: 15))] dependencies: {currentWord get}.
		
	"Per finger mapping including setup of middle finger metacarpal, proximal and tip for fist closing detection as well as coloring of finger tips."
	finger := [:name | self node name: name , 'Metacarpal';
				subscribeTo: #'global_transform' do: [:pos | name = 'Middle' ifTrue: [metacarpalPos set: pos translation] ];
				 children: {self node name: name , 'Proximal';
					 subscribeTo: #'global_transform' do: [:pos | name = 'Middle' ifTrue: [proximalPos set: pos translation] ];
					 children: {self node name: name , 'Intermediate';
						 children: {self node name: name , 'Distal';
							 children: {self node name: name , 'Tip';
								subscribeTo: #'global_transform' do: [:pos | name = 'Middle' ifTrue: [tipPos set: pos translation.] ];
								 children: {
											self area: (self fingerColorForName: name side: (props at: #side) isTyping: focus notNone)
									ref: (tipRefs get at: name).}}}}}].
	rootRef := self useGodotRef.
	
	"Loads the OpenXR Hand from handtracking and registers for side."
	self useRegisterHandsSide: (props at: #side) ref: rootRef.
	
	"Setup handtracking with hand collision as well as widgets including WristMenu and TrackedHand>>closedFistStartPoint:"
	^ {(GDSpatial new ref: rootRef; children: {
		self node
			ref: handRef;
			subscribeTo: #global_transform do: transform setter;
			name: 'Wrist';
			children: {
				WristMenu new onButtonPress: onButtonPress; onButtonRelease: onButtonRelease; pos: tipPos get.		
				GRActingArea new point: false; touch: true; handRef: handRef; children: (GDCollisionShape new shape: (GDSphereShape new radius: 5 cm)).
				GRPointer new handRef: handRef.
				(self methodAsComponent: #renderThumb:)
					tipRefs: tipRefs;
					onButtonRelease: onButtonRelease;
					onButtonPress: onButtonPress;
					side: (props at: #side).
				finger value: 'Index'.
				finger value: 'Middle'.
				finger value: 'Ring'.
				finger value: 'Little'.
				}}).
				(self methodAsComponent: #renderClosedFistStartPoint:)
					isFistClosed: isFistClosed;
					focus: focus;
					startPos: startPos get.
		}
]

{ #category : #'as yet unclassified' }
TrackedHand >> renderClosedFistStartPoint: props [
	"Helps users find out where they need to move their hand to change the scroll direction"
	^ props extract: [ :isFistClosed :startPos :focus |
		(isFistClosed and: focus notNone) ifTrue: [
					GDMeshInstance new mesh: (GDSphereMesh new
					radius: 1cm;
					height: 2cm;
					material: (GDSpatialMaterial new
						albedoColor: Color red darker;
						flagsUnshaded: true));
					translation: startPos
				]].
]

{ #category : #'as yet unclassified' }
TrackedHand >> renderThumb: props [
	"Renders the thumb of one hand. The thumb tip is used to detect pinch gestures (touch with other fingerstips).
	If a textbox is selected, a character will be selected via pinchtype. If no textbox is selected, a trigger event is generated on pinch."
	|currentWord lastPinchExited ref thumbRef isTracked currentChar areFistsClosed isAnyFistClosed isTyping|
	
	lastPinchExited := self useState: TimeStamp now.

	currentWord := self useProvided: #currentWord.
	ref := self useGodotRef.
	thumbRef := self useProvided: #thumbRef.
	isTyping := (self useProvided: #textFocus) get notNone.
	currentChar := self useProvided: #currentCharGroup.
	areFistsClosed := self useProvided: #areFistsClosed.
	isAnyFistClosed := self useMemo: [areFistsClosed get values anySatisfy: [:a | a].] dependencies: {areFistsClosed get}.
	isTracked := self useState: true.

	self useEffect: [(props at: #side) = 'right' ifTrue: [thumbRef set: ref].]	dependencies: #().
	
	^ props extract: [ :tipRefs :side :onButtonPress :onButtonRelease | | detector pinchedFinger |
		pinchedFinger := [: other | 
				(tipRefs get
					associationsSelect: [:asc | asc value get = other]) keys at: 1 ifAbsent: [nil]].
		detector :=  GDArea new
			children: {
				self class handsGripOnlyMode 
					ifTrue: [(self cubeOfSize: 0.1 @ 0.02 @ 0.02 color: Color gray) 
						translation: 0 @ -0.03 @- 0.06] 
					ifFalse: [self cubeOfSize: 0.015 color: Color gray]
					};
			ref: ref;
			subscribeTo: #'global_transform' do: [:pos | isTracked set: (pos = Vector3 zero) not];
			onAreaExited: [:other |  ((pinchedFinger value: other) notNil or: (other = thumbRef get get)) 
					ifTrue: [ 
						lastPinchExited set: TimeStamp now.
						isTyping
							ifTrue: [currentChar set: nil.]
							ifFalse: [onButtonRelease value: GDGlobalConstants joyVrTrigger.]]
				];
			onAreaEntered: [:other |
				(isTracked get and: (TimeStamp now - lastPinchExited get > self pinchCooldown))
					ifTrue: [
						"Backspace if thumbs were touched."
						(other = thumbRef get get ) 
							ifTrue: [ currentWord get ifNotEmpty: [currentWord set: [:c | c allButLast]].].
						(pinchedFinger value: other) ifNotNil: [: otherFingerName | 
							isTyping 
								ifFalse: [onButtonPress value: GDGlobalConstants joyVrTrigger.]
								ifTrue: [
									| fingerIndex |
									fingerIndex := self fingerIndexOf: otherFingerName, side.
									"Don't allow typing while the user is selecting a result"
									isAnyFistClosed ifFalse: [
										currentChar set: fingerIndex.
										currentWord set: [:c | c copyWith: fingerIndex].
								].
							].
						].
					].
				].
				{
					self node name: 'ThumbMetacarpal';
					 children: {self node name: 'ThumbProximal';
						 children: {self node name: 'ThumbDistal';
							 children: {self node name: 'ThumbTip';
								 children: {self class handsGripOnlyMode ifFalse: [detector]}}}}.
					self class handsGripOnlyMode ifTrue: [detector].
				}.
		]
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
