--DDD超死偉王ホワイテスト・ヘル・アーマゲドン (Anime)
--D/D/D Super Doom King Bright Armageddon (Anime)
--fixed by Larry126
local s,id,alias=GetID()
function s.initial_effect(c)
	alias=c:GetOriginalCodeRule()
	--synchro summon
	c:EnableReviveLimit()
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xaf),1,1,aux.NonTuner(Card.IsSetCard,0xaf),1,99)
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	--synchro indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_SYNCHRO))
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e2)
	--synchro cannot be target
	local e3=e1:Clone()
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
	--cannot be negate/disable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_DISABLE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_MONSTER))
	c:RegisterEffect(e4)
	--disable
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(alias,1))
	e5:SetCategory(CATEGORY_DISABLE)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_SUMMON_SUCCESS)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTarget(s.distg)
	e5:SetOperation(s.disop)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e6)
end
function s.pfilter(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM)
		and Duel.IsExistingMatchingCard(aux.disfilter1,tp,0,LOCATION_MZONE,1,c)
end
function s.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not eg:IsContains(e:GetHandler())
		and Duel.IsExistingMatchingCard(s.pfilter,tp,0,LOCATION_MZONE,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,nil,Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE),1-tp,LOCATION_MZONE)
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,1-tp,aux.Stringid(alias,2))
	local pc=Duel.SelectMatchingCard(1-tp,s.pfilter,tp,0,LOCATION_MZONE,1,1,nil,tp):GetFirst()
	if not pc then return end
	local c=e:GetHandler()
	local flag=(id+c:GetFieldID()+e:GetFieldID())*2
	for tc in aux.Next(Duel.GetMatchingGroup(aux.disfilter1,tp,0,LOCATION_MZONE,pc)) do
		tc:RegisterFlagEffect(flag,RESET_EVENT+RESETS_STANDARD,0,1)
		--negate
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetLabel(flag)
		e1:SetCondition(s.discon)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetLabelObject(e1)
		e2:SetValue(RESET_TURN_SET)
		tc:RegisterEffect(e2)
		--reset
		local e3=Effect.CreateEffect(c)
		e3:SetDescription(aux.Stringid(45014450,2))
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_SUMMON_SUCCESS)
		e3:SetLabel(flag)
		e3:SetLabelObject(e2)
		e3:SetRange(LOCATION_MZONE)
		e3:SetOperation(s.resetop)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		Duel.RegisterEffect(e3,tp)
		local e4=e3:Clone()
		e4:SetCode(EVENT_SPSUMMON_SUCCESS)
		e4:SetLabelObject(e3)
		Duel.RegisterEffect(e4,tp)
		e3:SetLabelObject(e4)
	end
end
function s.resetFilter(c,flag)
	return c:GetFlagEffect(flag)>0
end
function s.resetop(e,tp,eg,ep,ev,re,r,rp)
	for tc in aux.Next(Duel.GetMatchingGroup(s.resetFilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,e:GetLabel())) do
		tc:ResetFlagEffect(e:GetLabel())
	end
	e:Reset()
	e:GetLabelObject():Reset()
end
function s.discon(e)
	if e:GetHandler():GetFlagEffect(e:GetLabel())>0 then return true
	else e:Reset() return false end
end
