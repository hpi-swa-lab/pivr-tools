Class {
	#name : #TraceCollectorDworph,
	#superclass : #GRComponent,
	#category : #'Dworphic-Attention'
}

{ #category : #'as yet unclassified' }
TraceCollectorDworph class >> traceDistanceThreshold [

	^ 1
]

{ #category : #'as yet unclassified' }
TraceCollectorDworph >> render: props [

	| traces child lastTranslation ref |
	
	traces := self useTraces.
	child := props at: #child.
	ref := self useGodotRef.
	child ref: ref.
	lastTranslation := self useState: Vector3 new.
		
	child subscribeTo: #'global_translation' do:
			[:translation | ((lastTranslation get distanceTo: translation) > TraceCollectorDworph traceDistanceThreshold) ifTrue: [traces value: {ref get. translation}. lastTranslation set: translation]].
		
	^ child
]
