--Sunavalon Glorious Growth
function c511009675.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_RECOVER+CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_DAMAGE)
    e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
    e1:SetCondition(c511009675.condition)
    e1:SetTarget(c511009675.target)
    e1:SetOperation(c511009675.activate)
    c:RegisterEffect(e1)
    --damage
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_DAMAGE)
    e2:SetDescription(aux.Stringid(34408491,0))
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCode(EVENT_RECOVER)
    e2:SetCondition(c511009675.damcon)
    e2:SetTarget(c511009675.damtg)
    e2:SetOperation(c511009675.damop)
    c:RegisterEffect(e2)
    --negate attack
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(94804055,0))
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetRange(LOCATION_SZONE)
    e3:SetCode(EVENT_ATTACK_ANNOUNCE)
    e3:SetCountLimit(1)
    e3:SetCondition(c511009675.atkcon)
    e3:SetTarget(c511009675.atktg)
    e3:SetOperation(c511009675.atkop)
    c:RegisterEffect(e3)
    --destroy
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCode(EVENT_LEAVE_FIELD)
    e4:SetCondition(c511009675.sdescon)
    e4:SetOperation(c511009675.sdesop)
    c:RegisterEffect(e4)
end
function c511009675.condition(e,tp,eg,ep,ev,re,r,rp)
    return ep==tp 
end
function c511009675.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsPlayerCanSpecialSummonMonster(tp,511009676,0,0x4011,0,0,1,RACE_PLANT,ATTRIBUTE_EARTH) end
    Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c511009675.linkfilter(c)
    return c:IsSpecialSummonable(SUMMON_TYPE_LINK) and c:IsSetCard(0x574)
end
function c511009675.activate(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
        or not Duel.IsPlayerCanSpecialSummonMonster(tp,511009676,0,0x4011,0,0,1,RACE_PLANT,ATTRIBUTE_EARTH) then return end
    local token=Duel.CreateToken(tp,511009676)
    -- Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
    -- Duel.SpecialSummonComplete()
    if Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)~=0 
    and Duel.IsExistingMatchingCard(c511009675.linkfilter,tp,LOCATION_EXTRA,0,1,nil) 
    and Duel.SelectYesNo(tp,aux.Stringid(85431040,1))  then
        local g=Duel.SelectMatchingCard(tp,c511009675.linkfilter,tp,LOCATION_EXTRA,0,1,1,nil)
        local tc=g:GetFirst()
        if tc then
            Duel.SpecialSummonRule(tp,tc,SUMMON_TYPE_LINK)
        end
    end
    Duel.BreakEffect()
    Duel.Recover(tp,ev,REASON_EFFECT)   
end
--------------------------------------
function c511009675.damcon(e,tp,eg,ep,ev,re,r,rp)
    return ep==tp
end
function c511009675.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,ev)
end
function c511009675.damop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Damage(1-tp,ev,REASON_EFFECT)
end
--------------------------------------
function c511009675.atkcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetAttacker():IsControler(1-tp) and Duel.GetAttackTarget()==nil and not e:GetHandler():IsStatus(STATUS_CHAINING)
end
function c511009675.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local tg=Duel.GetAttacker()
    if chkc then return chkc==tg end
    if chk==0 then return tg:IsOnField() and tg:IsCanBeEffectTarget(e) end
    Duel.SetTargetCard(tg)
end
function c511009675.atkop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    local tc=Duel.GetAttacker()
    if Duel.NegateAttack() and tc then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_MUST_ATTACK)
        e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE)
        tc:RegisterEffect(e1)
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
        e2:SetValue(c511009675.atlimit)
        e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE)
        tc:RegisterEffect(e2)
        local e3=Effect.CreateEffect(c)
        e3:SetType(EFFECT_TYPE_SINGLE)
        e3:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
        e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE)
        tc:RegisterEffect(e3)
        Duel.ChainAttack()
    end
end
function c511009675.atlimit(e,c)
    return not c:IsSetCard(0x574) or c:IsFacedown()
end
--------------------------------------
function c511009675.sfilter(c)
    return c:IsReason(REASON_DESTROY) and c:IsPreviousPosition(POS_FACEUP)
        and c:IsSetCard(0x574) and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c511009675.sdescon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c511009675.sfilter,1,nil)
end
function c511009675.sdesop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end
