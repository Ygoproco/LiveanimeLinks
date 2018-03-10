--愚者の種蒔き
function c100000114.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)	
	local e2=Effect.CreateEffect(c)		
	e2:SetDescription(aux.Stringid(100000114,0))
	e2:SetCategory(CATEGORY_COIN+CATEGORY_DECKDES)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c100000114.ddtg)
	e2:SetOperation(c100000114.ddop)
	c:RegisterEffect(e2)	
end
c100000114.toss_coin=true
function c100000114.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x5) and c:IsAttackAbove(300)
end
function c100000114.ddtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c100000114.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c100000114.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c100000114.filter,tp,LOCATION_MZONE,0,1,1,nil)
	local ct=math.floor(g:GetFirst():GetAttack()/300)
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,PLAYER_ALL,ct)
end
function c100000114.ddop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local res=Duel.TossCoin(tp,1)
		local p
		if res==0 then
			p=tp
		else
			p=1-tp
		end
		local ct=math.floor(tc:GetAttack()/300)
		Duel.DiscardDeck(p,ct,REASON_EFFECT)
	end
end
