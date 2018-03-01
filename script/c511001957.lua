--閃珖竜 スターダスト (Anime)
--Stardust Spark Dragon (Anime)
--updated by Larry126
function c511001957.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,1,1,aux.NonTuner(nil),1,99)
	c:EnableReviveLimit()
	--destroy replace
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DESTROY_REPLACE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c511001957.reptg)
	e1:SetValue(c511001957.repval)
	e1:SetOperation(c511001957.repop)
	c:RegisterEffect(e1)
end
function c511001957.repfilter(c)
	return c:IsOnField() and not c:IsReason(REASON_REPLACE)
end
function c511001957.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=eg:Filter(c511001957.repfilter,nil)
	if chk==0 then return g:GetCount()>0 end
	if Duel.SelectEffectYesNo(tp,c) then
		local tg=g:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if tc then
			Duel.Hint(HINT_CARD,0,511001957)
			Duel.HintSelection(tg)
			e:SetLabelObject(tc)
		end
		return true
	else return false end
end
function c511001957.repval(e,c)
	return c==e:GetLabelObject() and c:IsOnField()
end
function c511001957.repop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE)
	e1:SetValue(1)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e:GetLabelObject():RegisterEffect(e1)
end