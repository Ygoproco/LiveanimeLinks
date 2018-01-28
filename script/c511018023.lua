--Fusion Destruction
function c511018023.initial_effect(c)
	--activate
	local e1 = Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c511018023.cost)
	e1:SetTarget(c511018023.target)
	e1:SetOperation(c511018023.operation)
	c:RegisterEffect(e1)
	--Negate
	local e2 = Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c511018023.negcon)
	e2:SetTarget(c511018023.negtg)
	e2:SetOperation(c511018023.negop)
	c:RegisterEffect(e2)
end
function c511018023.cfilter(c)
	return c:IsCode(24094653) and c:IsAbleToGraveAsCost()
end
function c511018023.cost(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return Duel.IsExistingMatchingCard(c511018023.cfilter, tp, LOCATION_HAND, 0, 1, nil) end
	local tc = Duel.SelectMatchingCard(tp, c511018023.cfilter, tp, LOCATION_HAND, 0, 1, 1, nil)
	Duel.SendtoGrave(tc, REASON_COST)
end
function c511018023.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0x46) and c:IsAbleToRemove() and not c:IsCode(87880531)
end
function c511018023.target(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk then return Duel.GetFieldGroupCount(tp, 0, LOCATION_DECK) > 0 end
	if Duel.IsExistingMatchingCard(c511018023.filter, tp, 0, LOCATION_DECK, 1, nil) then
		e:SetCategory(e:GetCategory()|CATEGORY_REMOVE)
	end
end
function c511018023.operation(e, tp, eg, ep, ev, re, r, rp)
	Duel.ConfirmCards(tp, Duel.GetFieldGroup(tp, 0, LOCATION_DECK))
	local tc = Duel.GetMatchingGroup(c511018023.filter, tp, 0, LOCATION_DECK, nil)
	if tc then
		tc = tc:Select(tp, 3, 3, nil)
		local rem = Duel.Remove(tc, 0, REASON_EFFECT)
		if rem > 0 then
			Duel.Damage(1 - tp, 300*rem, REASON_EFFECT)
		end
	end
end
function c511018023.negcon(e, tp, eg, ep, ev, re, r, rp)
	if rp==tp or e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	local rc = re:GetHandler()
	return not rc:IsCode(87880531) and rc:IsSetCard(0x46) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainNegatable(ev)
end
function c511018023.negtg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c511018023.negop(e, tp, eg, ep, ev, re, r, rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) and Duel.Destroy(eg,REASON_EFFECT) then
		Duel.BreakEffect()
		Duel.Damage(1-tp, 300, REASON_EFFECT)
	end
end