--High Drive Generator
function c511009709.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c511009709.target)
	e1:SetHintTiming(TIMING_SPSUMMON)
	c:RegisterEffect(e1)
	--atk change
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(2148918,0))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c511009709.spcon)
	e2:SetTarget(c511009709.sptg)
	e2:SetOperation(c511009709.spop)
	c:RegisterEffect(e2)
end
function c511009709.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local res,teg,tep,tev,tre,tr,trp=Duel.CheckEvent(EVENT_SUMMON_SUCCESS,true)
	if not res then
		res,teg,tep,tev,tre,tr,trp=Duel.CheckEvent(EVENT_SPSUMMON_SUCCESS,true)
	end
	if res 
		and c511009709.spcon(e,tp,teg,tep,tev,tre,tr,trp) 
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,511009710,0x577,0x4011,0,0,1,RACE_CYBERSE,ATTRIBUTE_EARTH)
		and Duel.SelectYesNo(tp,94) then
			e:SetCategory(CATEGORY_SPECIAL_SUMMON)
			e:SetLabel(1)
			e:GetHandler():RegisterFlagEffect(511009709,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
		else
		e:SetCategory(0)
		e:SetLabel(0)
		e:SetOperation(nil)
	end
end
function c511009709.tgfilter(c,e,tp)
	return c:IsFaceup() and c:IsControler(tp) 
end
function c511009709.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c511009709.tgfilter,1,nil,nil,1-tp) 
end
function c511009709.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(511009709)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,511009710,0x577,0x4011,0,0,1,RACE_CYBERSE,ATTRIBUTE_EARTH) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
	e:GetHandler():RegisterFlagEffect(511009709,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c511009709.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if e:GetLabel()==0 or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if Duel.IsPlayerCanSpecialSummonMonster(tp,511009710,0x577,0x4011,0,0,1,RACE_CYBERSE,ATTRIBUTE_EARTH) then
		local token=Duel.CreateToken(tp,511009710)
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
	end
end