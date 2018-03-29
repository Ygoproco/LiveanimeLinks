--Regenerative Rose (Anime)
--by CyberCatman
--edited/fixed by GameMaster(GM)
--cleaned up and fixed by MLD
function c511005737.initial_effect(c)
	--rose token
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(31986288,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_DESTROYED)
	e1:SetCondition(c511005737.spcon)
	e1:SetTarget(c511005737.sptg)
	e1:SetOperation(c511005737.spop)
	c:RegisterEffect(e1)
	--atk gain
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c511005737.adcon)
	e2:SetValue(c511005737.adval)
	c:RegisterEffect(e2)
end
function c511005737.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE)
end
function c511005737.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133) and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsPlayerCanSpecialSummonMonster(tp,31986289,0,0x4011,1200,1200,3,RACE_PLANT,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,0)
end
function c511005737.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=1 
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,31986289,0,0x4011,1200,1200,3,RACE_PLANT,ATTRIBUTE_DARK) then return end
	for i=1,2 do
		local token=Duel.CreateToken(tp,31986289)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
	end
	Duel.SpecialSummonComplete()
end
function c511005737.adcon(e)
	if Duel.GetCurrentPhase()~=PHASE_DAMAGE_CAL then return false end
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc and c:IsPosition(POS_FACEUP_ATTACK) and bc:IsPosition(POS_FACEUP_ATTACK) and bc:IsControler(1-e:GetHandlerPlayer())
end
function c511005737.adval(e,c)
	return e:GetHandler():GetBattleTarget():GetAttack()
end
