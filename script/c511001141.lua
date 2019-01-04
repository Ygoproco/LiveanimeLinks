--沈黙の魔術師 ＬＶ０
--Silent Magician LV0
--fixed by Larry126
function c511001141.initial_effect(c)
	--LV/Attack
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_DRAW)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) return ep~=tp end)
	e1:SetOperation(c511001141.rop)
	c:RegisterEffect(e1)
end
function c511001141.rop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=eg:FilterCount(Card.IsControler,nil,1-tp)
	local lv=c:GetFlagEffectLabel(511001141)
	if lv then
		c:ResetFlagEffect(511001141)
		c:RegisterFlagEffect(511001141,RESET_EVENT+0x1fe0000,EFFECT_FLAG_CLIENT_HINT,1,ct+lv,aux.Stringid(4015,ct+lv))
	else
		c:RegisterFlagEffect(511001141,RESET_EVENT+0x1fe0000,EFFECT_FLAG_CLIENT_HINT,1,ct,aux.Stringid(4015,ct))
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
