Class {
	#name : #TrackedHand,
	#superclass : #GRComponent,
	#category : #'Dworphic-HandTracking'
}

{ #category : #'as yet unclassified' }
TrackedHand >> render: props [

	| node finger rootRef |
	node := [GDMeshInstance new mesh: (GDCubeMesh new size: 0.01 asVector3)].
	finger := [:name |
		node value
			name: name, 'Metacarpal';
			children: (node value
				name: name, 'Proximal';
				children: (node value
					name: name, 'Intermediate';
					children: (node value
						name: name, 'Distal';
						children: (node value name: name, 'Tip'))))].
	rootRef := self useGodotRef.
	self
		useEffect: [
			rootRef get setScript: (GRReactCurrentSession value loadResource: 'res://addons/godot-openxr/config/OpenXRHand.gdns').
			GRReactCurrentSession value
				callOn: rootRef get
				method: 'set_hand'
				arguments: {(props at: #side) = #left ifTrue: [0] ifFalse: [1]}.
			GRReactCurrentSession value
				callOn: rootRef get
				method: '_ready'
				arguments: {}.
			rootRef get setPhysicsProcessEnable: true]
		dependencies: {}.
	^ GDSpatial new
		ref: rootRef;
		children: {
			node value
				name: 'Wrist';
				children: {
					node value
						name: 'ThumbMetacarpal';
						children: (node value
							name: 'ThumbProximal';
							children: (node value
								name: 'ThumbDistal';
								children: (node value name: 'ThumbTip'))).
					finger value: 'Index'.
					finger value: 'Middle'.
					finger value: 'Ring'.
					finger value: 'Little'}}
]
