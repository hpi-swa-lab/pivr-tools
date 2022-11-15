Class {
	#name : #HandTracking,
	#superclass : #GRComponent,
	#category : #'Dworphic-HandTracking'
}

{ #category : #'as yet unclassified' }
HandTracking class >> appDescription [
	<home>
	
	^ DworphicApplicationDescription new
		name: self name;
		render: [PinchtypeSuggestionPanel new. PinchtypeImage new. ];
		renderController: [TrackedHand new.]

	"^ super appDescription renderController: [TrackedHand new]"
]

{ #category : #'as yet unclassified' }
HandTracking >> render: props [

	^ nil
]
