--Number XX: Infinity Dark Hope
function c511009002.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,10,3)
	c:EnableReviveLimit()
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(50078320,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetTarget(c50078320.regtg)
	e2:SetOperation(c50078320.regop)
	c:RegisterEffect(e2)
end
c47805931.xyz_number="XX"
function c511009002.filter(c)
	return bit.band(c:GetSummonType(),SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL
end
function c511009002.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c511009002.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c511009002.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c511009002.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c511009002.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
	tc:RegisterFlagEffect(511009002,RESET_EVENT+0x1fe0000,0,1,fid)
	local g=Group.CreateGroup()
	g:AddCard(tc)
	g:KeepAlive()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetLabel(fid)
	e1:SetLabelObject(g)
	e1:SetCondition(c511009002.reccon)
	e1:SetOperation(c511009002.recop)
	Duel.RegisterEffect(e1,tp)
	end
	g:AddCard(c)
	g:KeepAlive()
	
end
function c511009002.recfilter(c,fid)
	return c:GetFlagEffectLabel(511009002)==fid
end
function c511009002.reccon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not g:IsExists(c511009002.rmfilter,1,nil,e:GetLabel()) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function c511009002.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=e:GetLabelObject()
	local tg=g:Filter(c511009002.rmfilter,nil,e:GetLabel())
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(tg:GetFirst():GetAttack())
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,tg:GetFirst():GetAttack())
end
function c511009002.recop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end