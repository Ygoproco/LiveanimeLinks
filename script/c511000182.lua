--Arduous Decision
function c511000182.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c511000182.target)
	e1:SetOperation(c511000182.activate)
	c:RegisterEffect(e1)
end
function c511000182.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanSpecialSummon(tp) and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>1 end
end
function c511000182.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<2 then return end
	Duel.ConfirmDecktop(tp,2)
	local g=Duel.GetDecktopGroup(tp,2)
	if g:GetCount()>0 then
		Duel.DisableShuffleCheck()
		local tg=g:RandomSelect(1-tp,1)
		local tc=tg:GetFirst()
		if tc:IsType(TYPE_MONSTER) and tc:IsCanBeSpecialSummoned(e,0,tp,false,false) then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
			local g2=g:Filter(aux.TRUE,tg)
			Duel.SendtoHand(g2,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g2)
			Duel.ShuffleHand(tp)
		else Duel.SendtoGrave(g,REASON_EFFECT) end
	end
end
