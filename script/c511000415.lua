--左腕の代償
function c511000415.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c511000415.cost)
	e1:SetTarget(c511000415.target)
	e1:SetOperation(c511000415.operation)
	c:RegisterEffect(e1)
end
function c511000415.cfilter(c)
	return not c:IsAbleToGraveAsCost()
end
function c511000415.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g1=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	g1:RemoveCard(e:GetHandler())
	if chk==0 then return g1:GetCount()>0 and not g1:IsExists(c511000415.cfilter,1,nil) end
	Duel.SendtoGrave(g1,REASON_COST)
end
function c511000415.filter(c)
	return c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c511000415.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c511000415.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c511000415.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c511000415.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end