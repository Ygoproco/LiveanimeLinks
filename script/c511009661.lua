--Motor Worm Bait
function c511009661.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c511009661.condition)
	e1:SetCost(c511009661.cost)
	e1:SetTarget(c511009661.target)
	e1:SetOperation(c511009661.activate)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(43140791,ACTIVITY_SUMMON,c511009661.counterfilter)
	Duel.AddCustomActivityCounter(43140791,ACTIVITY_SPSUMMON,c511009661.counterfilter)
end
function c511009661.counterfilter(c)
	return c:GetLevel()~=3 and c:GetLevel()~=4
end
function c511009661.cfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_INSECT)
end
function c511009661.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c511009661.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c511009661.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(43140791,tp,ACTIVITY_SUMMON)==0
		and Duel.GetCustomActivityCount(43140791,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c511009661.sumlimit)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SUMMON)
	Duel.RegisterEffect(e2,tp)
end
function c511009661.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
	local lv=c:GetLevel()
	return lv==3 or lv==4
end
function c511009661.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsPlayerCanSpecialSummonMonster(tp,511009659,0x3e,0x4011,0,0,1,RACE_INSECT,ATTRIBUTE_LIGHT) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
end
function c511009661.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsPlayerCanSpecialSummonMonster(tp,511009659,0x3e,0x4011,0,0,1,RACE_INSECT,ATTRIBUTE_LIGHT) then
		for i=1,2 do
			local token=Duel.CreateToken(tp,511009659)
			Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		end
		Duel.SpecialSummonComplete()
	end
end
