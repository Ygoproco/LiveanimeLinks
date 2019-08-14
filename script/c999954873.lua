--Hydradrive Mutation
local s,id=GetID()
function s.initial_effect(c)
    --Returns a Continuous Trap to the hand, then Special Summons itself and sets a Continuous Trap from your hand. 
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetHintTiming(0,0x11e0)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetRange(LOCATION_HAND)
    e1:SetTarget(s.traptarget)
    e1:SetOperation(s.returnsummonset)
    c:RegisterEffect(e1)
    --Changes Attribute
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetRange(LOCATION_MZONE)
    e2:SetTarget(s.montarget)
    e2:SetOperation(s.attchange)
    c:RegisterEffect(e2)
end
function s.trapfilter(c)
    return c:IsAbleToHand() and c:IsLocation(LOCATION_SZONE) and c:IsType(TYPE_TRAP+TYPE_CONTINUOUS) and c:IsPosition(POS_FACEUP)
end
function s.traptarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_SZONE) and s.trapfilter(chkc) end
    local c=e:GetHandler()
    if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
        and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingTarget(s.trapfilter,tp,LOCATION_SZONE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
    local g=Duel.SelectTarget(tp,s.trapfilter,tp,LOCATION_SZONE,0,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function s.trapfilter2(c)
    return c:IsSSetable() and c:IsType(TYPE_TRAP) and c:IsType(TYPE_CONTINUOUS)
end
function s.returnsummonset(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    local tc=Duel.GetFirstTarget()
    if Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_HAND) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
       Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
       local tc2=Duel.SelectMatchingCard(tp,s.trapfilter2,tp,LOCATION_HAND,0,1,1,nil):GetFirst()
       Duel.SSet(tp,tc2)
       local e1=Effect.CreateEffect(c)
       e1:SetType(EFFECT_TYPE_SINGLE)
       e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
       e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
       e1:SetReset(RESET_EVENT)
       tc2:RegisterEffect(e1)
    end
end
function s.monfilter(c)
    return c:IsFaceup() and c:IsType(TYPE_MONSTER) and not c:IsForbidden()
end
function s.montarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and s.monfilter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(s.monfilter,tp,0,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    Duel.SelectTarget(tp,s.monfilter,tp,0,LOCATION_MZONE,1,1,nil)
end
function s.attchange(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if c:IsRelateToEffect(e) and c:IsFaceup() and tc:IsRelateToEffect(e) then
        local at=tc:GetAttribute()
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
        e1:SetValue(at)
        c:RegisterEffect(e1)
    end
end
