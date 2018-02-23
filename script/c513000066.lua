--ウィジャ盤 (Anime)
--Destiny Board (Anime)
--updated by Larry126
function c513000066.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetTarget(c513000066.target)
	e1:SetCondition(c513000066.condition)
	c:RegisterEffect(e1)
	--win
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(94212438,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetCountLimit(1)
	e2:SetCondition(c513000066.lettercon)
	e2:SetOperation(c513000066.letterop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_ADJUST)
	e3:SetRange(LOCATION_SZONE)
	e3:SetOperation(c513000066.winop)
	c:RegisterEffect(e3)
	--trap spell
	local e4=Effect.CreateEffect(c)
	e4:SetCode(EFFECT_ADD_TYPE)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetValue(TYPE_SPELL)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e5:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e5:SetCondition(c513000066.handcon)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e6:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	c:RegisterEffect(e6)
end
function c513000066.handcon(e)
	return Duel.GetTurnPlayer()==e:GetHandlerPlayer()
end
function c513000066.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsCode,1,nil,31829185)
end
function c513000066.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
	c:RegisterFlagEffect(513000066,RESET_EVENT+0x1fe0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(4013,0))
end
function c513000066.lettercon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_GRAVE,0,1,nil,31829185)
end
function c513000066.letterop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetFlagEffectLabel(513000066)+1
	c:ResetFlagEffect(513000066)
	c:RegisterFlagEffect(513000066,RESET_EVENT+0x1fe0000,EFFECT_FLAG_CLIENT_HINT,1,ct,aux.Stringid(4013,ct))
end
function c513000066.winop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetFlagEffectLabel(513000066)==5 then
		Duel.Win(tp,0x15)
	end
end