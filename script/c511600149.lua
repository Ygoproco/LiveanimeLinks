--エクセス・レッサーリンカー
--Excess Lesser Linker
--scripted by Larry126
function c511600149.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e1:SetCondition(c511600149.condition)
	e1:SetTarget(c511600149.target)
	e1:SetOperation(c511600149.activate)
	c:RegisterEffect(e1)
end
function c511600149.condition(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if d and a:GetControler()~=d:GetControler() then
		if a:IsControler(tp) and a:IsFaceup() and a:IsType(TYPE_LINK) and a:IsLinkBelow(2) and a:IsRelateToBattle() then e:SetLabelObject(a)
		elseif d:IsFaceup() and d:IsType(TYPE_LINK) and d:IsLinkBelow(2) and d:IsRelateToBattle() then e:SetLabelObject(d)
		else return false end
		return true
	else return false end
end
function c511600149.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=e:GetLabelObject()
	if chk==0 then return tc:IsOnField() end
	Duel.SetTargetCard(tc)
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,tc,1,tp,0)
end
function c511600149.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc or not tc:IsRelateToEffect(e) or not tc:IsRelateToBattle() or tc:IsFacedown() or tc:IsControler(1-tp) then return end
	local bc=tc:GetBattleTarget()
	if not bc or not bc:IsRelateToBattle() or bc:IsFacedown() or bc:IsControler(tp) then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK_FINAL)
	e1:SetValue(bc:GetAttack())
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE_CAL)
	tc:RegisterEffect(e1)
end