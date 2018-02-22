--サイレント・ソードマン LV0
function c511001137.initial_effect(c)
	--LV/Attack
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F) 
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c511001137.atkcon)
	e1:SetOperation(c511001137.atkop)
	c:RegisterEffect(e1)
end
function c511001137.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer() and e:GetHandler():IsAttackPos()
end
function c511001137.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=eg:FilterCount(Card.IsControler,nil,1-tp)
	local lv=c:GetFlagEffectLabel(511001137)
	if lv then
		c:ResetFlagEffect(511001137)
		c:RegisterFlagEffect(511001137,RESET_EVENT+0x1fe0000,EFFECT_FLAG_CLIENT_HINT,1,ct+lv,aux.Stringid(4015,ct+lv))
	else
		c:RegisterFlagEffect(511001137,RESET_EVENT+0x1fe0000,EFFECT_FLAG_CLIENT_HINT,1,ct,aux.Stringid(4015,ct))
	end
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e1:SetValue(ct*500)
	c:RegisterEffect(e1)
end