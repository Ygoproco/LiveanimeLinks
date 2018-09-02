--Crimson Fire (Anime)
--クリムゾン・ヘルフレア
function c511010530.initial_effect(c)  
	--reflect
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c511010530.condition)
	e1:SetOperation(c511010530.operation)
	c:RegisterEffect(e1)
end
function c511010530.cfilter(c,ev)
	return c:IsFaceup() and c:GetAttack()>ev
end
function c511010530.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c511010530.cfilter,tp,LOCATION_ONFIELD,0,1,nil,ev) and ep~=tp 
		and aux.damcon1(e,tp,eg,ep,ev,re,r,rp)
end
function c511010530.operation(e,tp,eg,ep,ev,re,r,rp)
	local cid=Duel.GetChainInfo(ev,CHAININFO_CHAIN_ID)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_REFLECT_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetLabel(cid)
	e1:SetValue(c511010530.refcon)
	e1:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CHANGE_DAMAGE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetLabel(cid)
	e2:SetValue(c511010530.dammul)
	e2:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e2,tp)
end
function c511010530.refcon(e,re,val,r,rp,rc)
	local cc=Duel.GetCurrentChain()
	if cc==0 or bit.band(r,REASON_EFFECT)==0 then return end
	local cid=Duel.GetChainInfo(0,CHAININFO_CHAIN_ID)
	return cid==e:GetLabel()
end
function c511010530.dammul(e,re,val,r,rp,rc)
	local cc=Duel.GetCurrentChain()
	if cc==0 or bit.band(r,REASON_EFFECT)==0 then return end
	local cid=Duel.GetChainInfo(0,CHAININFO_CHAIN_ID)
	return cid==e:GetLabel() and val*2 or val
end
