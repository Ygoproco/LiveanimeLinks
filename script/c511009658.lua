--Motor Worm Spread Queen
function c511009653.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunctionEx(Card.IsRace,RACE_INSECT),2)
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(c511009653.value)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(93503294,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c511009653.spcon)
	e2:SetCost(c511009653.spcost)
	e2:SetTarget(c511009653.sptg)
	e2:SetOperation(c511009653.spop)
	c:RegisterEffect(e2)
	--cannot be battle target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetValue(c511009653.atktg)
	c:RegisterEffect(e3)
end
function c511009653.filter(c)
	return c:IsFaceup() and c:IsRace(RACE_INSECT)
end
function c511009653.value(e,c)
	return Duel.GetMatchingGroupCount(c511009653.filter,0,LOCATION_MZONE,LOCATION_MZONE,nil)*700
end


function c511009653.spcon(e)
	local c=e:GetHandler()
	return c:GetLinkedGroupCount()==0
end
function c511009653.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local zone=e:GetHandler():GetLinkedZone(tp)
		return zone~=0 and 
		Duel.IsPlayerCanSpecialSummonMonster(tp,511009659,0x3e,0x4011,0,0,1,RACE_INSECT,ATTRIBUTE_LIGHT) 
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c511009653.operation(e,tp,eg,ep,ev,re,r,rp)
	local zone=e:GetHandler():GetLinkedZone(tp)
	if zone==0 then return end
	if zone~=0 and Duel.IsPlayerCanSpecialSummonMonster(tp,511009659,0x3e,0x4011,0,0,1,RACE_INSECT,ATTRIBUTE_LIGHT) then
		local token=Duel.CreateToken(tp,511009659)
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
	end
end




function c511009653.atktg(e,c)
	return c:IsCode(511009659) and c:IsFaceup()
end