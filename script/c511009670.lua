--Sunvine Gardna
--fixed by MLD
function c511009670.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunctionEx(Card.IsRace,RACE_PLANT),1,1)
	--self destroy
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_SELF_DESTROY)
	e1:SetCondition(c511009670.descon)
	c:RegisterEffect(e1)
	-- Damage reduction
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(6552938,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_BE_BATTLE_TARGET)
	e2:SetTarget(c511009670.redtg)
	e2:SetOperation(c511009670.redop)
	c:RegisterEffect(e2)
	--to grave
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(27655513,0))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_DESTROYED)
	e3:SetTarget(c511009670.bptg)
	e3:SetOperation(c511009670.bpop)
	c:RegisterEffect(e3)
end
function c511009670.filter(c,sc,dam)
	return c:IsFaceup() and c:IsSetCard(0x574) and c:IsType(TYPE_LINK) and c:GetLinkedGroup():IsContains(sc) and (not dam or c:GetLink()>0)
end
function c511009670.descon(e)
	return not Duel.IsExistingMatchingCard(c511009670.filter,e:GetHandlerPlayer(),LOCATION_MZONE,LOCATION_MZONE,1,nil,e:GetHandler())
end
function c511009670.redtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c511009670.filter(chkc,c,true) end
	if chk==0 then return Duel.IsExistingTarget(c511009670.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,c,true) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c511009670.filter,tp,LOCATION_MZONE,0,1,1,nil,c,true)
end
function c511009670.redop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_PRE_BATTLE_DAMAGE)
		e2:SetLabel(tc:GetLink())
		e2:SetOperation(c511009670.rdop)
		e2:SetReset(RESET_PHASE+PHASE_DAMAGE)
		Duel.RegisterEffect(e2,tp)
	end
end
function c511009670.rdop(e,tp,eg,ep,ev,re,r,rp)
	local dam=e:GetLabel()*800
	Duel.ChangeBattleDamage(ep,math.max(Duel.GetBattleDamage(tp)-dam,0))
end
function c511009670.bptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<PHASE_BATTLE end
end
function c511009670.bpop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SkipPhase(1-tp,PHASE_BATTLE,RESET_PHASE+PHASE_BATTLE,1)
end
