--Left Arm Offering (Manga)
--左腕の代償
function c513000180.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c513000180.cost)
	e1:SetTarget(c513000180.target)
	e1:SetOperation(c513000180.operation)
	c:RegisterEffect(e1)
end
function c513000180.cfilter(c)
	return not c:IsAbleToGraveAsCost()
end
function c513000180.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g1=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	g1:RemoveCard(e:GetHandler())
	if chk==0 then return g1:GetCount()>0 and not g1:IsExists(c513000180.cfilter,1,nil) end
	Duel.SendtoGrave(g1,REASON_COST)
end
function c513000180.filter(c)
	return c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c513000180.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c513000180.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c513000180.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c513000180.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
