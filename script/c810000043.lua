-- Amplifier (Anime)
function c810000043.initial_effect(c)
	-- Activate
	aux.AddEquipProcedure(c,nil,aux.FilterBoolFunction(Card.IsCode,77585513))
	--Atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(500)
	c:RegisterEffect(e2)
	--register
	local e3=Effect.CreateEffect(c)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_EQUIP)
	e3:SetOperation(c810000043.regop)
	e3:SetLabelObject(e2)
	e3:SetRange(LOCATION_SZONE)
	c:RegisterEffect(e3)
	--atkdown
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1)
	e4:SetLabelObject(e2)
	e4:SetCondition(c810000043.atkcon)
	e4:SetOperation(c810000043.atkop)
	c:RegisterEffect(e4)
end
function c810000043.regop(e,tp,eg,ep,ev,re,r,rp)
	if not eg:IsContains(e:GetHandler()) then return end
	local pe=e:GetLabelObject()
	pe:SetValue(500)
end
function c810000043.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c810000043.atkop(e,tp,eg,ep,ev,re,r,rp)
	local pe=e:GetLabelObject()
	local atk=pe:GetValue()
	pe:SetValue(atk+300)
end
