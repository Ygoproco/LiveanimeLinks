--マーカーズ・ブレイク
--Arrow Break
--scripted by Larry126
function c511600185.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c511600185.condition)
	e1:SetTarget(c511600185.target)
	e1:SetOperation(c511600185.activate)
	c:RegisterEffect(e1)
	--act set turn
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetCondition(c511600185.actcon)
	c:RegisterEffect(e2)
	--act in hand
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e3:SetCondition(c511600185.handcon)
	c:RegisterEffect(e3)
end
function c511600185.cfilter(c,rate)
	return c:IsFaceup() and c:IsType(TYPE_LINK) and (not rate or c:IsLinkAbove(rate))
end
function c511600185.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp~=ep and re:IsActiveType(TYPE_TRAP) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
		and Duel.IsChainNegatable(ev) and Duel.IsExistingMatchingCard(c511600185.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c511600185.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c511600185.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c511600185.actcon(e)
	return Duel.IsExistingMatchingCard(c511600185.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil,3)
end
function c511600185.handcon(e)
	return Duel.IsExistingMatchingCard(c511600185.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil,4)
end