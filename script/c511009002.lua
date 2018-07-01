--Number XX: Infinity Dark Hope
--fixed by Larry126
function c511009002.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,10,3)
	c:EnableReviveLimit()
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(53701074,0))
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetTarget(c511009002.target)
	e2:SetOperation(c511009002.operation)
	c:RegisterEffect(e2)
end
c511009002.xyz_number="XX"
function c511009002.filter(c)
	return c:IsSummonType(SUMMON_TYPE_SPECIAL) and aux.nzatk(c)
end
function c511009002.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c511009002.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c511009002.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c511009002.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c511009002.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if aux.nzatk(tc) and tc:IsRelateToEffect(e) then
		local c=e:GetHandler()
		local fid=c:GetFieldID()
		tc:RegisterFlagEffect(511009002,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1,fid)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetLabel(fid)
		e1:SetLabelObject(tc)
		e1:SetCondition(c511009002.reccon)
		e1:SetTarget(c511009002.rectg)
		e1:SetOperation(c511009002.recop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c511009002.reccon(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabelObject():GetFlagEffectLabel(511009002)~=e:GetLabel() then
		e:Reset()
		return false
	else return true end
end
function c511009002.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,e:GetLabelObject():GetAttack())
end
function c511009002.recop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.Recover(p,e:GetLabelObject():GetAttack(),REASON_EFFECT)
end