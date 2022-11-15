Class {
	#name : #TimedLoggingDworph,
	#superclass : #GRComponent,
	#category : #'Dworphic-Log'
}

{ #category : #'as yet unclassified' }
TimedLoggingDworph >> render: props [

	| log value interval |
	log := self useLog.
	value := props at: #value.
	interval := props at: #interval.
	
	 ^ GDTimer new autostart: true; onTimeout: [log value: value]; waitTime: interval
]
