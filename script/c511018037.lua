--Gravity Fluctuation
function c511018037.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c511018037.target)
	e1:SetOperation(c511018037.operation)
	c:RegisterEffect(e1)
end
function c511018037.filter(c,tp)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_EARTH) and Duel.IsExistingMatchingCard(c511018037.dfilter,tp,0,LOCATION_MZONE,1,nil,c:GetAttack())
end
function c511018037.dfilter(c,atk)
	return c:IsFaceup() and c:GetAttack()<=atk
end
function c511018037.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return end
	if chk==0 then return Duel.IsExistingTarget(c511018037.filter,tp,LOCATION_MZONE,0,1,nil,tp) end
	local tc=Duel.SelectTarget(tp,c511018037.filter,tp,LOCATION_MZONE,0,1,1,nil)
	local dg=Duel.GetMatchingGroup(c511018037.dfilter,tp,0,LOCATION_MZONE,1,1,nil,tc:GetFirst():GetAttack())
	dg=dg+tc
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,dg,2,0,0)
end
function c511018037.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		local atk = tc:GetAttack()
		if Duel.Destroy(tc,REASON_EFFECT)~=0 then
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_DESTROY)
			local g=Duel.SelectMatchingCard(1-tp,c511018037.dfilter,tp,0,LOCATION_MZONE,1,1,nil,atk)
			if #g>0 then
				Duel.Destroy(g,REASON_EFFECT)
			end
		end
	end
end