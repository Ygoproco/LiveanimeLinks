--Gravity Warrior (Manga)
function c511010534.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,1,1,aux.NonTuner(nil),1,99)
	c:EnableReviveLimit()
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(44035031,0))
	e1:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetOperation(c511010534.atkop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--Force Attack
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(44035031,1))
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetHintTiming(0,0x28)
	e4:SetCountLimit(1)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c511010534.atcon)
	e4:SetTarget(c511010534.attg)
	e4:SetOperation(c511010534.atop)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(47754278,0))
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetCondition(c511010534.descon)
	e5:SetTarget(c511010534.destg)
	e5:SetOperation(c511010534.desop)
	c:RegisterEffect(e5)
end
function c511010534.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsFaceup() or not c:IsRelateToEffect(e) then return end
	local ct=Duel.GetMatchingGroupCount(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(ct*500)
	e1:SetReset(RESET_EVENT+0x1ff0000)
	c:RegisterEffect(e1)
end
function c511010534.atcon(e,tp,eg,ev,ep,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE 
end
function c511010534.filter(c)
	return c:IsFaceup() and not c:IsHasEffect(EFFECT_CANNOT_ATTACK) and not c:IsHasEffect(EFFECT_CANNOT_ATTACK_ANNOUNCE) 
		and (c:IsAttackPos() or c:IsHasEffect(EFFECT_DEFENSE_ATTACK))
end
function c511010534.attg(e,tp,eg,ev,ep,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and c511010534.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c511010534.filter,tp,0,LOCATION_MZONE,1,nil) and e:GetHandler():GetFlagEffect(511010534)==0 end
	Duel.SelectTarget(tp,c511010534.filter,tp,0,LOCATION_MZONE,1,1,nil,0)
	e:GetHandler():RegisterFlagEffect(511010534,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c511010534.atop(e,tp,eg,ev,ep,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_MUST_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		if tc:GetAttackAnnouncedCount()~=0 then
			local e2=e1:Clone()
			e2:SetCode(EFFECT_EXTRA_ATTACK)
			e2:SetValue(1)
			tc:RegisterEffect(e2)
		end
		tc=g:GetNext()
	end
end
function c511010534.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(511010534)~=0
end
function c511010534.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function c511010534.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end