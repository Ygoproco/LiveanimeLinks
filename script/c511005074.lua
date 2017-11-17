--Substitution Shield
--身代わりの盾
--  By Shad3
--cleaned and updated by MLD
function c511005074.initial_effect(c)
	aux.AddEquipProcedure(c)
	--effect
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_EQUIP)
	e1:SetCode(EFFECT_ADD_TYPE)
	e1:SetValue(TYPE_EFFECT)
	c:RegisterEffect(e1)
	--effect gain
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(c511005074.negop)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(c511005074.eftg)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
end
function c511005074.eftg(e,c)
	return e:GetHandler():GetEquipTarget()==c
end
function c511005074.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetFlagEffect(511005074)==0 and Duel.SelectEffectYesNo(tp,c) then
		Duel.Hint(HINT_CARD,0,c:GetOriginalCode())
		Duel.NegateAttack()
		c:RegisterFlagEffect(511005074,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,0)
	end
end
