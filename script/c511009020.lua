--ＥＭオッドアイズ・ヴァレット
--Performapal Odd-Eyes Valet
--scripted by Larry126
function c511009003.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--damage reduce
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTargetRange(1,0)
	e1:SetValue(c511009003.damval)
	c:RegisterEffect(e1)
end
function c511009003.filter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsFaceup()
end
function c511009003.damval(e,re,val,r,rp,rc)
	local c=e:GetHandler()
	local tp=e:GetHandlerPlayer()
	local ct=Duel.GetMatchingGroupCount(c511009003.filter,tp,LOCATION_EXTRA,0,nil)
	if ct>0 and c:GetFlagEffect(511009003)==0 and Duel.SelectEffectYesNo(tp,c) then
		c:RegisterFlagEffect(511009003,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
		return val-ct*300
	end
	return val
end