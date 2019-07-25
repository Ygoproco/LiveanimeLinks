--パラドクス・ハイドライブ・アトラース
--Paradox Hydradrive Atlas
--Scripted by Playmaker 772211
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunctionEx(Card.IsSetCard,0x577),2,nil,s.matcheck)
	--Dice
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	--Special summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
	--Change attribute
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_CHANGE_ATTRIBUTE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
    e3:SetTarget(s.tg)
    e3:SetValue(c:GetAttribute())
    c:RegisterEffect(e3)
	--Imminue
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(s.indcon)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	c:RegisterEffect(e5)
end
function s.matcheck(g,lc,tp)
	return g:IsExists(Card.IsLevelAbove,1,nil,5)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	local dice=Duel.TossDice(tp,1)
	if dice==1 then
		local e1=Effect.CreateEffect(c)
	    e1:SetType(EFFECT_TYPE_SINGLE)
	    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	    e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	    e1:SetRange(LOCATION_MZONE)
	    e1:SetValue(ATTRIBUTE_EARTH)
	    c:RegisterEffect(e1)
	elseif dice==2 then
		local e1=Effect.CreateEffect(c)
	    e1:SetType(EFFECT_TYPE_SINGLE)
	    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	    e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	    e1:SetRange(LOCATION_MZONE)
	    e1:SetValue(ATTRIBUTE_WATER)
	    c:RegisterEffect(e1)
	elseif dice==3 then
		local e1=Effect.CreateEffect(c)
	    e1:SetType(EFFECT_TYPE_SINGLE)
	    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	    e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	    e1:SetRange(LOCATION_MZONE)
	    e1:SetValue(ATTRIBUTE_FIRE)
	    c:RegisterEffect(e1)
	elseif dice==4 then
		local e1=Effect.CreateEffect(c)
	    e1:SetType(EFFECT_TYPE_SINGLE)
	    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	    e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	    e1:SetRange(LOCATION_MZONE)
	    e1:SetValue(ATTRIBUTE_WIND)
	    c:RegisterEffect(e1)
	elseif dice==5 then
		local e1=Effect.CreateEffect(c)
	    e1:SetType(EFFECT_TYPE_SINGLE)
	    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	    e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	    e1:SetRange(LOCATION_MZONE)
	    e1:SetValue(ATTRIBUTE_LIGHT)
	    c:RegisterEffect(e1)
	else
		local e1=Effect.CreateEffect(c)
	    e1:SetType(EFFECT_TYPE_SINGLE)
	    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	    e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	    e1:SetRange(LOCATION_MZONE)
	    e1:SetValue(ATTRIBUTE_DARK)
	    c:RegisterEffect(e1)
	end
end
function s.spfilter(c,e,tp,zone)
	return c:IsSetCard(0x577) and c:IsType(TYPE_LINK) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local zone=e:GetHandler():GetLinkedZone(tp)
		return zone~=0 and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,zone)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	local zone=e:GetHandler():GetLinkedZone(tp)
	if zone==0 then return end
	local dc=Duel.TossDice(tp,1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,zone)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP,zone)
	end
end
function s.tg(e,c)
    return e:GetHandler():GetLinkedGroup():IsContains(c)
end
function s.filter(c,att)
	return c:IsFaceup() and c:IsAttribute(att)
end
function s.indcon(e)
	return Duel.IsExistingMatchingCard(s.filter,0,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler())
end