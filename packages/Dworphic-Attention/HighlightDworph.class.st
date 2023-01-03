Class {
	#name : #HighlightDworph,
	#superclass : #GRComponent,
	#category : #'Dworphic-Attention'
}

{ #category : #'as yet unclassified' }
HighlightDworph >> render: props [

	| children gdChildren |
	
	children := props at: #children.
	gdChildren := self useState: nil.

	gdChildren get ifNotNil: [
		gdChildren get do: [:c | 
			((c grAsClass: #GDObject) getClass = 'MeshInstance') ifTrue: [
					| meshInst mat |
					meshInst := c grAsClass: #GDMeshInstance.
					mat := (meshInst mesh surfaceGetMaterialSurfIdx: 0) grAsClass: #GDSpatialMaterial.
					mat albedoColor: Color red.
					mat flagsNoDepthTest: true.
					mat flagsUnshaded: true.
					(meshInst mesh surfaceSetMaterialSurfIdx: 0 material: mat).
				]
			]
		].

	^ GDSpatial new name: 'ShowMeDworph'; 
		subscribeCall: #'get_children' with: #() do: [:c | gdChildren set: c];
		children: children
	
]
