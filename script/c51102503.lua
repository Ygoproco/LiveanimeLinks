--Divine Go-D/D/D Zero King Zero G.O.D. Reiji (Manga)
--Scripted by Rundas
local s,id=GetID()
function c51102503.initial_effect(c)
	--change lp to 0
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e1:SetHintTiming(TIMING_BATTLE_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(s.lpcon)
	e1:SetOperation(s.lpop)
	c:RegisterEffect(e1)
	--atkdown when attacked
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_QUICK_F)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e2:SetCondition(s.condition)
	e2:SetOperation(s.operation)
	c:RegisterEffect(e2)
	--tribute
    local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_RELEASE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(s.tributecondition)
	e3:SetTarget(s.tributetarget)
	e3:SetOperation(s.tributeoperation)
	c:RegisterEffect(e3)
	--atk down by tributing at least 1
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetCategory(CATEGORY_ATKCHANGE)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCondition(s.atkcondition)
	e4:SetOperation(s.atkoperation)
	c:RegisterEffect(e4)
	--sending stuff into nirvana by tributing at least 3
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,2))
	e5:SetCategory(CATEGORY_ATKCHANGE)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetCondition(s.deletcondition)
	e5:SetTarget(s.delettarget)
	e5:SetOperation(s.deletoperation)
	c:RegisterEffect(e5)
end

--change lp

function s.lpop(e,tp,eg,ep,ev,re,r,rp)
    Duel.SetLP(1-tp,0)
end

function s.lpcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetAttackedCount()>0 and Duel.GetTurnPlayer()==tp
end

--atkdown when attacked

function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and Duel.GetAttackTarget()==e:GetHandler()
end

function s.operation(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetAttacker()
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_SET_ATTACK_FINAL)
        e1:SetReset(RESET_PHASE+PHASE_DAMAGE_CAL)
        e1:SetValue(0)
        tc:RegisterEffect(e1)
end

--tribute

function s.tributecondition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)>1
end

function s.tributetarget(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
    local g=Duel.GetMatchingGroup(aux.FilterFaceupFunction(Card.IsReleasable),tp,LOCATION_MZONE,0,c)
	if chk==0 then return #g end
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,g,#g,0,0)
end

function s.tributeoperation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=Duel.GetMatchingGroup(aux.FilterFaceupFunction(Card.IsReleasable),tp,LOCATION_MZONE,0,c)
    if Duel.Release(g,REASON_EFFECT)==0 then return end
    if not c:IsRelateToEffect(e) then return end
    local og=Duel.GetOperatedGroup()
    if #og>0 then
	c:RegisterFlagEffect(id,RESET_PHASE+PHASE_END,0,1)
	c:SetFlagEffectLabel(id,#og)
    end
end

--atk down by tributing at least 1

function s.atkcondition(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetHandler():GetFlagEffectLabel(id)
	return ct and ct>=1
end

function s.atkoperation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(0)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end

--sending stuff to nirvana by tributing at least 3

function s.deletcondition(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetHandler():GetFlagEffectLabel(id)
	return ct and ct>=3
end

function s.delettarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD+LOCATION_HAND+LOCATION_GRAVE,1,nil) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD+LOCATION_HAND+LOCATION_GRAVE,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end

function s.deletoperation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE+LOCATION_SZONE+LOCATION_HAND+LOCATION_GRAVE,nil)
	Duel.SendtoDeck(g,nil,-2,REASON_EFFECT)
end