--バーニングナックル・スピリッツ
function c511003073.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DECKDES+CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c511003073.target)
	e1:SetOperation(c511003073.operation)
	c:RegisterEffect(e1)
end
function c511003073.filter(c,e,tp)
	return c:IsLevelBelow(4) and c:IsSetCard(0x84) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c511003073.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,1) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c511003073.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c511003073.operation(e,tp,eg,ep,ev,re,r,rp)
	local dc=Duel.GetDecktopGroup(tp,1):GetFirst()
	if dc and Duel.DiscardDeck(tp,1,REASON_EFFECT)>0 and dc:IsSetCard(0x84) then
		Duel.BreakEffect()
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c511003073.filter,tp,LOCATION_GRAVE,0,1,1,dc,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
