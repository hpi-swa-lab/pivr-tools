Class {
	#name : #VoiceWorldBuilderTutorial,
	#superclass : #GRComponent,
	#category : #'Dworphic-Voice'
}

{ #category : #'as yet unclassified' }
VoiceWorldBuilderTutorial >> fontSize [

	^ 30
]

{ #category : #'as yet unclassified' }
VoiceWorldBuilderTutorial >> render: props [

	| headPortal |
	headPortal := self useProvided: #headPortal.
	
	^ GRViewportTexture new
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
								self tutorialText collect: [:entry |
									{
										GDLabel new
											theme: (GDTheme new defaultFont: (GDDynamicFont new
												fontData: (GDDynamicFontData new fontPath: 'res://assets/attention-direction/NotoSans.ttf');
												size: self fontSize));
											autowrap: true;
											text: entry.
									}].
								GDControl new
									focusMode: GDControl focusAll;
									subscribeCall: 'grab_focus' with: #() do: []}}});
		meshDo: [:material |
			{
				GDCollisionShape new shape: (GDBoxShape new extents: 1 @ 1 @ 0.1).
				GDMeshInstance new
					translation: 1 @ 1.1 @ -1;
					mesh: (GDQuadMesh new
						size: 1.5 @ 1;
						material: material);
					rotationDegrees: 0 @ -30 @ 0}]
]

{ #category : #'as yet unclassified' }
VoiceWorldBuilderTutorial >> resolution [

	^ (1500 @ 1000)
]

{ #category : #'as yet unclassified' }
VoiceWorldBuilderTutorial >> tutorialText [

	^ {
		'Welcome to world builder!'.
		'This app allows you to build a world interactively. It is completely voice-controlled. To trigger voice commands, press "B" on the right joystick (thats the main button further away)'.
		''.
		'Each object has an id, which is visible near the red dot of the object.'.''.
		''.
		'All commands follow the pattern <object id> <message>'.
		''.
		'If you point on an object, you can see the objects voice commands and can give them directly without saying the object id.'.
		''.
		'To close this window, say "tutorial finish".'.
		''.
		'To open an overview of all commands, say "help me".'}
]
