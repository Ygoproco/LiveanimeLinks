--Helixx Marmotroll
function c511009614.initial_effect(c)
	--summon with no tribute
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(123709,0))
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(c511009614.ntcon)
	e1:SetCost(c511009614.ntcost)
	c:RegisterEffect(e1)
	
	--damage conversion
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_REVERSE_DAMAGE)
	e2:SetTargetRange(1,0)
	e2:SetValue(c511009614.valcon)
	e2:SetReset(RESET_PHASE+PHASE_END)
	c:RegisterEffect(e2)
end
function c511009614.ntcon(e,c,minc)
	if c==nil then return true end
	local tp=c:GetControler()
	return minc==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0
		and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function c511009614.cfilter(c)
	return c:IsSetCard(0x573) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
end
function c511009614.ntcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c511009614.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c511009614.cfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end

function c511009614.valcon(e,re,r,rp,rc)
	local c=e:GetHandler()
	if bit.band(r,REASON_BATTLE)~=0 then
		local tp=e:GetHandlerPlayer()
		local bc=rc:GetBattleTarget()
		if bc and bc:GetFlagEffect(511009614)==0 then
			c:RegisterFlagEffect(511009614,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
			return true
		end
	end
	return false
end
