--Passion of Baimasse (anime)
--バイ＝マーセの癇癪
function c511010516.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c511010516.condition)
	e1:SetTarget(c511010516.target)
	e1:SetOperation(c511010516.activate)
	c:RegisterEffect(e1)
end
function c511010516.condition(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp then return false end
	return Duel.IsChainNegatable(ev) and re:IsActiveType(TYPE_MONSTER)
end
function c511010516.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c511010516.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
