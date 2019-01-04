--バトルドローン・サージェント
--Battledrone Sergeant
--fixed by Larry126
function c511009742.initial_effect(c)
	c:SetSPSummonOnce(511009742)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,function(c) return c:IsDrone() end,1,1)
	--direct attack
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(511009742,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_BATTLE_DAMAGE)
	e1:SetCondition(c511009742.atkcon)
	e1:SetOperation(c511009742.atkop)
	c:RegisterEffect(e1)
	aux.CallToken(420)
end
function c511009742.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and eg:GetFirst():IsControler(tp) and eg:GetFirst():IsDrone() and Duel.GetAttackTarget()==nil 
		and not eg:GetFirst():IsCode(511009742) and not e:GetHandler():IsHasEffect(EFFECT_DIRECT_ATTACK)
end
function c511009742.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DIRECT_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCode(EVENT_ATTACK_ANNOUNCE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e2:SetCondition(c511009742.cond)
		e2:SetOperation(c511009742.op)
		c:RegisterEffect(e2)
	end
end
function c511009742.cond(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttacker()
	return at:IsControler(tp) and at~=e:GetHandler()
end
function c511009742.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
end
