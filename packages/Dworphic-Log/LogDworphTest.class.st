Class {
	#name : #LogDworphTest,
	#superclass : #GRTestCase,
	#category : #'Dworphic-Log'
}

{ #category : #'as yet unclassified' }
LogDworphTest >> testAddToLog [

	self openComponent: [
		WorldDworph new children: {
			[ | log |
				log := GRComponent basicNew useLog.
				GRComponent basicNew useEffect: [log value: 'a'] dependencies: {}] asComponent.
			LogDworph new}].
	self assert: 'a' equals: (godotTree firstNodeOfType: #Label3D) text
]
