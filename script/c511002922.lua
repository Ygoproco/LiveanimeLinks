--Drop Exchange
function c511002922.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c511002922.cost)
	e1:SetTarget(c511002922.target)
	e1:SetOperation(c511002922.activate)
	c:RegisterEffect(e1)
end
function c511002922.cfilter(c)
	return c:GetLevel()>0 and c:IsAbleToGraveAsCost()
end
function c511002922.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then return true end
end
function c511002922.spfilter(c,lv,e,tp)
	return c:IsLevel(lv) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c511002922.rescon(sg,e,tp,mg)
	local lv=sg:GetSum(Card.GetLevel)
	return aux.ChkfMMZ(1)(sg,e,tp,mg) and Duel.IsExistingMatchingCard(c511002922.spfilter,tp,LOCATION_HAND,0,1,nil,lv,e,tp)
end
function c511002922.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local rg=Duel.GetMatchingGroup(c511002922.cfilter,tp,LOCATION_MZONE,0,nil)
	if chk==0 then
		if e:GetLabel()~=1 then return false end
		e:SetLabel(0)
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2 and aux.SelectUnselectGroup(g,e,tp,2,nil,c511002922.rescon,0)
	end
	local g=aux.SelectUnselectGroup(rg,e,tp,2,nil,c511002922.rescon,1,tp,HINTMSG_TOGRAVE)
	local lv=g:GetSum(Card.GetLevel)
	Duel.SendtoGrave(g,REASON_COST)
	Duel.SetTargetParam(lv)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end 
function c511002922.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local lv=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c511002922.spfilter,tp,LOCATION_HAND,0,1,1,nil,lv,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
