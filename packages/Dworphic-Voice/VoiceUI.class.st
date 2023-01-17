Class {
	#name : #VoiceUI,
	#superclass : #GRComponent,
	#category : #'Dworphic-Voice'
}

{ #category : #'as yet unclassified' }
VoiceUI >> render: props [

	^ props extract: [:key :voiceIntents :hovered :rest | | handlers handlersKeys showKeys |
		handlers := self useProvided: #voiceIntentHandlers.
		handlersKeys := (handlers get gather: [:ref | ref get keys]) 
			select: [:intents | intents beginsWith: key].
		
		showKeys := self useState: false.
		
		GDSpatial new
			setAll: rest;
			children: {
				GDMeshInstance new mesh: (GDSphereMesh new
					radius: 0.1;
					height: 0.1 * 2;
					material: (GDSpatialMaterial new
						albedoColor: Color red;
						flagsUnshaded: true;
						flagsNoDepthTest: false)).
				GDLabel3D new
					text: key;
					fixedSize: true;
					horizontalAlignment: 0;
					verticalAlignment: 0;
					pixelSize: 0.003;
					translation: 0 @ 0 @ 0;
					billboard: GDSpatialMaterial billboardEnabled;
					noDepthTest: true.
				(showKeys get or: [hovered]) ifTrue: [
					{
						(handlersKeys select: [:intent | intent ~= key]) withIndexCollect: [:intent :i |
							GDLabel3D new
								key: intent;
								text: intent;
								pixelSize: 0.003;
								billboard: GDSpatialMaterial billboardEnabled;
								fixedSize: true;
								noDepthTest: true;
								translation: 0 @ (i * -0.2) @ 0;
								horizontalAlignment: 0;
								verticalAlignment: 0;
								width: 300;
								autowrap: true].
						GDTimer new
							autostart: true;
							waitTime: 5;
							onTimeout: [showKeys set: false]}].}]
]
