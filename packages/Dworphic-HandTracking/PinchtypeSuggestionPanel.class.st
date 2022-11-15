Class {
	#name : #PinchtypeSuggestionPanel,
	#superclass : #GRComponent,
	#category : #'Dworphic-HandTracking'
}

{ #category : #'as yet unclassified' }
PinchtypeSuggestionPanel >> render: props [ 
	| size viewportTex |
	size := 600 @ 400.
	viewportTex := self useState: nil.
	^ props
		extract: [:suggestions | 
			^ {GDViewport new name: 'pinchtypeSuggestionsViewport';
				 size: size;
				 renderTargetVFlip: true;
				 renderTargetUpdateMode: GDViewport updateAlways;
				
				subscribeCall: 'get_texture'
				with: #()
				do: [:tex | viewportTex set: tex];
				 children: {GDControl new rectSize:size;
					 children: {GDScrollContainer new rectSize: size;
						 children: {GDLabel new rectSize: size;
							text: ((suggestions first: self suggestionCount) joinSeparatedBy: String crlf)}}}. GDMeshInstance new mesh: (GDQuadMesh new size: 1.5 @ 1;
					 material: (GDSpatialMaterial new flagsUnshaded: true;
						 flagsAlbedoTexForceSrgb: true;
						 albedoTexture: viewportTex get;
						 resourceLocalToScene: true));
				 translation: 0 @ 1 @ 0}]
]

{ #category : #'as yet unclassified' }
PinchtypeSuggestionPanel >> suggestionCount [
	^ 10
]
