--速攻
--Quick Attack
--scripted by Larry126
function c511004016.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c511004016.target)
	e1:SetOperation(c511004016.activate)
	c:RegisterEffect(e1)
end
function c511004016.filter(c)
	return c:IsType(TYPE_FUSION) and c:IsFaceup()
		and c:IsStatus(STATUS_SPSUMMON_TURN) and c:IsSummonType(SUMMON_TYPE_FUSION)
end
function c511004016.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c511004016.filter,tp,LOCATION_MZONE,0,1,nil) end
end
function c511004016.activate(e,tp,eg,ep,ev,re,r,rp)
	local fg=Duel.SelectMatchingCard(tp,c511004016.filter,tp,LOCATION_MZONE,0,1,1,nil)
	if #fg>0 then
		fg:GetFirst():RegisterFlagEffect(511004016,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
	end
end