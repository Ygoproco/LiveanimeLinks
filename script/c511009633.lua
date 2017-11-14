--performapal Clay Breaker
function c511009633.initial_effect(c)

	--atk
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(21686473,0))
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_CONFIRM)
	e3:SetCondition(c511009633.atkcon)
	e3:SetOperation(c511009633.atkop)
	c:RegisterEffect(e3)
	
end

function c511009633.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return c:IsRelateToBattle() and bc and bc:IsFaceup() and bc:IsRelateToBattle() and bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_ADVANCE)==SUMMON_TYPE_ADVANCE
end
function c511009633.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM)
end
function c511009633.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	local ct=Duel.GetMatchingGroupCount(c511009633.filter,tp,LOCATION_EXTRA,0,nil)*500
	if c:IsFaceup() and c:IsRelateToBattle() and bc:IsFaceup() and bc:IsRelateToBattle() and ct>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-ct)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		bc:RegisterEffect(e1)
	end
end