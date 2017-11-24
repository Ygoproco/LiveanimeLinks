--Doppler Phase Coating
--scripted by Larry126
--fixed by MLD
function c511600035.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCost(aux.RemainFieldCost)
	e1:SetTarget(c511600035.target)
	e1:SetOperation(c511600035.activate)
	c:RegisterEffect(e1)
	--End Battle Phase
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c511600035.edcon)
	e2:SetOperation(c511600035.edop)
	c:RegisterEffect(e2)
end
function c511600035.filter(c)
	return c:IsFaceup() and c:IsRace(RACE_CYBERSE)
end
function c511600035.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c511600035.filter(chkc) end
	if chk==0 then return e:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsExistingTarget(c511600035.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c511600035.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c511600035.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsLocation(LOCATION_SZONE) or not c:IsRelateToEffect(e) or c:IsStatus(STATUS_LEAVE_CONFIRMED) then return end
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,c,tc)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_EQUIP)
		e1:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
		e1:SetCountLimit(1)
		e1:SetValue(c511600035.valcon)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_EQUIP_LIMIT)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetValue(c511600035.eqlimit)
		e2:SetLabelObject(tc)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e2)
	else
		c:CancelToGrave(false)
	end
end
function c511600035.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function c511600035.valcon(e,re,r,rp)
	return r&REASON_BATTLE~=0
end
function c511600035.edcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
end
function c511600035.edop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SkipPhase(Duel.GetTurnPlayer(),PHASE_BATTLE,RESET_PHASE+PHASE_BATTLE,1)
end
