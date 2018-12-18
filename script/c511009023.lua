--Gouki Unity
--fixed by MLD
function c511009023.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCondition(c511009023.condition)
	e2:SetTarget(c511009023.target)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	c:RegisterEffect(e4)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_SELF_DESTROY)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCondition(c511009023.descon)
	c:RegisterEffect(e4)
end
function c511009023.spcfilter(c)
	return c:GetSequence()>=5 and c:IsSetCard(0xfc)
end
function c511009023.condition(e)
	return Duel.IsExistingMatchingCard(c511009023.spcfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c511009023.target(e,c)
	return c:IsSetCard(0xfc) and c:GetSequence()<5
end
function c511009023.descon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetLP(tp)>Duel.GetLP(1-tp)
end
