--Spam Mail
--scripted by Larry126
function c511600102.initial_effect(c)
	aux.AddEquipProcedure(c,nil,c511600102.eqfilter)
	--normal
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_EQUIP)
	e1:SetCode(EFFECT_CHANGE_TYPE)
	e1:SetValue(TYPE_NORMAL)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_DISABLE)
	c:RegisterEffect(e2)
	--draw and return
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22093873,0))
	e3:SetCategory(CATEGORY_DRAW+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(c511600102.drcon)
	e3:SetTarget(c511600102.drtg)
	e3:SetOperation(c511600102.drop)
	c:RegisterEffect(e3)
end
function c511600102.eqfilter(c)
	return c:GetOriginalType()&TYPE_EFFECT==TYPE_EFFECT
end
function c511600102.drcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_EFFECT) and c:IsPreviousLocation(LOCATION_HAND+LOCATION_DECK+LOCATION_ONFIELD)
end
function c511600102.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,1-tp,LOCATION_ONFIELD)
end
function c511600102.filter(c,tpe)
	return c:IsFaceup() and c:IsType(tpe)
end
function c511600102.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)~=0 then
		local dc=Duel.GetOperatedGroup():GetFirst()
		Duel.ConfirmCards(1-tp,dc)
		local tpe=dc:GetType()&(TYPE_MONSTER|TYPE_SPELL|TYPE_TRAP)
		if Duel.IsExistingMatchingCard(c511600102.filter,tp,0,LOCATION_ONFIELD,1,e:GetHandler(),tpe) then
			Duel.BreakEffect()
			local tc=Duel.SelectMatchingCard(1-tp,c511600102.filter,tp,0,LOCATION_ONFIELD,1,1,e:GetHandler(),tpe)
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
		end
		Duel.ShuffleHand(tp)
	end
end