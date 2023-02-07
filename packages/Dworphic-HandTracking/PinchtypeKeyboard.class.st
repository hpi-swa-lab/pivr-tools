Class {
	#name : #PinchtypeKeyboard,
	#superclass : #GRComponent,
	#category : #'Dworphic-HandTracking'
}

{ #category : #'as yet unclassified' }
PinchtypeKeyboard >> collisionShape [

	^ (self godot: #BoxShape) extents: 0.02 @ 0.005 @ 0.03
]

{ #category : #'as yet unclassified' }
PinchtypeKeyboard >> keySize [

	^ 0.1
]

{ #category : #'as yet unclassified' }
PinchtypeKeyboard >> layout [

	^ {
				{'Q'. 'W'. 'E'. 'R'. 'T'. 'Z'. 'U'. 'I'. 'O'. 'P'}.
				{'A'. 'S'. 'D'. 'F'. 'G'. 'H'. 'J'. 'K'. 'L'}.
	 {"'Shift'." 'Y'. 'X'. 'C'. 'V'. 'B'. 'N'. 'M'. 'Comma'. 'Period'. 'Minus'}}
]

{ #category : #'as yet unclassified' }
PinchtypeKeyboard >> layout: aBool [

	^ {
				{'Q'. 'W'. 'E'. 'R'. 'T'. 'Z'. 'U'. 'I'. 'O'. 'P'}.
				{'A'. 'S'. 'D'. 'F'. 'G'. 'H'. 'J'. 'K'. 'L'}.
	aBool ifFalse: {"'Shift'." 'Y'. 'X'. 'C'. 'V'. 'B'. 'N'. 'M'. 'Comma'. 'Period'. 'Minus'} ifTrue: {'Shift'. 'Y'. 'X'. 'C'. 'V'. 'B'. 'N'. 'M'. 'Semicolon'. 'Colon'. 'Underscore'}.
				{'Braceleft'. 'Bracketleft'. 'Space'. 'Bracketright'. 'Braceright'. 'Plus'. 'Asterisk'. 'Numbersign'. 'Apostrophe'}}
]

{ #category : #'as yet unclassified' }
PinchtypeKeyboard >> render: props [

	| layout |
	layout := self layout.
	
	^ GRGrabbableArea new
	transform: (props at: #transform);
		children: {
			(self
				cubeOfSize: (layout collect: #size) max * self keySize @ (layout size * self keySize) @ 0.01
				color: (Color r: 0.37 g: 0.37 b: 0.37)) children: {
				self methodAsComponent: #renderCurrentInput:.
				GDSpatial new
					translation: (layout collect: #size) max - 1 * self keySize / -2 @ (self keySize / -2 * (layout size + 1)) @ 0;
					children: (layout withIndexCollect: [:row :rowIndex |
						row asOrderedCollection withIndexCollect: [:letter :columnIndex | | keyCode |
							keyCode := GDGlobalConstants perform: ('key{1}' format: {letter}) asSymbol.
							(self methodAsComponent: #renderKey:)
								key: letter;
								letter: (self scancodeName: keyCode);
								position: columnIndex - 1 @ (layout size - (rowIndex - 1));
								onPressed: ["text entering handled by pinch gestures"
								]]])}}
]

{ #category : #'as yet unclassified' }
PinchtypeKeyboard >> renderCurrentInput: props [
	
	| layout width currentWord colors |
	layout := self layout.
	currentWord := self useProvided: #currentWord.
	colors := self useMemo: [HandTracking fingerColor] dependencies: #().
	width := (layout collect: #size) max * self keySize.
	^ GDSpatial new   translation: 0 * self keySize / -2 @ (self keySize / 2 * (layout size + 1)) @ 0; children:{
	(self cubeOfSize:  width  @ self keySize @ 0.02 color: Color gray).
	GDLabel3D new text: 'Current Input:'; translation: width / -2.5 @ 0 @ 1.1cm; pixelSize: 0.2cm.
	currentWord get withIndexCollect: [:group : index | 
		(self cubeOfSize: self keySize asPoint * 0.7 @ 0.02 
			color: (colors at: group))
			translation: (width / -3.0) + (self keySize * index) @ 0 @ 0.1cm.].
	}
]

{ #category : #'as yet unclassified' }
PinchtypeKeyboard >> renderKey: props [

	| color charGroup currentCharGroup |
	^ props extract: [:letter |
		charGroup := self useMemo: [HandTracking fingerCharacterMapping at: ((props at: #letter)  asCharacter asLowercase) ifAbsent: [8].] dependencies: #().
	color := self useMemo: [HandTracking fingerColor at: charGroup] dependencies: #().
	currentCharGroup := self useProvided: #currentCharGroup.
	
	
	^ GDSpatial new
		children: {
			self cubeOfSize: self keySize asPoint @ 0.02 color: (currentCharGroup get = charGroup
				ifTrue: [color lighter]
				ifFalse: [color darker]).
			GDLabel3D new
				translation: 0 @ 0 @ 0.011;
				text: (props at: #letter) asString;
				pixelSize: 0.003.
			GDCollisionShape new shape: (GDBoxShape new extents: self keySize asPoint / 2 @ 0.01)};
		translation: (props at: #position) @ 0 * self keySize
		].
	
]

{ #category : #'as yet unclassified' }
PinchtypeKeyboard >> scancodeName: aScancode [
	"This should work using
		(GD_OS instance) getScancodeStringCode: (aScancode)
	but right now it doesn't, so we're doing the conversion manually."

	^ aScancode caseOf: {
			[GDGlobalConstants keyShift] -> ['Shift'].
			[GDGlobalConstants keyComma] -> [','].
			[GDGlobalConstants keyPeriod] -> ['.'].
			[GDGlobalConstants keyMinus] -> ['-'].
			[GDGlobalConstants keySemicolon] -> [';'].
			[GDGlobalConstants keyColon] -> [':'].
			[GDGlobalConstants keyUnderscore] -> ['_'].
			[GDGlobalConstants keyBraceleft] -> ['{'].
			[GDGlobalConstants keyBracketleft] -> ['['].
			[GDGlobalConstants keySpace] -> [' '].
			[GDGlobalConstants keyBracketright] -> [']'].
			[GDGlobalConstants keyBraceright] -> ['}'].
		} otherwise: [
			(Character value: aScancode) asString]
]
