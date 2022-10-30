Class {
	#name : #HandTracking,
	#superclass : #GRComponent,
	#category : #'Dworphic-HandTracking'
}

{ #category : #'as yet unclassified' }
HandTracking class >> appDescription [
	<home>

	^ super appDescription renderController: [TrackedHand new]
]

{ #category : #'as yet unclassified' }
HandTracking >> render: props [

	^ nil
]
