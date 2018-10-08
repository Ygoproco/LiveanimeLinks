--テンタクラスター・ドリルワーム
--Tentacluster Drillworm
--fixed by Larry126 & pyrQ
function c511009602.initial_effect(c)
	--handes
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(511009602,0))
	e1:SetCategory(CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCondition(c511009602.condition)
	e1:SetTarget(c511009602.target)
	e1:SetOperation(c511009602.operation)
	c:RegisterEffect(e1)
	--Special Summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(511009602,1))
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e2:SetCategory(CATEGORY_HANDES+CATEGORY_SPECIAL_SUMMON)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1)
	e2:SetCondition(c511009602.spcon)
	e2:SetCost(c511009602.spcost)
	e2:SetTarget(c511009602.sptg)
	e2:SetOperation(c511009602.spop)
	c:RegisterEffect(e2)
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
	if #g>0 then
		local sg=g:RandomSelect(tp,1)
		if Duel.SendtoGrave(sg,REASON_EFFECT)>0 and sg:GetFirst():IsLocation(LOCATION_GRAVE) then
			local tc=Duel.GetOperatedGroup():GetFirst()
			if tc:IsType(TYPE_MONSTER) then
				local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
				if #g>0 then
					local sg2=g:RandomSelect(tp,1)
					Duel.SendtoGrave(sg2,REASON_EFFECT)
				end
			end
		end
	end
end
function c511009602.cfilter(c)
	return c:GetSequence()<5
end
function c511009602.spcon(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer() and Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)==0
		and not Duel.IsExistingMatchingCard(c511009602.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c511009602.rmfilter(c,code)
	return c:IsCode(code) and c:IsAbleToRemoveAsCost() and aux.SpElimFilter(c,true)
end
function c511009602.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c511009602.rmfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,c,c:GetCode()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c511009602.rmfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,c,c:GetCode())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c511009602.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE) end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,1-tp,1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_GRAVE)
end
function c511009602.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	if g:GetCount()>0 then
		local sg=g:RandomSelect(1-tp,1)
		if Duel.SendtoGrave(sg,REASON_EFFECT)>0 and sg:GetFirst():IsLocation(LOCATION_GRAVE)
			and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsRelateToEffect(e)
			and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE) then
			Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		end
	end
end
