--Constructive Destruction
--fixed by MLD
function c511009436.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DEFCHANGE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c511009436.target)
	e1:SetOperation(c511009436.activate)
	c:RegisterEffect(e1)
end
function c511009436.filter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x10af) 
		and Duel.IsExistingMatchingCard(c511009436.deffilter,tp,0,LOCATION_MZONE,1,nil)
end
function c511009436.thfilter(c)
	return c:IsSetCard(0x10af) and c:IsAbleToHand()
end
function c511009436.deffilter(c)
	return c:IsFaceup() and c:GetDefense()>0
end
function c511009436.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c511009436.filter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c511009436.filter,tp,LOCATION_MZONE,0,1,nil,tp) 
		and Duel.IsExistingMatchingCard(c511009436.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c511009436.filter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c511009436.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local g=Duel.GetMatchingGroup(c511009436.thfilter,tp,LOCATION_DECK,0,nil)
	if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) and g:GetCount()>0 then
		Duel.Destroy(tc,REASON_EFFECT)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
	local dc=Duel.SelectMatchingCard(tp,c511009436.deffilter,tp,0,LOCATION_MZONE,1,1,nil):GetFirst()
	if dc then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_DEFENSE_FINAL)
		e1:SetValue(0)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		dc:RegisterEffect(e1)
	end
end
