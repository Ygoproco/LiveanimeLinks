--Ritual Refinement
function c511009696.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c511009696.condition)
	e1:SetTarget(c511009696.target)
	e1:SetOperation(c511009696.activate)
	c:RegisterEffect(e1)
	aux.CallToken(420)
end
function c511009696.cfilter(c)
	return c:IsFaceup() and c:IsAstral()
end
function c511009696.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c511009696.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c511009696.filter(c,e,tp)
	return c:IsAstral() and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c511009696.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c511009696.cfilter,tp,LOCATION_MZONE,0,nil,e,tp)
	local ct=g:GetCount()*2
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>=ct
		and Duel.IsExistingMatchingCard(c511009696.filter,tp,LOCATION_DECK,0,ct,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,ct,tp,LOCATION_DECK)
end
function c511009696.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	local g=Duel.GetMatchingGroup(c511009696.cfilter,tp,LOCATION_DECK,0,nil,e,tp)
	local ct=g:GetCount()*2
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=ct then return end
	local g=Duel.GetMatchingGroup(c511009696.filter,tp,LOCATION_DECK,0,nil,e,tp)
	if g:GetCount()>=ct then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,ct,ct,nil)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end
