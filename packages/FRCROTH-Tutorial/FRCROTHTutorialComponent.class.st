Class {
	#name : #FRCROTHTutorialComponent,
	#superclass : #GRComponent,
	#category : #'FRCROTH-Tutorial'
}

{ #category : #'as yet unclassified' }
FRCROTHTutorialComponent >> render: props [

	^ GDSpatial new children: {
	GDMeshInstance new mesh: (GDCubeMesh new size: 0.3 asVector3).
	GDCamera new translation: 0 @ 0 @ 0.5.
	GDTimer new autostart: true; onTimeout: []}
]
