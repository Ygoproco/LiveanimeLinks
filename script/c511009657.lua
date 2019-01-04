--Root Ransom Virus
function c511009657.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetCondition(c511009657.condition)
	e1:SetCost(c511009657.cost)
	e1:SetTarget(c511009657.target)
	e1:SetOperation(c511009657.activate)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetOperation(c511009657.regop)
	c:RegisterEffect(e2)	
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCondition(c511009657.con)
	e3:SetOperation(c511009657.activate)
	c:RegisterEffect(e3)
end
function c511009657.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated()
end
function c511009657.costfilter(c)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:GetAttack()==0
end
function c511009657.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroupCost(tp,c511009657.costfilter,1,false,nil,nil) end
	local g=Duel.SelectReleaseGroupCost(tp,c511009657.costfilter,1,1,false,nil,nil)
	Duel.Release(g,REASON_COST)
end
function c511009657.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_LINK) and (c:GetAttack()>0 or not c:IsDisabled())
end
function c511009657.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c511009657.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
end
function c511009657.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c511009657.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	g:ForEach(function(tc)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(0)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE)
		tc:RegisterEffect(e2)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_DISABLE_EFFECT)
		tc:RegisterEffect(e3)
	end)
end
function c511009657.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:SetTurnCounter(0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetOperation(c511009657.rmop)
	if Duel.GetTurnPlayer()~=tp and Duel.GetCurrentPhase()==PHASE_END then
		e1:SetCondition(c511009657.rmcon(0))
		e1:SetLabel(Duel.GetTurnCount())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN,3)
	else
		e1:SetCondition(c511009657.rmcon(1))
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN,2)
	end
	c:RegisterEffect(e1)
end
function c511009657.rmcon(chk)
	return	function(e,tp,eg,ep,ev,re,r,rp)
				return Duel.GetTurnPlayer()==1-tp and (chk==1 or Duel.GetTurnCount()~=e:GetLabel())
			end
end
function c511009657.rmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,511009657)
	local c=e:GetHandler()
	c:SetTurnCounter(c:GetTurnCounter()+1)
	if ct==2 then
		Duel.Remove(c,POS_FACEUP,REASON_EFFECT)
	end
end
function c511009657.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:GetFirst():IsSummonType(SUMMON_TYPE_LINK)
end
