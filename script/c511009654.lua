--Monster Restitch
--fixed by MLD
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
	e:SetLabel(1)
	if chk==0 then return Duel.CheckReleaseGroupCost(tp,Card.IsSetCard,1,false,nil,nil,0x56f) end
	local g=Duel.SelectReleaseGroupCost(tp,Card.IsSetCard,1,1,false,nil,nil,0x56f)
	Duel.Release(g,REASON_COST)
end
function c511009654.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)<=2 then return false end
		e:SetLabel(0)
		return not Duel.IsPlayerAffectedByEffect(tp,59822133) 
			and Duel.IsPlayerCanSpecialSummonMonster(tp,511009655,0x56f,0x4011,0,0,1,RACE_ZOMBIE,ATTRIBUTE_DARK)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,3,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,3,tp,0)
end
function c511009654.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=2 
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,511009655,0x56f,0x4011,0,0,1,RACE_ZOMBIE,ATTRIBUTE_DARK) then return end
	for i=1,3 do
		local token=Duel.CreateToken(tp,511009655)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
	end
	Duel.SpecialSummonComplete()
end
