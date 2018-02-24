--Sunvine Maiden
function c511009665.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1697104,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCondition(c511009665.condition)
	e1:SetTarget(c511009665.target)
	e1:SetOperation(c511009665.operation)
	c:RegisterEffect(e1)
end
function c511009665.tfilter(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:IsRace(RACE_PLANT) and c:IsControler(tp)
end
function c511009665.condition(e,tp,eg,ep,ev,re,r,rp)
	if rp==tp or not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return tg and tg:GetCount()==1 and tg:IsExists(c511009665.tfilter,1,nil,tp) and Duel.IsChainNegatable(ev)
end
function c511009665.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsStatus(STATUS_CHAINING)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c511009665.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 or not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local c=e:GetHandler()
	Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP)
	Duel.SpecialSummonComplete()
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.NegateActivation(ev)
	end
end
