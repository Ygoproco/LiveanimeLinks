--悲劇の引き金 (Anime)
--Remote Revenge (Anime)
function c511010535.initial_effect(c)
	--Activate
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c511010535.descon)
	e1:SetTarget(c511010535.destg)
	e1:SetOperation(c511010535.desop)
	c:RegisterEffect(e1)
end
function c511010535.cfilter(c,tp)
	return c:GetControler()==tp and c:IsType(TYPE_MONSTER) and c:IsLocation(LOCATION_MZONE) 
end
function c511010535.descon(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if g:FilterCount(c511010535.cfilter,nil,tp)==0 then return false end
	if not Duel.IsChainDisablable(ev) then return false end
	local ex,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_DESTROY)
	return ex and tg~=nil and tc+tg:FilterCount(c511010535.cfilter,nil,tp)-tg:GetCount()==1
end
function c511010535.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAttackPos()
end
function c511010535.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c511010535.filter,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c511010535.filter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,1-tp,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c511010535.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c511010535.filter,tp,0,LOCATION_MZONE,nil)
	if #g>0 and Duel.NegateEffect(ev) then
		Duel.Destroy(g,REASON_EFFECT)
	end 
end