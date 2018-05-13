--ボーン・フロム・ドラコニス (Manga)
--Born from Draconis (Manga)
--fixed by Larry126
function c511000662.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c511000662.target)
	e1:SetOperation(c511000662.activate)
	c:RegisterEffect(e1)
end
function c511000662.cfilter(c)
	return c:IsSetCard(0x93) and c:IsAbleToRemoveAsCost() and aux.SpElimFilter(c,true)
end
function c511000662.filter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0x93) and c:GetLevel()==10
end
function c511000662.mzfilter(c)
	return c:IsLocation(LOCATION_MZONE) and c:GetSequence()<5
end
function c511000662.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local fg=Duel.GetMatchingGroup(c511000662.cfilter,tp,LOCATION_MZONE,0,nil)
		local gg=not Duel.IsPlayerAffectedByEffect(tp,69832741) and Duel.GetMatchingGroup(c511000662.cfilter,tp,LOCATION_GRAVE,0,nil) 
			or Group.CreateGroup()
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		return ((fg:GetCount()>0 and fg:FilterCount(c511000662.mzfilter,nil)+ft>0) or (gg:GetCount()>0 and ft>0)) 
			and Duel.IsExistingMatchingCard(c511000662.filter,tp,LOCATION_HAND,0,1,nil,e,tp)
	end
	local g=Duel.IsPlayerAffectedByEffect(tp,69832741) and Duel.GetMatchingGroup(c511000662.cfilter,tp,LOCATION_MZONE,0,nil)
		or Duel.GetMatchingGroup(c511000662.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c511000662.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,c511000662.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if #sg>0 then
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end