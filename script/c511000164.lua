--Holding Arms (Anime)
function c511000164.initial_effect(c)
	--attack
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(511000164,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCondition(c511000164.condition)
	e1:SetTarget(c511000164.target)
	e1:SetOperation(c511000164.operation)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetCondition(c511000164.effcon)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--dam
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e3:SetCondition(c511000164.effcon)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--immune effect
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c511000164.effcon)
	e4:SetValue(c511000164.efilterx)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetCode(EFFECT_SEND_REPLACE)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(c511000164.effcon)
	e5:SetTarget(c511000164.reptg)
	e5:SetValue(function(e,c) return false end)
	c:RegisterEffect(e5)
end
function c511000164.condition(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttackTarget()
	return tc and tc:IsControler(1-tp)
end
function c511000164.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=Duel.GetAttackTarget()
	if chk==0 then return true end
	Duel.SetTargetCard(tc)
end
function c511000164.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetAttackTarget()
	if not tc or tc:IsControler(tp) or not tc:IsRelateToEffect(e) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_SELF_TURN,3)
	tc:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetLabel(0)
	e2:SetLabelObject(e1)
	e2:SetOwnerPlayer(tp)
	e2:SetCondition(c511000164.descon)
	e2:SetOperation(c511000164.desop)
	e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_SELF_TURN,3)
	tc:RegisterEffect(e2)
	tc:RegisterFlagEffect(511000164,RESET_EVENT+0x1fe0000,0,0)
	local descnum=tp==c:GetOwner() and 0 or 1
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetDescription(aux.Stringid(4931121,descnum))
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
	e3:SetCode(1082946)
	e3:SetLabelObject(e2)
	e3:SetOwnerPlayer(tp)
	e3:SetOperation(c511000164.reset)
	e3:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,3)
	c:RegisterEffect(e3)
end
function c511000164.reset(e,tp,eg,ep,ev,re,r,rp)
	c511000164.desop(e:GetLabelObject(),tp,eg,ep,ev,e,r,rp)
end
function c511000164.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=e:GetOwner():GetControler()
end
function c511000164.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=e:GetLabel()+1
	Duel.HintSelection(Group.FromCards(c))
	e:GetOwner():SetTurnCounter(ct)
	e:SetLabel(ct)
	if ct==3 then
		if e:GetLabelObject() then e:GetLabelObject():Reset() end
		c:ResetFlagEffect(511000164)
		Duel.Destroy(c,REASON_EFFECT)
		if re then re:Reset() end
	end
end
function c511000164.efilter(c)
	return c:IsFaceup() and c:GetFlagEffect(511000164)>0
end
function c511000164.effcon(e)
	return Duel.IsExistingMatchingCard(c511000164.efilter,0,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function c511000164.efilterx(e,te)
	if not te then return false end
	return te:IsHasCategory(CATEGORY_TOHAND+CATEGORY_DESTROY+CATEGORY_REMOVE+CATEGORY_TODECK+CATEGORY_RELEASE+CATEGORY_TOGRAVE+CATEGORY_FUSION_SUMMON)
end
function c511000164.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return re and e:GetHandler():IsReason(REASON_EFFECT) and r&REASON_EFFECT~=0 end
	return true
end