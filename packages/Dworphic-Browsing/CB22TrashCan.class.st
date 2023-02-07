Class {
	#name : #CB22TrashCan,
	#superclass : #GRComponent,
	#category : #'Dworphic-Browsing'
}

{ #category : #'as yet unclassified' }
CB22TrashCan >> render: props [

|methods grabbedMethod trashCanMesh|
methods := props at: #methods.
grabbedMethod := props at: #grabbedMethod.
trashCanMesh := self useTrashCanMesh.



^ GRInteractiveArea new
				onButtonRelease: [:e | e isGrip ifTrue: [e handle ifNotNil: [methods set: [:list | list reject: [:method | method first = e handle]]. grabbedMethod set: nil]]];
				children: {
					GDCollisionShape new
				shape: (GDCylinderShape new
					height: 80cm;
					radius: 20cm).
					GDMeshInstance new
						mesh: trashCanMesh;
						scale: 0.0015 asVector3;
						rotation: Float pi / -2 @ 0 @0.};
				transform: (Matrix4x4 withOffset: self trashCanPosition).

]

{ #category : #constants }
CB22TrashCan >> trashCanPosition [

	^ 1 @ 0 @ 0.
]

{ #category : #resources }
CB22TrashCan >> useTrashCanMesh [

	^ self
		useMemo: [GDResourceLoader instance loadPath: 'res://assets/models/trash_can/trash_can.tres']
		dependencies: #()
]
