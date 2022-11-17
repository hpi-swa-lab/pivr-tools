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

	^ 50
]

{ #category : #'as yet unclassified' }
LogDworph >> render: props [

	| entries viewportTex |
	entries := self useProvided: #logEntries.
	viewportTex := self useState: nil.

	^ {
		GDViewport new
		name: 'logViewport';
		size: self resolution;
		renderTargetVFlip: true;
		renderTargetUpdateMode: GDViewport updateAlways;
		subscribeCall: 'get_texture' with: #() do: [:tex | viewportTex set: tex];
		children: {
			GDControl new
				rectSize: self resolution;
				children: {
					GDScrollContainer new
						rectSize: self resolution; followFocus: true;
						children: {GDVBoxContainer new rectSize: self resolution; 
							sizeFlagsHorizontal: GDVBoxContainer sizeExpandFill; 
							children: {(entries get collect: [:entry | 
								{GDLabel new theme: (GDTheme new defaultFont: 
									(GDDynamicFont new fontData: 
										(GDDynamicFontData new fontPath: 'res://assets/attention-direction/NotoSans.ttf'); size: self fontSize));
								 text: entry.
							GDHSeparator new sizeFlagsHorizontal: GDHSeparator sizeExpandFill.}]). 
						}
					}
				}
		}.
		GDMeshInstance new
			mesh: (
				GDQuadMesh new
					size: (1.5 @ 1);
					material: (
						GDSpatialMaterial new 
							flagsUnshaded: true;
							flagsAlbedoTexForceSrgb: true;
							albedoTexture: viewportTex get;
							resourceLocalToScene: true
					)
			);
			translation: (0 @ 1 @ 0).
	}
]

{ #category : #'as yet unclassified' }
LogDworph >> resolution [

	^ (3000 @ 2000)
]
