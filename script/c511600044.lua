--トリックスター・カールマリー (Anime)
--Trickstar Maribold (Anime)
--scripted by Larry126
function c511600044.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c511600044.condition)
	e1:SetCost(c511600044.cost)
	e1:SetTarget(c511600044.target)
	e1:SetOperation(c511600044.activate)
	c:RegisterEffect(e1)
end
function c511600044.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsSummonType,1,nil,SUMMON_TYPE_LINK) and ep==tp
		and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
		and Duel.GetFlagEffect(tp,511600044)==0
end
function c511600044.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToHandAsCost() and c:IsSetCard(0xfb)
end
function c511600044.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c511600044.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c511600044.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SendtoHand(g,tp,REASON_COST)
end
function c511600044.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanSummon(tp) end
end
function c511600044.activate(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e1:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xfb))
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	Duel.RegisterFlagEffect(tp,511600044,RESET_PHASE+PHASE_END,0,1)
end