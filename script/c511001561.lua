--悪夢の三面鏡
--Nighmare Tri-Mirror
--update by Larry126
function c511001561.initial_effect(c)
	--Copy
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c511001561.target)
	e1:SetOperation(c511001561.operation)
	c:RegisterEffect(e1)
	if not c511001561.global_check then
		c511001561.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(c511001561.chk)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge1:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
		Duel.RegisterEffect(ge1,0)
	end
end
function c511001561.chk(e,tp,eg,ep,ev,re,r,rp)
	for tc in aux.Next(eg) do
		if tc:GetSummonPlayer()==0 then 
			Duel.RegisterFlagEffect(0,511001561,RESET_PHASE+PHASE_END,0,1)
		else 
			Duel.RegisterFlagEffect(1,511001561,RESET_PHASE+PHASE_END,0,1)
		end
	end
end
function c511001561.filter(c,tp)
	return c:IsFaceup() and c:GetOriginalLevel()>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,511001562,c:GetOriginalSetCard(),c:GetOriginalType(),c:GetBaseAttack(),c:GetBaseDefense(),c:GetOriginalLevel(),c:GetOriginalRace(),c:GetOriginalAttribute())
end
function c511001561.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetFlagEffect(1-tp,511001561)
	if ct>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then return false end
	if chk==0 then return ct>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>=ct
		and Duel.IsExistingMatchingCard(c511001561.filter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,ct,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,ct,0,0)
end
function c511001561.operation(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetFlagEffect(1-tp,511001561)
	if (ct>1 and Duel.IsPlayerAffectedByEffect(tp,59822133)) or Duel.GetLocationCount(tp,LOCATION_MZONE)<ct
		or not Duel.IsExistingMatchingCard(c511001561.filter,tp,LOCATION_MZONE,0,1,nil,tp) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local tc=Duel.SelectMatchingCard(tp,c511001561.filter,tp,LOCATION_MZONE,0,1,1,nil,tp):GetFirst()
	local c=e:GetHandler()
	for i=1,ct do
		local token=Duel.CreateToken(tp,511001562)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_BASE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(tc:GetBaseAttack())
		e1:SetReset(RESET_EVENT+0xfe0000)
		token:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_BASE_DEFENSE)
		e2:SetValue(tc:GetBaseDefense())
		token:RegisterEffect(e2)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_CHANGE_LEVEL)
		e3:SetValue(tc:GetOriginalLevel())
		token:RegisterEffect(e3)
		local e4=e1:Clone()
		e4:SetCode(EFFECT_CHANGE_RACE)
		e4:SetValue(tc:GetOriginalRace())
		token:RegisterEffect(e4)
		local e5=e1:Clone()
		e5:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e5:SetValue(tc:GetOriginalAttribute())
		token:RegisterEffect(e5)
		local e6=e1:Clone()
		e6:SetCode(EFFECT_CHANGE_CODE)
		e6:SetValue(tc:GetOriginalCode())
		token:RegisterEffect(e6)
		local e7=e1:Clone()
		e7:SetCode(EFFECT_CHANGE_TYPE)
		e7:SetValue(tc:GetOriginalType())
		token:RegisterEffect(e7)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP_ATTACK)
		local e7=Effect.CreateEffect(c)
		e7:SetType(EFFECT_TYPE_SINGLE)
		e7:SetCode(EFFECT_CANNOT_ATTACK)
		e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e7:SetCondition(c511001561.atkcon)
		e7:SetReset(RESET_EVENT+0xfe0000)
		token:RegisterEffect(e7)
		token:CopyEffect(tc:GetOriginalCode(),RESET_EVENT+0xfe0000,1)
	end
	Duel.SpecialSummonComplete()
end
function c511001561.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end