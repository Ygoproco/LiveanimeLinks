--CNo.102 光堕天使ノーブル・デーモン (Anime)
--Number C102: Archfiend Seraph (Anime)
--fixed by Larry126
function c511001429.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunctionEx(Card.IsAttribute,ATTRIBUTE_LIGHT),5,4)
	c:EnableReviveLimit()
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(49678559,0))
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c511001429.cost)
	e1:SetTarget(c511001429.tg)
	e1:SetOperation(c511001429.op)
	c:RegisterEffect(e1,false,1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(49678559,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e2:SetCondition(c511001429.indescon)
	e2:SetCost(c511001429.indescost)
	e2:SetTarget(c511001429.indestg)
	e2:SetOperation(c511001429.indesop)
	c:RegisterEffect(e2,false,1)
	local e3=e2:Clone()
	e3:SetCode(EVENT_CHAINING)
	e3:SetCondition(c511001429.indescon2)
	c:RegisterEffect(e3,false,1)
	--battle indestructable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e4:SetValue(aux.NOT(aux.TargetBoolFunction(Card.IsSetCard,0x48)))
	c:RegisterEffect(e4)
	--Rank Up Check
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_MATERIAL_CHECK)
	e5:SetValue(c511001429.valcheck)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	e6:SetLabelObject(e5)
	e6:SetOperation(c511001429.rankupregop)
	c:RegisterEffect(e6)
	e1:SetLabelObject(e6)
	e2:SetLabelObject(e6)
	e3:SetLabelObject(e6)
	aux.CallToken(67173574)
end
c511001429.xyz_number=102
c511001429.listed_names={49678559}
function c511001429.rumfilter(c)
	return c:IsCode(49678559) and not c:IsPreviousLocation(LOCATION_OVERLAY)
end
function c511001429.valcheck(e,c)
	local mg=c:GetMaterial()
	if mg:IsExists(c511001429.rumfilter,1,nil) then
		e:SetLabel(1)
	else
		e:SetLabel(0)
	end
end
function c511001429.rankupregop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ) and (rc:IsSetCard(0x95)
		or rc:IsCode(100000581) or rc:IsCode(111011002) or rc:IsCode(511000580)
		or rc:IsCode(511002068) or rc:IsCode(511002164) or rc:IsCode(93238626))
		and e:GetLabelObject():GetLabel()==1 then
		e:SetLabel(1)
	else
		e:SetLabel(0)
	end
end
function c511001429.rankupcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabelObject():GetLabel()==1
end
function c511001429.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST)
		and e:GetLabelObject():GetLabel()==1 end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c511001429.filter(c)
	return c:IsFaceup() and (c:GetAttack()>0 or not c:IsDisabled())
end
function c511001429.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c511001429.filter,tp,0,LOCATION_MZONE,1,nil) end
end
function c511001429.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectMatchingCard(tp,c511001429.filter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.HintSelection(g)
	local tc=g:GetFirst()
	if tc then
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
			e3:SetValue(0)
			e3:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e3)
		end
	end
end
function c511001429.indescon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler()
	local bc=tc:GetBattleTarget()
	if not bc then return false end
	if tc:IsHasEffect(EFFECT_INDESTRUCTABLE_BATTLE) then
		local tcind={tc:GetCardEffect(EFFECT_INDESTRUCTABLE_BATTLE)}
		for _,te in ipairs(tcind) do
			local f=te:GetValue()
			if type(f)=='function' then
				if f(te,bc) then return false end
			else return false end
		end
	end
	if bc==Duel.GetAttackTarget() and bc:IsDefensePos() then return false end
	if bc:IsPosition(POS_FACEUP_DEFENSE) and bc==Duel.GetAttacker() then
		if not bc:IsHasEffect(EFFECT_DEFENSE_ATTACK) then return false end
		if bc:IsHasEffect(75372290) then
			if tc:IsAttackPos() then
				return bc:GetAttack()>0 and bc:GetAttack()>=tc:GetAttack()
			else
				return bc:GetAttack()>tc:GetDefense()
			end
		else
			if tc:IsAttackPos() then
				return bc:GetDefense()>0 and bc:GetDefense()>=tc:GetAttack()
			else
				return bc:GetDefense()>tc:GetDefense()
			end
		end
	else
		if tc:IsAttackPos() then
			return bc:GetAttack()>0 and bc:GetAttack()>=tc:GetAttack()
		else
			return bc:GetAttack()>tc:GetDefense()
		end
	end
end
function c511001429.indescon2(e,tp,eg,ep,ev,re,r,rp)
	local ex,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_DESTROY)
	return ex and tg and tg:IsContains(e:GetHandler())
end
function c511001429.indescost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:CheckRemoveOverlayCard(tp,c:GetOverlayCount(),REASON_COST)
		and e:GetLabelObject():GetLabel()==1 end
	c:RemoveOverlayCard(tp,c:GetOverlayCount(),c:GetOverlayCount(),REASON_COST)
end
function c511001429.indestg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local atk=e:GetHandler():GetAttack()
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(atk)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,atk)
end
function c511001429.indesop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		if e:GetCode()==EVENT_PRE_DAMAGE_CALCULATE then
			e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
			e1:SetValue(1)
			e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
		else
			e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
			e1:SetValue(function(e,te) return re==te end)
			e1:SetReset(RESET_CHAIN)
		end
		c:RegisterEffect(e1)
		local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
		Duel.Damage(p,c:GetAttack(),REASON_EFFECT)
	end
end