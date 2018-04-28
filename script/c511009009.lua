--Mystic Factor Balthazar
function c511009009.initial_effect(c)
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9523599,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_BE_MATERIAL)
	e1:SetCountLimit(1)
	e1:SetCondition(c511009009.condition)
	e1:SetTarget(c511009009.target)
	e1:SetOperation(c511009009.operation)
	c:RegisterEffect(e1)
end
function c511009009.condition(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_FUSION or r==REASON_SYNCHRO
end
function c511009009.mgfilter(c,e,tp,rc)
	return c:IsLocation(LOCATION_GRAVE)
		and (bit.band(c:GetReason(),0x80008)==0x80008 or bit.band(c:GetReason(),0x40008)==0x40008)
		and c:GetReasonCard()==rc
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c511009009.target(e,tp,eg,ep,ev,re,r,rp,chk
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local mg=tc:GetMaterial()
	local ct=mg:GetCount()
	if chk==0 then return ct<=Duel.GetLocationCount(tp,LOCATION_MZONE)
		and (ct==1 or not Duel.IsPlayerAffectedByEffect(tp,59822133))
		and mg:FilterCount(aux.NecroValleyFilter(c511009009.mgfilter),nil,e,tp,rc)==ct end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,mg,mg:GetCount(),0,LOCATION_GRAVE)
end
function c511009009.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local mg=tc:GetMaterial()
	local ct=mg:GetCount()
	if ct>0 and (ct==1 or not Duel.IsPlayerAffectedByEffect(tp,59822133))
		and ct<=Duel.GetLocationCount(tp,LOCATION_MZONE)
		and mg:FilterCount(aux.NecroValleyFilter(c511009009.mgfilter),nil,e,tp,rc)==ct
		then
			Duel.SpecialSummon(mg,0,tp,tp,false,false,POS_FACEUP)
	end
end