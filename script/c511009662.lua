--Motor Worm Gate
--fixed by MLD
function c511009662.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--direct attack
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11493868,0))
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c511009662.atkcon)
	e2:SetTarget(c511009662.atktg)
	e2:SetOperation(c511009662.atkop)
	c:RegisterEffect(e2)
end
function c511009662.atkfilter(c,chkatk)
	return c:IsFaceup() and c:IsRace(RACE_INSECT) and (not chkatk or not c:IsHasEffect(EFFECT_DIRECT_ATTACK))
end
function c511009662.cfilter(c)
	return c:IsFaceup() and not c:IsRace(RACE_INSECT)
end
function c511009662.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c511009662.atkfilter,tp,0,LOCATION_MZONE,1,nil) 
		and not Duel.IsExistingMatchingCard(c511009662.cfilter,tp,0,LOCATION_MZONE,1,nil)
end
function c511009662.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c511009662.atkfilter(chkc,true) end
	if chk==0 then return Duel.IsExistingTarget(c511009662.atkfilter,tp,LOCATION_MZONE,0,1,nil,true) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c511009662.atkfilter,tp,LOCATION_MZONE,0,1,1,nil,true)
end
function c511009662.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DIRECT_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
	end
end
