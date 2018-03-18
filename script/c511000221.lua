--Vessel of Illusion
function c511000221.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCondition(c511000221.condition)
	e1:SetTarget(c511000221.target)
	e1:SetOperation(c511000221.operation)
	c:RegisterEffect(e1)
end
function c511000221.cfilter(c,e,tp)
	return c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_MZONE)
		and c:IsPreviousPosition(POS_FACEUP) and c:IsType(TYPE_SPIRIT) and c:IsLocation(LOCATION_GRAVE) 
		and (not e or c:IsRelateToEffect(e))
end
function c511000221.condition(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c511000221.cfilter,nil,tp)
	return g:GetCount()==1
end
function c511000221.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(c511000221.cfilter,nil,tp)
	local ec=g:GetFirst()
	if chk==0 then return eg:IsExists(c511000221.cfilter,1,nil,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and Duel.IsPlayerCanSpecialSummonMonster(tp,511000222,0,0x4011,ec:GetBaseAttack(),ec:GetBaseDefense(),
			ec:GetOriginalLevel(),ec:GetOriginalRace(),ec:GetOriginalAttribute()) end
	Duel.SetTargetCard(ec)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
end
function c511000221.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c511000221.cfilter,nil,e,tp)
	local ec=g:GetFirst()
	if not ec or not ec:IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,511000222,0,0x4011,ec:GetBaseAttack(),ec:GetBaseDefense(),
			ec:GetOriginalLevel(),ec:GetOriginalRace(),ec:GetOriginalAttribute()) then return end
	local token=Duel.CreateToken(tp,511000222)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetValue(ec:GetBaseAttack())
	e1:SetReset(RESET_EVENT+0xfe0000)
	token:RegisterEffect(e1,true)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_BASE_DEFENSE)
	e2:SetValue(ec:GetBaseDefense())
	token:RegisterEffect(e2,true)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_CHANGE_LEVEL)
	e3:SetValue(ec:GetOriginalLevel())
	token:RegisterEffect(e3,true)
	local e4=e1:Clone()
	e4:SetCode(EFFECT_CHANGE_RACE)
	e4:SetValue(ec:GetOriginalRace())
	token:RegisterEffect(e4,true)
	local e5=e1:Clone()
	e5:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	e5:SetValue(ec:GetOriginalAttribute())
	token:RegisterEffect(e5,true)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
end
