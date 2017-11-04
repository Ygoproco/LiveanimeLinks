--ナンバーズ・イヴォケーション
function c100000277.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c100000277.cost)
	e1:SetTarget(c100000277.target)
	e1:SetOperation(c100000277.activate)
	c:RegisterEffect(e1)
end
function c100000277.cfilter(c,ft,tp)
	return c:IsRace(RACE_SPELLCASTER) and (ft>0 or (c:IsControler(tp) and c:GetSequence()<5)) and (c:IsControler(tp) or c:IsFaceup())
end
function c100000277.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return ft>-1 and Duel.CheckReleaseGroup(tp,c100000277.cfilter,1,nil,ft,tp) end
	local rg=Duel.SelectReleaseGroup(tp,c100000277.cfilter,1,1,nil,ft,tp)
	Duel.Release(rg,REASON_COST)
end
function c100000277.spfilter(c,e,tp)
	return c:IsSetCard(0x48) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100000277.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c100000277.spfilter(chkc,e,tp) end
	if chk==0 then
		if e:GetLabel()==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return false end
		e:SetLabel(0)
		return Duel.IsExistingTarget(c100000277.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c100000277.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c100000277.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
