--Lemoine Point
--fixed by MLD
function c511009625.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--selfdes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EFFECT_SELF_DESTROY)
	e2:SetCondition(c511009625.sdcon)
	c:RegisterEffect(e2)
	--at limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetCondition(c511009625.atcon)
	e3:SetValue(aux.TargetBoolFunction(Card.IsPosition,POS_FACEDOWN_DEFENSE))
	c:RegisterEffect(e3)
end
function c511009625.sdcon(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_MZONE,0)==0
end
function c511009625.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x10b)
end
function c511009625.atcon(e)
	return Duel.IsExistingMatchingCard(c511009625.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
