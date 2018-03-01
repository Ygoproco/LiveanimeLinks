--Lemoine Point
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
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e2:SetCondition(c511009625.atcon)
	e1:SetValue(c511009625.atlimit)
	c:RegisterEffect(e1)
end
function c511009625.sdcon(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_MZONE,0)==0
end
function c511009625.atlimit(e,c)
	return c:IsPosition(POS_FACEDOWN_DEFENSE)
end
function c511009625.atcon(e)
	return Duel.IsExistingMatchingCard(Card.IsSetCard,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil,0x10b)
end