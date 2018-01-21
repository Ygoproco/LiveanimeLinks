--Scrap-Iron Pitfall
function c511003083.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCost(c511003083.cost)
	e1:SetTarget(c511003083.target)
	e1:SetOperation(c511003083.activate)
	c:RegisterEffect(e1)
end
function c511003083.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		aux.RemainFieldCost(e,tp,eg,ep,ev,re,r,rp,1)
	end
end
function c511003083.filter(c,e,tp)
	return c:GetSummonPlayer()~=tp and c:IsAbleToHand() and (not e or c:IsRelateToEffect(e))
end
function c511003083.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(c511003083.filter,nil,nil,tp)
	if chk==0 then return g:GetCount()==1 end
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function c511003083.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c511003083.filter,nil,e,tp)
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsStatus(STATUS_LEAVE_CONFIRMED) then return end
	if c:IsCanTurnSet() and e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.BreakEffect()
		c:CancelToGrave()
		Duel.ChangePosition(c,POS_FACEDOWN)
		Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
	else
		c:CancelToGrave(false)
	end
end
