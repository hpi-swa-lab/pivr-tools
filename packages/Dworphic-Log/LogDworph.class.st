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
	^ GRGrabbableArea new translation: (0 @ 1 @ 0); children: {
		GDLabel3D new
			pixelSize: 0.002;
			width: 300;
			autowrap: true;
			doubleSided: false;
			 text: ((entries get last: (20 min: entries get size)) joinSeparatedBy: String crlf); horizontalAlignment: GDGlobalConstants halignLeft; verticalAlignment: GDGlobalConstants valignBottom.
		(self cubeOfSize: (0.6@1@0.01) color: (Color gray)) translation: (0.3 @ 0.5 @ -0.006).
	}.
]
