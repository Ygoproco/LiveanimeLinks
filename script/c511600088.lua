--ＤＤＤ昇進
--D/D/D Advance
--scripted by Larry126
function c511600088.initial_effect(c)
   --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c511600088.cost)
	e1:SetTarget(c511600088.target)
	e1:SetOperation(c511600088.activate)
	c:RegisterEffect(e1)
end
function c511600088.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then return true end
end
function c511600088.cfilter(c,e,tp)
	return c:IsType(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ) and c:IsAbleToExtraAsCost()
		and Duel.IsExistingMatchingCard(c511600088.spfilter,tp,LOCATION_EXTRA,0,1,nil,c,e,tp)
end
function c511600088.spfilter(c,sc,e,tp)
	return c:IsRace(sc:GetRace()) and c:IsAttribute(sc:GetAttribute())
		and c:IsType(sc:GetType()&(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ))
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c511600088.exfilter(c,e,tp)
	return Duel.IsExistingMatchingCard(c511600088.spfilter,tp,LOCATION_EXTRA,0,1,nil,c,e,tp)
end
function c511600088.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCountFromEx(tp)
	if chk==0 then 
		if e:GetLabel()~=1 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(c511600088.cfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
		and ft>0
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local cg=Duel.SelectMatchingCard(tp,c511600088.cfilter,tp,LOCATION_GRAVE,0,1,ft,nil,e,tp)
	cg:KeepAlive()
	e:SetLabelObject(cg)
	Duel.SendtoDeck(cg,nil,0,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,cg:GetCount(),tp,LOCATION_EXTRA)
end
function c511600088.filter(c,sc)
	return c:IsRace(sc:GetRace()) and c:IsAttribute(sc:GetAttribute())
		and c:IsType(sc:GetType()&(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ))
end
function c511600088.activate(e,tp,eg,ep,ev,re,r,rp)
	local cg=e:GetLabelObject()
	local ct=#cg
	if Duel.GetLocationCountFromEx(tp)<ct or cg:FilterCount(c511600088.exfilter,nil,e,tp)<ct then return end
	local sg=Group.CreateGroup()
	while #sg<ct do
		local dg=Group.CreateGroup()
		local tg=Group.CreateGroup()
		local ig=Group.CreateGroup()
		for c in aux.Next(cg) do
			if sg:IsExists(c511600088.filter,1,ig,c) then
				ig=ig+sg:Filter(c511600088.filter,ig,c):GetFirst()
				ig=ig+c
			end
		end
		for c in aux.Next(cg-ig) do
			tg=tg+c
		end
		for c in aux.Next(tg) do
			dg=dg+Duel.GetMatchingGroup(c511600088.spfilter,tp,LOCATION_EXTRA,0,dg,c,e,tp)
		end
		local tc=Group.SelectUnselect(dg,sg,tp,false,false,ct,ct)
		if not sg:IsContains(tc) then
			sg=sg+tc
		else
			sg=sg-tc
		end
	end
	if #sg>0 then
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end