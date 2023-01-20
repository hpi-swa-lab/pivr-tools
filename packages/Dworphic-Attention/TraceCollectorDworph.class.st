Class {
	#name : #TraceCollectorDworph,
	#superclass : #GRComponent,
	#category : #'Dworphic-Attention'
}

{ #category : #'as yet unclassified' }
TraceCollectorDworph >> render: props [

	| traces child lastCollection |
	
	traces := self useTraces.
	child := props at: #child.
	lastCollection := self useState: Time millisecondClockValue.
		
	^ GDSpatial new
		subscribeTo: #'global_translation' do: [:translation | (Time millisecondsSince: lastCollection get) > 100 ifTrue: [traces value: translation. lastCollection set: Time millisecondClockValue]];
		children: {
			child.
		}
]
