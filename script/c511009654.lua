--Monster Restitch
function c511009654.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c511009654.cost)
	e1:SetTarget(c511009654.target)
	e1:SetOperation(c511009654.activate)
	c:RegisterEffect(e1)
end
function c511009654.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,nil,1,nil) end
	local g=Duel.SelectReleaseGroup(tp,nil,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c511009654.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>2
		and Duel.IsPlayerCanSpecialSummonMonster(tp,511009655,0x56f,0x4011,0,0,1,RACE_ZOMBIE,ATTRIBUTE_DARK,POS_FACEUP,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,3,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,3,0,0)
end
function c511009654.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.GetLocationCount(1-tp,LOCATION_MZONE)<3 then return end
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,511009655,0x56f,0x4011,0,0,1,RACE_ZOMBIE,ATTRIBUTE_DARK,POS_FACEUP,tp) then return end
	for i=1,3 do
		local token=Duel.CreateToken(tp,511009655)
		Duel.SpecialSummonStep(token,0,tp,1-tp,false,false,POS_FACEUP)
	end
	Duel.SpecialSummonComplete()
end
function c511009654.damop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsReason(REASON_DESTROY) then
		Duel.Damage(c:GetPreviousControler(),800,REASON_EFFECT)
	end
	e:Reset()
end
