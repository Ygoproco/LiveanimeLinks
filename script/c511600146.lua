--サイバース・ブリッジ
--Cyberse Bridge
--scripted by Larry126
function c511600146.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCost(c511600146.cost)
	e1:SetTarget(c511600146.target)
	e1:SetOperation(c511600146.activate)
	c:RegisterEffect(e1)
end
function c511600146.cfilter(c)
	return c:IsRace(RACE_CYBERSE) and c:IsAbleToGraveAsCost()
end
function c511600146.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c511600146.cfilter,tp,LOCATION_HAND,0,1,nil) end
	local c=Duel.SelectMatchingCard(tp,c511600146.cfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(c,REASON_COST)
end
function c511600146.exmfilter(c)
	return c:GetSequence()>=5
end
function c511600146.spfilter(c,e,tp,lv)
	return c:IsRace(RACE_CYBERSE) and c:GetLevel()==lv and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c511600146.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and chkc:GetSequence()>=5 end
	if chk==0 then return Duel.IsExistingTarget(c511600146.exmfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanDraw(tp,1) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c511600146.exmfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c511600146.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local zone=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
	Duel.MoveSequence(tc,math.log(zone,2))
	Duel.BreakEffect()
	if Duel.Draw(tp,1,REASON_EFFECT)>0 then
		local tc=Duel.GetOperatedGroup():GetFirst()
		Duel.ConfirmCards(1-tp,tc)
		Duel.BreakEffect()
		if tc:IsType(TYPE_MONSTER) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsExistingMatchingCard(c511600146.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,tc:GetLevel())
			and Duel.SelectYesNo(tp,2) then
			local sc=Duel.SelectMatchingCard(tp,c511600146.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,tc:GetLevel())
			Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
		else
			Duel.SendtoGrave(tc,REASON_EFFECT)
		end
		Duel.ShuffleHand(tp)
	end
end