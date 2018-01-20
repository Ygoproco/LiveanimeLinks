--Timegazer Magician (Anime)
function c511018022.initial_effect(c)
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetCountLimit(1)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c511018022.target)
	e1:SetOperation(c511018022.operation)
	c:RegisterEffect(e1)
end
function c511018022.filter(c)
	return c:IsType(TYPE_MONSTER)
end
function c511018022.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c511018022.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c511018022.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.SelectTarget(tp,c511018022.filter,tp,LOCATION_SZONE,0,1,1,nil)
end
function c511018022.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
	end
end