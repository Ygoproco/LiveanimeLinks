--Sunavalon Bloom
function c511009700.initial_effect(c)
	--persistent prochedure
	aux.AddPersistentProcedure(c,0,c511009700.filter,CATEGORY_ATKCHANGE,nil,nil,0x1c0,nil,c511009700.cost,c511009700.target)
	--atk change
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SET_ATTACK)
	e1:SetCondition(c511009700.atkcon)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetTarget(aux.PersistentTargetFilter)
	e1:SetValue(c511009700.atkval)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	--Destroy
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetCondition(c511009700.descon)
	e3:SetOperation(c511009700.desop)
	c:RegisterEffect(e3)
end
function c511009700.filter(c)
	return c:IsType(TYPE_LINK) and c:IsLinkAbove(4) and c:IsRace(RACE_PLANT) and c:GetSequence()>4
end
function c511009700.cfilter(c)
	return c:IsType(TYPE_EFFECT) and not c:IsDisabled()
end
function c511009700.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c511009700.cfilter,tp,0,LOCATION_MZONE,nil)
	if chk==0 then return #g>0 end
	for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1,true)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		tc:RegisterEffect(e2,true)
	end
end
function c511009700.target(e,tp,eg,ep,ev,re,r,rp,tc,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,tc,1,0,0)
end
function c511009700.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_DAMAGE_CAL
end
function c511009700.atkfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c511009700.atkval(e,c)
	return c:GetLinkedGroup():Filter(c511009700.atkfilter,nil):GetSum(Card.GetAttack)
end
function c511009700.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsStatus(STATUS_DESTROY_CONFIRMED) then return false end
	local tc=c:GetFirstCardTarget()
	return tc and eg:IsContains(tc) and tc:IsReason(REASON_DESTROY)
end
function c511009700.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end
