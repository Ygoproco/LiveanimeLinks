-- 時械神祖ヴルガータ
-- Timelord Proginitor, Vulgate
function c511009000.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,1,1,aux.NonTuner(nil),1,99)
	c:EnableReviveLimit()
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	c:RegisterEffect(e3)
	--banish
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DAMAGE_STEP_END)
	e3:SetTarget(c511009000.rmtg)
	e3:SetOperation(c511009000.rmop)
	c:RegisterEffect(e3)
end
function c511009000.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),LOCATION_MZONE,1-tp)
end
function c511009000.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_MZONE,nil)
	if Duel.Remove(g,0,REASON_EFFECT+REASON_TEMPORARY)~=0 then
		local fid=c:GetFieldID()
		local og=Duel.GetOperatedGroup()
		for oc in aux.Next(og) do
			oc:RegisterFlagEffect(511009000,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1,fid)
		end
		og:KeepAlive()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetLabel(fid)
		e1:SetLabelObject(og)
		e1:SetCondition(c511009000.retcon)
		e1:SetOperation(c511009000.retop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c511009000.retfilter(c,fid)
	return c:GetFlagEffectLabel(511009000)==fid
end
function c511009000.retcon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if g:IsExists(c511009000.retfilter,1,nil,e:GetLabel()) then
		return true
	else 
		g:DeleteGroup()
		e:Reset()
		return false
	end
end
function c511009000.retop(e,tp,eg,ep,ev,re,r,rp)
	local og=e:GetLabelObject()
	local g=og:Filter(c511009000.retfilter,nil,e:GetLabel())
	og:DeleteGroup()
	if g:GetCount()<=0 then return end
	local p=g:GetFirst():GetPreviousControler()
	local tg=Group.CreateGroup()
	local ft=Duel.GetLocationCount(p,LOCATION_MZONE)
	if g:GetCount()>ft then
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TOFIELD)
		tg:Merge(g:Select(p,ft,ft,nil))
	else
		tg:Merge(g)
	end
	for tc in aux.Next(tg) do
		Duel.ReturnToField(tc)
	end
end
