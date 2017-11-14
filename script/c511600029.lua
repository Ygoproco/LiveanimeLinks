--Frontline Disturbance
function c511600029.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c511600029.target)
	e1:SetOperation(c511600029.activate)
	c:RegisterEffect(e1)
end
function c511600029.filter(c)
	return c:IsFaceup() and c:IsLevelBelow(4)
end
function c511600029.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(c511600029.filter,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.SelectTarget(tp,c511600029.filter,tp,0,LOCATION_MZONE,1,1,nil)
end
function c511600029.activate(e)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
		e1:SetCode(EVENT_LEAVE_FIELD)
		e1:SetOperation(c511600029.lfop)
		e1:SetReset(RESET_EVENT+0x47e0000)
		tc:RegisterEffect(e1,true)
	end
end
function c511600029.lfop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,e:GetOwnerPlayer(),HINTMSG_FACEUP)
	local g=Duel.SelectMatchingCard(e:GetOwnerPlayer(),Card.IsFaceup,e:GetOwnerPlayer(),LOCATION_MZONE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc and tc:AddCounter(0x1112,1) then
		--atkdown
		local e1=Effect.CreateEffect(e:GetOwner())
		e1:SetDescription(aux.Stringid(96864105,0))
		e1:SetCategory(CATEGORY_ATKCHANGE)
		e1:SetType(EFFECT_TYPE_QUICK_O)
		e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCost(c511600029.atkcost)
		e1:SetCondition(c511600029.atkcon)
		e1:SetTarget(c511600029.atktg)
		e1:SetOperation(c511600029.atkop)
		tc:RegisterEffect(e1)		
	end
end
function c511600029.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsCanRemoveCounter(tp,0x1112,1,REASON_COST) end
	c:RemoveCounter(tp,0x1112,1,REASON_COST)
end
function c511600029.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler()==Duel.GetAttacker() or e:GetHandler()==Duel.GetAttackTarget()
end
function c511600029.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,g,1,1-tp,LOCATION_MZONE)
end
function c511600029.atkfilter(c)
	return c:IsFaceup() and c:IsDefensePos()
end
function c511600029.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local g=Duel.GetMatchingGroup(c511600029.atkfilter,tp,0,LOCATION_MZONE,nil)
		local def=g:GetSum(Card.GetDefense)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-def)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end