Class {
	#name : #HandTracking,
	#superclass : #GRComponent,
	#category : #'Dworphic-HandTracking'
}

{ #category : #'as yet unclassified' }
HandTracking class >> appDescription [
	<home>
	
	"^ DworphicApplicationDescription new
		name: self name;
		render: [];
		renderController: [TrackedHand new.]"

	^ super appDescription renderController: [TrackedHand new].
]

{ #category : #'as yet unclassified' }
HandTracking >> render: props [

	^nil.
		"| inputIIndex log resultIndex suggestionsIndex logIndices |
	log := self useLog.
	suggestionsIndex := (log value: 'Start typing to see suggestions here') value.
	inputIIndex := (log value: 'Start typing to see your input here') value.	
	resultIndex := (log value: '') value.
	
	logIndices := self useProvided: #logIndices.
	logIndices set: {#suggestions -> suggestionsIndex. #input -> inputIIndex. #result -> resultIndex} asDictionary.
	
	^ nil."
]
