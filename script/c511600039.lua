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
	local tc=Duel.GetAttacker()
	local bc=tc:GetBattleTarget()
	if not tc or not bc then return false end
	if tc:IsHasEffect(EFFECT_INDESTRUCTABLE_BATTLE) and bc:IsHasEffect(EFFECT_INDESTRUCTABLE_BATTLE) then
		local tcind={tc:GetCardEffect(EFFECT_INDESTRUCTABLE_BATTLE)}
		local bcind={bc:GetCardEffect(EFFECT_INDESTRUCTABLE_BATTLE)}
		for i=1,#tcind do
			local te=tcind[i]
			local f=te:GetValue()
			if type(f)=='function' then
				if f(te,bc) then 
					for i=1,#bcind do
						local te=bcind[i]
						local f=te:GetValue()
						if type(f)=='function' then
							if f(te,tc) then return false end
						else return false end
					end
				end
			else
				for i=1,#bcind do
					local te=bcind[i]
					local f=te:GetValue()
					if type(f)=='function' then
						if f(te,tc) then return false end
					else return false end
				end
			end
		end
	end
	if tc:IsHasEffect(EFFECT_DEFENSE_ATTACK) then
		if tc:IsHasEffect(75372290) then
			return bc:GetAttack()<=tc:GetAttack()
		else
			return bc:GetAttack()<=tc:GetDefense()
		end
	else
		return true
	end
end
function c511600039.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x99)
end
function c511600039.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsStatus(STATUS_CHAINING)
		and c:GetFlagEffect(511600039)<Duel.GetMatchingGroupCount(c511600039.filter,tp,LOCATION_PZONE,0,nil) end
end
function c511600039.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:RegisterFlagEffect(511600039,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE_CAL)
	e1:SetTargetRange(1,1)
	e1:SetValue(1)
	Duel.RegisterEffect(e1,tp)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetTarget(c511600039.destg)
	e2:SetValue(c511600039.value)
	e2:SetOperation(c511600039.desop)
	Duel.RegisterEffect(e2,tp)
end
function c511600039.desfilter(c)
	return c:IsLocation(LOCATION_ONFIELD) and c:IsType(TYPE_MONSTER)
		and c:IsReason(REASON_BATTLE) and not c:IsReason(REASON_REPLACE)
		and c:IsRelateToBattle()
end
function c511600039.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return eg:IsExists(c511600039.desfilter,1,nil)
	end
	return true
end
function c511600039.value(e,c)
	return c511600039.desfilter(c)
end
function c511600039.desop(e,tp,eg,ep,ev,re,r,rp)
	e:Reset()
end