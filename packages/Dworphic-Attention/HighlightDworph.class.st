Class {
	#name : #HighlightDworph,
	#superclass : #GRComponent,
	#category : #'Dworphic-Attention'
}

{ #category : #'as yet unclassified' }
HighlightDworph class >> highlightBeam [

	^ 1
]

{ #category : #'as yet unclassified' }
HighlightDworph class >> highlightOutline [

	^ 2
]

{ #category : #'as yet unclassified' }
HighlightDworph class >> highlightSurface [

	^ 3
]

{ #category : #'as yet unclassified' }
HighlightDworph >> render: props [

	| children active gdChildren highlightMaterial highlightMode outlineMaterial |
	
	children := props at: #children.
	active := props at: #active ifAbsent: true.
	highlightMode := props at: #mode ifAbsent: HighlightDworph highlightSurface.
	gdChildren := self useState: nil.
	highlightMaterial := self useMemo: [GDResourceLoader instance loadPath: 'res://assets/attention-direction/highlight_material.tres'] dependencies: #().
	outlineMaterial := self useMemo: [GDResourceLoader instance loadPath: 'res://assets/attention-direction/outline_material.tres'] dependencies: #().

	gdChildren get ifNotNil: [
		gdChildren get do: [:c | 
			((c grAsClass: #GDObject) getClass = 'MeshInstance') ifTrue: [
					| meshInst mat oldMat |
					meshInst := c grAsClass: #GDMeshInstance.
					
					meshInst materialOverride: nil.
					oldMat := meshInst mesh surfaceGetMaterialSurfIdx: 0.
					oldMat nextPass: nil.
					highlightMode caseOf: {
					[HighlightDworph highlightSurface] -> [
						mat := active ifTrue: highlightMaterial ifFalse: nil.
						meshInst materialOverride: mat.].
					[HighlightDworph highlightOutline] -> [
						mat := active ifTrue: outlineMaterial ifFalse: nil.
						oldMat nextPass: mat.
					].
					[HighlightDworph highlightBeam] -> [
						"Not implemented here for technical reasons"
					]
					}
				]
			]
		].

	^ GDSpatial new name: 'HighlightDworph'; 
		subscribeCall: #'get_children' with: #() do: [:c | gdChildren set: c];
		children: {children. (highlightMode = HighlightDworph highlightBeam) ifTrue: self showMe}
	
]
