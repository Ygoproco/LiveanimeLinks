--Odd-Eyes Mirage Dragon (Anime)
--scripted by Larry126
function c511600039.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--no damage & destruction
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(34149830,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c511600039.condition)
	e2:SetTarget(c511600039.target)
	e2:SetOperation(c511600039.operation)
	c:RegisterEffect(e2)
end
function c511600039.condition(e,tp,eg,ep,ev,re,r,rp)
	if not (Duel.GetBattleDamage(tp)>0 or Duel.GetBattleDamage(1-tp)>0) then return false end
	local tc=Duel.GetAttacker()
	local bc=tc:GetBattleTarget()
	if not tc or not bc then return false end
	local bd=Group.CreateGroup()
	if tc:IsPosition(POS_FACEUP_DEFENSE) then
		if not tc:IsHasEffect(EFFECT_DEFENSE_ATTACK) then return false end
		if tc:IsHasEffect(75372290) then
			bd:Merge(bc:IsAttackPos() and tc:GetAttack()>0 and (tc:GetAttack()>bc:GetAttack() and Group.FromCards(bc)
				or bc:GetAttack()>tc:GetAttack() and Group.FromCards(tc) or Group.FromCards(bc,tc))
				or tc:GetAttack()>bc:GetDefense() and Group.FromCards(bc) or bd)
		else
			bd:Merge(bc:IsAttackPos() and tc:GetDefense()>0 and tc:GetDefense()>=bc:GetAttack() and Group.FromCards(bc)
			or tc:GetDefense()>bc:GetDefense() and Group.FromCards(bc) or bd)
		end
	else
		bd:Merge(bc:IsAttackPos() and tc:GetAttack()>0 and (tc:GetAttack()>bc:GetAttack() and Group.FromCards(bc)
			or bc:GetAttack()>tc:GetAttack() and Group.FromCards(tc) or Group.FromCards(bc,tc))
			or tc:GetAttack()>bc:GetDefense() and Group.FromCards(bc) or bd)
	end
	local dg=Group.CreateGroup()
	for dc in aux.Next(bd) do
		if dc:IsHasEffect(EFFECT_INDESTRUCTABLE_BATTLE) then
			local bdind={dc:GetCardEffect(EFFECT_INDESTRUCTABLE_BATTLE)}
			for i=1,#bdind do
				local te=bdind[i]
				local f=te:GetValue()
				if type(f)=='function' then
					if not f(te,dc) then dg:AddCard(dc) end
				end
			end
		else dg:AddCard(dc) end
	end
	dg:KeepAlive()
	e:SetLabelObject(dg)
	return dg:GetCount()>0
end
function c511600039.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x99)
end
function c511600039.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsStatus(STATUS_CHAINING)
		and c:GetFlagEffect(511600039)<Duel.GetMatchingGroupCount(c511600039.filter,tp,LOCATION_PZONE,0,nil) end
	Duel.SetTargetCard(e:GetLabelObject())
end
function c511600039.cfilter(c,e,tp)
	return c:IsOnField() and c:IsType(TYPE_MONSTER) and c:IsRelateToEffect(e) and c:IsRelateToBattle()
end
function c511600039.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:RegisterFlagEffect(511600039,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(c511600039.cfilter,nil,e,tp)
	g:KeepAlive()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DESTROY_SUBSTITUTE)
	e1:SetLabelObject(g)
	e1:SetTarget(c511600039.destg)
	e1:SetValue(c511600039.value)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e2:SetOperation(c511600039.damop)
	e2:SetReset(RESET_PHASE+PHASE_DAMAGE)
	Duel.RegisterEffect(e2,tp)
end
function c511600039.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(Duel.GetBattleDamage(tp)>0 and tp or 1-tp,0)
end
function c511600039.desfilter(c,g)
	return c:IsLocation(LOCATION_ONFIELD) and c:IsType(TYPE_MONSTER)
		and c:IsReason(REASON_BATTLE) and c:IsRelateToBattle() and g:IsContains(c)
end
function c511600039.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return eg:IsExists(c511600039.desfilter,1,nil,e:GetLabelObject())
	end
	return true
end
function c511600039.value(e,c)
	return c511600039.desfilter(c,e:GetLabelObject())
end