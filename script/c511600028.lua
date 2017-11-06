--Battle Buffer
--バトル・バッファ
--scripted by Larry126
function c511600028.initial_effect(c)
	c:EnableCounterPermit(0x96)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c511600028.target)
	e1:SetOperation(c511600028.operation)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SET_ATTACK_FINAL)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_ONFIELD,0)
	e2:SetTarget(function(e,c) return c:IsType(TYPE_LINK) and c:IsRace(RACE_CYBERSE) end)
	e2:SetValue(function(e,c) return c:GetBaseAttack()+e:GetHandler():GetCounter(0x96)*700 end)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(82821760,0))
	e3:SetCategory(CATEGORY_COUNTER)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_BATTLED)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c511600028.ctcon)
	e3:SetTarget(c511600028.cttg)
	e3:SetOperation(c511600028.ctop)
	c:RegisterEffect(e3)
end
function c511600028.ctcon(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if d and d:IsControler(tp) then
		return d:IsType(TYPE_LINK) and d:IsRace(RACE_CYBERSE)
	elseif a:IsControler(tp) then
		return a:IsType(TYPE_LINK) and a:IsRace(RACE_CYBERSE)
	end
	return false
end
function c511600028.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0x96)
end
function c511600028.ctop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		e:GetHandler():AddCounter(0x96,1)
	end
end
function c511600028.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc==0 then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsType(TYPE_MONSTER) end
	local ct=Duel.GetMatchingGroupCount(function(c) return c:GetMutualLinkedGroupCount()>0 end,tp,LOCATION_MZONE,0,nil)
	if chk==0 then return ct>0 and Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(511600028,0))
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_MZONE,1,ct,nil)
end
function c511600028.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	for tc in aux.Next(tg) do
		if tc:IsRelateToEffect(e) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_TRIGGER)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			e1:SetCondition(c511600028.rcon)
			e1:SetLabelObject(c)
			e1:SetValue(1)
			tc:RegisterEffect(e1)
		end
	end
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(23289281,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c511600028.destg)
	e2:SetOperation(c511600028.desop)
	e2:SetReset(RESET_EVENT+0x96e0000+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e2)
end
function c511600028.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function c511600028.desop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.Destroy(e:GetHandler(),REASON_EFFECT)
	end
end
function c511600028.rcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetLabelObject()
	local ct=Duel.GetMatchingGroupCount(function(c) return c:GetMutualLinkedGroupCount()>0 end,c:GetControler(),LOCATION_MZONE,0,nil)
	return ct>0
end