Class {
	#name : #FRCROTHController,
	#superclass : #GRComponent,
	#category : #'FRCROTH-Tutorial'
}

{ #category : #'as yet unclassified' }
FRCROTHController >> render: props [

	| areaRef position |
		position := self useState: Vector3 new.
		areaRef := props at: #areaRef.

	^ GRExternalEvents new 
		subscribeToMousePosition: [:mousePosition | position set: ((GRRay forCamera: areaRef get point: mousePosition) intersectPlane: 0 @ 0@ 0 normal: 0@ 1 @ 0)];
		 children: {
		GDArea new ref: areaRef; translation:  position get; children: {self cubeOfSize: 0.05	 color: Color red}
		}
]
