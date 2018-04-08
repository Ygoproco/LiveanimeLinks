--ＥＭペンデュラム・コンダクター
--Performapal Pendulum Conductor
--scripted by Larry126
function c511600094.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1160)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c511600094.sctg)
	e1:SetOperation(c511600094.scop)
	c:RegisterEffect(e1)
	--Attack
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(4013,11))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCondition(c511600094.atcon)
	e2:SetOperation(c511600094.atop)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(511600094,ACTIVITY_SPSUMMON,c511600094.counterfilter)
end
function c511600094.counterfilter(c)
	return not c:IsSummonType(SUMMON_TYPE_PENDULUM)
end
function c511600094.scfilter(c,pc)
	return c:IsType(TYPE_PENDULUM) and not c:IsForbidden() and c:IsLevelAbove(1)
end
function c511600094.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c511600094.scfilter,tp,LOCATION_DECK,0,1,nil,e:GetHandler()) end
end
function c511600094.scop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(29432356,1))
	local g=Duel.SelectMatchingCard(tp,c511600094.scfilter,tp,LOCATION_DECK,0,1,1,nil,c)
	local tc=g:GetFirst()
	if tc and Duel.SendtoExtraP(tc,tp,REASON_EFFECT)>0 then
		local lv=tc:GetLevel()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LSCALE)
		e1:SetValue(lv)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_RSCALE)
		e2:SetValue(lv)
		c:RegisterEffect(e2)
	end
end
function c511600094.atcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCustomActivityCount(511600094,tp,ACTIVITY_SPSUMMON)>0
end
function c511600094.atop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_BATTLED)
	e1:SetCondition(c511600094.discon)
	e1:SetOperation(c511600094.disop)
	Duel.RegisterEffect(e1,tp)
end
function c511600094.discon(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttacker()
	return at and at:IsControler(tp) and at:IsType(TYPE_PENDULUM) and at:IsFaceup()
end
function c511600094.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=Duel.GetAttacker()
	local bc=c:GetBattleTarget()
	if not bc or not bc:IsStatus(STATUS_BATTLE_DESTROYED) then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_TRIGGER)
	e1:SetReset(RESET_EVENT+0x17a0000)
	bc:RegisterEffect(e1)
end