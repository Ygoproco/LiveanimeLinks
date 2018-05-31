--リンク・ショート
--Link Short
--scripted by Larry126
function c511600123.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c511600123.target)
	e1:SetOperation(c511600123.activate)
	c:RegisterEffect(e1)
end
function c511600123.filter(c)
	return c:IsType(TYPE_LINK) and c:IsFaceup()
end
function c511600123.mfilter(c)
	return c:GetSequence()<5
end
function c511600123.cfilter(c)
	return c:IsFaceup() and c:GetMutualLinkedGroupCount()>0 and not c:IsDisabled()
end
function c511600123.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and c511600123.cfilter(chkc) and chkc:IsLocation(LOCATION_MZONE) end
	local tg=Duel.GetMatchingGroup(c511600123.cfilter,tp,0,LOCATION_MZONE,nil)
	if chk==0 then return Duel.GetTargetCount(c511600123.cfilter,tp,0,LOCATION_MZONE,nil)==#tg
		and Duel.GetMatchingGroupCount(c511600123.filter,tp,0,LOCATION_MZONE,nil)>=Duel.GetMatchingGroupCount(c511600123.mfilter,tp,LOCATION_MZONE,0,nil)
	end
	Duel.SetTargetCard(tg)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,tg,#tg,1-tp,LOCATION_MZONE)
end
function c511600123.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	for tc in aux.Next(tg) do
		if tc:IsRelateToEffect(e) and tc:IsFaceup() then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e2)
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_CANNOT_ATTACK)
			e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e3)
		end
	end
end