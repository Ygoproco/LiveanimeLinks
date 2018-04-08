--Mirror Imagine Secondary 9
--fixed by MLD
function c511009646.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCondition(c511009646.sumcon)
	e2:SetTarget(c511009646.sptg)
	e2:SetOperation(c511009646.sumop)
	c:RegisterEffect(e2)
end
function c511009646.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():IsControler(1-tp)
end
function c511009646.filter(c,e,tp)
	local lv=c:GetLevel()
	return lv>lsc and lv<rsc and c:IsSetCard(0x572) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c511009646.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local lc=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
	local rc=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
	if not lc or not rc then return false end
	local lsc=lc:GetLeftScale()
	local rsc=rc:GetRightScale()
	if lsc>rsc then lsc,rsc=rsc,lsc end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c511009646.filter,tp,LOCATION_DECK,0,1,nil,e,tp,lsc,rsc) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c511009646.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not e:GetHandler():IsRelateToEffect(e) then return end
	local lc=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
	local rc=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
	if not lc or not rc then return end
	local lsc=lc:GetLeftScale()
	local rsc=rc:GetRightScale()
	if lsc>rsc then lsc,rsc=rsc,lsc end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c511009646.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp,lsc,rsc):GetFirst()
	if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)>0 then
		Duel.ChangeAttackTarget(tc)
	end
end
