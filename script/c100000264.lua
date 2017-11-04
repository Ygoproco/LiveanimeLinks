--闇に堕ちた天使
function c100000264.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c100000264.cost)
	e1:SetTarget(c100000264.target)
	e1:SetOperation(c100000264.Operation)
	c:RegisterEffect(e1)
end
function c100000264.cosfilter(c,ft)
	return c:IsRace(RACE_FAIRY) and c:IsAbleToGraveAsCost() and (ft>0 or c:GetSequence()<5)
end
function c100000264.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return ft>-1 and Duel.IsExistingMatchingCard(c100000264.cosfilter,tp,LOCATION_MZONE,0,1,nil,ft) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c100000264.cosfilter,tp,LOCATION_MZONE,0,1,1,nil,ft)
	Duel.SendtoGrave(g,REASON_COST)
end
function c100000264.filter(c,e,tp)
	return c:IsRace(RACE_FAIRY) and c:IsAttribute(ATTRIBUTE_DARK) and c:GetLevel()>6
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100000264.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(c100000264.filter,tp,LOCATION_HAND,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c100000264.Operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c100000264.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
