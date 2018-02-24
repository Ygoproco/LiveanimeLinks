--Sunavalon Dryades
function c511009667.initial_effect(c)
    --link summon
    c:EnableReviveLimit()
    aux.AddLinkProcedure(c,aux.FilterBoolFunctionEx(Card.IsRace,RACE_PLANT),2)
    --material check
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_SINGLE)
    e0:SetCode(EFFECT_MATERIAL_CHECK)
    e0:SetValue(c511009667.valcheck)
    e0:SetLabelObject(e3)
    c:RegisterEffect(e0)
    --cannot link material
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
    e1:SetCondition(c511009667.matcon)
    e1:SetValue(1)
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
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_DAMAGE)
    e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(2)
    e3:SetCondition(c511009667.spcon)
    e3:SetTarget(c511009667.sptg)
    e3:SetOperation(c511009667.spop)
    c:RegisterEffect(e3)
end
function c511009667.matcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:IsSummonType(SUMMON_TYPE_LINK) and c:GetTurnID()==Duel.GetTurnCount()
end
function c511009667.matfilter(c)
    return c:IsOriginalSetCard(0x574)
end
function c511009667.valcheck(e,c)
    if c:GetMaterial():IsExists(c511009667.matfilter,1,nil,tp) then
        e:GetLabelObject():SetLabel(1)
    else
        e:GetLabelObject():SetLabel(0)
    end
end
function c511009667.spcon(e,tp,eg,ep,ev,re,r,rp)
    return ep==tp and bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0 and e:GetLabel()>0
end
function c511009667.filter(c,e,tp,zone)
    return c:IsSetCard(0x575) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
end
function c511009667.lkfilter(c)
    return c:IsSetCard(0x574) and c:IsFaceup() and c:IsType(TYPE_LINK)
end
function c511009667.zonefilter(tp)
    local lg=Duel.GetMatchingGroup(c511009667.lkfilter,tp,LOCATION_MZONE,0,nil)
    local zone=0
    for tc in aux.Next(lg) do
        zone=zone|tc:GetLinkedZone()
    end
    return zone
end
function c511009667.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local zone=c511009667.zonefilter(tp)
    if chk==0 then
        local zone=c511009667.zonefilter(tp)
        return zone~=0 and Duel.IsExistingMatchingCard(c511009667.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp,zone)
    end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c511009667.spop(e,tp,eg,ep,ev,re,r,rp)
    local zone=c511009667.zonefilter(tp)
    if Duel.GetLocationCountFromEx(tp)<=0 and zone~=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c511009667.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,zone)
    if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP) then
        Duel.Recover(tp,ev,REASON_EFFECT)
    end
end
