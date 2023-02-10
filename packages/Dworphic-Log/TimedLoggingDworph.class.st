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

	| value interval |
	value := props at: #value ifAbsent: ['Test'].
	interval := props at: #interval ifAbsent: [2].
	
	^ {
		GDTimer new
			autostart: true;
			onTimeout: [
				Transcript showln: value];
			waitTime: interval}
]
