--Battledrone Sergeant
function c511009742.initial_effect(c)
	c:SetSPSummonOnce(511009742)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c511009742.matfilter,1,1)
	--direct attack
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(511009742,0))
	e3:SetCategory(CATEGORY_RECOVER)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_BATTLE_DAMAGE)
	e3:SetCondition(c511009742.atkcon)
	e3:SetOperation(c511009742.atkop)
	c:RegisterEffect(e3)
	aux.CallToken(420)
end
function c511009742.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and eg:GetFirst():IsControler(tp) and eg:GetFirst():IsDrone() and Duel.GetAttackTarget()==nil and 
	not e:GetHandler():IsHasEffect(EFFECT_DIRECT_ATTACK) and not eg:GetFirst():IsCode(511009742)
end
function c511009742.ftarget(e,c)
	return e:GetLabel()~=c:GetFieldID()
end
function c511009742.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DIRECT_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(27632240,0))
		e1:SetCategory(CATEGORY_TOGRAVE)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EVENT_ATTACK_ANNOUNCE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetCondition(c511009742.cond)
		e1:SetOperation(c511009742.op)
		c:RegisterEffect(e1)
	end
end

function c511009742.cond(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttacker()
	return at:GetControler()==tp and not at==e:GetHandler()
end
function c511009742.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			c:RegisterEffect(e1)
	end
end