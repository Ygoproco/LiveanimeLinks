--Providential Injustice
-- created by Donpax
function c511008500.initial_effect(c)
	local e1 = Effect.CreateEffect(c)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetHintTiming(TIMING_DESTROY)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c511008500.target)
	e1:SetCondition(c511008500.condition)
	e1:SetOperation(c511008500.operation)
	c:RegisterEffect(e1)
end

function c511008500.filter(c, cards)
	local eff = c:GetReasonEffect()
	return c:IsType(TYPE_SYNCHRO) and (eff and eff:GetCategory() & CATEGORY_DISABLE_SUMMON and c511008500.has(cards, eff))
end


function c511008500.has (g, e)
	local c = g:GetFirst()
	while c do
		if c:GetFieldID() == e:GetOwner():GetFieldID() and  c:GetCode() == e:GetOwner():GetCode() then
			return true
		end
		c = g:GetNext()
	end
	return false
end

function c511008500.condition(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckTiming(TIMING_DESTROY) then return false end
	local operatedGroup = Duel.GetOperatedGroup()
	if operatedGroup and operatedGroup:GetCount() > 0 then
		return Duel.IsExistingMatchingCard(c511008500.filter, tp, LOCATION_GRAVE+LOCATION_EXTRA, 0, 1, nil, operatedGroup)
	end
	return false
end

function c511008500.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsDestructable,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c511008500.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc, nil, REASON_EFFECT)
		--Duel.ConfirmCards(1-tp,tc)
	end
end
