--プロテクション・ウィザード
--Protection Wizard
--scripted by Larry126
function c511600098.initial_effect(c)
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetTarget(c511600098.indtg)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTarget(c511600098.reptg)
	e2:SetValue(c511600098.repval)
	e2:SetOperation(c511600098.repop)
	c:RegisterEffect(e2)
end
function c511600098.indtg(e,c)
	return c:IsType(TYPE_LINK) and c:IsFaceup()
		and (e:GetHandler():GetLinkedGroup():IsContains(c) or c:GetLinkedGroup():IsContains(e:GetHandler()))
end
function c511600098.repfilter(c,tp)
	return c:IsFaceup() and c:IsRace(RACE_CYBERSE) and c:IsLocation(LOCATION_MZONE) and c:IsControler(tp) 
		and c:IsType(TYPE_LINK) and not c:IsReason(REASON_REPLACE) and c:IsReason(REASON_BATTLE)
end
function c511600098.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(c511600098.repfilter,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c511600098.repval(e,c)
	return c511600098.repfilter(c,e:GetHandlerPlayer())
end
function c511600098.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end