--真青眼の究極竜 (Anime)
--Neo Blue-Eyes Ultimate Dragon (Anime)
function c511016006.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcMixN(c,true,true,89631139,3)
	--cos
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(89312388,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c511016006.atkcost)
	e1:SetTarget(c511016006.atktg)
	e1:SetOperation(c511016006.atkop)
	c:RegisterEffect(e1)
	--cannot be target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsCode,23995346))
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetValue(c511016006.efilter)
	c:RegisterEffect(e3)
end
c511016006.listed_names={89631139,23995346}
function c511016006.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(511016006)==0 and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_EXTRA,0,1,nil,23995346) end
	c:RegisterFlagEffect(511016006,nil,0,1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,Card.IsCode,tp,LOCATION_EXTRA,0,1,1,nil,23995346)
	Duel.ConfirmCards(1-tp,g)
end
function c511016006.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetEffectCount(EFFECT_EXTRA_ATTACK)==0 end
end
function c511016006.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local fid=c:GetFieldID()
	if c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_EXTRA_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(2)
		c:RegisterEffect(e1)
		c:RegisterFlagEffect(51116006,RESET_EVENT+0x1fe0000,0,1,fid)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_PHASE+PHASE_BATTLE)
		e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e2:SetCountLimit(1)
		e2:SetLabel(fid)
		e2:SetLabelObject(c)
		e2:SetCondition(c511016006.descon)
		e2:SetOperation(c511016006.desop)
		Duel.RegisterEffect(e2,tp)
	end
end
function c511016006.descon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffectLabel(51116006)==e:GetLabel() then
		return true
	else
		e:Reset()
		return false end
end
function c511016006.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.Destroy(tc,REASON_EFFECT)
end
function c511016006.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end