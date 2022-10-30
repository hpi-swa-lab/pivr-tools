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
	^ GDLabel3D new text: (entries get joinSeparatedBy: String cr)
]
