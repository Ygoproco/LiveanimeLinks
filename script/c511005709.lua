--Friller Rabca (Anime)
--scripted by GameMaster(GM)
function c511005709.initial_effect(c)
	--disable attack
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(511005709,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCondition(c511005709.condition)
	e1:SetCost(c511005709.cost)
	e1:SetTarget(c511005709.target)
	e1:SetOperation(c511005709.operation)
	c:RegisterEffect(e1)
end
function c511005709.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end

function c511005709.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end

function c511005709.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tg=Duel.GetAttacker()
	if chkc then return chkc==tg end
	if chk==0 then return tg:IsOnField() and tg:IsCanBeEffectTarget(e) end
	Duel.SetTargetCard(tg)
end

function c511005709.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.NegateAttack()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-500)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
	end
end
