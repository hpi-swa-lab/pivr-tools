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
TrackedHand >> fingerCharacterMapping [
	^ Dictionary newFromPairs: {
		'Littleleft'. 'a'.
		'Ringleft'. 's'.
		'Middleleft'. 'd'.
		'Indexleft'. 'f'.
		'Littleright'. 'o'.
		'Ringright'. 'l'.
		'Middleright'. 'k'.
		'Indexright'. 'j'.
	}
]

{ #category : #'as yet unclassified' }
TrackedHand >> node [
	^ GDMeshInstance new
				mesh: (GDCubeMesh new size: 0.01 asVector3)
]

{ #category : #'as yet unclassified' }
TrackedHand >> render: props [ 
	| finger rootRef tipRefs metacarpalPos proximalPos tipPos waitForRelease angle log |

	tipRefs := self
				useState: (Dictionary newFromPairs: {'Index'. self useGodotRef. 'Middle'. self useGodotRef. 'Ring'. self useGodotRef. 'Little'. self useGodotRef}).
	"log := self useLog."
	log := [:text | Transcript show: text].
	
	tipPos := self useState: (Vector3 zero).
	proximalPos := self useState: (Vector3 zero).
	metacarpalPos := self useState: (Vector3 zero).
	
	waitForRelease := self useState: false.
	angle := (tipPos get - proximalPos get) angleTo: (metacarpalPos get - proximalPos get).
	
	(angle < 1 and: waitForRelease get not and: angle < 1) ifTrue: [
		log value: ((props at: #side) = #left
						ifTrue: Character space
						ifFalse: Character linefeed).
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
										translation: 0 @ 0.01 @ 0; text: (self fingerCharacterMapping at: (name, (props at: #side)))}}}}}].
	rootRef := self useGodotRef.
	
	self useRegisterHandsSide: (props at: #side) ref: rootRef.
	
	^ GDSpatial new ref: rootRef;
		 children: {self node name: 'Wrist';
			 children: {(self methodAsComponent: #renderThumb:) log: log; tipRefs: tipRefs; side: (props at: #side). finger value: 'Index'. finger value: 'Middle'. finger value: 'Ring'. finger value: 'Little'}}
]

{ #category : #'as yet unclassified' }
TrackedHand >> renderThumb: props [
	^ props extract: [:log :tipRefs :side |
		self node name: 'ThumbMetacarpal';
				 children: {self node name: 'ThumbProximal';
					 children: {self node name: 'ThumbDistal';
						 children: {self node name: 'ThumbTip';
							 children: {self area
								onAreaEntered: [:other | (tipRefs get
										associationsSelect: [:asc | asc value get = other]) associations
										ifNotEmpty: [:list |
											 log
												value: (self fingerCharacterMapping at: list first key
															, side)]]}}}}
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
