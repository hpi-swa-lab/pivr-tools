Class {
	#name : #PinchtypeImage,
	#superclass : #GRComponent,
	#category : #'Dworphic-HandTracking'
}

{ #category : #'as yet unclassified' }
PinchtypeImage >> render: props [

	| size texture |
	size := 0.5 @ 0.5 @ 0.
	texture := self
		useMemo: [GDResourceLoader instance loadPath: 'res://assets/handtracking/pinchtype.png']
		dependencies: #().
	^ GDCollisionShape new 
			shape: (GDBoxShape new extents: size;
			children: (GDMeshInstance new mesh: (GDCubeMesh new material: 
			(GDSpatialMaterial new albedoTexture: texture; paramsCullMode: GDSpatialMaterial cullFront ); size: size))).
]
