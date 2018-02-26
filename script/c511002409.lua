--Scrap Garage
function c511002409.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCondition(c511002409.condition)
	e1:SetTarget(c511002409.target)
	e1:SetOperation(c511002409.activate)
	c:RegisterEffect(e1)
	aux.CallToken(420)
end
function c511002409.cfilter(c)
	return c:IsMotor() and c:GetPreviousLocation()==LOCATION_MZONE and c:GetPreviousPosition()&POS_FACEUP~=0
end
function c511002409.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c511002409.cfilter,1,nil)
end
function c511002409.filter(c,e,tp)
	return c:IsMotor() and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c511002409.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c511002409.filter,tp,LOCATION_GRAVE,0,nil)
	if chk==0 then return g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>=g:GetCount() end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,g:GetCount(),0,0)
end
function c511002409.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c511002409.filter,tp,LOCATION_GRAVE,0,nil)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=math.min(ft,1) end
	if ft<g:GetCount() then return end
	g:ForEach(function(tc)
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(0)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
		tc:RegisterEffect(e2)
	end)
	Duel.SpecialSummonComplete()
end
