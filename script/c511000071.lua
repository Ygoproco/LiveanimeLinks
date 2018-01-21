--Terminal Countdown
function c511000071.initial_effect(c)
	--Cannot Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetTargetRange(1,0)
	e2:SetValue(c511000071.aclimit)
	c:RegisterEffect(e2)
	--Set Card
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(73468603,0))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetCountLimit(1)
	e3:SetCondition(c511000071.setcon)
	e3:SetTarget(c511000071.settg)
	e3:SetOperation(c511000071.setop)
	c:RegisterEffect(e3)
	--Damage LP
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(45591967,0))
	e4:SetCategory(CATEGORY_DAMAGE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCondition(c511000071.damcon)
	e4:SetCost(c511000071.damcost)
	e4:SetTarget(c511000071.damtg)
	e4:SetOperation(c511000071.damop)
	c:RegisterEffect(e4)
end
function c511000071.setcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c511000071.aclimit(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c511000071.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function c511000071.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 
		and Duel.IsExistingMatchingCard(c511000071.filter,tp,LOCATION_DECK,0,1,nil) end
end
function c511000071.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local tc=Duel.SelectMatchingCard(tp,c511000071.filter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if tc then
		Duel.ConfirmCards(1-tp,tc)
		Duel.SSet(tp,tc)
		c:SetCardTarget(tc)
	end
end
function c511000071.damcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function c511000071.damcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=c:GetCardTarget()
	local ct=g:GetCount()
	if chk==0 then return c:IsAbleToGraveAsCost() and ct>0 and g:FilterCount(Card.IsAbleToGraveAsCost,nil)==ct end
	g:AddCard(c)
	local dam=0
	if ct==2 then dam=500
	elseif ct==3 then dam=1500
	elseif ct==4 then dam=3000
	elseif ct==5 then dam=6000
	end
	e:SetLabel(dam)
end
function c511000071.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local dam=e:GetLabel()
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(dam)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
	e:SetLabel(0)
end
function c511000071.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
