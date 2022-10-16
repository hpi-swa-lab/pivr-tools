Class {
	#name : #BaselineOfPiVR,
	#superclass : #BaselineOf,
	#category : #BaselineOfPiVR
}

{ #category : #'as yet unclassified' }
BaselineOfPiVR >> baseline: spec [
	<baseline>

	spec for: #common do: [
		spec baseline: 'GReaSe' with: [spec repository: 'github://hpi-swa-lab/pivr'].
		spec package: 'Example' with: [spec requires: #('GReaSe')].
		spec group: 'default' with: #('Example')]
]

{ #category : #'as yet unclassified' }
BaselineOfPiVR >> projectClass [

	^ Smalltalk at: #MetacelloCypressBaselineProject ifAbsent: [super projectClass]
]
