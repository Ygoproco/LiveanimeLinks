--Scripted by Eerie Code
--Ancient Gear Chaos Fusion
--fixed by MLD
function c700000034.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetCost(c700000034.cost)
	e1:SetTarget(c700000034.target)
	e1:SetOperation(c700000034.activate)
	c:RegisterEffect(e1)
end
function c700000034.cfilter(c)
	return c:IsCode(24094653) and c:IsAbleToGraveAsCost()
end
function c700000034.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c700000034.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c700000034.cfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c700000034.matfilter(c,e,tp,fc)
	return c:IsCanBeFusionMaterial(fc) and c:IsType(TYPE_MONSTER) and not c:IsImmuneToEffect(e) and c:IsCanBeSpecialSummoned(e,0,tp,true,false) 
end
function c700000034.spfilter(c,e,tp,rg)
	if not c:IsType(TYPE_FUSION) or not c:IsSetCard(0x7) or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) then return false end
	local minc=c.min_material_count
	local maxc=c.max_material_count
	return minc and aux.SelectUnselectGroup(rg,e,tp,minc,maxc,c700000034.rescon1(c),0)
end
function c700000034.rescon1(fc)
	return	function(sg,e,tp,mg)
				local mg=Duel.GetMatchingGroup(c700000034.matfilter,tp,LOCATION_DECK+LOCATION_EXTRA+LOCATION_GRAVE,0,sg,e,tp,c)
				return (not Duel.IsPlayerAffectedByEffect(tp,59822133) or sg:GetCount()<=1) 
					and aux.SelectUnselectGroup(mg,e,tp,sg:GetCount(),sg:GetCount(),c700000034.rescon2(fc,sg),0)
			end
end
function c700000034.rescon2(fc,remg)
	return	function(sg,e,tp,mg)
				local ect=c29724053 and Duel.IsPlayerAffectedByEffect(tp,29724053) and (c29724053[tp]-1)
				local chkg=remg and remg or Group.CreateGroup()
				Auxiliary.FCheckExact=sg:GetCount()
				local res=Duel.GetLocationCountFromEx(tp,tp,chkg)>=sg:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA) 
					and chkg:FilterCount(aux.MZFilter,nil,tp)+Duel.GetLocationCount(tp,LOCATION_MZONE)>=sg:FilterCount(aux.NOT(Card.IsLocation),nil,LOCATION_EXTRA)
					and chkg:FilterCount(Card.IsLocation,nil,LOCATION_MZONE)+Duel.GetUsableMZoneCount(tp)>=sg:GetCount()
					and (not ect or sg:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA)<ect) and fc:CheckFusionMaterial(sg,nil,tp)
				Auxiliary.FCheckExact=nil
				return res
			end
end
function c700000034.rmfilter(c)
	return c:GetSummonLocation()==LOCATION_EXTRA and c:IsPreviousLocation(LOCATION_MZONE) and c:IsAbleToRemove() and aux.SpElimFilter(c,true)
end
function c700000034.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local rg=Duel.GetMatchingGroup(c700000034.rmfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	if chk==0 then return Duel.IsPlayerCanSpecialSummonCount(tp,2) 
		and Duel.IsExistingMatchingCard(c700000034.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,rg) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local fg=Duel.SelectMatchingCard(tp,c700000034.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,rg)
	Duel.ConfirmCards(1-tp,fg:GetFirst())
	Duel.SetTargetCard(fg)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c700000034.activate(e,tp,eg,ep,ev,re,r,rp)
	local fc=Duel.GetFirstTarget()
	local rg=Duel.GetMatchingGroup(c700000034.rmfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	if not fc or not fc:IsRelateToEffect(e) or not c700000034.spfilter(fc,e,tp,rg) then return end
	local minc=fc.min_material_count
	local maxc=fc.max_material_count
	local rsg=aux.SelectUnselectGroup(rg,e,tp,nil,nil,c700000034.rescon1(fc),1,tp,HINTMSG_REMOVE,c700000034.rescon1(fc))
	local ct=Duel.Remove(rsg,POS_FACEUP,REASON_EFFECT)
	local mg=Duel.GetMatchingGroup(c700000034.matfilter,tp,LOCATION_DECK+LOCATION_EXTRA+LOCATION_GRAVE,0,nil,e,tp,fc)
	if ct<rsg:GetCount() then return end
	local matg=aux.SelectUnselectGroup(mg,e,tp,ct,ct,c700000034.rescon2(fc,rsg),1,tp,HINTMSG_SPSUMMON)
	local mc=matg:GetFirst()
	while mc do
		Duel.SpecialSummonStep(mc,0,tp,tp,true,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		mc:RegisterEffect(e1)
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_DISABLE_EFFECT)
		e3:SetReset(RESET_EVENT+0x1fe0000)
		mc:RegisterEffect(e3)
		mc=matg:GetNext()
	end
	Duel.SpecialSummonComplete()
	Duel.BreakEffect()
	fc:SetMaterial(matg)
	Duel.SendtoGrave(matg,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
	Duel.BreakEffect()
	Duel.SpecialSummon(fc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
end
