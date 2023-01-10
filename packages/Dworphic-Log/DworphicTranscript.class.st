Class {
	#name : #DworphicTranscript,
	#superclass : #Object,
	#instVars : [
		'lineBufferSize',
		'lines'
	],
	#category : #'Dworphic-Log'
}

{ #category : #'as yet unclassified' }
DworphicTranscript >> cleanup [

	Transcript removeDependent: self
]

{ #category : #'as yet unclassified' }
DworphicTranscript >> initialize [

	lines := OrderedCollection with: ''.
	Transcript addDependent: self.
]

{ #category : #'as yet unclassified' }
DworphicTranscript >> lineBufferSize [

	^ lineBufferSize ifNil: [20]
]

{ #category : #'as yet unclassified' }
DworphicTranscript >> lineBufferSize: aNumber [

	lineBufferSize := aNumber.
	self shrinkLineBuffer
	lineBufferSize < lines size ifTrue: [lines := lines copyLast: lineBufferSize]
]

{ #category : #'as yet unclassified' }
DworphicTranscript >> lines [

	^ lines
]

{ #category : #'as yet unclassified' }
DworphicTranscript >> shrinkLineBuffer [

	self lineBufferSize < lines size ifTrue: [lines := lines last: self lineBufferSize]
]

{ #category : #'as yet unclassified' }
DworphicTranscript >> update: anUpdate [

	| newLines |
	newLines := Transcript contents splitBy: String cr.
	lines last addAll: newLines first.
	lines addAll: newLines allButFirst.
	self shrinkLineBuffer
]
