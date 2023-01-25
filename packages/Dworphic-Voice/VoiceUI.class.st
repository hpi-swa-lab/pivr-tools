Class {
	#name : #VoiceUI,
	#superclass : #GRComponent,
	#category : #'Dworphic-Voice'
}

{ #category : #'as yet unclassified' }
VoiceUI >> reduce: aCollectionOfStrings [
	| acc |
	acc := ''.
	aCollectionOfStrings do: [:s | acc := (acc,s, String lf)].
	^ acc
]

{ #category : #'as yet unclassified' }
VoiceUI >> render: props [

	| text |
	^ props extract: [:key :voiceIntents :hovered :rest | | handlers handlersKeys showKeys |
		handlers := self useProvided: #voiceIntentHandlers.
		handlersKeys := (handlers get gather: [:ref | ref get keys]) 
			select: [:intents | intents beginsWith: key].
		
		showKeys := self useState: false.
		text := self useState: key.
	
		GDSpatial new
			setAll: rest;
			children: {
				GDMeshInstance new mesh: (GDSphereMesh new
					radius: 0.1;
					height: 0.2;
					material: (GDSpatialMaterial new
						albedoColor: Color red;
						flagsUnshaded: true;
						flagsNoDepthTest: true)).
				GDLabel3D new
					text: ((showKeys get or: [hovered]) 
						ifTrue: [self reduce: handlersKeys] 
						ifFalse: [key]);
					fixedSize: true;
					horizontalAlignment: 0;
					verticalAlignment: 0;
					pixelSize: 0.001;
					translation: 0 @ 0 @ 0;
					billboard: GDSpatialMaterial billboardEnabled;
					noDepthTest: true.
				(showKeys get or: [hovered]) ifTrue: [ GDTimer new
							autostart: true;
							waitTime: 5;
							onTimeout: [showKeys set: false]
					]}]
]
