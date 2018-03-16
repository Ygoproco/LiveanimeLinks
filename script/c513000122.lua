--Virus Cannon (Anime)
function c513000122.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c513000122.target)
	e1:SetOperation(c513000122.activate)
	c:RegisterEffect(e1)
end
function c513000122.filter(c)
	return c:IsType(TYPE_SPELL) and c:IsAbleToGrave()
end
function c513000122.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGrave,1-tp,LOCATION_DECK+LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,10,1-tp,LOCATION_DECK+LOCATION_HAND)
end
function c513000122.activate(e,tp,eg,ep,ev,re,r,rp)
	local sg=Group.CreateGroup()
	if Duel.GetMatchingGroupCount(c513000122.filter,1-tp,LOCATION_DECK+LOCATION_HAND,0,nil)<=10 then
		sg=Duel.GetMatchingGroup(c513000122.filter,1-tp,LOCATION_DECK+LOCATION_HAND,0,nil)
	else
		sg=Duel.SelectMatchingCard(1-tp,c513000122.filter,1-tp,LOCATION_DECK+LOCATION_HAND,0,10,10,nil)
	end
	Duel.SendtoGrave(sg,REASON_EFFECT)
end
