--トリックスター・トリート (Anime)
--Trickstar Treat (Anime)
--scripted by Larry126
--fixed by MLD
function c511600045.initial_effect(c)
	c:EnableCounterPermit(0xfb)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c511600045.target)
	e1:SetOperation(c511600045.activate)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(511600045,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(c511600045.setcon)
	e2:SetCost(c511600045.setcost)
	e2:SetOperation(c511600045.setop)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c511600045.descon)
	e3:SetTarget(c511600045.destg)
	e3:SetOperation(c511600045.desop)
	c:RegisterEffect(e3)
	--damage
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_LEAVE_FIELD_P)
	e4:SetOperation(c511600045.damp)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(511600045,0))
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e5:SetCategory(CATEGORY_DAMAGE)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetCode(EVENT_DESTROY)
	e5:SetTarget(c511600045.damtg)
	e5:SetOperation(c511600045.damop)
	e5:SetLabelObject(e4)
	c:RegisterEffect(e5)
end
function c511600045.damp(e,tp,eg,ep,ev,re,r,rp)
	e:SetLabel(e:GetHandler():GetCounter(0xfb))
end
function c511600045.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=e:GetLabelObject():GetLabel()
	if chk==0 then return ct~=0 end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(ct*1000)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,ct*1000)
end
function c511600045.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
function c511600045.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetCounter(0xfb)>=2
end
function c511600045.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function c511600045.desop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.Destroy(e:GetHandler(),REASON_EFFECT)
	end
end
function c511600045.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0xfb)
end
function c511600045.activate(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		e:GetHandler():AddCounter(0xfb,1)
	end
end
function c511600045.filter(c)
	return c:GetFlagEffect(511600045)>0
end
function c511600045.setcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c511600045.filter,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil)
end
function c511600045.cfilter(c,tp)
	return c:IsType(TYPE_TRAP) and c:IsSetCard(0xfb) and not c:IsPublic() and c:IsSSetable() 
		and c:GetFlagEffect(511600044)==0
end
function c511600045.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c511600045.cfilter,tp,LOCATION_HAND,0,1,nil)
		and c:IsCanAddCounter(0xfb,1) end
	c:AddCounter(0xfb,1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c511600045.cfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
	Duel.SetTargetCard(g:GetFirst())
	g:GetFirst():RegisterFlagEffect(511600044,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,0,1,fid)
end
function c511600045.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and c511600045.setcon(e,tp,eg,ep,ev,re,r,rp) and tc and tc:IsSSetable() 
		and not Duel.IsExistingMatchingCard(c511600045.filter,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil) then
		Duel.SSet(tp,tc)
		Duel.ConfirmCards(1-tp,tc)
		local fid=c:GetFieldID()
		tc:RegisterFlagEffect(511600045,RESET_EVENT+RESETS_STANDARD,0,1,fid)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetLabel(fid)
		e1:SetLabelObject(tc)
		e1:SetCondition(c511600045.descon)
		e1:SetOperation(c511600045.desop)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
		e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
	else
		Duel.SendtoGrave(tc,REASON_RULE)
	end
end
function c511600045.descon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffectLabel(511600045)~=e:GetLabel() then
		e:Reset()
		return false
	else return true end
end
function c511600045.desop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.Destroy(e:GetLabelObject(),REASON_EFFECT)
	end
end
