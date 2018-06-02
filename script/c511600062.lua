--救出劇 (Anime)
--Dramatic Rescue (Anime)
--scripted by Larry126
function c511600062.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_BECOME_TARGET)
	e1:SetCondition(c511600062.condition)
	e1:SetTarget(c511600062.target)
	e1:SetOperation(c511600062.activate)
	c:RegisterEffect(e1)
end
function c511600062.cfilter(c,ft,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and (ft>0 or c:GetSequence()<5)
end
function c511600062.condition(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_TRAP) and eg:IsExists(c511600062.cfilter,1,nil,Duel.GetLocationCount(tp,LOCATION_MZONE),tp)
end
function c511600062.spfilter(c,e,tp,g)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and (not g or not g:IsContains(c))
end
function c511600062.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return ft>-1 and Duel.IsExistingMatchingCard(c511600062.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	local g=eg:Filter(c511600062.cfilter,nil,ft,tp)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c511600062.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()==0 then return end
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,c511600062.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp,g)
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
end