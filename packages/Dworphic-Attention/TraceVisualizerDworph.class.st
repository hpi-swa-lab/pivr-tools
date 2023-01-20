Class {
	#name : #TraceVisualizerDworph,
	#superclass : #GRComponent,
	#category : #'Dworphic-Attention'
}

{ #category : #'as yet unclassified' }
TraceVisualizerDworph class >> appDescription [
	<home>

	^ super appDescription
]

{ #category : #'as yet unclassified' }
TraceVisualizerDworph >> render: props [

	| traces world |
	
	traces := self useProvided: #traces.
	world := self useWorldPortal.
	^ traces get collect: [:trace | CMFReactNodePortal child: ((self cubeVisualOfSize: 0.1 color: Color gray) globalTranslation: trace) in: world].
]
