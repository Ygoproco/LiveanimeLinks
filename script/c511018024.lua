--Destiny Hero - Captain Tenacious (Anime)
function c511018024.initial_effect(c)
	--
	local e1 = Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c511018024.condition)
	e1:SetTarget(c511018024.target)
	e1:SetOperation(c511018024.operation)
	c:RegisterEffect(e1)
end
function c511018024.condition(e, tp, eg, ep, ev, re, r, rp)
	return tp == Duel.GetTurnPlayer()
end
function c511018024.filter(c, e, tp, tid)
	return c:GetReason()&0x21 == 0x21 and c:GetTurnID() == tid - 1 and c:IsType(TYPE_MONSTER) and c:IsSetCard(0xc008)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c511018024.target(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
	local tid=Duel.GetTurnCount()
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c511018024.filter(chkc, e, tp, tid) end
	if chk == 0 then return Duel.IsExistingTarget(c511018024.filter, tp, LOCATION_GRAVE, 0, 1, nil, e, tp, tid) end
	local tg = Duel.SelectTarget(tp, c511018024.filter, tp, LOCATION_GRAVE, 0, 1, 1, nil, e, tp, tid)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,tg,1,0,0)
end
function c511018024.operation(e, tp, eg, ep, ev, re, r, rp)
	local tc = Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end