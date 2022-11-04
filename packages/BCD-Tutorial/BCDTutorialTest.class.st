Class {
	#name : #BCDTutorialTest,
	#superclass : #GRTestCase,
	#category : #'BCD-Tutorial-Test'
}

{ #category : #'as yet unclassified' }
BCDTutorialTest >> testOpen [

	self openComponent: BCDTutorialComponent
]

{ #category : #'as yet unclassified' }
BCDTutorialTest >> testSpawnCube [

	| count |
	self openComponent: BCDTutorialComponent.
	godotTree explore.
	
	count := (godotTree allNodesOfType: #RigidBody) size.
	self tick: {(godotTree firstNodeOfType: #GREvents) signal: #keyboard with: {true. GDGlobalConstants keySpace. ''}}.
	
	self assert: count < (godotTree allNodesOfType: #RigidBody) size
]
