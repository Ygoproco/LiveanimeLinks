--World Dino Wrestling
function c511009723.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--cannot attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetCondition(c511009723.atkcon)
	e2:SetTarget(c511009723.atktg)
	c:RegisterEffect(e2)
	--check
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetOperation(c511009723.checkop)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
	--atk
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c511009723.atktg)
	e3:SetCondition(c511009723.atkcon)
	e3:SetValue(400)
	c:RegisterEffect(e3)
end
function c511009723.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x580)
end
function c511009723.atkcon(e)
	return e:GetHandler():GetFlagEffect(511009723)~=0 and Duel.IsExistingMatchingCard(c511009723.filter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c511009723.atktg(e,c)
	return c:GetFieldID()~=e:GetLabel()
end
function c511009723.checkop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetFlagEffect(511009723)~=0 then return end
	local fid=eg:GetFirst():GetFieldID()
	e:GetHandler():RegisterFlagEffect(511009723,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
	e:GetLabelObject():SetLabel(fid)
end
function c511009723.atktg(e,c)
	return c:IsSetCard(0x580) and Duel.GetAttacker()==c
end
function c511009723.atkcon(e)
	return Duel.GetCurrentPhase()==PHASE_DAMAGE_CAL and Duel.GetAttackTarget()~=nil
end