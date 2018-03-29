--DD魔導賢者ガリレイ
function c511001043.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--scale change
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetDescription(aux.Stringid(511001043,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetCountLimit(1)
	e2:SetCondition(c511001043.sccon)
	e2:SetTarget(c511001043.sctg)
	e2:SetOperation(c511001043.scop)
	c:RegisterEffect(e2)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(42110604,0))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e2:SetOperation(c511001043.atkop)
	c:RegisterEffect(e2)
end
function c511001043.sccon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c511001043.filter(c,lsc,rsc)
	return c:IsFaceup() and c:IsAbleToGrave() and (c:IsLevelBelow(lsc) or c:IsLevelBelow(rsc)) and c:IsSummonType(SUMMON_TYPE_PENDULUM)
end
function c511001043.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local lsc=e:GetHandler():GetLeftScale()*2
	local rsc=e:GetHandler():GetRightScale()*2
	local g=Duel.GetMatchingGroup(c511001043.filter,tp,LOCATION_MZONE,0,nil,lsc,rsc)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
end
function c511001043.scop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local lsc=c:GetLeftScale()*2
	local rsc=c:GetRightScale()*2
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_LSCALE)
	e1:SetValue(lsc)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CHANGE_RSCALE)
	e2:SetValue(rsc)
	c:RegisterEffect(e2)
	if c:IsImmuneToEffect(e1) or c:IsImmuneToEffect(e2) then return end
	local g=Duel.GetMatchingGroup(c511001043.filter,tp,LOCATION_MZONE,0,nil,lsc,rsc)
	if g:GetCount()>0 then
		Duel.BreakEffect()
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c511001043.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_PZONE,0,nil)
		local atk=g:GetSum(Card.GetAttack) or 0
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE)
		e1:SetValue(atk)
		c:RegisterEffect(e1)
	end
end
