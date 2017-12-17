--Ｓｐ－奈落との契約
function c100101003.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1057)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c100101003.condition)
	e1:SetTarget(aux.RPETarget(c100101003.ritual_filter))
	e1:SetOperation(aux.RPEOperation(c100101003.ritual_filter))
	c:RegisterEffect(e1)
end
function c100101003.condition(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
	return tc and tc:GetCounter(0x91)>1
end
function c100101003.ritual_filter(c)
	return c:IsType(TYPE_RITUAL) and c:IsAttribute(ATTRIBUTE_DARK)
end
