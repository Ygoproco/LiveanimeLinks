--Overlay Connection
function c511001167.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c511001167.target)
	e1:SetOperation(c511001167.activate)
	c:RegisterEffect(e1)
end
function c511001167.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:GetOverlayCount()==0
end
function c511001167.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c511001167.filter(chkc) end
	if chk==0 then return e:IsHasType(EFFECT_TYPE_ACTIVATE)
		and Duel.IsExistingTarget(c511001167.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c511001167.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c511001167.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() and c:IsRelateToEffect(e) then
		local fid=c:GetFieldID()
		c:CancelToGrave()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
		e1:SetCode(EVENT_TO_GRAVE)
		e1:SetCondition(c511001167.con)
		e1:SetOperation(c511001167.op)
		e1:SetReset(RESET_EVENT+0x1fa0000)
		e1:SetLabelObject(tc)
		e1:SetLabel(fid)
		c:RegisterEffect(e1)
		Duel.Overlay(tc,Group.FromCards(c))
		tc:RegisterFlagEffect(51101167,RESET_EVENT+RESETS_STANDARD,0,1,fid)
	end
end
function c511001167.con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetLabelObject()
	if not tc or tc:GetFlagEffect(51101167)==0 or tc:GetFlagEffectLabel(51101167)~=e:GetLabel() then
		e:Reset()
		return false
	else return c:IsReason(REASON_COST) and re:IsHasType(0x7e0) and re:IsActiveType(TYPE_MONSTER)
		and c:GetPreviousLocation()&LOCATION_OVERLAY~=0 end
end
function c511001167.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetLabelObject()
	if tc==nil then return end
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(511001167,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1)
	e1:SetCost(c511001167.atcost)
	e1:SetCondition(c511001167.atcon)
	e1:SetTarget(c511001167.attg)
	e1:SetOperation(c511001167.atop)
	e1:SetLabelObject(tc)
	e1:SetLabel(e:GetLabel())
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
end
function c511001167.atcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c511001167.atcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if not tc or tc:GetFlagEffect(51101167)==0 or tc:GetFlagEffectLabel(51101167)~=e:GetLabel() then
		return false
	else return tp==Duel.GetTurnPlayer() end
end
function c511001167.attg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=e:GetLabelObject()
	if chk==0 then return tc and tc:IsLocation(LOCATION_MZONE) and tc:IsFaceup() end
	Duel.SetTargetCard(tc)
end
function c511001167.atop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and tc:GetFlagEffect(51101167)>0 and tc:GetFlagEffectLabel(51101167)==e:GetLabel() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
		e1:SetCode(EVENT_TO_GRAVE)
		e1:SetCondition(c511001167.con)
		e1:SetOperation(c511001167.op)
		e1:SetReset(RESET_EVENT+0x1fa0000)
		e1:SetLabelObject(tc)
		e1:SetLabel(e:GetLabel())
		c:RegisterEffect(e1)
		Duel.Overlay(tc,Group.FromCards(c))
	end
end
