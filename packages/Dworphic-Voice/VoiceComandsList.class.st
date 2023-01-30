Class {
	#name : #VoiceComandsList,
	#superclass : #GRComponent,
	#category : #'Dworphic-Voice'
}

{ #category : #'as yet unclassified' }
VoiceComandsList >> fontSize [

	^ 30
]

{ #category : #'as yet unclassified' }
VoiceComandsList >> intentHandlersKeys: aCollectionOfIntentHandlerCollections [
	| intentHandlerKeys |
	intentHandlerKeys := {}.
	aCollectionOfIntentHandlerCollections get do: 
		[:aCollectionOfIntentHandlers | | intentGroup |
			intentGroup := ''.
			aCollectionOfIntentHandlers get keys do: [:intentString | 
				intentGroup := (intentGroup, (intentGroup isEmpty ifTrue: [''] ifFalse: [', ']), intentString)].
				intentHandlerKeys := intentHandlerKeys copyWith: intentGroup.
		].
	^ intentHandlerKeys
]

{ #category : #'as yet unclassified' }
VoiceComandsList >> render: props [

	| headPortal commandStrings intentHandlers visible |
	headPortal := self useProvided: #headPortal.
	intentHandlers := self useProvided: #voiceIntentHandlers.
	commandStrings := self useState: {}.
	visible := self useState: false.
	
	self
		useVoiceIntents: {
			'help me' -> [
				commandStrings set: (self intentHandlersKeys: intentHandlers).
				visible set: true.
				Transcript showln: 'help me']}
		key: ' '.
	
	^ visible get
		ifTrue: [
			{
				GRViewportTexture new
					extent: self resolution;
					children: (GDControl new
						rectSize: self resolution;
						children: {
							GDScrollContainer new
								rectSize: self resolution;
								followFocus: true;
								scrollHorizontalEnabled: false;
								children: {
									GDVBoxContainer new
										rectSize: self resolution;
										sizeFlagsHorizontal: GDVBoxContainer sizeExpandFill;
										children: {
											GDLabel new
												theme: (GDTheme new defaultFont: (GDDynamicFont new
													fontData: (GDDynamicFontData new fontPath: 'res://assets/attention-direction/NotoSans.ttf');
													size: self fontSize));
												autowrap: true;
												text: 'You can say the following commands:'.
											commandStrings get collect: [:entry |
												GDLabel new
													theme: (GDTheme new defaultFont: (GDDynamicFont new
														fontData: (GDDynamicFontData new fontPath: 'res://assets/attention-direction/NotoSans.ttf');
														size: self fontSize));
													autowrap: true;
													text: entry]}}});
					meshDo: [:material |
						{
							GDCollisionShape new shape: (GDBoxShape new extents: 1.5 @ 1 @ 0.1).
							GDMeshInstance new
								translation: 0 @ 1.5 @ 2;
								mesh: (GDQuadMesh new
									size: 1.5 @ 1;
									material: material).
							GDMeshInstance new
								translation: 0 @ 1.5 @ 2;
								mesh: (GDQuadMesh new
									size: 1.5 @ 1;
									material: material);
								rotationDegrees: 0 @ 180 @ 0}]}]
		ifFalse: [{}]
]

{ #category : #'as yet unclassified' }
VoiceComandsList >> resolution [

	^ (1500 @ 1000)
]
