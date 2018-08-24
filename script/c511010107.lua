--No.107 銀河眼の時空竜 (Anime)
--Number 107: Galaxy-Eyes Tachyon Dragon (Anime)
--fixed and cleaned up by MLD
--fixed by Larry126
function c511010107.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,8,2)
	c:EnableReviveLimit()
	--battle indestructable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(aux.NOT(aux.TargetBoolFunction(Card.IsSetCard,0x48)))
	c:RegisterEffect(e1)
	--negate opponent's turn
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(799183,0))
	e2:SetCategory(CATEGORY_DISABLE+CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c511010107.negcono)
	e2:SetCost(c511010107.negcost)
	e2:SetTarget(c511010107.negtg)
	e2:SetOperation(c511010107.negop)
	c:RegisterEffect(e2,false,1)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DISABLE+CATEGORY_ATKCHANGE)
	e3:SetDescription(aux.Stringid(799183,0))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c511010107.negconp)
	e3:SetCost(c511010107.negcost)
	e3:SetTarget(c511010107.negtg)
	e3:SetOperation(c511010107.negop)
	c:RegisterEffect(e3,false,1)
	if not c511010107.global_check then
		c511010107.global_check=true
		--Cards that resolved effects check
		BPResolvedEffects={}
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAIN_SOLVED)
		e1:SetCondition(c511010107.regcon)
		e1:SetOperation(c511010107.regop)
		Duel.RegisterEffect(e1,0)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetCountLimit(1)
		e2:SetOperation(c511010107.reset)
		Duel.RegisterEffect(e2,0)
	end
	aux.CallToken(88177324)
end
c511010107.xyz_number=107
function c511010107.regcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE
end
function c511010107.regop(e,tp,eg,ep,ev,re,r,rp)
	local cid=e:GetOwner():GetFieldID()
	if not BPResolvedEffects[cid] then BPResolvedEffects[cid]={} end
	for _,fid in ipairs(BPResolvedEffects[cid]) do
		if fid==re:GetHandler():GetFieldID() then return end
	end
	table.insert(BPResolvedEffects[cid],re:GetHandler():GetFieldID())
end
function c511010107.reset(e,tp,eg,ep,ev,re,r,rp)
	BPResolvedEffects={}
end
function c511010107.negcono(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c511010107.cfilter(c)
	return c:GetFlagEffect(511010108)>0
end
function c511010107.negconp(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE and Duel.GetTurnPlayer()==tp 
		and not Duel.GetAttacker() and Duel.GetCurrentChain()==0 
		and not Duel.IsExistingMatchingCard(c511010107.cfilter,tp,LOCATION_MZONE,0,1,e:GetHandler())
end
function c511010107.ftarget(e,c)
	return c:GetFlagEffectLabel(511010108)~=e:GetLabel()
end
function c511010107.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	if Duel.GetTurnPlayer()==tp then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_ATTACK)
		e1:SetProperty(EFFECT_FLAG_OATH+EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetTargetRange(LOCATION_MZONE,0)
		e1:SetTarget(c511010107.ftarget)
		e1:SetLabel(e:GetHandler():GetFieldID())
		e1:SetReset(RESET_PHASE+PHASE_BATTLE)
		Duel.RegisterEffect(e1,tp)
	end
end
function c511010107.disfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT) and not c:IsDisabled()
end
function c511010107.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c511010107.disfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler()) 
		or BPResolvedEffects[e:GetHandler():GetFieldID()] end
end
function c511010107.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local res=false
	local g=Duel.GetMatchingGroup(c511010107.disfilter,tp,LOCATION_MZONE,LOCATION_MZONE,c)
	for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2)
		if not tc:IsImmuneToEffect(e1) and not tc:IsImmuneToEffect(e2) then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_SET_ATTACK_FINAL)
			e3:SetValue(tc:GetBaseAttack())
			e3:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e3)
			local e4=Effect.CreateEffect(c)
			e4:SetType(EFFECT_TYPE_SINGLE)
			e4:SetCode(EFFECT_SET_DEFENSE_FINAL)
			e4:SetValue(tc:GetBaseDefense())
			e4:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e4)
		end
		res=true
	end
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	local fid=e:GetHandler():GetFieldID()
	local bpre=BPResolvedEffects[fid]
	if bpre then
		Duel.BreakEffect()
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_SINGLE)
		e5:SetCode(EFFECT_UPDATE_ATTACK)
		e5:SetValue(#bpre*1000)
		e5:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e5)
		res=true
	end
	local atkct=c:GetAttackAnnouncedCount()
	if atkct>0 and Duel.GetTurnPlayer()==tp and res then
		local e6=Effect.CreateEffect(c)
		e6:SetType(EFFECT_TYPE_SINGLE)
		e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e6:SetCode(EFFECT_EXTRA_ATTACK)
		e6:SetValue(atkct)
		e6:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
		c:RegisterEffect(e6)
		c:RegisterFlagEffect(511010108,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE+PHASE_BATTLE,0,1,fid)
	end
end