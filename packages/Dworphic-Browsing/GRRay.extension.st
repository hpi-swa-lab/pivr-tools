Extension { #name : #GRRay }

{ #category : #'*Dworphic-Browsing' }
GRRay >> intersectSphere: sphereOrigin radius: sphereRadius [

	| oMinC p q discriminant dRoot|
	oMinC := origin - sphereOrigin.
	p := (direction normalized) dot: oMinC.
	q := (oMinC dot: oMinC) - (sphereRadius * sphereRadius).
	
	discriminant := (p * p) - q.
	discriminant < 0 ifTrue: [^ {}].
	
	dRoot := discriminant sqrt.
	^ {self pointFromOrigin: (p * -1 - dRoot).  self pointFromOrigin: (p * -1 + dRoot)}
	
]

{ #category : #'*Dworphic-Browsing' }
GRRay >> origin: aVector direction: anotherVector [

	origin := aVector.
	direction := anotherVector
]
