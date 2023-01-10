Class {
	#name : #SuggestionPanel,
	#superclass : #GRComponent,
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

	| entries viewportTex |
	
	entries := #('hello' 'wasup').
	viewportTex := self useState: nil.
	
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
								entries collect: [:entry |
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
									subscribeCall: 'grab_focus' with: #() do: []}}
									
				});
		meshDo: [:material |
			GRGrabbableArea new children: {
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
