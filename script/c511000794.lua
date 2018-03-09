--Hell Spider
function c511000794.initial_effect(c)
	--skip battle phase
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(511000794,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_LEAVE_FIELD)
	e1:SetCondition(c511000794.condition)
	e1:SetOperation(c511000794.operation)
	c:RegisterEffect(e1)
end
function c511000794.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE
end
function c511000794.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.SkipPhase(Duel.GetTurnPlayer(),PHASE_BATTLE,RESET_PHASE+PHASE_BATTLE,1)
end
