Class {
	#name : #TimedLoggingDworph,
	#superclass : #GRComponent,
	#category : #'Dworphic-Log'
}

{ #category : #'as yet unclassified' }
TimedLoggingDworph class >> appDescription [
	<home>

	^ super appDescription
]

{ #category : #'as yet unclassified' }
TimedLoggingDworph >> render: props [

	| interval n |
	n := self useState: 0.
	interval := props at: #interval ifAbsent: [2].
	
	^ {GDTimer new
			autostart: true;
			waitTime: interval;
			onTimeout: [
				Transcript showln: 'tick ', n get asString.
				n set: [:old | old  + 1]]}
]
