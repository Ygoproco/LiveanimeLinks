--Elemental HERO Absolute Zero (manga)
function c511023011.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcMix(c,true,true,aux.FilterBoolFunction(Card.IsFusionSetCard,0x8),aux.FilterBoolFunctionEx(Card.IsAttribute,ATTRIBUTE_WATER))
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(c511023011.value)
	c:RegisterEffect(e1)
end
c511023011.material_setcode=0x8
function c511023011.filter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WATER)
end
function c511023011.value(e,c)
	return Duel.GetMatchingGroupCount(c511023011.filter,0,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())*500
end