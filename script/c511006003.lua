--Evil Eye of Coercion
--fixed by MLD
function c511006003.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c511006003.condition)
	c:RegisterEffect(e1)
	 --prevent target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_IGNORE_BATTLE_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	c:RegisterEffect(e2)
end
function c511006003.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x8e)
end
function c511006003.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c511006003.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
