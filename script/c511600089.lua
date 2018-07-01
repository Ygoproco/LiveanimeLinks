--トリックスター・ペレニアル
--Trickstar Perennial
--scripted by Larry126
function c511600089.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetTarget(c511600089.target)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(83994433,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetTarget(c511600089.tg)
	e2:SetOperation(c511600089.op)
	c:RegisterEffect(e2)
end
function c511600089.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return c511600089.tg(e,tp,eg,ep,ev,re,r,rp,0,chkc) end
	if chk==0 then return true end
	if c511600089.tg(e,tp,eg,ep,ev,re,r,rp,0) and Duel.SelectEffectYesNo(tp,e:GetHandler()) then
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		e:SetOperation(c511600089.op)
		c511600089.tg(e,tp,eg,ep,ev,re,r,rp,1)
	else
		e:SetProperty(0)
		e:SetOperation(nil)
	end
end
function c511600089.filter(c,ec)
	return c:IsType(TYPE_LINK) and c:IsFaceup() and c:IsSetCard(0xfb)
		and (c:GetLinkedGroup():IsExists(Card.IsAbleToGraveAsCost,1,nil) or ec:IsAbleToGraveAsCost())
end
function c511600089.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c511600089.filter(chkc,c) end
	if chk==0 then return c:GetFlagEffect(511600089)==0
		and Duel.IsExistingTarget(c511600089.filter,tp,LOCATION_MZONE,0,1,nil,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local tc=Duel.SelectTarget(tp,c511600089.filter,tp,LOCATION_MZONE,0,1,1,nil,c):GetFirst()
	local lg=tc:GetLinkedGroup()
	lg:AddCard(c)
	local cg=lg:FilterSelect(tp,Card.IsAbleToGraveAsCost,1,1,nil)
	Duel.SendtoGrave(cg,REASON_COST)
	cg:KeepAlive()
	e:SetLabelObject(cg)
	c:RegisterFlagEffect(511600089,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c511600089.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not e:GetLabelObject():IsContains(c) and not c:IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end