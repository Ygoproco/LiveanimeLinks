--Clean Barrier - Clear Force
-- created by: Donpax
local card = c511008501
function card.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DESTROY)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_ATTACK_ANNOUNCE)
    e1:SetCondition(card.condition)
    e1:SetTarget(card.target)
    e1:SetOperation(card.activate)
    c:RegisterEffect(e1)
end


function card.disop(e,tp,eg,ep,ev,re,r,rp)
    if not re:IsHasCategory(CATEGORY_ATKCHANGE) then return end
    local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
    if not g then return end
    for tc in aux.Next(g) do
        if tc:IsControler(1-tp) and tc:IsLocation(LOCATION_MZONE) then
            Duel.NegateEffect(ev)
        end
    end
end

function card.condition(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()~=tp
end

function card.filter2(c)
    return c:IsFaceup() and c:GetAttack()~=c:GetBaseAttack()
end

function card.target(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return Duel.IsExistingMatchingCard(card.filter2,tp,0,LOCATION_MZONE,1,c) end
    local sg=Duel.GetMatchingGroup(card.filter2,tp,0,LOCATION_MZONE,1,c)
    Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,sg,sg:GetCount(),1-tp,LOCATION_MZONE)
end
function card.activate(e,tp,eg,ep,ev,re,r,rp)
    local sg = Duel.GetMatchingGroup(card.filter2,tp,0,LOCATION_MZONE,1,c)
    for tc in aux.Next(sg) do
        if tc:GetAttack()~=tc:GetBaseAttack() then
            local e1=Effect.CreateEffect(e:GetHandler())
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_SET_ATTACK_FINAL)
            e1:SetValue(tc:GetBaseAttack())
            e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
            tc:RegisterEffect(e1)
        end
    end

    --disable effect
    local e3=Effect.CreateEffect(e:GetHandler())
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e3:SetCode(EVENT_CHAIN_SOLVING)
    e3:SetRange(LOCATION_MZONE)
    e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
    e3:SetOperation(card.disop)
    Duel.RegisterEffect(e3, tp)
end
