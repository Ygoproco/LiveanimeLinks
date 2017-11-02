--不滅階級
function c500000124.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c500000124.cost)
	e1:SetTarget(c500000124.target)
	e1:SetOperation(c500000124.activate)
	c:RegisterEffect(e1)
end
function c500000124.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	local rg=Duel.GetReleaseGroup(tp)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2 and rg:GetCount()>1 and aux.SelectUnselectGroup(rg,e,tp,2,2,aux.ChkfMMZ(1),0) end
	local sg=aux.SelectUnselectGroup(rg,e,tp,2,2,aux.ChkfMMZ(1),1,tp,HINTMSG_RELEASE)
	Duel.Release(sg,REASON_COST)
end
function c500000124.filter(c,e,tp)
	if c:IsLevelAbove(7) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) then return true end
	return c:IsCode(6007213,32491822,69890967) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c500000124.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(c500000124.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c500000124.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c500000124.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp):GetFirst()
	if tc then
		local ignore=tc:IsCode(6007213,32491822,69890967)
		Duel.SpecialSummon(tc,0,tp,tp,ignore,false,POS_FACEUP)
	end
end
