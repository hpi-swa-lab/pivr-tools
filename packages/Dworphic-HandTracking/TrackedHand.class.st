Class {
	#name : #TrackedHand,
	#superclass : #GRComponent,
	#category : #'Dworphic-HandTracking'
}

{ #category : #'as yet unclassified' }
TrackedHand >> area [
	^ GDArea new children: {self cubeOfSize: 0.011 color: Color red}
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
		'Littleright'. 
		'Ringright'. 
		'Middleright'. 
		'Indexright'.
	}
]

{ #category : #'as yet unclassified' }
TrackedHand >> render: props [ 
	| finger rootRef tipRefs metacarpalPos proximalPos tipPos waitForRelease angle log currentWord suggestions |
	
	suggestions := self useMemo: (FuzzySuggestions newFrom: Symbol allSymbols) dependencies: #().
	currentWord := self useState: {}.
	tipRefs := self
				useState: (Dictionary newFromPairs: {'Index'. self useGodotRef. 'Middle'. self useGodotRef. 'Ring'. self useGodotRef. 'Little'. self useGodotRef}).
	
	 "log := [:message | currentWordRef get set: [:word | word, message]]."
	log := [:text | Transcript showln: text].
	"log := self useLog."
	
	tipPos := self useState: Vector3 zero.
	proximalPos := self useState: Vector3 zero.
	metacarpalPos := self useState: Vector3 zero.
	
	waitForRelease := self useState: false.
	angle := (tipPos get - proximalPos get) angleTo: (metacarpalPos get - proximalPos get).
	
	(angle < 1 and: waitForRelease get not and: angle < 1) ifTrue: [
		log value: 'Suggestions recieved for input: ', (suggestions search: currentWord get) .
		currentWord set: {}.
		waitForRelease set: true.
		] .
	(angle > 2 and: waitForRelease get) ifTrue: [
		waitForRelease set: false.
		].
		
	finger := [:name | self node name: name , 'Metacarpal';
				subscribeTo: #'global_transform' do: [:pos | name = 'Middle' ifTrue: [metacarpalPos set: pos translation] ];
				 children: {self node name: name , 'Proximal';
					 subscribeTo: #'global_transform' do: [:pos | name = 'Middle' ifTrue: [proximalPos set: pos translation] ];
					 children: {self node name: name , 'Intermediate';
						 children: {self node name: name , 'Distal';
							 children: {self node name: name , 'Tip';
								subscribeTo: #'global_transform' do: [:pos | name = 'Middle' ifTrue: [tipPos set: pos translation] ];
								 children: {
											self area
									ref: (tipRefs get at: name).
									GDLabel3D new 
										billboard: GDSpatialMaterial billboardEnabled;
										noDepthTest: true;
										fixedSize: true;
										pixelSize: 0.005;
										translation: 0 @ 0.01 @ 0; text: (self oldFingerCharacterMapping indexOf: (name, (props at: #side)))}}}}}].
	rootRef := self useGodotRef.
	
	self useRegisterHandsSide: (props at: #side) ref: rootRef.
	
	^ GDSpatial new ref: rootRef;
		 children: {self node name: 'Wrist';
			 children: {(self methodAsComponent: #renderThumb:) log: log; tipRefs: tipRefs; side: (props at: #side); currentWord: currentWord. finger value: 'Index'. finger value: 'Middle'. finger value: 'Ring'. finger value: 'Little'}}
]

{ #category : #'as yet unclassified' }
TrackedHand >> renderThumb: props [

	^ props extract: [:log :tipRefs :side :currentWord |
		self node name: 'ThumbMetacarpal';
				 children: {self node name: 'ThumbProximal';
					 children: {self node name: 'ThumbDistal';
						 children: {self node name: 'ThumbTip';
							 children: {self area
								onAreaEntered: [:other | (tipRefs get
										associationsSelect: [:asc | asc value get = other]) associations
										ifNotEmpty: [:list |
											|inputString|
											 inputString :=  list first key, side.
											log value: ('Detected input ', inputString).
											currentWord set: (currentWord copyWith: (self oldFingerCharacterMapping indexOf: inputString)).]]}}}}
		].

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
