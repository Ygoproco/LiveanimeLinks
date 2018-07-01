--Phantasm Emperor, Trilojig
function c511009001.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcMixN(c,false,false,aux.FilterBoolFunction(Card.IsFusionLevel,10),3)
	
end