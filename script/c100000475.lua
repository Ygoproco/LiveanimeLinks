--チャージ・フュージョン
function c100000475.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c100000475.target)
	e1:SetOperation(c100000475.activate)
	c:RegisterEffect(e1)
end
function c100000475.filter1(c,e)
	return c:IsLocation(LOCATION_HAND) and not c:IsImmuneToEffect(e)
end
function c100000475.filter2(c,e,tp,m)
	return c:IsType(TYPE_FUSION) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false)
		and c:CheckFusionMaterial(m,nil,tp)
end
function c100000475.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg1=Duel.GetFusionMaterial(tp):Filter(Card.IsLocation,nil,LOCATION_HAND)
		local res=Duel.IsExistingMatchingCard(c100000475.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				res=Duel.IsExistingMatchingCard(c100000475.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c100000475.activate(e,tp,eg,ep,ev,re,r,rp)
	local mg1=Duel.GetFusionMaterial(tp):Filter(c100000475.filter1,nil,e)
	local sg1=Duel.GetMatchingGroup(c100000475.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1)
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		sg2=Duel.GetMatchingGroup(c100000475.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2)
	end
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,tp)
			tc:SetMaterial(mat1)
			Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,nil,tp)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
	end
	local c=e:GetHandler()
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		local res
		local e1=Effect.CreateEffect(c)
		e1:SetCategory(CATEGORY_TOHAND)
		e1:SetType(EFFECT_TYPE_IGNITION)
		e1:SetRange(LOCATION_GRAVE)
		if Duel.GetTurnPlayer()==tp then
			res=3
			e1:SetLabel(Duel.GetTurnCount())
		else
			res=2
			e1:SetLabel(Duel.GetTurnCount()-1)
		end
		e1:SetValue(4)
		e1:SetCondition(c100000475.thcon)
		e1:SetTarget(c100000475.thtg)
		e1:SetOperation(c100000475.thop)
		e1:SetReset(RESET_EVENT+0x17a0000+RESET_PHASE+PHASE_END+RESET_SELF_TURN,res)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
		e2:SetCode(1082946)
		e2:SetLabelObject(e1)
		e2:SetOperation(c100000475.reset)
		e2:SetReset(RESET_EVENT+0x17a0000+RESET_PHASE+PHASE_END+RESET_SELF_TURN,res)
		c:RegisterEffect(e2)
	end
end
function c100000475.reset(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	local val=te:GetValue()
	if Duel.GetTurnCount()==te:GetLabel()+val then
		e:GetHandler():SetTurnCounter(3)
		e:Reset() te:Reset()
	else
		val=val-2
		if Duel.GetTurnCount()==te:GetLabel()+val then
			e:GetHandler():SetTurnCounter(2)
		elseif Duel.GetTurnCount()==te:GetLabel()+val-2 then
			e:GetHandler():SetTurnCounter(1)
		end
		te:SetValue(val)
	end
end
function c100000475.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()==e:GetLabel()+e:GetValue()
end
function c100000475.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c100000475.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
end
