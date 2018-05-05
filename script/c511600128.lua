--EMコール (Anime)
--Performapal Call (Anime)
--scripted by Larry126
function c511600128.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCondition(c511600128.condition)
	e1:SetTarget(c511600128.target)
	e1:SetOperation(c511600128.activate)
	c:RegisterEffect(e1)
end
function c511600128.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():IsControler(1-tp) and Duel.GetAttackTarget()==nil
end
function c511600128.filter1(c,def)
	return c:IsSetCard(0x9f) and c:IsDefenseBelow(def) and c:IsAbleToHand()
		and Duel.IsExistingMatchingCard(c511600128.filter2,tp,LOCATION_DECK,0,1,nil,def-c:GetDefense())
end
function c511600128.filter2(c,def)
	return c:IsSetCard(0x9f) and c:IsDefenseBelow(def) and c:IsAbleToHand()
end
function c511600128.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local at=Duel.GetAttacker()
	if chk==0 then return at:IsOnField()
		and Duel.IsExistingMatchingCard(c511600128.filter1,tp,LOCATION_DECK,0,1,nil,at:GetAttack()) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
end
function c511600128.activate(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttacker()
	if Duel.NegateAttack() and at:IsOnField() and at:IsStatus(STATUS_ATTACK_CANCELED)
		and Duel.IsExistingMatchingCard(c511600128.filter1,tp,LOCATION_DECK,0,1,nil,at:GetAttack()) then
		local val=at:GetAttack()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g1=Duel.SelectMatchingCard(tp,c511600128.filter1,tp,LOCATION_DECK,0,1,1,nil,val)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g2=Duel.SelectMatchingCard(tp,c511600128.filter2,tp,LOCATION_DECK,0,1,1,g1,val-g1:GetFirst():GetDefense())
		g1:Merge(g2)
		Duel.SendtoHand(g1,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g1)
		local c=e:GetHandler()
		for tc in aux.Next(g1) do
			--summon success
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_SUMMON_SUCCESS)
			e1:SetOperation(c511600128.sumsuc)
			e1:SetReset(RESET_EVENT+0xfe0000)
			tc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EVENT_SPSUMMON_SUCCESS)
			tc:RegisterEffect(e2)
		end
	end
end
function c511600128.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c511600128.sumlimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c511600128.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsLocation(LOCATION_EXTRA)
end