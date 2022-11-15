Class {
	#name : #BCDController,
	#superclass : #GRComponent,
	#category : #'BCD-Tutorial'
}

{ #category : #'as yet unclassified' }
BCDController >> render: props [

	| areaRef position |
	areaRef := props at: #areaRef.
	position := self useState: Vector3 new.

	^ GRExternalEvents new 
		subscribeToMousePosition: [:mousePos | position set: ((GRRay forCamera: areaRef get point: mousePos) intersectPlane: 0 @ 0 @ 0 normal: 0 @ 1 @ 0)];
		children: {
			GDArea new ref: areaRef; translation: position get; children: (self cubeOfSize: 0.1 color: Color red)
		}
]
