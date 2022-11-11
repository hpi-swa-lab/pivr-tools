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

	| entries |
	entries := self useProvided: #logEntries.
	^
	self renderQuad: props.
	"GRGrabbableArea new translation: (0 @ 1 @ 0); children: {
		GDLabel3D new
			pixelSize: 0.002;
			width: 300;
			autowrap: true;
			doubleSided: false;
			 text: ((entries get last: (20 min: entries get size)) joinSeparatedBy: String crlf); horizontalAlignment: GDGlobalConstants halignLeft; verticalAlignment: GDGlobalConstants valignBottom.
		(self cubeOfSize: (0.6@1@0.01) color: (Color gray)) translation: (0.3 @ 0.5 @ -0.006).
	}."
]

{ #category : #'as yet unclassified' }
LogDworph >> renderQuad: props [

	| entries viewport viewportRef viewportTex |
	entries := self useProvided: #logEntries.
	viewportRef := self useGodotRef.
	viewportTex := self useState: nil.
	viewport := GDViewport new
		name: 'logViewport';
		size: (300 @ 200);
		hdr: false;
		usage: GDViewport usage2d;
		renderTargetVFlip: true;
		renderTargetUpdateMode: GDViewport updateAlways;
		ref: viewportRef;
		subscribeCall: 'get_texture' with: #() do: [:tex | viewportTex set: tex];
		children: {
			GDControl new
				rectSize: (300 @ 200);
				children: {
					GDColorRect new color: Color red; rectSize: (300 @ 200).
					GDLabel new text: 'Hello world'
				}
		}.

	^ {
		viewport.
		GDMeshInstance new
			mesh: (
				GDQuadMesh new
					size: (3 @ 2);
					material: (
						GDSpatialMaterial new 
							flagsTransparent: true;
							flagsUnshaded: true;
							flagsAlbedoTexForceSrgb: true;
							albedoTexture: viewportTex get;
							resourceLocalToScene: true
					)
			);
			translation: (0 @ 1 @ 0).
	}
]
