--超融合
function c511003010.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1e0)
	e1:SetCost(c511003010.cost)
	e1:SetTarget(c511003010.target)
	e1:SetOperation(c511003010.activate)
	c:RegisterEffect(e1)
end
function c511003010.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGraveAsCost,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsAbleToGraveAsCost,1,1,REASON_COST)
end
function c511003010.mfilter(c)
	return c:GetOriginalType()&TYPE_MONSTER==TYPE_MONSTER
end
function c511003010.filter2(c,e,tp,m,f)
	return c:IsType(TYPE_FUSION) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,tp)
end
function c511003010.fcheck(tp,sg,fc)
	return not sg or sg:GetCount()==0 or sg:IsExists(Card.IsControler,1,nil,tp)
end
function c511003010.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetFusionMaterial(tp):Filter(Card.IsOnField,nil)
		local g=Duel.GetMatchingGroup(c511003010.mfilter,tp,LOCATION_SZONE,LOCATION_SZONE,nil)
		local reset={}
		g:ForEach(function(tc)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
			e1:SetCode(EFFECT_EXTRA_FUSION_MATERIAL)
			e1:SetValue(1)
			e1:SetReset(RESET_CHAIN)
			tc:RegisterEffect(e1)
			table.insert(reset,e1)
		end)
		local mg1=Duel.GetFusionMaterial(tp):Filter(Card.IsOnField,nil)
		local mg2=Duel.GetFusionMaterial(1-tp):Filter(Card.IsOnField,nil)
		mg1:Merge(mg2)
		Auxiliary.FCheckAdditional=c511003010.fcheck
		Auxiliary.FCheckExact=2
		local res=Duel.IsExistingMatchingCard(c511003010.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg3=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c511003010.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg3,mf)
			end
		end
		Auxiliary.FCheckAdditional=nil
		Auxiliary.FCheckExact=nil
		for _,te in ipairs(reset) do
			te:Reset()
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(aux.FALSE)
	end
end
function c511003010.filter0(c,e)
	return c:IsOnField() and not c:IsImmuneToEffect(e)
end
function c511003010.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c511003010.mfilter,tp,LOCATION_SZONE,LOCATION_SZONE,nil)
	g:ForEach(function(tc)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetCode(EFFECT_EXTRA_FUSION_MATERIAL)
		e1:SetValue(1)
		e1:SetReset(RESET_CHAIN)
		tc:RegisterEffect(e1)
	end)
	local mg1=Duel.GetFusionMaterial(tp):Filter(c511003010.filter0,nil,e)
	local mg2=Duel.GetFusionMaterial(1-tp):Filter(c511003010.filter0,nil,e)
	mg1:Merge(mg2)
	Auxiliary.FCheckAdditional=c511003010.fcheck
	Auxiliary.FCheckExact=2
	local sg1=Duel.GetMatchingGroup(c511003010.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil)
	local mg3=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg3=fgroup(ce,e,tp):Filter(c511003010.filter0,nil)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c511003010.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg3,mf)
	end
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_SPSUMMON_SUCCESS)
		e1:SetOperation(c511003010.sumsuc)
		e1:SetReset(RESET_EVENT+0xfe0000)
		tc:RegisterEffect(e1,true)
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,tp)
			tc:SetMaterial(mat1)
			Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg3,nil,tp)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
	end
	Auxiliary.FCheckAdditional=nil
	Auxiliary.FCheckExact=nil
end
function c511003010.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetChainLimitTillChainEnd(aux.FALSE)
end
