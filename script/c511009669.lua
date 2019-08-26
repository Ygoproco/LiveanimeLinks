--Sunvine Thrasher
--cleaned up by MLD
function c511009669.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c511009669.matfilter,1,1)
	--self destroy
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_SELF_DESTROY)
	e1:SetCondition(c511009669.descon)
	c:RegisterEffect(e1)
	--spsummon success
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(3954901,0))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetTarget(c511009669.atktg)
	e2:SetOperation(c511009669.atkop)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(96622984,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_START)
	e3:SetTarget(c511009669.destg)
	e3:SetOperation(c511009669.desop)
	c:RegisterEffect(e3)
end
function c511009669.matfilter(c,lc,sumtype,tp)
	return c:IsType(TYPE_NORMAL,lc,sumtype,tp) and c:IsRace(RACE_PLANT,lc,sumtype,tp)
end
function c511009669.filter(c,sc,atk)
	return c:IsFaceup() and c:IsSetCard(0x574) and c:IsType(TYPE_LINK) and c:GetLinkedGroup():IsContains(sc) and (not atk or c:GetLink()>0)
end
function c511009669.descon(e)
	return not Duel.IsExistingMatchingCard(c511009669.filter,e:GetHandlerPlayer(),LOCATION_MZONE,LOCATION_MZONE,1,nil,e:GetHandler())
end
function c511009669.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsOnField() and chkc:IsLocation(LOCATION_MZONE) and c511009669.filter(chkc,c,true) end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c511009669.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,c,true)
end
function c511009669.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(tc:GetLink()*800)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE)
		c:RegisterEffect(e1)
	end
end
function c511009669.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local bc=e:GetHandler():GetBattleTarget()
	if chk==0 then return bc and bc:IsControler(1-tp) and bc:IsRelateToBattle() end
end
function c511009669.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=c:GetBattleTarget()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_BATTLE_DESTROYED)
	e1:SetLabelObject(tc)
	e1:SetCondition(c511009669.sumcon)
	e1:SetOperation(c511009669.sumop)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
	Duel.RegisterEffect(e1,tp)
end
function c511009669.sumcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return tc and eg:IsContains(tc)
end
function c511009669.lkfilter(c)
	return c:IsSetCard(0x574) and c:IsFaceup() and c:IsType(TYPE_LINK)
end
function c511009669.zonefilter(tp)
	local lg=Duel.GetMatchingGroup(c511009669.lkfilter,tp,LOCATION_MZONE,0,nil)
	local zone=0
	lg:ForEach(function(tc)
		zone=zone|tc:GetLinkedZone()
	end)
	return zone
end
function c511009669.sumop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	local zone=c511009669.zonefilter(tp)
	if zone>0 and tc:IsLocation(LOCATION_GRAVE) and tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone) then 
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP,zone)
	end
	e:Reset()
end
