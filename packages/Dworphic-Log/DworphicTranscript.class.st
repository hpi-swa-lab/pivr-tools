Class {
	#name : #DworphicTranscript,
	#superclass : #Object,
	#instVars : [
		'lines',
		'lineBufferSize'
	],
	#category : #'Dworphic-Log'
}

{ #category : #'as yet unclassified' }
DworphicTranscript >> cleanup [

	Transcript removeDependent: self
]

{ #category : #'as yet unclassified' }
DworphicTranscript >> initialize [

	Transcript addDependent: self.
	lines := OrderedCollection with: ''.
]

{ #category : #'as yet unclassified' }
DworphicTranscript >> lineBufferSize [

	^ lineBufferSize ifNil: [20]
]

{ #category : #'as yet unclassified' }
DworphicTranscript >> lineBufferSize: aNumber [

	lineBufferSize := aNumber.
	self shrinkLines
]

{ #category : #'as yet unclassified' }
DworphicTranscript >> lines [

	^ lines
]

{ #category : #'as yet unclassified' }
DworphicTranscript >> shrinkLines [

	self lineBufferSize < lines size ifTrue: [lines := lines last: self lineBufferSize]
]

{ #category : #'as yet unclassified' }
DworphicTranscript >> update: anUpdate [

	| newLines |
	newLines := Transcript contents splitBy: String cr.
	lines first addAll: newLines first.
	lines addAll: newLines allButFirst.
	self shrinkLines
]
