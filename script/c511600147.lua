--ディメンション・リンケージ
--Dimension Link
--scripted by Larry126
function c511600147.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c511600147.cost)
	e1:SetTarget(c511600147.target)
	e1:SetOperation(c511600147.activate)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(511600147,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_ATKCHANGE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c511600147.spcon)
	e2:SetCost(c511600147.spcost)
	e2:SetTarget(c511600147.sptg)
	e2:SetOperation(c511600147.spop)
	c:RegisterEffect(e2)
	e1:SetLabelObject(e2)
end
function c511600147.filter(c)
	return c:IsType(TYPE_LINK) and c:IsFaceup() and c:IsAbleToRemove()
end
function c511600147.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function c511600147.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c511600147.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c511600147.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c511600147.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,tp,LOCATION_MZONE)
end
function c511600147.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
		tc:RegisterFlagEffect(511600147,RESET_EVENT+0x1fe0000,0,1,c:GetFieldID())
		e:GetLabelObject():SetLabel(c:GetFieldID())
	end
end
function c511600147.spcfilter(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_LINK) and c:IsSummonType(SUMMON_TYPE_LINK) and c:IsControler(tp)
end
function c511600147.spfilter(c,e,tp,fid,zone)
	return c:GetFlagEffectLabel(511600147)==fid and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
end
function c511600147.zonefilter(eg,tp)
	local lg=eg:Filter(c511600147.spcfilter,nil,tp)
	local zone=0
	for tc in aux.Next(lg) do
		zone=zone|tc:GetFreeLinkedZone()&0x1f
	end
	return zone
end
function c511600147.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c511600147.spcfilter,1,nil,tp)
end
function c511600147.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() end
	Duel.SendtoGrave(c,REASON_COST)
end
function c511600147.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local zone=c511600147.zonefilter(eg,tp)
	local fid=e:GetLabel()
	if chk==0 then return zone~=0
		and Duel.IsExistingMatchingCard(c511600147.spfilter,tp,LOCATION_REMOVED,0,1,nil,e,tp,fid,zone) end
	local sg=Duel.GetMatchingGroup(c511600147.spfilter,tp,LOCATION_REMOVED,0,nil,e,tp,fid,zone)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,sg,1,tp,LOCATION_REMOVED)
end
function c511600147.spop(e,tp,eg,ep,ev,re,r,rp)
	local zone=c511600147.zonefilter(eg,tp)
	local tc=Duel.GetMatchingGroup(c511600147.spfilter,tp,LOCATION_REMOVED,0,nil,e,tp,e:GetLabel(),zone):GetFirst()
	if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP,zone) then
		local c=e:GetHandler()
		tc:RegisterFlagEffect(511600147,RESET_EVENT+0x1fe0000,0,1)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2,true)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_UPDATE_ATTACK)
		e3:SetValue(600)
		e3:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e3,true)
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e4:SetCode(EVENT_PHASE+PHASE_END)
		e4:SetCountLimit(1)
		e4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e4:SetLabelObject(tc)
		e4:SetCondition(c511600147.descon)
		e4:SetOperation(c511600147.desop)
		Duel.RegisterEffect(e4,tp)
		Duel.SpecialSummonComplete()
	end
end
function c511600147.descon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffect(511600147)~=0 then
		return true
	else
		e:Reset()
		return false
	end
end
function c511600147.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.Destroy(tc,REASON_EFFECT)
end
