Class {
	#name : #TOBETutorialComponent,
	#superclass : #GRComponent,
	#category : #'TOBE-Tutorial'
}

{ #category : #'as yet unclassified' }
TOBETutorialComponent >> render: props [

	^ GDSpatial new children: {
		GDMeshInstance new mesh: (GDCubeMesh new size: 0.3 asVector3).
		GDCamera new translation: 0 @ 0 @ 1.
		GDTimer new autostart: true; onTimeout: []; waitTime: 1
	}
]
