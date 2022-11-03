Class {
	#name : #LogDworph,
	#superclass : #GRComponent,
	#category : #'Dworphic-Log'
}

{ #category : #'as yet unclassified' }
LogDworph class >> appDescription [
	<home>

	^ super appDescription
]

{ #category : #'as yet unclassified' }
LogDworph >> render: props [

	| entries |
	entries := self useProvided: #logEntries.
	^ GRGrabbableArea new children: {
		GDLabel3D new text: (entries get joinSeparatedBy: String crlf); horizontalAlignment: GDGlobalConstants halignLeft; verticalAlignment: GDGlobalConstants valignBottom.
		(self cubeOfSize: (0.1@0.1@0.1) color: (Color red)).
	}.
]
