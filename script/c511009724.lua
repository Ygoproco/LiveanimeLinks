--ダイナマッスル
--Dinomuscle
--fixed by Larry126
--cleaned up by MLD
function c511009724.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x11a))
	e2:SetValue(400)
	c:RegisterEffect(e2)
	--indes
	local e3=e2:Clone()
	e3:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e3:SetValue(c511009724.indct)
	c:RegisterEffect(e3)
end
function c511009724.indct(e,re,r,rp)
	if r&REASON_BATTLE+REASON_EFFECT~=0 then
		return 1
	else return 0 end
end
