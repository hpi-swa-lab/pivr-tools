Class {
	#name : #FormDworph,
	#superclass : #GRComponent,
	#category : #'Dworphic-Browsing'
}

{ #category : #'as yet unclassified' }
FormDworph >> render: props [

	^ props extract: [:form :morph :rest | | texture image actualForm |
		image := self useState: nil.
		texture := self useState: nil.
		actualForm := self useState: nil.
		
		self
			useEffect: [
				actualForm set: ((morph ifNotNil: [morph imageForm] ifNil: [form])).
				image set: GDImage externalNew.
				image get
					createFromDataWidth: actualForm get width
					height: actualForm get height
					useMipmaps: false
					format: GDImage formatRgba8
					data: actualForm get bits.
				texture set: GDImageTexture externalNew.
				texture get createFromImage: image get flags: GDTexture flagsDefault.
				[
					image get unreference.
					texture get unreference]]
			dependencies: {morph. form}.
		
		actualForm get ifNotNil: [
			GDMeshInstance new
				setAll: rest;
				mesh: (GDPlaneMesh new
					size: actualForm get extent * 0.001;
					material: (GDSpatialMaterial new albedoTexture: texture get) "Without the use of a shader, colors are off."
					"material: (GDShaderMaterial new
						call: 'set_shader_param' arguments: {'image'. texture get};
						shader: ())")]]
]
