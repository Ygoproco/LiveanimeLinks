--Mirror Imagine Primary 6
function c511009643.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(511009643,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCondition(c511009643.spcon)
	e1:SetTarget(c511009643.sptg)
	e1:SetOperation(c511009643.spop)
	c:RegisterEffect(e1)
	
end
function c511009643.cfilter(c,tp)
	return c:GetSummonPlayer()==tp and c:IsSummonType(SUMMON_TYPE_PENDULUM) and c:GetPreviousLocation()==LOCATION_HAND
end
function c511009643.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c511009643.cfilter,1,nil,tp) and eg:GetCount()==1
end
function c511009643.filter(c,e,tp)
	return c:IsSetCard(0x572) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c511009643.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c511009643.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c511009643.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c511009643.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
