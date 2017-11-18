--Forest Wolf
function c511001418.initial_effect(c)
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetCode(EVENT_BATTLE_DESTROYING)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetTarget(c511001418.eqtg)
	e1:SetOperation(c511001418.eqop)
	c:RegisterEffect(e1)
	aux.AddEREquipLimit(c,nil,function(ec,_,tp) return ec:GetOriginalType()&TYPE_MONSTER>0 end,aux.EquipByEffectAndLimitRegister,e1)
	--aux.AddEREquipLimit(c,nil,aux.FilterBoolFunction(Card.IsType,TYPE_MONSTER),aux.EquipByEffectAndLimitRegister,e1)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetCode(EVENT_LEAVE_FIELD_P)
	e4:SetOperation(c511001418.eqcheck)
	c:RegisterEffect(e4)
	--Release equipped monsters
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCondition(c511001418.damcon)
	e2:SetTarget(c511001418.damtg)
	e2:SetOperation(c511001418.damop)
	e2:SetLabelObject(e4)
	c:RegisterEffect(e2)
end
function c511001418.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local bc=e:GetHandler():GetBattleTarget()
	if bc then
		Duel.SetTargetCard(bc)
		Duel.SetOperationInfo(0,CATEGORY_EQUIP,bc,1,0,0)
		if bc:IsLocation(LOCATION_GRAVE) then
			Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,bc,1,0,0)
		end
	end
end
function c511001418.eqop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if not bc or c:IsStatus(STATUS_BATTLE_DESTROYED) then return end
	if c:IsFaceup() and c:IsRelateToEffect(e) and bc and bc:IsRelateToEffect(e) and bc:IsLocation(LOCATION_SZONE+LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED) then
		aux.EquipByEffectAndLimitRegister(c,e,tp,bc)
	end
end
function c511001418.eqcheck(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabelObject() then e:GetLabelObject():DeleteGroup() end
	local g=e:GetHandler():GetEquipGroup()
	g:KeepAlive()
	e:SetLabelObject(g)
end
function c511001418.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_DESTROY) and c:GetPreviousLocation()==LOCATION_MZONE
end
function c511001418.spfilter(c,e,tp)
	return c:IsRelateToEffect(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c511001418.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=e:GetLabelObject():GetLabelObject()
	if chk==0 then return true end
	if g and g:GetCount()>0 then
		Duel.SetTargetCard(g)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,g:GetCount(),0,0)
	end
end
function c511001418.damop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not tg or tg:GetCount()<=0 then return end
	local g=tg:Filter(c511001418.spfilter,nil,e,tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	if g:GetCount()>ft then return end
	local tc=g:GetFirst()
	while tc do
		Duel.SpecialSummonStep(tc,0,tc:GetOwner(),tc:GetOwner(),false,false,POS_FACEUP)
		tc=g:GetNext()
	end
	Duel.SpecialSummonComplete()
end
