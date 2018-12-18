--モロコシーナ
--fixed by MLD
function c511009921.initial_effect(c)
	--token
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(511009921,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,51109921)
	e1:SetCost(c511009921.spcost)
	e1:SetTarget(c511009921.sptg)
	e1:SetOperation(c511009921.spop)
	c:RegisterEffect(e1)
end
function c511009921.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,500) end
	Duel.PayLPCost(tp,500)
end
function c511009921.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,511009926,0x579,0x4011,100,100,1,RACE_CYBERSE,ATTRIBUTE_WATER) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
end
function c511009921.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and Duel.IsPlayerCanSpecialSummonMonster(tp,511009926,0x579,0x4011,100,100,1,RACE_CYBERSE,ATTRIBUTE_WATER) then
		local token=Duel.CreateToken(tp,511009926)
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
	end
end
