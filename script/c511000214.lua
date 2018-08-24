--悪夢の十字架
--Nightmare's Chains
--re-scripted by Larry126
function c511000214.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c511000214.condition)
	e1:SetTarget(c511000214.target)
	e1:SetOperation(c511000214.activate)
	c:RegisterEffect(e1)
end
function c511000214.condition(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_TRAP) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainNegatable(ev)
end
function c511000214.filter(c)
	return c:IsFaceup() and c:IsRace(RACE_SPELLCASTER)
end
function c511000214.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c511000214.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c511000214.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	local tc=Duel.SelectMatchingCard(tp,c511000214.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil):GetFirst()
	if tc then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_IGNORE_BATTLE_TARGET)
		tc:RegisterEffect(e2)
	end
end