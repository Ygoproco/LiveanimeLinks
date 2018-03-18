--Dandilion (Anime)
--scripted by GameMaster(GM)
--cleaned up by MLD
function c511005643.initial_effect(c)
	--token
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(511005643,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_BATTLE_DESTROYED)
	e1:SetTarget(c511005643.target)
	e1:SetOperation(c511005643.operation)
	c:RegisterEffect(e1)
end
function c511005643.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,0)
end
function c511005643.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=1 
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,15341822,0,0x4011,0,0,1,RACE_PLANT,ATTRIBUTE_WIND) then return end
	for i=1,2 do
		local token=Duel.CreateToken(tp,15341821+i)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
	Duel.SpecialSummonComplete()
end
