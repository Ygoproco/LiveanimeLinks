--Magnet Force Minus
function c170000123.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCost(aux.RemainFieldCost)
	e1:SetTarget(c170000123.target)
	e1:SetOperation(c170000123.operation)
	c:RegisterEffect(e1)
	aux.CallToken(419)
end
function c170000123.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return e:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c170000123.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsLocation(LOCATION_SZONE) or not c:IsRelateToEffect(e) or c:IsStatus(STATUS_LEAVE_CONFIRMED) then return end
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		if not Duel.Equip(tp,c,tc) then return end
		--Equip limit
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1)
		--must attack
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_EQUIP)
		e3:SetCode(EFFECT_MUST_ATTACK)
		e3:SetCondition(c170000123.becon)
		e3:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e3)
		local e4=e3:Clone()
		e4:SetCode(EFFECT_MUST_ATTACK_MONSTER)
		e4:SetValue(c170000123.atkval)
		c:RegisterEffect(e4)
		local e6=Effect.CreateEffect(c)
		e6:SetCode(EFFECT_ADD_TYPE)
		e6:SetType(EFFECT_TYPE_EQUIP)
		e6:SetValue(TYPE_MINUS)
		e6:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e6)
	else
		c:CancelToGrave(false)
	end
end
function c170000123.atkfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_PLUS)
end
function c170000123.becon(e)
	return Duel.IsExistingMatchingCard(c170000123.atkfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c170000123.atkval(e,c)
	return c170000123.atkfilter(c) and c:IsControler(e:GetHandlerPlayer())
end
