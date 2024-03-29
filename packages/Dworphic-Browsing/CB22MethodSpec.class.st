Class {
	#name : #CB22MethodSpec,
	#superclass : #Object,
	#instVars : [
		'name',
		'text',
		'key',
		'className',
		'initialTransform',
		'grabEvent'
	],
	#category : #'Dworphic-Browsing'
}

{ #category : #'instance creation' }
CB22MethodSpec class >> fromKey: key class: class name: name text: text [

	^ CB22MethodSpec new
		key: key;
		className: class;
		name: name;
		text: text;
		yourself
]

{ #category : #accessing }
CB22MethodSpec >> className [

	^ class
]

{ #category : #accessing }
CB22MethodSpec >> className: aClassName [

	class := aClassName
]

{ #category : #accessing }
CB22MethodSpec >> grabEvent [

	^ grabEvent
]

{ #category : #accessing }
CB22MethodSpec >> grabEvent: anEvent [

	grabEvent := anEvent
]

{ #category : #accessing }
CB22MethodSpec >> initialTransform [

	^ initialTransform
]

{ #category : #accessing }
CB22MethodSpec >> initialTransform: aMatrix4x4 [

	initialTransform := aMatrix4x4
]

{ #category : #accessing }
CB22MethodSpec >> key [

	^ key
]

{ #category : #accessing }
CB22MethodSpec >> key: aString [

	key := aString
]

{ #category : #accessing }
CB22MethodSpec >> name [

	^ name
]

{ #category : #accessing }
CB22MethodSpec >> name: aString [

	name := aString
]

{ #category : #accessing }
CB22MethodSpec >> text [

	^ text
]

{ #category : #accessing }
CB22MethodSpec >> text: aString [

	text := aString
]
