--Claret Note
function c511001329.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1c0)
	e1:SetTarget(c511001329.target)
	e1:SetOperation(c511001329.activate)
	c:RegisterEffect(e1)
end
function c511001329.cfilter(c,tp)
	local ct=math.floor(c:GetLevel()/4)
	return c:IsFaceup() and c:IsLevelAbove(4) and Duel.GetLocationCount(tp,LOCATION_MZONE)>=ct 
		and (ct==1 or not Duel.IsPlayerAffectedByEffect(tp,59822133))
end
function c511001329.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c511001329.cfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c511001329.cfilter,tp,0,LOCATION_MZONE,1,nil,tp) 
		and Duel.IsPlayerCanSpecialSummonMonster(tp,511001330,0,0x4011,0,0,1,RACE_WARRIOR,ATTRIBUTE_DARK) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c511001329.cfilter,tp,0,LOCATION_MZONE,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
end
function c511001329.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc then return end
	local ct=math.floor(tc:GetLevel()/4)
	if not tc:IsRelateToEffect(e) or tc:IsFacedown() or Duel.GetLocationCount(tp,LOCATION_MZONE)<ct 
		or (ct>1 and Duel.IsPlayerAffectedByEffect(tp,59822133))
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,511001330,0,0x4011,0,0,1,RACE_WARRIOR,ATTRIBUTE_DARK) then return end
	for i=1,ct do
		local token=Duel.CreateToken(tp,511001330)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
	end
	Duel.SpecialSummonComplete()
end
