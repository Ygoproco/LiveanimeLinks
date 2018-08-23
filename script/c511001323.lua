--忍法・天空大凧
--Great Kite of Ninja
--fixed by Larry126
function c511001323.initial_effect(c)
	--equip
	aux.AddEquipProcedure(c,nil,aux.FilterBoolFunction(Card.IsCode,511001322))
	--disable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTargetRange(LOCATION_SZONE,LOCATION_SZONE)
	e1:SetTarget(c511001323.distg)
	c:RegisterEffect(e1)
	--disable effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetRange(LOCATION_SZONE)
	e2:SetOperation(c511001323.disop)
	c:RegisterEffect(e2)
	--untargetable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--Direct attack
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(37433748,1))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCondition(c511001323.dircon)
	e4:SetCost(c511001323.dircost)
	e4:SetOperation(c511001323.dirop)
	c:RegisterEffect(e4)
end
function c511001323.distg(e,c)
	local ec=e:GetHandler()
	if c==ec or c:GetCardTargetCount()==0 then return false end
	local eq=ec:GetEquipTarget()
	return eq and c:GetCardTarget():IsContains(eq) and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c511001323.disop(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler()
	if not ec:GetEquipTarget() or not re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
		or not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not g or not g:IsContains(ec:GetEquipTarget()) then return end
	Duel.NegateEffect(ev)
end
function c511001323.dircon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsAbleToEnterBP()
end
function c511001323.dircost(e,tp,eg,ep,ev,re,r,rp,chk)
	local eq=e:GetHandler():GetEquipTarget()
	if chk==0 then return Duel.CheckReleaseGroupCost(tp,nil,1,false,nil,nil,eq) end
	local g=Duel.SelectReleaseGroupCost(tp,nil,1,1,false,nil,nil,eq)
	Duel.Release(g,REASON_COST)
end
function c511001323.dirop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_EQUIP)
	e5:SetProperty(EFFECT_CANNOT_DISABLE)
	e5:SetCode(EFFECT_DIRECT_ATTACK)
	e5:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e5)
end