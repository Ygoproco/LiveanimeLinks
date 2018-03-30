--リンク・アトロシティ (Anime)
--Link Atrocity (Anime)
--scripted by Larry126
--cleaned up by MLD
function c511600058.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c511600058.cost)
	e1:SetTarget(c511600058.target)
	e1:SetOperation(c511600058.activate)
	c:RegisterEffect(e1)
end
function c511600058.cfilter(c,tp)
	return c:IsType(TYPE_LINK) and Duel.IsExistingTarget(c511600058.tfilter,tp,LOCATION_MZONE,0,1,c)
end
function c511600058.tfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_LINK)
end
function c511600058.cost(e,tp,eg,ep,ev,re,r,rp)
	e:SetLabel(1)
	return true
end
function c511600058.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c511600058.tfilter(chkc) end
	if chk==0 then
		if e:GetLabel()~=1 then return false end
		e:SetLabel(0)
		return Duel.CheckReleaseGroupCost(tp,c511600058.cfilter,1,false,nil,nil,tp)
	end
	local rg=Duel.SelectReleaseGroupCost(tp,c511600058.cfilter,1,1,false,nil,nil,tp)
	local atk=rg:GetFirst():GetAttack()
	Duel.SetTargetParam(atk)
	Duel.Release(rg,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local tc=Duel.SelectTarget(tp,c511600058.tfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,tc,1,tp,atk)
end
function c511600058.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local atk=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetLabelObject(tc)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetReset(RESET_PHASE+PHASE_END)
		e2:SetTargetRange(0,LOCATION_MZONE)
		e2:SetCondition(c511600058.atkcon)
		e2:SetTarget(c511600058.atktg)
		e2:SetValue(c511600058.atkval)
		e2:SetLabelObject(e1)
		Duel.RegisterEffect(e2,tp)
	end
end
function c511600058.atkcon(e)
	return e:GetLabelObject() and e:GetLabelObject():GetLabelObject()
end
function c511600058.atktg(e,c)
	return Duel.GetAttacker()==e:GetLabelObject():GetLabelObject() and Duel.GetAttackTarget()==c and c:IsType(TYPE_LINK)
end
function c511600058.atkval(e,c)
	return Duel.GetMatchingGroupCount(Card.IsType,0,LOCATION_GRAVE,LOCATION_GRAVE,nil,TYPE_LINK)*-400
end
