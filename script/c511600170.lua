--thousand knifes (manga)
function c511600170.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c511600170.condition)
	e1:SetTarget(c511600170.target)
	e1:SetOperation(c511600170.activate)
	c:RegisterEffect(e1)
end
function c511600170.filter(c)
	return c:IsFaceup() and c:IsRace(RACE_SPELLCASTER)
end
function c511600170.condition(e,tp)
	return Duel.IsExistingMatchingCard(c511600170.filter,tp,LOCATION_MZONE,0,1,nil)
end
function c511600170.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c511600170.activate(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	Duel.Destroy(sg,REASON_EFFECT)
end
