--Sunvine Gardna
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
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_BE_BATTLE_TARGET)
	e2:SetTarget(c511009670.redtg)
	e2:SetOperation(c511009670.redop)
	c:RegisterEffect(e2)
	--to grave
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(27655513,0))
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_DESTROYED)
	e3:SetCondition(c511009670.condition)
	e3:SetTarget(c511009670.target)
	e3:SetOperation(c511009670.operation)
	c:RegisterEffect(e3)
end
function c511009670.desfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x574) and c:IsType(TYPE_LINK) and c:GetLinkedGroup():IsContains(e:GetHandler())
end
function c511009670.descon(e)
	return not Duel.IsExistingMatchingCard(c511009670.desfilter,e:GetHandlerPlayer(),LOCATION_MZONE,LOCATION_MZONE,1,nil,e)
end
function c511009670.filter2(c,card)
	return c:IsFaceup() and c:IsSetCard(0x574) and c:IsType(TYPE_LINK) and c:GetLinkedGroup():IsContains(card)
end
function c511009670.redtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c511009670.filter2(chkc,e:GetHandler()) end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c511009670.filter2,tp,LOCATION_MZONE,0,1,1,nil,e:GetHandler())
end
function c511009670.redop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_PRE_BATTLE_DAMAGE)
		e2:SetCondition(c511009670.rdcon)
		e2:SetLabel(tc:GetLink())
		e2:SetOperation(c511009670.rdop)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE)
		c:RegisterEffect(e2)
	end
end
function c511009670.rdcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==e:GetOwnerPlayer()
end
function c511009670.rdop(e,tp,eg,ep,ev,re,r,rp)
	local red=e:GetLabel()*800
	Duel.ChangeBattleDamage(ep,ev-red)
end
function c511009670.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_BATTLE)
end
function c511009670.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c511009670.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.SkipPhase(1-tp,PHASE_BATTLE,RESET_PHASE+PHASE_BATTLE,1)
end
