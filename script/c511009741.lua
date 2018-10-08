--Drone Pawn
function c511009741.initial_effect(c)
	--check
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_BATTLE_DAMAGE)
	e1:SetCondition(c511009741.checkcon)
	e1:SetOperation(c511009741.checkop)
	c:RegisterEffect(e1)
	--recover
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(511009741,0))
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetLabelObject(e1)
	e2:SetCountLimit(1)
	e2:SetCondition(c511009741.condition)
	e2:SetTarget(c511009741.rectg)
	e2:SetOperation(c511009741.recop)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetCondition(c511009741.condition)
	e3:SetValue(1)
	c:RegisterEffect(e3)
end
function c511009741.checkcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and (e:GetHandler()==Duel.GetAttacker() or e:GetHandler()==Duel.GetAttackTarget())
end
function c511009741.checkop(e,tp,eg,ep,ev,re,r,rp)
	local val=e:GetLabel()+ev
	e:SetLabel(val)
end
function c511009741.reccon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabel()>0
end
function c511009741.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,e:GetLabelObject():GetLabel())
end
function c511009741.recop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.Recover(p,e:GetLabelObject():GetLabel(),REASON_EFFECT)
	e:GetLabelObject():SetLabel(0)
end

function c511009741.condition(e)
	return not Duel.IsExistingMatchingCard(nil,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,e:GetHandler())
end
