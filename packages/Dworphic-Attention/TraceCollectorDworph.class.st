Class {
	#name : #TraceCollectorDworph,
	#superclass : #GRComponent,
	#category : #'Dworphic-Attention'
}

{ #category : #'as yet unclassified' }
TraceCollectorDworph >> render: props [

	| traces child |
	
	traces := self useTraces.
	child := props at: #child.
	
	^ GDSpatial new
		subscribeTo: #'global_translation' do: [:translation | traces value: translation];
		children: {
			child.
		}
]
