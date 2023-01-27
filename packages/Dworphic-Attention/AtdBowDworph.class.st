Class {
	#name : #AtdBowDworph,
	#superclass : #GRComponent,
	#category : #'Dworphic-Attention-UserTest'
}

{ #category : #'as yet unclassified' }
AtdBowDworph >> render: props [

	^ self renderFull: props
]

{ #category : #'as yet unclassified' }
AtdBowDworph >> renderFull: props [

	| arrows world grabbedSide aim string |
	arrows := self useState: {}.
	grabbedSide := self useState: nil.
	aim := self useRef: Matrix4x4 identity.
	string := self useRef: Matrix4x4 identity.
	world := self useWorldPortal.
	
	^ {
		GRGrabbableArea new
			onGrab: [:e | grabbedSide set: e side];
			transform: (Matrix4x4 withOffset: 0 @ 1 @ 0);
			children: {
				self cubeVisualOfSize: 0.03 @ 0.6 @ 0.03 color: (Color r: 0.6 g: 0.2 b: 0.0).
				(self cubeVisualOfSize: 0.03 @ 0.03 @ 0.1 color: (Color r: 0.6 g: 0.2 b: 0.0)) translation: 0 @ 0.3 @ 0.05.
				(self cubeVisualOfSize: 0.03 @ 0.03 @ 0.1 color: (Color r: 0.6 g: 0.2 b: 0.0)) translation: 0 @ -0.3 @ 0.05.
				(self cubeOfSize: 0.04 @ 0.08 @ 0.04 color: (Color r: 0.707 g: 0.523 b: 0.432))
					subscribeTo: #'global_transform'
					do: [:t | aim set: t].
				GRGrabbableArea new
					transform: (Matrix4x4 withOffset: 0 @ 0 @ 0.1);
					onRelease: [:e | arrows set: [:a | a copyWith: {aim get. aim get translation distanceTo: string get translation}]];
					children: ((self cubeOfSize: 0.005 @ 0.6 @ 0.005 color: (Color r: 0.758 g: 0.58 b: 0.491))
						subscribeTo: #'global_transform'
						do: [:t | string set: t])}.
		CMFReactNodePortal
			child: (arrows get collect: [:t |
				AtdArrowDworph new
					transform: t first;
					strength: t second])
			in: world}
]

{ #category : #'as yet unclassified' }
AtdBowDworph >> renderVisuals: props [

	^ GDSpatial new
		transform: (Matrix4x4 withOffset: 0 @ 1 @ 0);
		children: {
			self cubeVisualOfSize: 0.03 @ 0.6 @ 0.03 color: (Color r: 0.6 g: 0.2 b: 0.0).
			(self cubeVisualOfSize: 0.03 @ 0.03 @ 0.1 color: (Color r: 0.6 g: 0.2 b: 0.0)) translation: 0 @ 0.3 @ 0.05.
			(self cubeVisualOfSize: 0.03 @ 0.03 @ 0.1 color: (Color r: 0.6 g: 0.2 b: 0.0)) translation: 0 @ -0.3 @ 0.05.
			self cubeVisualOfSize: 0.04 @ 0.08 @ 0.04 color: (Color r: 0.758 g: 0.58 b: 0.491).
			GDSpatial new
				transform: (Matrix4x4 withOffset: 0 @ 0 @ 0.1);
				children: (self cubeVisualOfSize: 0.005 @ 0.6 @ 0.005 color: (Color r: 0.758 g: 0.58 b: 0.491))}
]
