Class {
	#name : #HandTrackingGUI,
	#superclass : #GRComponent,
	#category : #'Dworphic-HandTracking'
}

{ #category : #'as yet unclassified' }
HandTrackingGUI >> render: props [

	| entries viewportTex |
	entries := self useProvided: #logEntries.
	viewportTex := self useState: nil.
	
	^ GRViewportTexture new
		extent: self resolution;
		children: (GDControl new
			rectSize: self resolution;
			children: {
			
						GDVBoxContainer new
							rectSize: self resolution;
							sizeFlagsHorizontal: GDVBoxContainer sizeExpandFill;
							children: {
								(entries get last: (20 min: entries get size)) collect: [:entry |
									{
										GDLabel new
											theme: (GDTheme new defaultFont: (GDDynamicFont new
												fontData: (GDDynamicFontData new fontPath: 'res://assets/attention-direction/NotoSans.ttf');
												size: self fontSize));
											autowrap: true;
											text: entry.
										GDHSeparator new sizeFlagsHorizontal: GDHSeparator sizeExpandFill}].
								}});
		meshDo: [:material |
			GRGrabbableArea new children: {
				GDCollisionShape new shape: (GDBoxShape new extents: 1.5 @ 1 @ 0.1).
				GDMeshInstance new mesh: (GDQuadMesh new
					size: 1.5 @ 1;
					material: (GDSpatialMaterial new
						flagsUnshaded: true;
						flagsAlbedoTexForceSrgb: true;
						albedoTexture: viewportTex get;
						resourceLocalToScene: true)).
				GDMeshInstance new
					mesh: (GDQuadMesh new
						size: 1.5 @ 1;
						material: material);
					rotationDegrees: 0 @ 180 @ 0}]
]
