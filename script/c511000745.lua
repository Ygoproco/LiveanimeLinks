--Phoenix Battle Wing
--fixed by Larry126
function c511000745.initial_effect(c)
	aux.AddEquipProcedure(c)
	--destroy replace
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCode(EFFECT_DESTROY_REPLACE)
	e1:SetCountLimit(1)
	e1:SetTarget(c511000745.desreptg)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp) end)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetTarget(c511000745.reptg)
	e2:SetValue(c511000745.repval)
	e2:SetOperation(function(e,tp,eg,ep,ev,re,r,rp) end)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_ADJUST)
	e3:SetOperation(c511000745.atkop)
	c:RegisterEffect(e3)
end
function c511000745.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	 if chk==0 then return not c:IsReason(REASON_REPLACE) and c:GetEquipTarget() end
	if Duel.SelectEffectYesNo(tp,c) then
		Duel.Hint(HINT_CARD,0,511000745)
		return true
	else return false end
end
function c511000745.repfilter(c,ec)
	return c==ec and not c:IsReason(REASON_REPLACE) and c:GetEquipTarget()
end
function c511000745.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return eg:IsExists(c511000745.repfilter,1,nil,c) end
	c:RegisterFlagEffect(511000745,RESET_EVENT+0x1fe0000,0,1)
	return false
end
function c511000745.repval(e,c)
	return c==e:GetHandler()
end
function c511000745.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=c:GetEquipTarget()
	for i=1,c:GetFlagEffect(511000745) do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_EQUIP)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(tc:GetAttack()*2)
		c:RegisterEffect(e1)
	end 
	c:ResetFlagEffect(511000745) 
end