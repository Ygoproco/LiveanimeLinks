--ゲイザー・シャーク
function c511002793.initial_effect(c)
	--xyzlimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetValue(c511002793.xyzlimit)
	c:RegisterEffect(e1)
	--banish
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetOperation(c511002793.rmop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(511002793)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_BE_MATERIAL)
	e4:SetCondition(c511002793.regcon)
	e4:SetOperation(c511002793.regop)
	c:RegisterEffect(e4)
end
function c511002793.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetFlagEffect(511002794)>0 then
		Duel.Remove(c,POS_FACEUP,REASON_EFFECT)
		c:ResetFlagEffect(511002794)
	end
end
function c511002793.xyzlimit(e,c)
	if not c then return false end
	return not e:GetHandler():IsLocation(LOCATION_GRAVE)
end
function c511002793.regcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_XYZ
end
function c511002793.regop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(511002794,RESET_EVENT+0x1fa0000,0,0)
end
