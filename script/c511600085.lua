--リンク・コイン
--Link Coin
--scripted by Larry126
function c511600085.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c511600085.cost)
	e1:SetTarget(c511600085.target)
	e1:SetOperation(c511600085.activate)
	c:RegisterEffect(e1)
end
c511600085.check=false
function c511600085.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	c511600085.check=true
	if chk==0 then return true end
end
function c511600085.cfilter(c,tp)
	return c:IsType(TYPE_LINK) and c:IsLinkAbove(1) and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=c:GetLink()
		and Duel.GetDecktopGroup(tp,c:GetLink()):IsExists(Card.IsAbleToHand,1,nil)
end
function c511600085.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		if not c511600085.check then return false end
		c511600085.check=false
		return Duel.IsExistingMatchingCard(c511600085.cfilter,tp,LOCATION_MZONE,0,1,nil,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local c=Duel.SelectMatchingCard(tp,c511600085.cfilter,tp,LOCATION_MZONE,0,1,1,nil,tp):GetFirst()
	e:SetLabel(c:GetLink())
	Duel.SendtoGrave(c,REASON_COST)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN)
	e1:SetLabelObject(c)
	e1:SetCountLimit(1)
	e1:SetTarget(c511600085.sumtg)
	e1:SetOperation(c511600085.sumop)
	Duel.RegisterEffect(e1,tp)
end
function c511600085.activate(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<ct then return end
	local g=Duel.GetDecktopGroup(tp,ct)
	Duel.ConfirmCards(tp,g)
	if g:IsExists(Card.IsAbleToHand,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:FilterSelect(tp,Card.IsAbleToHand,1,1,nil)
		Duel.DisableShuffleCheck()
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
		Duel.ShuffleHand(tp)
		Duel.SortDecktop(tp,tp,ct-1)
	else Duel.SortDecktop(tp,tp,ct) end
end
function c511600085.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetTurnPlayer()==tp
		and e:GetLabelObject():IsCanBeSpecialSummoned(e,0,tp,false,false) end
end
function c511600085.sumop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SpecialSummon(e:GetLabelObject(),0,tp,tp,false,false,POS_FACEUP)
end