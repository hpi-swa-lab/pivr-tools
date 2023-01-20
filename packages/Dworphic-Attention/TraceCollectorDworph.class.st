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

	| traces child lastTranslation |
	
	traces := self useTraces.
	child := props at: #child.
	lastTranslation := self useState: Vector3 new.
		
	^ GDSpatial new
		subscribeTo: #'global_translation' do: [:translation | ((lastTranslation get distanceTo: translation) > TraceCollectorDworph traceDistanceThreshold) ifTrue: [traces value: {child godotId. translation}. lastTranslation set: translation]];
		children: {
			child.
		}
]
