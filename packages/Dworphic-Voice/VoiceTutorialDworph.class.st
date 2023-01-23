Class {
	#name : #VoiceTutorialDworph,
	#superclass : #GRComponent,
	#category : #'Dworphic-Voice'
}

{ #category : #'as yet unclassified' }
VoiceTutorialDworph >> fontSize [

	^ 30
]

{ #category : #'as yet unclassified' }
VoiceTutorialDworph >> render: props [

	| headPortal |
	headPortal := self useProvided: #headPortal.

	^ CMFReactNodePortal child: {GRViewportTexture new
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
										GDHSeparator new sizeFlagsHorizontal: GDHSeparator sizeExpandFill}].
								GDControl new
									focusMode: GDControl focusAll;
									subscribeCall: 'grab_focus' with: #() do: []}}});
		meshDo: [:material |
			GRGrabbableArea new children: {
				GDCollisionShape new shape: (GDBoxShape new extents: 1.5 @ 1 @ 0.1).
				GDMeshInstance new
				translation: 0@0@ (-2);
					mesh: (GDQuadMesh new
						size: 1.5 @ 1;
						material: material).
				GDMeshInstance new
					translation: 0 @ 1 @ 0;
					mesh: (GDQuadMesh new
						size: 1.5 @ 1;
						material: material);
					rotationDegrees: 0 @ 180 @ 0}]}
				in: headPortal.
]

{ #category : #'as yet unclassified' }
VoiceTutorialDworph >> resolution [

	^ (1500 @ 1000)
]

{ #category : #'as yet unclassified' }
VoiceTutorialDworph >> tutorialText [
	^ {
	'Welcome to world builder!'. 
	'This app allows you to build a world interactively. It is completely voice-controlled. To trigger voice commands, either '.
	'move either hand to your mouth (like a microphone),'.
	'or  press "B" on either joystick (thats the main button further away)'.
	''.
	'Most objects you can interact with have a label attached to them. Voice commands follow the simple form:'.
	'"<Label> messageToLabel"'.
	'If you just say the objects label, it will display all possible voice commands. If you just say "help me", all commands are shown.'.
	'If you point your finger on an object, you can say its voice commands without the <Label>.'.
	''.
	'To close this window, say "tutorial finish".'}
]
