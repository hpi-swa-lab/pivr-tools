Class {
	#name : #WhisperParams,
	#superclass : #ExternalStructure,
	#category : #'Dworphic-Voice'
}

{ #category : #'field definition' }
WhisperParams class >> fields [

	^ #(#(#strategy #long) #(#nThreads #long) #(#nMaxTextCtx #long) #(#offsetMs #long) #(#durationMs #long) #(#translate #bool) #(#noContext #bool) #(#printSpecialTokens #bool) #(#printProgress #bool) #(#printRealtime #bool) #(#printTimestamps #bool) #(#tokenTimestamps #bool) #(#tholdPt #float) #(#tholdPtsum #float) #(#maxLen #long) #(#speedUp #bool) #(#greedyNPast #long) #(#beamSearchNPast #long) #(#beamSearchBeamWidth #long) #(#beamSearchNBest #long) #(#newSegmentCallback #'void*') #(#newSegmentCallbackUserData #'void*'))
]
