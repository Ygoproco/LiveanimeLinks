--ミラーコート・ユニット
--Mirror Coat Unit
--scripted by Larry126
local s,id=GetID()
function s.initial_effect(c)
	--equip
	aux.AddEquipProcedure(c,nil,aux.FilterBoolFunction(Card.IsSetCard,0x581))
	--reflect
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCondition(s.refcon)
	e1:SetOperation(s.refop)
	c:RegisterEffect(e1)
	--no damage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(34149830,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(s.condition)
	e2:SetOperation(s.operation)
	c:RegisterEffect(e2)
	--return
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(2356994,0))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCondition(function(e) return e:GetHandler():IsPreviousPosition(POS_FACEUP) end)
	e3:SetTarget(s.rettg)
	e3:SetOperation(s.retop)
	c:RegisterEffect(e3)
end
function s.refcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetEquipTarget()
	local bc=tc:GetBattleTarget()
	return bc and bc:IsLevelBelow(4) and Duel.GetBattleDamage(tp)>0
end
function s.refop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(1-tp,Duel.GetBattleDamage(1-tp)+Duel.GetBattleDamage(tp),false)
	Duel.ChangeBattleDamage(tp,0)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	local bc=tc:GetBattleTarget()
	local ec=e:GetHandler():GetEquipTarget()
	if not bc or Duel.GetBattleDamage(ec:GetControler())<=0 or not (tc==ec or bc==ec) then return false end
	if ec:IsHasEffect(EFFECT_INDESTRUCTABLE_BATTLE) then
		local ecind={ec:GetCardEffect(EFFECT_INDESTRUCTABLE_BATTLE)}
		for i=1,#ecind do
			local te=ecind[i]
			local f=te:GetValue()
			if type(f)=='function' then
				if f(te,bc) then return false end
			else return false end
		end
	end
	local bd=Group.CreateGroup()
	if tc:IsPosition(POS_FACEUP_DEFENSE) then
		if not tc:IsHasEffect(EFFECT_DEFENSE_ATTACK) then return false end
		if tc:IsHasEffect(75372290) then
			bd:Merge(bc:IsAttackPos() and (tc:GetAttack()>0 or bc:GetAttack()>0)
			and (tc:GetAttack()>bc:GetAttack() and Group.FromCards(bc)
			or bc:GetAttack()>tc:GetAttack() and Group.FromCards(tc) or Group.FromCards(bc,tc))
			or tc:GetAttack()>bc:GetDefense() and Group.FromCards(bc) or bd)
		else
			bd:Merge(bc:IsAttackPos() and (tc:GetDefense()>0 or bc:GetDefense()>0)
			and tc:GetDefense()>=bc:GetAttack() and Group.FromCards(bc)
			or tc:GetDefense()>bc:GetDefense() and Group.FromCards(bc) or bd)
		end
	else
		bd:Merge(bc:IsAttackPos() and (tc:GetAttack()>0 or bc:GetAttack()>0) and (tc:GetAttack()>bc:GetAttack() and Group.FromCards(bc)
		or bc:GetAttack()>tc:GetAttack() and Group.FromCards(tc) or Group.FromCards(bc,tc))
		or tc:GetAttack()>bc:GetDefense() and Group.FromCards(bc) or bd)
	end
	return bd:IsContains(ec)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not Duel.SelectEffectYesNo(tp,c) then return end
	--no damage
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e1:SetOperation(s.damop)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
	Duel.RegisterEffect(e1,c:GetEquipTarget():GetControler())
	--destroy sub
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCode(EFFECT_DESTROY_SUBSTITUTE)
	e2:SetReset(RESET_PHASE+PHASE_DAMAGE)
	e2:SetValue(s.val)
	c:RegisterEffect(e2)
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(tp,0)
end
function s.val(e,re,r,rp)
	return r&REASON_BATTLE==REASON_BATTLE
end
function s.thfilter(c,cid)
	return c:IsCode(cid) and c:IsAbleToHand()
end
function s.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=e:GetHandler():GetPreviousEquipTarget()
	if chk then return tc and tc:IsAbleToHand()
		and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil,tc:GetCode()) end
	local g=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_DECK,0,nil,tc:GetCode())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g+tc,2,0,tc:GetLocation()+LOCATION_DECK)
end
function s.retop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetPreviousEquipTarget()
	local dg=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_DECK,0,nil,tc:GetCode())
	if tc and Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 and #dg>0 then
		local g=#dg==1 and dg or dg:Select(tp,1,1,nil)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
