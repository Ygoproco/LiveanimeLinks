--Drone Cordon
function c511009740.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c511009740.actcon)
	c:RegisterEffect(e1)

	--cannot be target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c511009740.tg)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
	--cannot attack
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_ATTACK)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(0,LOCATION_MZONE)
	e4:SetTarget(c511009740.atktg)
	c:RegisterEffect(e4)
	aux.CallToken(420)
end

function c511009740.cfilter(c)
	return c:IsFaceup() and c:IsDrone() and c:IsType(TYPE_LINK)
end
function c511009740.actcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c511009740.cfilter,tp,LOCATION_MZONE,0,1,nil)
end

function c511009740.tg(e,c)
	return c:IsDrone() and c:IsFaceup() 
end
function c511009740.indval(e,re,rp)
	return rp~=e:GetHandlerPlayer()
end

function c511009740.atktg(e,c)
	return c:IsType(TYPE_LINK)
end