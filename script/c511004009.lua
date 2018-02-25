--Phoenix Battle Wings
--Scripted by edo9300
function c511004009.initial_effect(c)
	aux.AddEquipProcedure(c)
	--Destroy replace and atk increase
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCode(EFFECT_DESTROY_REPLACE)
	e1:SetCountLimit(1)
	e1:SetTarget(c511004009.desreptg)
	c:RegisterEffect(e1)
end
function c511004009.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsReason(REASON_REPLACE) and e:GetHandler():GetEquipTarget() end
	if Duel.SelectYesNo(tp,aux.Stringid(511004009,0)) then
		local tc=e:GetHandler():GetEquipTarget()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(tc:GetAttack()*2)
		tc:RegisterEffect(e1)
		return true
	else return false end
end