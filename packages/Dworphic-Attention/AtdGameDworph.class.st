Class {
	#name : #AtdGameDworph,
	#superclass : #GRComponent,
	#category : #'Dworphic-Attention-UserTest'
}

{ #category : #'as yet unclassified' }
AtdGameDworph class >> appDescription [
	<home>

	^ super appDescription rendersEnvironment: true
]

{ #category : #rendering }
AtdGameDworph >> render: props [

	^ self renderFull: props
]

{ #category : #rendering }
AtdGameDworph >> renderFull: props [

	| trees hits treePosition |
	treePosition := self useState: (Point r: (10 to: 30) atRandom degrees: 360 atRandom).
	hits := self useState: 0.
	
	trees := self
		useMemo: [
			Array streamContents: [:stream |
				1 timesRepeat: [
					stream nextPut: {
						#position -> (-10 @ 10).
						#scale -> (1.0 mix: 1.3 alpha: ThreadSafeRandom next).
						#rotaion -> 360 atRandom.
						#onHitCallback -> [
							hits set: hits get + 1.
							Transcript showln: 'Hit']}]]]
		dependencies: {}.
	^ {
		GDStaticBody new children: (self cubeOfSize: 30 @ 0.1 @ 30 color: (Color r: 0.542 g: 0.321 b: 0.134)).
		AtdBowDworph new}, (trees collect: [:tree | AtdTreeDworph new props: (tree as: Dictionary)]), {hits get >= 5 ifTrue: [NotificationDworph new message: 'You won!']}, {AtdRandomizedTreeDworph new}
]

{ #category : #rendering }
AtdGameDworph >> renderTree: props [

	^ props extract: [:scale :position :rotation |
		GDStaticBody new
			scale: scale;
			rotationDegrees: rotation;
			translation: position x @ 0 @ position y;
			children: {
				(self cubeOfSize: 0.2 asVector3 color: Color gray) translation: 0 @ 0.1 @ 0.
				(self cubeOfSize: 0.6 @ 1.8 @ 0.6 color: (Color r: 0.108 g: 0.656 b: 0.108)) translation: 0 @ (0.9 + 0.2) @ 0} highlight]
]

{ #category : #rendering }
AtdGameDworph >> renderVisuals: props [

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
		GDStaticBody new children: (self cubeOfSize: 30 @ 0.1 @ 30 color: (Color r: 0.542 g: 0.321 b: 0.134))}, (trees collect: [:tree | (self methodAsComponent: #renderTree:) props: (tree as: Dictionary)])
]
