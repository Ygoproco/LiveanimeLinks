--Gouki Shout
function c511009686.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetCondition(c511009686.atkcon)
	e2:SetTarget(c511009686.atktg)
	e2:SetValue(c511009686.atkval)
	c:RegisterEffect(e2)
end
function c511009686.atkcon(e)
	c511009686[0]=false
	return Duel.GetCurrentPhase()==PHASE_DAMAGE_CAL 
end
function c511009686.atktg(e,c)
	return c==Duel.GetAttacker() and c:IsSetCard(0xfc)
end
function c511009686.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xfc)
end
function c511009686.atkval(e,c)
	local sg=Duel.GetMatchingGroup(c511009686.filter,tp,LOCATION_MZONE,0,nil)
	local atk=sg:GetCount()*300
	if c511009686[0] then
		c511009686[0]=true
		return atk
	else return 0 end
end
