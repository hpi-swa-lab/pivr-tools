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
LogDworph >> render: props [

	| entries viewportTex |
	entries := self useProvided: #logEntries.
	viewportTex := self useState: nil.

	^ {
		GDViewport new
		name: 'logViewport';
		size: (600 @ 400);
		renderTargetVFlip: true;
		renderTargetUpdateMode: GDViewport updateAlways;
		subscribeCall: 'get_texture' with: #() do: [:tex | viewportTex set: tex];
		children: {
			GDControl new
				rectSize: (600 @ 400);
				children: {
					GDScrollContainer new
						rectSize: (600 @ 400);
						children: {
							GDLabel new rectSize: (600 @ 400); text: (entries get joinSeparatedBy: String crlf)
						}
				}
		}.
		GDMeshInstance new
			children: (DebugDworph new point: 0 asVector3);
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
