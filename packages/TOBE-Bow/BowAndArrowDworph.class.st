Class {
	#name : #BowAndArrowDworph,
	#superclass : #GRComponent,
	#category : #'TOBE-Bow'
}

{ #category : #'as yet unclassified' }
BowAndArrowDworph class >> appDescription [
	<home>

	^ super appDescription
]

{ #category : #'as yet unclassified' }
BowAndArrowDworph >> render: props [

	| trees |
	trees := self
		useMemo: [
			Array streamContents: [:stream |
				56 timesRepeat: [
					stream nextPut: {
						#position -> (Point r: (10 to: 30) atRandom degrees: 360 atRandom).
						#scale -> (1.0 mix: 1.3 alpha: ThreadSafeRandom next).
						#rotaion -> 360 atRandom}]]]
		dependencies: {}.
	^ {
		GDStaticBody new children: (self cubeOfSize: 30 @ 0.1 @ 30 color: (Color r: 0.542 g: 0.321 b: 0.134)).
		BowDworph new}, (trees collect: [:tree | (self methodAsComponent: #renderTree:) props: (tree as: Dictionary)])
]

{ #category : #'as yet unclassified' }
BowAndArrowDworph >> renderTree: props [

	^ props extract: [:scale :position :rotation |
		GDStaticBody new
			scale: scale;
			rotationDegrees: rotation;
			translation: position x @ 0 @ position y;
			children: {
				(self cubeOfSize: 0.2 asVector3 color: (Color r: 0.6 g: 0.2 b: 0.0)) translation: 0 @ 0.1 @ 0.
				(self cubeOfSize: 0.6 @ 1.8 @ 0.6 color: (Color r: 0.108 g: 0.656 b: 0.108)) translation: 0 @ (0.9 + 0.2) @ 0}]
]
