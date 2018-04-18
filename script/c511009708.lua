--High Drive Booster
function c511009708.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c511009708.hspcon)
	c:RegisterEffect(e1)
end
function c511009708.cfilter(c)
	return c:GetSequence()<5
end
function c511009708.hspcon(e,c)
	if c==nil then return true end
	return not Duel.IsExistingMatchingCard(c511009708.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
