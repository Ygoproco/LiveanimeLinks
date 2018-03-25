--Double Magical Arm Bind 
function c511001116.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c511001116.cost)
	e1:SetTarget(c511001116.target)
	e1:SetOperation(c511001116.activate)
	c:RegisterEffect(e1)
end
function c511001116.chk(sg,tp,exg,dg)
	return dg:IsExists(aux.TRUE,2,sg)
end
function c511001116.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local dg=Duel.GetMatchingGroup(c511001116.filter,tp,0,LOCATION_MZONE,nil,e)
	if chk==0 then return Duel.CheckReleaseGroupCost(tp,nil,2,false,c511001116.chk,nil,dg) end
	local rg=Duel.SelectReleaseGroupCost(tp,nil,2,2,false,c511001116.chk,nil,dg)
	Duel.Release(rg,REASON_COST)
end
function c511001116.filter(c,e)
	return c:IsAbleToChangeControler() and (not e or c:IsCanBeEffectTarget(e))
end
function c511001116.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsControlerCanBeChanged() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,2,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,2,0,0)
end
function c511001116.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc=g:GetFirst()
	while tc do
		if Duel.GetControl(tc,tp) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_ATTACK)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
			tc:RegisterEffect(e2)
		end
		tc=g:GetNext()
	end
end
