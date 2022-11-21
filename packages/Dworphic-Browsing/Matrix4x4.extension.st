Extension { #name : #Matrix4x4 }

{ #category : #'*Dworphic-Browsing' }
Matrix4x4 class >> lookAt2: to from: from up: up [
	"Build a right-handed look at view matrix. The camera is positioned at eye, looks at center, and is positioned in a world where up points upwards in world space. Up is expected to be normalized already."
	| forward right newup |
	forward := (from - to) normalized.
	right := (up cross: forward) normalized.
	newup := forward cross: right.
	^ self identity
		a11: right x;
		a12: right y;
		a13: right z;
		a21: newup x;
		a22: newup y;
		a23: newup z;
		a31: forward x;
		a32: forward y;
		a33: forward z;
		a41: from x;
		a42: from y;
		a43: from z;
		"a14: (right dot: from) negated;
		a24: (newup dot: from) negated;
		a34: (forward dot: from) negated;"
		yourself
]
