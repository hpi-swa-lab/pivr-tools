Class {
	#name : #TrackedHand,
	#superclass : #GRComponent,
	#category : #'Dworphic-HandTracking'
}

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
TrackedHand >> render: props [ 
	| node finger rootRef area tipRefs |
	node := [GDMeshInstance new].
	area := [GDArea new children: {self cubeOfSize: 0.01 color: Color red}].
	tipRefs := self
				useState: (Dictionary newFromPairs: {'Index'. self useGodotRef. 'Middle'. self useGodotRef. 'Ring'. self useGodotRef. 'Little'. self useGodotRef}).
	finger := [:name | node value name: name , 'Metacarpal';
				 children: {node value name: name , 'Proximal';
					 children: {node value name: name , 'Intermediate';
						 children: {node value name: name , 'Distal';
							 children: {node value name: name , 'Tip';
								 children: {area value
									ref: (tipRefs get at: name)}}}}}].
	rootRef := self useGodotRef.
	self
		useEffect: [rootRef get
				setScript: (GRReactCurrentSession value loadResource: 'res://addons/godot-openxr/config/OpenXRHand.gdns').
			GRReactCurrentSession value
				callOn: rootRef get
				method: 'set_hand'
				arguments: {(props at: #side)
							= #left
						ifTrue: [0]
						ifFalse: [1]}.
			GRReactCurrentSession value
				callOn: rootRef get
				method: '_ready'
				arguments: {}.
			rootRef get setPhysicsProcessEnable: true]
		dependencies: {}.
	^ GDSpatial new ref: rootRef;
		 children: {node value name: 'Wrist';
			 children: {area value. node value name: 'ThumbMetacarpal';
				 children: {area value. node value name: 'ThumbProximal';
					 children: {area value. node value name: 'ThumbDistal';
						 children: {area value. node value name: 'ThumbTip';
							 children: {GDArea new children: {self cubeOfSize: 0.01 color: Color red};
								
								onAreaEntered: [:other | (tipRefs get
										associationsSelect: [:asc | asc value get = other]) associations
										ifNotEmpty: [:list | Transcript
												show: (self fingerCharacterMapping at: list first key
															, (props at: #side))]]}}}}. finger value: 'Index'. finger value: 'Middle'. finger value: 'Ring'. finger value: 'Little'}}
]
