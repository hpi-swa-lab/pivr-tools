Class {
	#name : #HandTracking,
	#superclass : #GRComponent,
	#category : #'Dworphic-HandTracking'
}

{ #category : #'as yet unclassified' }
HandTracking class >> appDescription [
	<home>
	
	
	^ DworphicApplicationDescription new
		name: self name;
		render: [self new.];
		renderController: [TrackedHand new.]

	"^ super appDescription renderController: [TrackedHand new]."
]

{ #category : #'as yet unclassified' }
HandTracking class >> fingerCharacterMapping [
	^ Dictionary newFromPairs: {
		$q. 1. $a. 1. $y. 1. 							"LeftLittle"
		$w. 2. $s. 2. $x. 2. 							"LeftRing"
		$e. 3. $d. 3. $c. 3. 							"LeftMiddle"
		$t. 4. $r. 4. $f. 4. $g. 4. $v. 4. $b. 4. 		"LeftIndex"
		$z. 5. $u. 5. $h. 5. $j. 5. $n. 5. $m. 5. 		"RightIndex"
		$i. 6. $k. 6. 								"RightMiddle"
		$o. 7. $p. 7. $l. 7. 							"RightRing"
		$ü. 8. $ö. 8. $ä. 8							"RightLittle"
	}.
]

{ #category : #'as yet unclassified' }
HandTracking class >> fingerColor [
	^ {
		Color red.
		Color orange.
		Color yellow.
		Color green.
		Color cyan.
		Color blue.
		Color eggplant.
		Color magenta.
	}
]

{ #category : #'as yet unclassified' }
HandTracking >> render: props [

	| focus |
	focus := (self useProvided: #textFocus) get.
	
	^ focus notNone ifTrue: [
		GDSpatial new transform: focus textAreaBottomCenter; children: {
		PinchtypeKeyboard new transform: (Matrix4x4 identity translation: 20cm @ -25cm @ 5 cm).
		SuggestionPanel new transform: (Matrix4x4 identity translation: -40cm @ -25cm @ 5 cm).
		}.
		
	]
]
