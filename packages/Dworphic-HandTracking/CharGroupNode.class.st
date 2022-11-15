Class {
	#name : #CharGroupNode,
	#superclass : #Object,
	#instVars : [
		'finger',
		'words',
		'children',
		'hasChildren'
	],
	#category : #'Dworphic-HandTracking'
}

{ #category : #'as yet unclassified' }
CharGroupNode class >> newFromFingerName: aString [
	^(self new)
		finger: aString;
		children: (Array new: 8);
		hasChildren: false;
		words: Bag new;
		yourself.
]

{ #category : #'as yet unclassified' }
CharGroupNode >> children [
	^ children
]

{ #category : #'as yet unclassified' }
CharGroupNode >> children: anArray [
	children := anArray
]

{ #category : #'as yet unclassified' }
CharGroupNode >> finger [
	^ finger
]

{ #category : #'as yet unclassified' }
CharGroupNode >> finger: aString [
	finger := aString
]

{ #category : #'as yet unclassified' }
CharGroupNode >> getChild: anIndex [
	(self hasChildren) ifFalse: [self initChildren].
	^ self children at: anIndex ifAbsent: []
]

{ #category : #'as yet unclassified' }
CharGroupNode >> hasChildren [
	^hasChildren
]

{ #category : #'as yet unclassified' }
CharGroupNode >> hasChildren: aBoolean [
	hasChildren := aBoolean
]

{ #category : #'as yet unclassified' }
CharGroupNode >> initChildren [
	self hasChildren: true.
	self children at: 1 put: (CharGroupNode newFromFingerName: 'LeftLittle').
	self children at: 2 put: (CharGroupNode newFromFingerName: 'LeftRing').
	self children at: 3 put: (CharGroupNode newFromFingerName: 'LeftMiddle').
	self children at: 4 put: (CharGroupNode newFromFingerName: 'LeftIndex').
	self children at: 5 put: (CharGroupNode newFromFingerName: 'RightIndex').
	self children at: 6 put: (CharGroupNode newFromFingerName: 'RightMiddle').
	self children at: 7 put: (CharGroupNode newFromFingerName: 'RightRing').
	self children at: 8 put: (CharGroupNode newFromFingerName: 'RightLittle')
]

{ #category : #'as yet unclassified' }
CharGroupNode >> words [
	
	^ words
]

{ #category : #'as yet unclassified' }
CharGroupNode >> words: aList [
	words := aList
]
