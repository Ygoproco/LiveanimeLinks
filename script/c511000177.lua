--Necro Wall
function c511000177.initial_effect(c)
	--token
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(511000177,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetProperty(EFFECT_FLAG_REPEAT)
	e1:SetCondition(c511000177.spcon)
	e1:SetTarget(c511000177.sptg)
	e1:SetOperation(c511000177.spop)
	c:RegisterEffect(e1)
end
function c511000177.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c511000177.spfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_ZOMBIE)
end
function c511000177.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ct=Duel.GetMatchingGroupCount(c511000177.spfilter,tp,LOCATION_MZONE,0,c)
	if chk==0 then return ct>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>=ct and not Duel.IsPlayerAffectedByEffect(tp,59822133) 
		and Duel.IsPlayerCanSpecialSummonMonster(tp,511000178,0,0x4011,0,0,1,RACE_ZOMBIE,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,ct,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,ct,tp,0)
end
function c511000177.spop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(c511000177.spfilter,tp,LOCATION_MZONE,0,e:GetHandler())
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<ct or Duel.IsPlayerAffectedByEffect(tp,59822133) 
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,511000178,0,0x4011,0,0,1,RACE_ZOMBIE,ATTRIBUTE_DARK) then return end
	for i=1,ct do
		local token=Duel.CreateToken(tp,511000178)
	end
	Duel.SpecialSummonComplete()
end
