--Arrows Charge
--マーカーズ・チャージ
--scripted by Larry126
function c511600024.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c511600024.condition)
	e1:SetTarget(c511600024.target)
	e1:SetOperation(c511600024.activate)
	c:RegisterEffect(e1)
end
function c511600024.filter(c)
	return c:IsFaceup() and c:GetSequence()>=5 and c:IsType(TYPE_LINK)
end
function c511600024.condition(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c511600024.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	return g and g:GetCount()==2 and g:GetFirst():GetLink()==g:GetNext():GetLink()
end
function c511600024.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c511600024.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
	for c in aux.Next(g) do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetRange(LOCATION_HAND)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetOperation(c511600024.retop)
		c:RegisterEffect(e1)
	end
end
function c511600024.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end