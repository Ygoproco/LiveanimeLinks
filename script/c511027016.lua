--ヴァレル・バスター・バリア
--Borrel Buster Barrier
--Scripted by Playmaker 772211
local s,id=GetID()
local COUNTER_BR=0x15a
local s,id=GetID()
function s.initial_effect(c)
    c:EnableCounterPermit(COUNTER_BR)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--Cannot be target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(s.tgcon)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	--Activate 1 of 2
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(s.actcon)
	e3:SetCost(s.actcost)
	e3:SetTarget(s.acttg)
	e3:SetOperation(s.actop)
	c:RegisterEffect(e3)
end
function s.costfilter(c,tp)
	return c:IsType(TYPE_LINK)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroupCost(tp,s.costfilter,1,false,nil,nil,tp) end
	local sg=Duel.SelectReleaseGroupCost(tp,s.costfilter,1,1,false,nil,nil,tp)
	local rating=sg:GetFirst():GetLink()
	e:SetLabel(rating)
	Duel.Release(sg,REASON_COST)
end
function s.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x10f) and c:IsType(TYPE_LINK)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and s.filter(chkc) end
	if chk==0 then return e:IsHasType(EFFECT_TYPE_ACTIVATE) 
		and Duel.IsExistingTarget(s.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,s.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=e:GetLabel() 
	if not c:IsLocation(LOCATION_SZONE) then return end
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() and Duel.Equip(tp,c,tc) then
		c:CancelToGrave()
	    c:AddCounter(COUNTER_BR,ct)
		--Equip limit
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(s.eqlimit)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
		--Unaffected
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_EQUIP)
		e2:SetCode(EFFECT_IMMUNE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		e2:SetValue(s.efilter)
		c:RegisterEffect(e2,true)
	end
end
function s.eqlimit(e,c)
	return c:IsSetCard(0x10f) and c:IsType(TYPE_LINK)
end
function s.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer() and re:IsActivated()
end
function s.tgcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetEquipTarget()~=nil
end
function s.actcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler():GetEquipTarget()
	local bc=c:GetBattleTarget()
	return bc and bc:IsControler(1-tp)
end
function s.actcost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,COUNTER_BR,1,REASON_COST) end
    e:GetHandler():RemoveCounter(tp,COUNTER_BR,1,REASON_COST)
end
function s.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local op=Duel.SelectOption(tp,aux.Stringid(id,0),aux.Stringid(id,1))
	e:SetLabel(op)
end
function s.actop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler():GetEquipTarget()
	if e:GetLabel()==0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_BATTLED)
		e1:SetOperation(s.desop)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE)
		c:RegisterEffect(e1)
	else
		local e2=Effect.CreateEffect(c)
	    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	    e2:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	    e2:SetOperation(s.damop)
	    e2:SetReset(RESET_PHASE+PHASE_DAMAGE)
	    Duel.RegisterEffect(e2,tp)
	end
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local dc=c:GetBattleTarget()
	local atk=dc:GetAttack()/2
	if atk<0 then atk=0 end
	if dc and Duel.Destroy(dc,REASON_EFFECT)>0 then
		Duel.Damage(1-tp,atk,REASON_EFFECT)
	end
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(tp,ev/2)
end