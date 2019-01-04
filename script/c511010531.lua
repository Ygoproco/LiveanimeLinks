--Justice Bringer (Anime)
function c511010531.initial_effect(c)
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetCondition(c511010531.condition)
	e1:SetTarget(c511010531.target)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_DISABLE_EFFECT)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_CANNOT_TRIGGER)
	c:RegisterEffect(e3)
end
function c511010531.condition(e)
	return Duel.GetTurnPlayer()~=e:GetHandlerPlayer()
end
function c511010531.target(e,c)
	return bit.band(c:GetSummonType(),SUMMON_TYPE_SPECIAL)~=0
end
