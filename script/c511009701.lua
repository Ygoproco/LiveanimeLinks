--トランザクション・ロールバック
--Transaction Rollback
function c511009701.initial_effect(c)
	--copy trap
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0x1e1,0x1e1)
	e1:SetCost(c511009701.cost)
	e1:SetTarget(c511009701.target)
	e1:SetOperation(c511009701.operation)
	c:RegisterEffect(e1)
end
function c511009701.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function c511009701.filter(c)
	return c:GetType()==0x4 and c:CheckActivateEffect(false,true,false)~=nil
end
function c511009701.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		local te=e:GetLabelObject()
		local tg=te:GetTarget()
		return tg and tg(e,tp,eg,ep,ev,re,r,rp,0,chkc)
	end
	if chk==0 then return Duel.IsExistingTarget(c511009701.filter,tp,0,LOCATION_GRAVE,1,nil) end
	e:SetProperty(EFFECT_FLAG_CARD_TARGET)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c511009701.filter,tp,0,LOCATION_GRAVE,1,1,nil)
	local te,ceg,cep,cev,cre,cr,crp=g:GetFirst():CheckActivateEffect(false,true,true)
	Duel.ClearTargetCard()
	g:GetFirst():CreateEffectRelation(e)
	local tg=te:GetTarget()
	e:SetCategory(te:GetCategory())
	e:SetProperty(te:GetProperty())
	if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
	c511009701[Duel.GetCurrentChain()]={ceg,cep,cev,cre,cr,crp}
end
function c511009701.operation(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if not te or not te:GetHandler():IsRelateToEffect(e) then return end
	e:SetLabelObject(te:GetLabelObject())
	local op=te:GetOperation()
	if op then op(e,tp,table.unpack(c511009701[Duel.GetCurrentChain()],2)) end
end
