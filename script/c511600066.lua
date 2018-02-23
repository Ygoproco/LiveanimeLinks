--リンク・プロテクション (Anime)
--Link Protection (Anime)
--scripted by Larry126
function c511600066.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--cannot attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_ATTACK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c511600066.atktg)
	c:RegisterEffect(e2)
	--atk
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c511600066.target)
	e3:SetOperation(c511600066.operation)
	c:RegisterEffect(e3)
	--banish
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(2129638,0))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCost(c511600066.rmcost)
	e4:SetOperation(c511600066.rmop)
	c:RegisterEffect(e4)
end
function c511600066.atktg(e,c)
	return not c:IsType(TYPE_LINK)
end
function c511600066.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_LINK)
end
function c511600066.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c511600066.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c511600066.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c511600066.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c511600066.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
		tc:RegisterEffect(e2)
		--destroy
		local e3=Effect.CreateEffect(c)
		e3:SetCategory(CATEGORY_DESTROY)
		e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
		e3:SetCode(EVENT_BATTLED)
		e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e3:SetTarget(c511600066.destg)
		e3:SetOperation(c511600066.desop)
		tc:RegisterEffect(e3)
	end
end
function c511600066.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=Duel.GetAttackTarget()
	if chk==0 then return e:GetHandler()==Duel.GetAttacker() and tc and tc:IsType(TYPE_LINK) and tc:IsDestructable() end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tc,1,0,0)
	e:SetLabelObject(tc)
end
function c511600066.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:IsRelateToBattle() then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c511600066.cfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousControler()==tp
		and c:IsReason(REASON_DESTROY) and c:IsType(TYPE_LINK) and c:IsAbleToRemoveAsCost()
end
function c511600066.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return eg:IsExists(c511600066.cfilter,1,nil,tp) and c:IsAbleToRemoveAsCost() 
		and not Duel.IsPlayerAffectedByEffect(tp,69832741) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tc=eg:FilterSelect(tp,c511600066.cfilter,1,1,nil,tp):GetFirst()
	e:SetLabelObject(tc)
	Duel.Remove(Group.FromCards(c,tc),POS_FACEUP,REASON_COST)
end
function c511600066.rmop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetLabel(e:GetLabelObject():GetLink())
	e1:SetCondition(c511600066.atkcon)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c511600066.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(c511600066.filter,tp,0,LOCATION_MZONE,nil)<e:GetLabel()
end