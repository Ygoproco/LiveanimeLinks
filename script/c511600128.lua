--EMコール (Anime)
--Performapal Call (Anime)
--scripted by Larry126
--fixed by MLD
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
function c511600128.filter(c,def)
	return c:IsSetCard(0x9f) and c:IsDefenseBelow(def) and c:IsAbleToHand()
end
function c511600128.rescon(atk)
	return	function(sg,e,tp,mg)
				return sg:GetSum(Card.GetDefense)==atk
			end
end
function c511600128.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local at=Duel.GetAttacker()
	local atk=at:GetAttack()
	local g=Duel.GetMatchingGroup(c511600128.filter,tp,LOCATION_DECK,0,nil,atk)
	if chk==0 then return at:IsOnField() and aux.SelectUnselectGroup(g,e,tp,2,2,c511600128.rescon(atk),0) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
end
function c511600128.activate(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttacker()
	if at and at:IsRelateToBattle() and at:IsOnField() and Duel.NegateAttack() and at:IsStatus(STATUS_ATTACK_CANCELED) then
		local atk=at:GetAttack()
		local g=Duel.GetMatchingGroup(c511600128.filter,tp,LOCATION_DECK,0,nil,atk)
		local sg=aux.SelectUnselectGroup(g,e,tp,2,2,c511600128.rescon(atk),1,tp,HINTMSG_ATOHAND)
		if sg:GetCount()>0 then
			Duel.BreakEffect()
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
			sg:ForEach(function(tc)
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
				e1:SetCode(EVENT_SUMMON_SUCCESS)
				e1:SetOperation(c511600128.sumsuc)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1)
				local e2=e1:Clone()
				e2:SetCode(EVENT_SPSUMMON_SUCCESS)
				tc:RegisterEffect(e2)
			end)
		end
	end
end
function c511600128.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsLocation,LOCATION_EXTRA))
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
