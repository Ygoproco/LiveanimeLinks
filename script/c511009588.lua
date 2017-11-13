--Odd-Eyes Wing Dragon
--fixed by MLD
function c511009588.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,1,1,aux.FilterBoolFunction(Card.IsCode,82044279),1,1)
	c:EnableReviveLimit()
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21250202,1))
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c511009588.discon1)
	e1:SetTarget(c511009588.distg1)
	e1:SetOperation(c511009588.disop1)
	c:RegisterEffect(e1)
	--destroy and gain atk
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(6924874,0))
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c511009588.descon)
	e2:SetTarget(c511009588.destg)
	e2:SetOperation(c511009588.desop)
	c:RegisterEffect(e2)
	--disable
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(21250202,1))
	e3:SetCategory(CATEGORY_DISABLE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c511009588.descon)
	e3:SetTarget(c511009588.distg2)
	e3:SetOperation(c511009588.disop2)
	c:RegisterEffect(e3)
	--disable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_DISABLE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e4:SetTarget(aux.PersistentTargetFilter)
	c:RegisterEffect(e4)
	--destroy replace
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EFFECT_DESTROY_REPLACE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTarget(c511009588.reptg)
	e5:SetValue(c511009588.repval)
	e5:SetOperation(c511009588.repop)
	c:RegisterEffect(e5)
	--double tuner check
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_MATERIAL_CHECK)
	e6:SetValue(c511009588.valcheck)
	c:RegisterEffect(e6)
end
function c511009588.discon1(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainDisablable(ev) and re:IsActiveType(TYPE_MONSTER)
end
function c511009588.distg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c511009588.disop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) or Duel.GetCurrentChain()~=ev+1 or c:IsStatus(STATUS_BATTLE_DESTROYED) then
		return
	end
	if Duel.NegateEffect(ev) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAIN_SOLVING)
		e1:SetRange(LOCATION_MZONE)
		e1:SetLabelObject(re)
		e1:SetOperation(c511009588.disop)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function c511009588.disop(e,tp,eg,ep,ev,re,r,rp)
	if re==e:GetLabelObject() then
		Duel.NegateEffect(ev)
	end
end
function c511009588.descon(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnPlayer()~=tp then return false end
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE) or ph==PHASE_MAIN2
end
function c511009588.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if c:IsHasEffect(511009518) then
		e:SetProperty(0)
	else
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
	end
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) end
	if chk==0 then
		if c:IsHasEffect(511009518) then
			return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil)
		else
			return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_MZONE,1,nil)
		end
	end
	if not c:IsHasEffect(511009518) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_MZONE,1,1,nil)
	end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c511009588.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local atk=0
	if c:IsHasEffect(511009518) then
		local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
		local tc=g:GetFirst()
		while tc do
			atk=atk+tc:GetAttack()
			tc=g:GetNext()
		end
	else
		local tc=Duel.GetFirstTarget()
		if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) then atk=tc:GetAttack() end
	end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	if Duel.Destroy(g,REASON_EFFECT)~=0 and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(atk)
		c:RegisterEffect(e1)
	end
end
function c511009588.disfilter(c,g)
	return (not g or not g:IsContains(c)) and aux.disfilter1(c)
end
function c511009588.distg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if c:IsHasEffect(511009518) then
		e:SetProperty(0)
	else
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
	end
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and aux.disfilter1(chkc) end
	if chk==0 then 
		local g=c:GetCardTarget()
		if c:IsHasEffect(511009518) then
			local sg=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
			return sg:FilterCount(c511009588.disfilter,nil,g)==sg:GetCount()
		else
			return Duel.IsExistingTarget(c511009588.disfilter,tp,0,LOCATION_MZONE,1,nil,g)
		end
	end
	local g
	if c:IsHasEffect(511009518) then
		g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		g=Duel.SelectTarget(tp,aux.disfilter1,tp,0,LOCATION_MZONE,1,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function c511009588.disop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Group.CreateGroup()
	if c:IsRelateToEffect(e) then
		if c:IsHasEffect(511009518) then
			g=Duel.GetMatchingGroup(c511009588.disfilter,tp,0,LOCATION_MZONE,nil)
		else
			local tg=Duel.GetFirstTarget()
			if tg and tg:IsFaceup() and tg:IsRelateToEffect(e) then
				g:AddCard(tg)
			end
		end
		local tc=g:GetFirst()
		while tc do
			c:SetCardTarget(tc)
			tc=g:GetNext()
		end
	end
end
function c511009588.repfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x99) and c:IsOnField() and c:IsControler(tp) and c:IsReason(REASON_BATTLE) 
		and not c:IsReason(REASON_REPLACE)
end
function c511009588.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) 
		and eg:IsExists(c511009588.repfilter,1,nil,tp) end
	return Duel.SelectYesNo(tp,aux.Stringid(45974017,0))
end
function c511009588.repval(e,c)
	return c511009588.repfilter(c,e:GetHandlerPlayer())
end
function c511009588.repop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return false end
	Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_PZONE,POS_FACEUP,true)
end
function c511009588.valcheck(e,c)
	local g=c:GetMaterial()
	if g:IsExists(Card.IsType,2,nil,TYPE_TUNER) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e1:SetCode(21142671)
		e1:SetReset(RESET_EVENT+0xfe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
