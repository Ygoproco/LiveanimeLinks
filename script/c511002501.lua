--グレート・モス
function c511002501.initial_effect(c)
	c:EnableReviveLimit()
	--atk down
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetValue(-500)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c511002501.spcon)
	e2:SetOperation(c511002501.spop)
	c:RegisterEffect(e2)
end
function c511002501.eqfilter(c)
	return c:IsCode(40240595) and c:GetTurnCounter()>=4
end
function c511002501.rfilter(c,ft,tp)
	return c:IsCode(58192742) and c:GetEquipGroup():IsExists(c511002501.eqfilter,1,nil) and (ft>0 or (c:IsControler(tp) and c:GetSequence()<5)) 
		and (c:IsControler(tp) or c:IsFaceup())
end
function c511002501.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return ft>-1 and Duel.CheckReleaseGroup(tp,c511002501.rfilter,1,nil,ft,tp)
end
function c511002501.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectReleaseGroup(tp,c511002501.rfilter,1,1,nil,Duel.GetLocationCount(tp,LOCATION_MZONE),tp)
	Duel.Release(g,REASON_COST)
end
