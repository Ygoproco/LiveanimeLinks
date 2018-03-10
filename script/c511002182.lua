--Blizzard Wall
function c511002182.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_BE_BATTLE_TARGET)
	e1:SetTarget(c511002182.target)
	e1:SetOperation(c511002182.activate)
	c:RegisterEffect(e1)
end
function c511002182.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local d=Duel.GetAttackTarget()
	if chk==0 then return d and d:IsControler(tp) end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,d,1,0,0)
end
function c511002182.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToBattle() then
		Duel.ChangePosition(tc,POS_FACEUP_DEFENSE,POS_FACEDOWN_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_BATTLE_DESTROYED)
		e1:SetOperation(c511002182.ctop)
		tc:RegisterEffect(e1)
	end
end
function c511002182.ctop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetAttacker() and e:GetHandler():GetReasonCard() and e:GetHandler():GetReasonCard()==Duel.GetAttacker() then
		Duel.Hint(HINT_CARD,0,511002182)
		Duel.GetAttacker():AddCounter(0x1015,1,REASON_EFFECT)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetCondition(c511002182.bpcon)
		e1:SetValue(1)
		tc:RegisterEffect(e1)
	end
	e:Reset()
end
function c511002182.bpcon(e)
	if e:GetHandler():GetCounter(0x1015)>0 then
		return true
	else
		e:Reset()
		return false
	end
end
