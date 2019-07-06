--チャリオット・パイル (anime)
--Chariot Pile (anime)
--scripted by pyrQ
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	c:RegisterEffect(e1)
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(s.damtg)
	e2:SetOperation(s.damop)
	c:RegisterEffect(e2)
	--negate attack and destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCost(s.descost)
	e3:SetCondition(s.descon)
	e3:SetTarget(s.destg)
	e3:SetOperation(s.desop)
	c:RegisterEffect(e3)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local a=Duel.GetAttacker()
	local opt=-1
	local opt1=0
	local opt2=0
	if s.damtg(e,tp,eg,ep,ev,re,r,rp,0) then
		opt1=1
	end
	if Duel.CheckEvent(EVENT_ATTACK_ANNOUNCE) and s.descon(e,tp,Group.FromCards(a),ep,ev,re,r,rp) 
		and s.descost(e,tp,Group.FromCards(a),ep,ev,re,r,rp,0) and s.destg(e,tp,Group.FromCards(a),ep,ev,re,r,rp,0) then
		opt2=1
	end
	if opt1==1 and opt2==1 then
		opt=Duel.SelectOption(tp,aux.Stringid(89493368,0),aux.Stringid(89493368,1))
	elseif opt1==1 and Duel.SelectYesNo(tp,aux.Stringid(89493368,0)) then
		opt=0
	elseif opt2==1 and Duel.SelectYesNo(tp,aux.Stringid(89493368,1)) then
		opt=1
	end
	if opt==0 then
		e:SetCategory(CATEGORY_DAMAGE)
		e:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e:SetOperation(s.damop)
		s.damtg(e,tp,eg,ep,ev,re,r,rp,1)
	elseif opt==1 then
		e:SetCategory(CATEGORY_DESTROY)
		e:SetProperty(0)
		e:SetOperation(s.desop)
		s.descost(e,tp,Group.FromCards(a),ep,ev,re,r,rp,1)
		s.destg(e,tp,Group.FromCards(a),ep,ev,re,r,rp,1)
	else
		e:SetCategory(0)
		e:SetProperty(0)
		e:SetOperation(nil)
	end
end
function s.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(id)==0 end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(800)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,800)
	e:GetHandler():RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.CheckReleaseGroup(1-tp,Card.IsReleasableByEffect,1,nil) and Duel.SelectYesNo(1-tp,aux.Stringid(4014,4)) then
		local g=Duel.SelectReleaseGroup(1-tp,Card.IsReleasableByEffect,1,1,nil)
		if Duel.Release(g,REASON_EFFECT)>0 then return end
	end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
function s.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,800) end
	Duel.PayLPCost(tp,800)
end
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttacker()
	return at:IsControler(1-tp) and Duel.GetAttackTarget()==nil
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tg=Duel.GetAttacker()
	if chk==0 then return tg:IsOnField() and tg:IsDestructable() and e:GetHandler():GetFlagEffect(id)==0 end
	Duel.SetTargetCard(tg)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tg,1,0,0)
	e:GetHandler():RegisterFlagEffect(id-1,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsAttackable() and not tc:IsStatus(STATUS_ATTACK_CANCELED)
		and Duel.NegateAttack() then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end