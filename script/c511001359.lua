--Tri-Slice
function c511001359.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c511001359.cost)
	e1:SetTarget(c511001359.target)
	e1:SetOperation(c511001359.operation)
	c:RegisterEffect(e1)
end
function c511001359.cfilter(c,e,tp,ft)
	return c:IsRace(RACE_FISH) and (c:IsLevel(6) or c:IsLevel(9) or c:IsLevel(12))
		and (ft>2 or (c:IsControler(tp) and c:GetSequence()<5))
		and Duel.IsExistingMatchingCard(c511001359.spfilter,tp,LOCATION_DECK,0,3,nil,c:GetLevel()/3,e,tp)
end
function c511001359.spfilter(c,lv,e,tp)
	return c:IsLevel(lv) and c:IsAttribute(ATTRIBUTE_WATER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c511001359.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then return true end
end
function c511001359.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then
		if e:GetLabel()~=1 then return false end
		e:SetLabel(0)
		return ft>1 and not Duel.IsPlayerAffectedByEffect(tp,59822133) 
			and Duel.CheckReleaseGroupCost(tp,c511001359.cfilter,1,false,nil,nil,e,tp,ft)
	end
	local g=Duel.SelectReleaseGroupCost(tp,c511001359.cfilter,1,1,false,nil,nil,e,tp,ft)
	local lv=g:GetFirst():GetLevel()/3
	Duel.Release(g,REASON_COST)
	Duel.SetTargetParam(lv)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,3,tp,LOCATION_HAND)
end
function c511001359.operation(e,tp,eg,ep,ev,re,r,rp)
	local lv=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=2 or Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	local g=Duel.GetMatchingGroup(c511001359.spfilter,tp,LOCATION_DECK,0,nil,lv,e,tp)
	if g:GetCount()>2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,3,3,nil)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end
