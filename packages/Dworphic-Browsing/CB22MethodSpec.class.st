Class {
	#name : #CB22MethodSpec,
	#superclass : #Object,
	#instVars : [
		'name',
		'text',
		'key',
		'class',
		'initialTransform',
		'grabEvent'
	],
	#category : #'Dworphic-Browsing'
}

{ #category : #'as yet unclassified' }
CB22MethodSpec class >> fromKey: key Class: class Name: name text: text [

	^ CB22MethodSpec new
		key: key;
		class: class;
		name: name;
		text: text;
		yourself
]

{ #category : #'as yet unclassified' }
CB22MethodSpec >> class [

	^ class
]

{ #category : #'as yet unclassified' }
CB22MethodSpec >> class: aClassName [

	class := aClassName
]

{ #category : #'as yet unclassified' }
CB22MethodSpec >> grabEvent [

	^ grabEvent
]

{ #category : #'as yet unclassified' }
CB22MethodSpec >> grabEvent: anEvent [

	grabEvent := anEvent
]

{ #category : #'as yet unclassified' }
CB22MethodSpec >> initialTransform [

	^ initialTransform
]

{ #category : #'as yet unclassified' }
CB22MethodSpec >> initialTransform: aMatrix4x4 [

	initialTransform := aMatrix4x4
]

{ #category : #'as yet unclassified' }
CB22MethodSpec >> key [

	^ key
]

{ #category : #'as yet unclassified' }
CB22MethodSpec >> key: aString [

	key := aString
]

{ #category : #'as yet unclassified' }
CB22MethodSpec >> name [

	^ name
]

{ #category : #'as yet unclassified' }
CB22MethodSpec >> name: aString [

	name := aString
]

{ #category : #'as yet unclassified' }
CB22MethodSpec >> text [

	^ text
]

{ #category : #'as yet unclassified' }
CB22MethodSpec >> text: aString [

	text := aString
]
