--Dinowrestler King T Wrextle
function c511009722.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x580),2)
	c:EnableReviveLimit()
	--actlimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,1)
	e1:SetValue(c511009722.aclimit)
	e1:SetCondition(c511009722.actcon)
	c:RegisterEffect(e1)
	--pos
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(44035031,1))
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c511009722.atkcon)
	e2:SetTarget(c511009722.atktg)
	e2:SetOperation(c511009722.atkop)
	c:RegisterEffect(e2)
end
function c511009722.aclimit(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c511009722.actcon(e)
	return Duel.GetAttacker()==e:GetHandler()
end



function c511009722.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE)
end
function c511009722.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsAttackPos() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAttackPos,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectTarget(tp,Card.IsAttackPos,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
end
function c511009722.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
			if tc:IsFaceup() then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_FIELD)
				e1:SetCode(EFFECT_CANNOT_ATTACK)
				e1:SetTargetRange(LOCATION_MZONE,0)
				e1:SetTarget(c511009722.ftarget)
				e1:SetLabelObject((tc)
				e1:SetReset(RESET_PHASE+PHASE_END)
				Duel.RegisterEffect(e1,tp)
				--atk clear
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e2:SetCode(EVENT_PHASE+PHASE_BATTLE)
				e2:SetRange(LOCATION_MZONE)
				e2:SetCountLimit(1)
				e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
				e2:SetCondition(c511009722.descon)
				e2:SetOperation(c511009722.desop)
				c:RegisterEffect(e2)
			end
		end
	end
end
function c511009722.ftarget(e,c)
	return e:GetLabelObject():GetFieldID()~=c:GetFieldID() and e:GetLabelObject():IsAttackable()
end
function c511009722.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetAttackedCount()==0
end
function c511009722.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetAttackedCount()==0 then
		Duel.Destroy(c,REASON_EFFECT)
	end
end

