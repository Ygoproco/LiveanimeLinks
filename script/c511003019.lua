--メンタルマスター
function c511003019.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(96782886,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c511003019.cost)
	e1:SetTarget(c511003019.target)
	e1:SetOperation(c511003019.operation)
	c:RegisterEffect(e1)
end
function c511003019.cfilter(c,ft,tp)
	return c:IsRace(RACE_PSYCHO) and (ft>0 or (c:IsControler(tp) and c:GetSequence()<5)) and (c:IsControler(tp) or c:IsFaceup())
end
function c511003019.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return Duel.CheckLPCost(tp,800) and ft>-1 and Duel.CheckReleaseGroupCost(tp,c511003019.cfilter,1,false,nil,nil,ft,tp) end
	Duel.PayLPCost(tp,800)
	local sg=Duel.SelectReleaseGroupCost(tp,c511003019.cfilter,1,1,false,nil,nil,ft,tp)
	Duel.Release(sg,REASON_COST)
end
function c511003019.filter(c,e,tp)
	return c:IsRace(RACE_PSYCHO) and c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK)
end
function c511003019.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c511003019.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c511003019.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c511003019.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_ATTACK)
	end
end
