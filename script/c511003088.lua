--BK リベージ・ガードナー
function c511003088.initial_effect(c)
	--change target
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(54912977,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_BATTLE_CONFIRM)
	e1:SetCondition(c511003088.condition)
	e1:SetTarget(c511003088.target)
	e1:SetOperation(c511003088.operation)
	c:RegisterEffect(e1)
end
function c511003088.condition(e,tp,eg,ep,ev,re,r,rp)
	return r~=REASON_REPLACE and Duel.GetAttackTarget()==e:GetHandler() 
		and e:GetHandler():GetBattlePosition()==POS_FACEDOWN_DEFENSE
end
function c511003088.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,)
	Duel.SelectTarget(tp,nil,tp,0,LOCATION_MZONE,1,1,Duel.GetAttacker())
end
function c511003088.operation(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.ChangeAttackTarget(g:GetFirst())
		if a and a:IsRelateToBattle() and a:IsType(TYPE_XYZ) then
			local og=a:GetOverlayGroup()
			if og:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(81330115,1)) then
				Duel.SendtoGrave(og,REASON_EFFECT)
			end
		end
	end
end
