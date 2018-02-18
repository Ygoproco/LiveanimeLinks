--Sunavalon Dryas
function c511009666.initial_effect(c)
	
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c511009666.matfilter,1,1)
	
	--cannot link material
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e1:SetCondition(c511009666.matcon)
	c:RegisterEffect(e1)
	
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_IGNORE_BATTLE_TARGET)
	e2:SetRange(LOCATION_MZONE)
	c:RegisterEffect(e2)
	
	
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(511009666,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DAMAGE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1)
	e3:SetCondition(c511009666.spcon)
	e3:SetTarget(c511009666.target)
	e3:SetOperation(c511009666.operation)
	c:RegisterEffect(e3)
end
function c511009666.matfilter(c,lc,sumtype,tp)
	return c:IsType(TYPE_NORMAL,lc,sumtype,tp) and c:IsRace(RACE_PLANT,lc,sumtype,tp)
end
function c511009666.matcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_LINK) and c:GetTurnID()==Duel.GetTurnCount()
end



function c511009666.spcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0
end

function c511009666.filter(c,e,tp,zone)
	return c:IsSetCard(0x575) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
end
function c511009666.lkfilter(c)
	return c:IsSetCard(0x574) and c:IsFaceup() and c:IsType(TYPE_LINK)
end
function c511009666.zonefilter(tp)
	local lg=Duel.GetMatchingGroup(c511009666.lkfilter,tp,LOCATION_MZONE,0,nil)
	local zone=0
	for tc in aux.Next(lg) do
		zone=zone|tc:GetLinkedZone()>>16
	end
	return zone
end
function c511009666.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local zone=c511009666.zonefilter(tp)
		return zone~=0 and Duel.IsExistingMatchingCard(c511009666.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp,zone)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end

function c511009666.spop(e,tp,eg,ep,ev,re,r,rp)
	local zone=c511009666.zonefilter(tp)
	if Duel.GetLocationCountFromEx(tp)<=0 and zone~=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c511009666.spfilter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,zone)
	if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP) then
		Duel.Recover(tp,ev,REASON_EFFECT)
	end
end
