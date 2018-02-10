--Ｄ－フォース
function c100000270.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)	
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c100000270.target)
	e1:SetOperation(c100000270.activate)
	c:RegisterEffect(e1)	
	--Cannot draw
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_DRAW)
	e2:SetRange(LOCATION_DECK)
	e2:SetTargetRange(1,0)
	e2:SetCondition(c100000270.sdcon)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_DRAW_COUNT)
	e3:SetValue(0)
	c:RegisterEffect(e3)
	
end
function c100000270.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function c100000270.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.BreakEffect()
		c:CancelToGrave()
		Duel.SendtoDeck(c,nil,0,REASON_EFFECT)
		c:ReverseInDeck()
	end
end
function c100000270.sdcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()	
	local g=Duel.GetDecktopGroup(c:GetControler(),1)
	return g:GetFirst()==c and c:IsFaceup() and Duel.GetCurrentPhase()==PHASE_DRAW and Duel.GetTurnPlayer()==tp
end
