--聖花葬
--Sunbloom Doom
--scripted by Larry126
function c511600207.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c511600207.condition)
	e1:SetTarget(c511600207.target)
	e1:SetOperation(c511600207.activate)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c511600207.destg)
	e2:SetOperation(c511600207.desop)
	c:RegisterEffect(e2)
	if not c511600207.global_check then
		c511600207.global_check=true
		local e1=Effect.GlobalEffect()
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAINING)
		e1:SetCondition(c511600207.regcon)
		e1:SetOperation(c511600207.regop1)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.GlobalEffect()
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_CHAIN_NEGATED)
		e2:SetCondition(c511600207.regcon)
		e2:SetOperation(c511600207.regop2)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
	end
end
function c511600207.regcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end
function c511600207.regop1(e,tp,eg,ep,ev,re,r,rp)
	re:GetHandler():RegisterFlagEffect(511600207,RESET_EVENT+RESETS_STANDARD+RESET_OVERLAY-RESET_TOGRAVE-RESET_LEAVE+RESET_PHASE+PHASE_END,0,1)
end
function c511600207.regop2(e,tp,eg,ep,ev,re,r,rp)
	re:GetHandler():ResetFlagEffect(511600207)
end
function c511600207.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x574)
end
function c511600207.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c511600207.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c511600207.rfilter(c,race)
	return c:IsFaceup() and c:IsRace(race)
end
function c511600207.filter(c)
	return c:IsFaceup()
		and Duel.GetMatchingGroup(c511600207.rfilter,0,LOCATION_MZONE,LOCATION_MZONE,nil,c:GetRace()):GetSum(Card.GetAttack)>0
end
function c511600207.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c511600207.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c511600207.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
	local g=Duel.SelectTarget(tp,c511600207.filter,tp,LOCATION_MZONE,0,1,1,nil)
	local val=Duel.GetMatchingGroup(c511600207.rfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,g:GetFirst():GetRace()):GetSum(Card.GetAttack)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,val)
end
function c511600207.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local val=Duel.GetMatchingGroup(c511600207.rfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tc:GetRace()):GetSum(Card.GetAttack)
		Duel.Recover(tp,val,REASON_EFFECT)
	end
end
function c511600207.actfilter(c)
	return c:GetFlagEffect(511600207)>0
end
function c511600207.desfilter(c)
	return c:IsFaceup() and c:IsLevelBelow(Duel.GetMatchingGroupCount(c511600207.actfilter,0,LOCATION_GRAVE,LOCATION_GRAVE,nil))
end
function c511600207.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c511600207.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local dg=Duel.GetMatchingGroup(c511600207.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,dg,#dg,tp,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,0,#dg*300)
end
function c511600207.desop(e,tp,eg,ep,ev,re,r,rp)
	local dg=Duel.GetMatchingGroup(c511600207.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if Duel.Destroy(dg,REASON_EFFECT)>0 then
		local og=Duel.GetOperatedGroup()
		for p=0,1 do
			Duel.Damage(p,og:FilterCount(Card.IsControler,nil,p)*300,REASON_EFFECT)
		end
	end
end