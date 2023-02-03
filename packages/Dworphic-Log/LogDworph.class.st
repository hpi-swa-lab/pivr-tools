Class {
	#name : #LogDworph,
	#superclass : #GRComponent,
	#category : #'Dworphic-Log'
}

{ #category : #'as yet unclassified' }
LogDworph class >> appDescription [
	<home>

	^ super appDescription
]

{ #category : #'as yet unclassified' }
LogDworph >> fontSize [

	^ 30
]

{ #category : #'as yet unclassified' }
LogDworph >> render: props [

	| entries viewportTex transcript |
	transcript := self useRef: nil.
	self useEffect: [
		transcript set: DworphicTranscript new.
		[transcript get cleanup]] dependencies: #().
	
	entries := transcript get
		ifNil: [#()]
		ifNotNil: [:t |
			t lines].
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
									subscribeCall: 'grab_focus' with: #() do: []}}});
		meshDo: [:material |
			GRGrabbableArea new children: {
				GDCollisionShape new shape: (GDBoxShape new extents: 0.75 @ 0.5 @ 0.1); translation: 0 @ 1 @ 0.
				GDMeshInstance new
				translation: 0@1@0;
					mesh: (GDQuadMesh new
						size: 1.5 @ 1;
						material: material).
				GDMeshInstance new
					translation: 0 @ 1 @ 0;
					mesh: (GDQuadMesh new
						size: 1.5 @ 1;
						material: material);
					rotationDegrees: 0 @ 180 @ 0}]
]

{ #category : #'as yet unclassified' }
LogDworph >> resolution [

	^ (1500 @ 1000)
]
