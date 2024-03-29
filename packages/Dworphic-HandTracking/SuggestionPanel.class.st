"
A SuggestionPanel is a Dworph that shows users the possible words that may result from their pinchtype query. It indicates which word is currently selected.
"
Class {
	#name : #SuggestionPanel,
	#superclass : #GRComponent,
	#instVars : [
		'scrollContainer'
	],
	#category : #'Dworphic-HandTracking'
}

{ #category : #'as yet unclassified' }
SuggestionPanel >> fontSize [

	^ 30
]

{ #category : #'as yet unclassified' }
SuggestionPanel >> panelSize [
	
	^ (0.3 @ 0.5)
]

{ #category : #'as yet unclassified' }
SuggestionPanel >> render: props [

	| viewportTex scrollPos suggestionEntries |
	
	suggestionEntries := (self useProvided: #suggestionEntries) get.

	viewportTex := self useState: nil.

	scrollPos := (self useProvided: #scrollPos) get.
	
	^ GRViewportTexture new
		extent: self resolution;
		children: (GDControl new
			rectSize: self resolution;
			children: {
				GDScrollContainer new
					rectSize: self resolution;
					followFocus: false;
					scrollHorizontalEnabled: false;
					scrollVertical: ((scrollPos - 5) * (self resolution y / 9)) asFloat;
					children: {
						GDVBoxContainer new
							rectSize: self resolution;
							sizeFlagsHorizontal: GDVBoxContainer sizeExpandFill;
							children: {
								suggestionEntries withIndexCollect: [:entry :index |
									{
										GDLabel new
											theme: (
												GDTheme new 
													defaultFont: (GDDynamicFont new
														fontData: (GDDynamicFontData new fontPath: 'res://assets/attention-direction/NotoSans.ttf');
														size: self fontSize));
											autowrap: true;
											text: ((index = scrollPos) ifTrue: ['>>>', entry] ifFalse: [entry]).
										GDHSeparator new sizeFlagsHorizontal: GDHSeparator sizeExpandFill}].
								GDControl new
									focusMode: GDControl focusAll;
									subscribeCall: 'grab_focus' with: #() do: []}}.
				});
		meshDo: [:material |
			GRGrabbableArea new transform: (props at: #transform); children: {
				GDCollisionShape new shape: (GDBoxShape new extents: (self panelSize / 2) x @ (self panelSize / 2) y @ 0.05).
				GDMeshInstance new
					mesh: (GDQuadMesh new
						size: self panelSize;
						material: material).
				GDMeshInstance new
					mesh: (GDQuadMesh new
						size: self panelSize;
						material: material);
					rotationDegrees: 0 @ 180 @ 0}]
]

{ #category : #'as yet unclassified' }
SuggestionPanel >> resolution [

	^ (300 @ 500)
]
