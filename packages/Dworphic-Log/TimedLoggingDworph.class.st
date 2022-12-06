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

	| log value interval idx rlog |
	log := self useLog.
	rlog := self replaceLog.
	value := props at: #value ifAbsent: ['xdd'].
	interval := props at: #interval ifAbsent: [2].
	
	^ {GDTimer new autostart: true; onTimeout: [idx := (log value: value) value. 
		rlog value: idx value: [idx asString].
		]; waitTime: interval.
	}
]
