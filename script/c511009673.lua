--Sunvine Burial
--fixed by MLD
function c511009673.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c511009673.condition)
	e1:SetTarget(c511009673.target)
	e1:SetOperation(c511009673.activate)
	c:RegisterEffect(e1)
end
function c511009673.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x574)
end
function c511009673.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c511009673.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c511009673.filter(c)
	return c:IsFacedown() and c:GetSequence()<5
end
function c511009673.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and chkc:IsControler(1-tp) and c511009673.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c511009673.filter,tp,0,LOCATION_SZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	Duel.SelectTarget(tp,c511009673.filter,tp,0,LOCATION_SZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,0)
end
function c511009673.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsFacedown() then
		Duel.ConfirmCards(tp,tc)
		if tc:IsType(TYPE_TRAP) and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)>0 then
			Duel.BreakEffect()
			local g=Duel.GetMatchingGroup(Card.IsCode,tp,0,LOCATION_DECK+LOCATION_HAND,nil,tc:GetCode())
			Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		end
	end
end
