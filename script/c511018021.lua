--Timegazer Magician (Anime)
function c511018021.initial_effect(c)
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetCountLimit(1)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c511018021.target)
	e1:SetOperation(c511018021.operation)
	c:RegisterEffect(e1)
end
function c511018021.filter(c)
	return c:IsType(TYPE_TRAP+TYPE_SPELL)
end
function c511018021.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and chkc:IsControler(tp) and c511018021.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c511018021.filter,tp,LOCATION_SZONE,0,1,nil) end
	Duel.SelectTarget(tp,c511018021.filter,tp,LOCATION_SZONE,0,1,1,nil)
end
function c511018021.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
	end
end