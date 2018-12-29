-- ブラック・ウィング
-- Black Wing
-- scripted by: UnknownGuest
-- rescripted by Larry126
--updated by MLD
function c810000054.initial_effect(c)
	-- Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCost(c810000054.cost)
	e1:SetCondition(c810000054.condition)
	e1:SetOperation(c810000054.activate)
	c:RegisterEffect(e1)
	-- destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(810000054,0))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c810000054.descon)
	e2:SetCost(c810000054.descost)
	e2:SetTarget(c810000054.destg)
	e2:SetOperation(c810000054.desop)
	c:RegisterEffect(e2)
end
function c810000054.rfilter(c)
	return c:IsSetCard(0x33) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost() and aux.SpElimFilter(c,true)
end
function c810000054.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c810000054.rfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c810000054.rfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c810000054.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():IsControler(1-tp)
end
function c810000054.activate(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	if a:IsAttackAbove(2000) and a:IsControler(1-tp) then
		Duel.NegateAttack()
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetOperation(c810000054.negop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c810000054.negop(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	if a:IsAttackAbove(2000) and a:IsControler(1-tp) then
		Duel.NegateAttack()
	end
end
function c810000054.costfilter(c)
	return c:IsCode(810000054) and c:IsAbleToRemoveAsCost() and aux.SpElimFilter(c,true)
end
function c810000054.desfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO)
end
function c810000054.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(Card.IsCode,tp,LOCATION_GRAVE,0,nil,810000054)==2
end
function c810000054.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return aux.bfgcost(e,tp,eg,ep,ev,re,r,rp,0)
		and Duel.IsExistingMatchingCard(c810000054.costfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c810000054.costfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,c)
	g=g+c
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c810000054.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil)
		and Duel.IsExistingMatchingCard(c810000054.desfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,2,0,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,0)
end
function c810000054.desop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(c810000054.desfilter,tp,LOCATION_MZONE,0,nil)
	local g2=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	if g1:GetCount()>0 and g2:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
		local sg1=g1:Select(tp,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPPO)
		local sg2=g2:Select(tp,1,1,nil)
		local tc=sg2:GetFirst()
		local dam=tc:GetAttack()
		sg1:Merge(sg2)
		if dam<0 or tc:IsFacedown() then dam=0 end
		if Duel.Destroy(sg1,REASON_EFFECT)>0 and Duel.GetOperatedGroup():IsContains(tc) then
			Duel.Damage(1-tp,dam,REASON_EFFECT)
		end
	end
end
