--リンク・バック
--Link Back
--scripted by Larry126
function c511600205.initial_effect(c)
   --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DECKDES+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c511600205.target)
	e1:SetOperation(c511600205.activate)
	c:RegisterEffect(e1)
end
function c511600205.filter(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_LINK) and c:GetSequence()>4
		and c:GetLink()>0 and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>c:GetLink()
		and Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_CONTROL,c:GetLinkedZone(tp)&0x1f)>0
end
function c511600205.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c511600205.filter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c511600205.filter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
	local tc=Duel.SelectTarget(tp,c511600205.filter,tp,LOCATION_MZONE,0,1,1,nil,tp):GetFirst()
	local ct=tc:GetLink()
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,ct)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,Duel.GetDecktopGroup(tp,ct),ct,tp,LOCATION_DECK)
end
function c511600205.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc or not tc:IsRelateToEffect(e) then return end
	local zone=tc:GetLinkedZone(tp)&0x1f
	if Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_CONTROL,zone)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
		local nseq=math.log(Duel.SelectDisableField(tp,1,LOCATION_MZONE,LOCATION_MZONE,~zone),2)
		Duel.MoveSequence(tc,nseq)
		local ct=tc:GetLink()
		if ct>0 then
			Duel.BreakEffect()
			Duel.DiscardDeck(tp,ct,REASON_EFFECT)
		end
	end
end
