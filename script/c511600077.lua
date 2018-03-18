--スプール・コード
--Spool Code
--scripted by Larry126
function c511600077.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(15341821,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCondition(c511600077.condition)
	e1:SetTarget(c511600077.target)
	e1:SetOperation(c511600077.activate)
	c:RegisterEffect(e1)
end
function c511600077.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():IsControler(1-tp) and Duel.GetAttackTarget()==nil
		and Duel.IsExistingMatchingCard(Card.IsRace,tp,LOCATION_GRAVE,0,3,nil,RACE_CYBERSE)
end
function c511600077.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,511600078,0,0x4011,0,0,1,RACE_CYBERSE,ATTRIBUTE_LIGHT,POS_FACEUP_DEFENSE) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
end
function c511600077.activate(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if not Duel.NegateAttack() or ft<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,511600078,0,0x4011,0,0,1,RACE_CYBERSE,ATTRIBUTE_LIGHT,POS_FACEUP_DEFENSE) then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	if ft~=1 then
		local ct = {}
		for i=1,math.min(ft,3) do
			ct[#ct+1]=i
		end
		ft=Duel.AnnounceNumber(tp,table.unpack(ct))
	end
	for i=1,ft do
		local token=Duel.CreateToken(tp,511600078)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UNRELEASABLE_SUM)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(1)
		token:RegisterEffect(e1,true)
	end
	Duel.SpecialSummonComplete()
end
