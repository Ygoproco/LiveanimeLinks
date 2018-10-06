--Capture Drone
function c511009745.initial_effect(c)
	aux.AddPersistentProcedure(c,nil,c511009745.filter,CATEGORY_DISABLE,nil,nil,0x1c0,nil,nil,c511009745.target)
	--disable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetTarget(aux.PersistentTargetFilter)
	c:RegisterEffect(e1)
	--cannot attack
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_ATTACK)
	c:RegisterEffect(e2)
	--cannot release
	local e3=e1:Clone()
	e3:SetCode(EFFECT_UNRELEASABLE_SUM)
	c:RegisterEffect(e3)
	local e4=e1:Clone()
	e4:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	c:RegisterEffect(e4)
	local e5=e1:Clone()
	e5:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	c:RegisterEffect(e5)
	--cannot attack
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_CANNOT_ATTACK)
	e6:SetRange(LOCATION_SZONE)
	e6:SetTargetRange(0,LOCATION_MZONE)
	e6:SetTarget(c511009745.atktg)
	c:RegisterEffect(e6)
	--Destroy
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e7:SetRange(LOCATION_SZONE)
	e7:SetCode(EVENT_LEAVE_FIELD)
	e7:SetCondition(c511009745.descon)
	e7:SetOperation(c511009745.desop)
	c:RegisterEffect(e7)
	--tokens
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_QUICK_O)
	e8:SetCode(EVENT_FREE_CHAIN)
	e8:SetRange(LOCATION_SZONE)
	e8:SetCountLimit(1)
	e8:SetHintTiming(0,TIMING_BATTLE_PHASE)
	e8:SetCondition(c511009745.tkcon)
	e8:SetTarget(c511009745.tktg)
	e8:SetOperation(c511009745.tkop)
	c:RegisterEffect(e1)
end
function c511009745.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_LINK)
end
function c511009745.target(e,tp,eg,ep,ev,re,r,rp,tc,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,tc,1,0,0)
end
function c511009745.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsStatus(STATUS_DESTROY_CONFIRMED) then return false end
	local tc=c:GetFirstCardTarget()
	return tc and eg:IsContains(tc) and tc:IsReason(REASON_DESTROY)
end
function c511009745.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end
function c511009745.atktg(e,c)
	return c:IsType(TYPE_LINK)
end



function c511009745.tkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
		and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function c511009745.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tc=c:GetFirstCardTarget()
	if chk==0 then return Duel.IsPlayerCanSpecialSummonMonster(tp,511009746,0x581,0x4011,0,0,1,RACE_MACHINE,ATTRIBUTE_WIND) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,tp,0)
end
function c511009745.tkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=c:GetFirstCardTarget()
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,511009746,0,0x4011,0,0,1,RACE_CYBERSE,ATTRIBUTE_DARK) then return end
	local ct=tc:GetLink()
	if ct<1 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ct=1 end
	repeat
		local token=Duel.CreateToken(tp,511009746)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		ct=ct-1
	until ct<=0 or not Duel.SelectYesNo(tp,aux.Stringid(511009745,0))
	Duel.SpecialSummonComplete()
end
