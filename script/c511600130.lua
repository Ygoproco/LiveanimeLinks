--狂戦士の魂 (Anime)
--Berserker Soul (Anime)
--scripted by Larry126
function c511600130.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_HANDES+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_DAMAGE_STEP_END)
	e1:SetCost(c511600130.cost)
	e1:SetTarget(c511600130.target)
	e1:SetOperation(c511600130.activate)
	c:RegisterEffect(e1)
end
function c511600130.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
		g:RemoveCard(e:GetHandler())
		return g:GetCount()>0 and g:FilterCount(Card.IsDiscardable,nil)==g:GetCount()
	end
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
function c511600130.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ac=Duel.GetAttacker()
	if chk==0 then return Duel.IsPlayerCanDraw(tp) and ac:IsControler(tp)
		and ac:IsAttackBelow(1500) and ac:IsRelateToBattle() and ac:IsChainAttackable(60) end
end
function c511600130.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	if not tc:IsControler(tp) or not tc:IsAttackBelow(1500) or not tc:IsRelateToBattle() or not tc:IsChainAttackable(60) then return end
	if Duel.Draw(tp,1,REASON_EFFECT)>0 then
		local dc=Duel.GetOperatedGroup():GetFirst()
		Duel.ConfirmCards(1-tp,dc)
		Duel.BreakEffect()
		if dc:IsType(TYPE_MONSTER) and Duel.SendtoGrave(dc,REASON_COST+REASON_DISCARD)>0 and dc:IsLocation(LOCATION_GRAVE) then
			Debug.Message("Dorō! Monsutākādo!")
			Duel.ChainAttack()
			local e1=Effect.GlobalEffect()
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_DAMAGE_STEP_END)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_UNCOPYABLE)
			e1:SetReset(RESET_PHASE+PHASE_BATTLE+PHASE_END)
			e1:SetLabelObject(tc)
			e1:SetOperation(c511600130.caop)
			Duel.RegisterEffect(e1,tp)
			tc:CreateEffectRelation(e1)
		end
	end
end
function c511600130.caop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	if tc~=e:GetLabelObject() or not tc:IsControler(tp) or not tc:IsAttackBelow(1500)
		or not tc:IsRelateToBattle() or not tc:IsRelateToEffect(e) or not tc:IsChainAttackable(60) then return end
	if Duel.Draw(tp,1,REASON_EFFECT)>0 then
		local dc=Duel.GetOperatedGroup():GetFirst()
		Duel.ConfirmCards(1-tp,dc)
		Duel.BreakEffect()
		if dc:IsType(TYPE_MONSTER) and Duel.SendtoGrave(dc,REASON_COST+REASON_DISCARD)>0 and dc:IsLocation(LOCATION_GRAVE) then
			Debug.Message("Dorō! Monsutākādo!")
			Duel.ChainAttack()
		else
			e:Reset()
		end
	else
		e:Reset()
	end
end