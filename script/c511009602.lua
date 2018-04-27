--Tentacluster Drillworm
function c511009602.initial_effect(c)
	--handes
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(511009602,0))
	e1:SetCategory(CATEGORY_HANDES+CATEGORY_DAMAGE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetCondition(c511009602.condition)
	e1:SetTarget(c511009602.target)
	e1:SetOperation(c511009602.operation)
	c:RegisterEffect(e1)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(511009602,0))
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1)
	e1:SetCondition(c511009602.spcon)
	e1:SetCost(c511009602.spcost)
	e1:SetTarget(c511009602.sptg)
	e1:SetOperation(c511009602.spop)
	c:RegisterEffect(e1)
end
function c511009602.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_EFFECT) and c:IsPreviousPosition(POS_ATTACK)
end
function c511009602.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,1-tp,1)
end
function c511009602.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	if g:GetCount()>0 then
		local sg=g:RandomSelect(1-tp,1)
		Duel.SendtoGrave(sg,REASON_EFFECT+REASON_DISCARD)
		local tc=sg:GetFirst()
		if tc:IsType(TYPE_MONSTER) then
			local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
			if g:GetCount()>0 then
				local sg=g:RandomSelect(1-tp,1)
				Duel.SendtoGrave(sg,REASON_EFFECT+REASON_DISCARD)
			end
		end
	end
end



function c511009602.cfilter(c)
	return c:GetSequence()<5
end
function c511009602.spcon(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer() and Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)==0 and not Duel.IsExistingMatchingCard(c511009602.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c511009602.rmfilter(c,code)
	return c:IsType(TYPE_MONSTER) and c:IsCode(code) and c:IsAbleToRemoveAsCost() and aux.SpElimFilter(c)
end
function c511009602.cpcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c511009602.rmfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil,e:GetHandler():GetCode()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c511009602.rmfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil,e:GetHandler():GetCode())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c511009602.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,1-tp,1)
end
function c511009602.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	if g:GetCount()>0 then
		local sg=g:RandomSelect(1-tp,1)
		if Duel.SendtoGrave(sg,REASON_EFFECT+REASON_DISCARD))>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) then
			Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
