--Gouki Serpent Splash
function c511009607.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,511009607+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c511009607.cost)
	e1:SetTarget(c511009607.target)
	e1:SetOperation(c511009607.activate)
	c:RegisterEffect(e1)
end
function c511009607.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCurrentPhase()==PHASE_MAIN1 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BP)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c511009607.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xfc) and c:IsType(TYPE_LINK) and c:GetBaseAttack()<c:GetAttack()
end
function c511009607.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c511009607.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c511009607.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c511009607.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c511009607.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local dam=tc:GetAttack()-tc:GetBaseAttack()
		Duel.Damage(1-tp,dam,REASON_EFFECT)
	end
end
