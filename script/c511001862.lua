--Power Exchange
function c511001862.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c511001862.condition)
	e1:SetTarget(c511001862.target)
	e1:SetOperation(c511001862.activate)
	c:RegisterEffect(e1)
end
function c511001862.condition(e,tp,eg,ep,ev,re,r,rp)
	local e1=Duel.IsPlayerAffectedByEffect(tp,EFFECT_REVERSE_DAMAGE)
	local e2=Duel.IsPlayerAffectedByEffect(tp,EFFECT_REVERSE_RECOVER)
	local rd=e1 and not e2
	local rr=not e1 and e2
	local ex,cg,ct,cp,cv=Duel.GetOperationInfo(ev,CATEGORY_DAMAGE)
	if ex and (cp==tp or cp==PLAYER_ALL) and not rd and not Duel.IsPlayerAffectedByEffect(tp,EFFECT_NO_EFFECT_DAMAGE) then
		e:SetLabel(cv)
		return true 
	end
	ex,cg,ct,cp,cv=Duel.GetOperationInfo(ev,CATEGORY_RECOVER)
	if ex and (cp==tp or cp==PLAYER_ALL) and rr and not Duel.IsPlayerAffectedByEffect(tp,EFFECT_NO_EFFECT_DAMAGE) then
		e:SetLabel(cv)
		return true
	else
		e:SetLabel(0)
		return false
	end
end
function c511001862.filter(c,atk)
	return c:IsFaceup() and c:IsAttackAbove(atk)
end
function c511001862.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local dam=e:GetLabel()
	if chk==0 then return dam>0 and Duel.IsExistingMatchingCard(c511001862.filter,tp,LOCATION_MZONE,0,1,nil,dam) end
	Duel.SetTargetParam(dam)
end
function c511001862.activate(e,tp,eg,ep,ev,re,r,rp)
	local cid=Duel.GetChainInfo(ev,CHAININFO_CHAIN_ID)
	local dam=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectMatchingCard(tp,c511001862.filter,tp,LOCATION_MZONE,0,1,1,nil,dam)
	local tc=g:GetFirst()
	if tc then
		Duel.HintSelection(g)
		if tc:UpdateAttack(-dam,nil,e:GetHandler())==-dam then
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_FIELD)
			e2:SetCode(EFFECT_CHANGE_DAMAGE)
			e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e2:SetTargetRange(1,0)
			e2:SetLabel(cid)
			e2:SetValue(c511001862.damcon)
			e2:SetReset(RESET_CHAIN)
			Duel.RegisterEffect(e2,tp)
		end
	end
end
function c511001862.damcon(e,re,val,r,rp,rc)
	local cc=Duel.GetCurrentChain()
	if cc==0 or r&REASON_EFFECT==0 then return val end
	local cid=Duel.GetChainInfo(0,CHAININFO_CHAIN_ID)
	if cid==e:GetLabel() then return 0 end
	return 0
end
