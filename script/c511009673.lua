--Sunvine Burial
function c511009673.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
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
	return c:IsFacedown() 
end
function c511009673.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and c511009673.filter(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(c511009673.filter,tp,0,LOCATION_SZONE,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c511009673.filter,tp,0,LOCATION_SZONE,1,1,e:GetHandler())
end
function c511009673.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if tc:IsFacedown() then Duel.ConfirmCards(tp,tc) end
		if tc:IsType(TYPE_TRAP) then 
			Duel.Remove(tc,POS_UP,REASON_EFFECT)
			local code=tc:GetCode()
			local g=Duel.GetMatchingGroup(Card.IsCode,tp,0,LOCATION_DECK+LOCATION_HAND,nil,code)
			Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
			g=Duel.GetFieldGroup(tp,0,LOCATION_DECK+LOCATION_HAND)
			Duel.ConfirmCards(tp,g)
			Duel.ShuffleDeck(1-tp)
		end
	end
end
