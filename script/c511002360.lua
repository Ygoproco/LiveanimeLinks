--Heat Crystals
function c511002360.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c511002360.cost)
	e1:SetTarget(c511002360.target)
	e1:SetOperation(c511002360.activate)
	c:RegisterEffect(e1)
end
function c511002360.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c511002360.cfilter(c)
	return c:IsAttribute(ATTRIBUTE_FIRE) and c:IsAbleToRemoveAsCost() and aux.SpElimFilter(c,true)
end
function c511002360.spfilter(c,e,tp,sg)
	if not c:IsAttribute(ATTRIBUTE_FIRE) or not c:IsType(TYPE_FUSION) or not c:IsSetCard(0x3008) 
		or not c:IsCanBeSpecialSummoned(e,0,tp,true,false) then return false end
	if c:IsLocation(LOCATION_EXTRA) then
		return Duel.GetLocationCountFromEx(tp,tp,sg)>0
	else
		return aux.ChkfMMZ(1)(sg,e,tp)
	end
end
function c511002360.rescon(sg,e,tp,mg)
	return Duel.IsExistingMatchingCard(c511002360.filter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,sg,e,tp,sg)
end
function c511002360.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local chkcost=e:GetLabel()==1
	local cg=Duel.GetMatchingGroup(c511002360.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	if chk==0 then
		if chkcost then
			e:SetLabel(0)
			return cg:GetCount()>1 and aux.SelectUnselectGroup(cg,e,tp,2,2,c511002360.rescon,0)
		else
			return Duel.IsExistingMatchingCard(c511002360.spfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil,e,tp,Group.CreateGroup())
		end
	end
	if chkcost then
		local rg=aux.SelectUnselectGroup(cg,e,tp,2,2,c511002360.rescon,1,tp,HINTMSG_REMOVE)
		Duel.Remove(rg,POS_FACEUP,REASON_COST)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA+LOCATION_GRAVE)
end
function c511002360.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c511002360.spfilter),tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,1,nil,e,tp,Group.CreateGroup())
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
	end
end
