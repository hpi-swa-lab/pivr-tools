Class {
	#name : #HighlightDworph,
	#superclass : #GRComponent,
	#category : #'Dworphic-Attention'
}

{ #category : #'as yet unclassified' }
HighlightDworph >> render: props [

	| children gdChildren highlightMaterial |
	
	children := props at: #children.
	gdChildren := self useState: nil.
	highlightMaterial := self useMemo: [GDResourceLoader instance loadPath: 'res://assets/attention-direction/highlight_material.tres'] dependencies: #().

	gdChildren get ifNotNil: [
		gdChildren get do: [:c | 
			((c grAsClass: #GDObject) getClass = 'MeshInstance') ifTrue: [
					| meshInst |
					meshInst := c grAsClass: #GDMeshInstance.
					(meshInst mesh surfaceSetMaterialSurfIdx: 0 material: highlightMaterial).
				]
			]
		].

	^ GDSpatial new name: 'HighlightDworph'; 
		subscribeCall: #'get_children' with: #() do: [:c | gdChildren set: c];
		children: children
	
]
