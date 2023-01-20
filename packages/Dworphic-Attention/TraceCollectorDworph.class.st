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
	lastCollection := self useState: Time now.
		
	^ GDSpatial new
		subscribeTo: #'global_translation' do: [:translation | (Time millisecondsSince: lastCollection get) > 500 ifTrue: [traces value: translation. lastCollection set: Time now]];
		children: {
			child.
		}
]
