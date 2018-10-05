--Sacred Sword Thanatos
function c511009160.initial_effect(c)
	aux.AddEquipProcedure(c)
	--atkup
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(300)
	c:RegisterEffect(e3)
	--Token destroy and atk up
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_ADJUST)
	e4:SetRange(LOCATION_SZONE)	
	e4:SetOperation(c511009160.desop)
	c:RegisterEffect(e4)
end
function c511009160.filter(c,e)
	return c:IsType(TYPE_TOKEN) and c:IsDestructable(e)
end
function c511009160.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c511009160.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,e)
	local atk=g:GetSum(Card.GetAttack)
	Duel.Destroy(g,REASON_EFFECT)
	if e:GetHandler():GetEquipTarget() and atk>0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(atk)
		e:GetHandler():GetEquipTarget():RegisterEffect(e1)
	end
end
