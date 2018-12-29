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
function c511600088.cfilter(c)
	return c:IsType(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ) and c:IsAbleToExtraAsCost()
end
function c511600088.spfilter(c,e,tp,g)
	return g:IsExists(c511600088.chkfilter,1,nil,c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c511600088.chkfilter(sc,c)
	local tpe=TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ
	return c:IsRace(sc:GetRace()) and c:IsAttribute(sc:GetAttribute()) and c:GetType()&tpe==sc:GetType()&tpe
end
function c511600088.rescon1(g)
	return	function(sg,e,tp,mg)
				local ct=sg:GetCount()
				return aux.SelectUnselectGroup(g,e,tp,ct,ct,c511600088.rescon2(sg),0)
			end
end
function c511600088.rescon2(g)
	return	function(sg,e,tp,mg)
				local gtable={}
				g:ForEach(function(tc)
					table.insert(gtable,tc)
				end)
				return sg:IsExists(c511600088.chk,1,nil,sg,Group.CreateGroup(),table.unpack(gtable))
			end
end
function c511600088.chk(c,sg,g,sc,...)
	local tpe=TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ
	if not c:IsRace(sc:GetRace()) or not c:IsAttribute(sc:GetAttribute()) or c:GetType()&tpe~=sc:GetType()&tpe then return false end
	local res
	if ... then
		g:AddCard(c)
		res=sg:IsExists(c511600088.chk,1,g,sg,g,...)
		g:RemoveCard(c)
	else
		res=true
	end
	return res
end
function c511600088.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCountFromEx(tp)
	local g=Duel.GetMatchingGroup(c511600088.cfilter,tp,LOCATION_GRAVE,0,nil)
	local sg=Duel.GetMatchingGroup(c511600088.spfilter,tp,LOCATION_EXTRA,0,nil,e,tp,g)
	if chk==0 then
		if e:GetLabel()~=1 then return false end
		e:SetLabel(0)
		return ft>0 and aux.SelectUnselectGroup(g,e,tp,nil,1,c511600088.rescon1(sg),0)
	end
	local cg=aux.SelectUnselectGroup(g,e,tp,nil,ft,c511600088.rescon1(sg),1,tp,HINTMSG_TODECK,c511600088.rescon1(sg))
	cg:KeepAlive()
	Duel.SendtoDeck(cg,nil,0,REASON_COST)
	Duel.SetTargetCard(cg)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,cg:GetCount(),tp,LOCATION_EXTRA)
end
function c511600088.filter(c,sc)
	return c:IsRace(sc:GetRace()) and c:IsAttribute(sc:GetAttribute())
		and c:IsType(sc:GetType()&(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ))
end
function c511600088.activate(e,tp,eg,ep,ev,re,r,rp)
	local cg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local ct=#cg
	local sg=Duel.GetMatchingGroup(c511600088.spfilter,tp,LOCATION_EXTRA,0,nil,e,tp,cg)
	if Duel.GetLocationCountFromEx(tp)<ct or not aux.SelectUnselectGroup(sg,e,tp,ct,ct,c511600088.rescon2(cg),0) then return end
	local spg=aux.SelectUnselectGroup(sg,e,tp,ct,ct,c511600088.rescon2(cg),1,tp,HINTMSG_SPSUMMON)
	Duel.SpecialSummon(spg,0,tp,tp,false,false,POS_FACEUP)
end
