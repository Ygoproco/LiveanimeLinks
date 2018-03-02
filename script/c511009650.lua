--Devil Mirage
function c511009650.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c511009650.condition)
	e1:SetTarget(c511009650.target)
	e1:SetOperation(c511009650.activate)
	c:RegisterEffect(e1)
end
function c511009650.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x572)
end
function c511009650.filter(c,p)
	return c:GetControler()==p and c:IsOnField()
end
function c511009650.condition(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsChainNegatable(ev) then return false end
	local ex,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_DESTROY)
	return ex and tg~=nil and tc+tg:FilterCount(c511009650.filter,nil,tp)-tg:GetCount()>0
	and Duel.IsExistingMatchingCard(c511009650.cfilter,e:GetHandler():GetControler(),LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
end
function c511009650.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c511009650.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=re:GetHandler()
	if not tc:IsDisabled() then
		if Duel.NegateEffect(ev) and tc:IsRelateToEffect(re) then
			local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
			Duel.Destroy(g,REASON_EFFECT)
		end
	end
end
