--アルティマヤ・ツィオルキン (Manga)
--Ultimaya Tzolkin (Manga)
--updated by Larry126
function c511000817.initial_effect(c)
	--dark synchro summon
	c:EnableReviveLimit()
	aux.AddDarkSynchroProcedure(c,aux.NonTuner(nil),nil,0)
	c:SetStatus(STATUS_NO_LEVEL,true)
	--add setcode
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_ADD_SETCODE)
	e1:SetValue(0x601)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(511000817,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SSET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c511000817.spcon)
	e2:SetTarget(c511000817.sptg)
	e2:SetOperation(c511000817.spop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_MSET)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_CHANGE_POS)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e5)
	--check
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_SSET)
	e6:SetRange(LOCATION_MZONE)
	e6:SetOperation(c511000817.chkop)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EVENT_MSET)
	c:RegisterEffect(e7)
	local e8=e7:Clone()
	e8:SetCode(EVENT_CHANGE_POS)
	c:RegisterEffect(e8)
	local e9=e7:Clone()
	e9:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e9)
	--cannot set
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_FIELD)
	e10:SetCode(EFFECT_CANNOT_MSET)
	e10:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e10:SetRange(LOCATION_MZONE)
	e10:SetTargetRange(1,1)
	e10:SetTarget(c511000817.setlimit)
	e10:SetLabelObject(e6)
	c:RegisterEffect(e10)
	local e11=e10:Clone()
	e11:SetCode(EFFECT_CANNOT_SSET)
	c:RegisterEffect(e11)
	local e11=e10:Clone()
	e11:SetCode(EFFECT_CANNOT_TURN_SET)
	c:RegisterEffect(e11)
	local e12=e10:Clone()
	e12:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e12:SetTarget(c511000817.sumlimit)
	c:RegisterEffect(e12)
	--cannot be battle target
	local e13=Effect.CreateEffect(c)
	e13:SetType(EFFECT_TYPE_SINGLE)
	e13:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e13:SetRange(LOCATION_MZONE)
	e13:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e13:SetCondition(function(e) return Duel.IsExistingMatchingCard(c511000817.ddfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,e:GetHandler()) end)
	e13:SetValue(1)
	c:RegisterEffect(e13)
	--battle des rep
	local e14=Effect.CreateEffect(c)
	e14:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e14:SetCode(EFFECT_DESTROY_REPLACE)
	e14:SetCountLimit(1)
	e14:SetTarget(c511000817.reptg)
	c:RegisterEffect(e14)
	--change atk and destroy
	local e15=Effect.CreateEffect(c)
	e15:SetDescription(aux.Stringid(511000817,2))
	e15:SetCategory(CATEGORY_DESTROY+CATEGORY_ATKCHANGE)
	e15:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e15:SetCode(EVENT_ATTACK_ANNOUNCE)
	e15:SetRange(LOCATION_MZONE)
	e15:SetCondition(c511000817.batcon)
	e15:SetTarget(c511000817.battg)
	e15:SetOperation(c511000817.batop)
	c:RegisterEffect(e15)
end
function c511000817.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and (c:IsRace(RACE_DRAGON) or c:IsSetCard(0xc2)) 
end
function c511000817.cfilter(c,p)
	return c:IsFacedown() and c:IsControler(p)
end
function c511000817.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c511000817.cfilter,1,nil,tp)
end
function c511000817.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ct=eg:FilterCount(c511000817.cfilter,nil,tp)
	local g=Duel.GetMatchingGroup(c511000817.spfilter,tp,LOCATION_EXTRA,0,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,ct,tp,LOCATION_EXTRA)
end
function c511000817.spop(e,tp,eg,ep,ev,re,r,rp)
	local ex,tg,ct=Duel.GetOperationInfo(0,CATEGORY_SPECIAL_SUMMON)
	if Duel.GetLocationCountFromEx(tp)<ct or (ct>1 and Duel.IsPlayerAffectedByEffect(tp,59822133)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c511000817.spfilter,tp,LOCATION_EXTRA,0,ct,ct,nil,e,tp)
	if #g==ct then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c511000817.chkop(e,tp,eg,ep,ev,re,r,rp)
	for i=0,1 do
		if eg:IsExists(c511000817.cfilter,1,nil,i) then
			Duel.RegisterFlagEffect(i,511000817,RESET_PHASE+PHASE_END,0,1)
		end
	end
end
function c511000817.setlimit(e,c,tp)
	return not c:IsLocation(LOCATION_ONFIELD) and Duel.GetFlagEffect(tp,511000817)>0
end
function c511000817.sumlimit(e,c,sump,sumtype,sumpos,targetp)
	return sumpos&POS_FACEDOWN==POS_FACEDOWN and not c:IsLocation(LOCATION_ONFIELD) and Duel.GetFlagEffect(sump,511000817)>0
end
function c511000817.ddfilter(c)
	return (c:IsRace(RACE_DRAGON) or c:IsSetCard(0xc2)) and c:IsFaceup()
end
function c511000817.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsReason(REASON_REPLACE) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler())
end
function c511000817.batcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c511000817.ddfilter,tp,LOCATION_MZONE,0,1,e:GetHandler())
end
function c511000817.battg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetAttackTarget()==c or (Duel.GetAttacker()==c and Duel.GetAttackTarget()~=nil)
		and Duel.IsExistingMatchingCard(Card.IsFacedown,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsFacedown,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,1-tp,LOCATION_ONFIELD)
end
function c511000817.batop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetBattleTarget()
	local c=e:GetHandler()
	if tc then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(tc:GetAttack())
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE)
		c:RegisterEffect(e1)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,Card.IsFacedown,tp,0,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end