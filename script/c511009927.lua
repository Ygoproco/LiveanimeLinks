--Energy of Fire
function c511009927.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCondition(c511009927.condition)
	e1:SetTarget(c511009927.target)
	e1:SetOperation(c511009927.activate)
	c:RegisterEffect(e1)
end
function c511009927.condition(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttackTarget()
	e:SetLabelObject(tc)
	return tc and tc:IsControler(tp) and Duel.GetTurnPlayer()==1-tp
end
function c511009927.filter(c,e,tp)
	return c:GetAttack()>0 and c:IsSetCard(0x119) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function c511009927.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c38815069.filter(chkc) end
	if chk==0 then return true end
	if Duel.IsExistingTarget(c38815069.filter,tp,LOCATION_GRAVE,0,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectTarget(tp,c38815069.filter,tp,LOCATION_GRAVE,0,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
		Duel.SetTargetPlayer(tp)
		Duel.SetTargetParam(g:GetFirst():GetAttack())
		Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,g:GetFirst():GetAttack())
	end
end
function c511009927.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local bc=e:GetLabelObject()
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	
	if bc:IsRelateToBattle() then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
			e1:SetValue(1)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE)
			bc:RegisterEffect(e1)
		end
	if tc and tc:IsRelateToEffect(e) then
		if Duel.SendtoDeck(tc,nil,0,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_DECK+LOCATION_EXTRA) then
			if tc:IsLocation(LOCATION_DECK) then Duel.ShuffleDeck(tp) end
			Duel.Recover(p,d,REASON_EFFECT)
		end
	end
end
