Class {
	#name : #TOBEController,
	#superclass : #GRComponent,
	#category : #'TOBE-Tutorial'
}

{ #category : #'as yet unclassified' }
TOBEController >> render: props [

	| areaRef position |
	position := self useState: Vector3 new.
	areaRef := props at: #areaRef.
	
	^ GRExternalEvents new
		subscribeToMousePosition: [:mousePos |
			position set: ((GRRay forCamera: areaRef get point: mousePos) intersectPlane: 0 @ 0 @ 0 normal: 0 @ 1 @ 0)];
		children: {
			GDArea new ref: areaRef; translation: position get; children: (self cubeOfSize: 0.05 color: Color red)}
]
