--究極進化薬
function c100000318.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c100000318.cost)
	e1:SetTarget(c100000318.target)
	e1:SetOperation(c100000318.activate)
	c:RegisterEffect(e1)
end
function c100000318.cfilter(c,e,tp,rc)
	return c:IsRace(rc) and c:IsAbleToRemoveAsCost() and (c:IsLocation(LOCATION_HAND) or aux.SpElimFilter(c,true))
end
function c100000318.filter(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsRace(RACE_DINOSAUR) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100000318.rescon(sg,e,tp,mg)
	return aux.ChkfMMZ(1)(sg,e,tp,mg) and sg:IsExists(c100000318.chk,1,nil,sg) and Duel.IsExistingMatchingCard(c100000318.filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,sg,e,tp)
end
function c100000318.chk(c,sg)
	return c:IsRace(RACE_MACHINE) and sg:IsExists(Card.IsRace,1,c,RACE_DINOSAUR)
end
function c100000318.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	local g1=Duel.GetMatchingGroup(c100000318.cfilter,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,nil,RACE_MACHINE)
	local g2=Duel.GetMatchingGroup(c100000318.cfilter,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,nil,RACE_DINOSAUR)
	local g=g1:Clone()
	g:Merge(g2)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2 and g1:GetCount()>0 and g2:GetCount()>0 
		and aux.SelectUnselectGroup(g,e,tp,2,2,c100000318.rescon,0) end
	local sg=aux.SelectUnselectGroup(g,e,tp,2,2,c100000318.rescon,1,tp,HINTMSG_REMOVE)
	Duel.Remove(sg,POS_FACEUP,REASON_COST)
end
function c100000318.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(c100000318.filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c100000318.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c100000318.filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
