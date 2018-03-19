--ロウリング・Ｄ
--Lowering D
--scripted by Larry126
function c511600087.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(c511600087.condition)
	e1:SetOperation(c511600087.activate)
	c:RegisterEffect(e1)
end
function c511600087.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():IsControler(1-tp) and Duel.GetAttackTarget()==nil
end
function c511600087.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetCondition(c511600087.con)
	e1:SetOperation(c511600087.op)
	Duel.RegisterEffect(e1,tp)
	local at=Duel.GetAttacker()
	if aux.nzdef(at) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(-at:GetDefense())
		at:RegisterEffect(e1)
	end
end
function c511600087.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttackTarget()==nil and aux.nzdef(Duel.GetAttacker())
end
function c511600087.op(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttacker()
	if at and aux.nzdef(at) and at:IsLocation(LOCATION_MZONE) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(-at:GetDefense())
		at:RegisterEffect(e1)
	end
end