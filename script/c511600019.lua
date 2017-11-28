--スペース・インシュレイター
--Space Insulator
--scripted by Larry126
function c511600019.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,2)
	c:EnableReviveLimit()
	--atk up
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetTarget(c511600019.atktg)
	e1:SetValue(-500)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(282886,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCondition(c511600019.spcon)
	e3:SetTarget(c511600019.sptg)
	e3:SetOperation(c511600019.spop)
	c:RegisterEffect(e3)
end
function c511600019.atktg(e,c)
	return e:GetHandler():GetLinkedGroup():IsContains(c)
end
function c511600019.cfilter(c,e,tp,sc)
	local zone=c:GetLinkedZone(tp)
	return c:IsRace(RACE_CYBERSE) and c:IsType(TYPE_LINK)
		and c:IsControler(tp) and zone~=0
		and sc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
end
function c511600019.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c511600019.cfilter,1,nil,e,tp,e:GetHandler()) and aux.exccon(e)
end
function c511600019.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsRelateToEffect(e) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c511600019.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local c=e:GetHandler()
	local zone=0
	for ec in aux.Next(eg) do
		zone=zone|ec:GetLinkedZone(tp)
	end
	if Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP,zone) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		e2:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e2,true)
	end
	Duel.SpecialSummonComplete()
end