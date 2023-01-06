Class {
	#name : #HighlightDworph,
	#superclass : #GRComponent,
	#category : #'Dworphic-Attention'
}

{ #category : #'as yet unclassified' }
HighlightDworph >> render: props [

	| children active gdChildren highlightMaterial |
	
	children := props at: #children.
	active := props at: #active ifAbsent: true.
	gdChildren := self useState: nil.
	highlightMaterial := self useMemo: [GDResourceLoader instance loadPath: 'res://assets/attention-direction/highlight_material.tres'] dependencies: #().

	gdChildren get ifNotNil: [
		gdChildren get do: [:c | 
			((c grAsClass: #GDObject) getClass = 'MeshInstance') ifTrue: [
					| meshInst mat |
					meshInst := c grAsClass: #GDMeshInstance.
					mat := active ifTrue: highlightMaterial ifFalse: nil.
					meshInst materialOverride: mat.
				]
			]
		].

	^ GDSpatial new name: 'HighlightDworph'; 
		subscribeCall: #'get_children' with: #() do: [:c | gdChildren set: c];
		children: children
	
]
