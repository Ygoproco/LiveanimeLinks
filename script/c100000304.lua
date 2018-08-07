--The Suppression Pluto
function c100000304.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c100000304.target)
	e1:SetOperation(c100000304.operation)
	c:RegisterEffect(e1)
end
function c100000304.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0
		and Duel.IsExistingMatchingCard(c100000304.filter,tp,0,LOCATION_ONFIELD,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	local ac=Duel.AnnounceCard(tp)
	e:GetHandler():SetHint(CHINT_CARD,ac)
	Duel.SetTargetParam(ac)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,ANNOUNCE_CARD)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,0,1,0,0)
end
function c100000304.filter(c,tp)
	return (c:IsControler(1-tp) and c:IsControlerCanBeChanged()) or not c:IsType(TYPE_MONSTER)
end
function c100000304.operation(e,tp,eg,ep,ev,re,r,rp)
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local g=Duel.GetMatchingGroup(Card.IsCode,tp,0,LOCATION_HAND,nil,ac)
	if g:GetCount()>0 then
		Duel.ConfirmCards(tp,g)
		local tc=Duel.SelectMatchingCard(tp,c100000304.filter,tp,0,LOCATION_ONFIELD,1,1,nil,tp):GetFirst()
		if tc and tc:IsLocation(LOCATION_ONFIELD) then
			if tc:IsType(TYPE_MONSTER) then
				Duel.GetControl(tc,tp)
			else
				Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,tc:GetPosition(),true)
			end
		end
	end
	Duel.ShuffleHand(1-tp)
end
