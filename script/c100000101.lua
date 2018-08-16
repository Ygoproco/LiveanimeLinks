--おジャマンダラ
--Ojamandala
--Rescripted by AlphaKretin
local card, code = GetID()
local CARD_OJAMA_YELLOW = 42941100
local CARD_OJAMA_BLACK = 79335209
local CARD_OJAMA_GREEN = 12482652
function card.initial_effect(c)
    --Activate
    local e1 = Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCost(card.spcost)
    e1:SetTarget(card.sptg)
    e1:SetOperation(card.spop)
    c:RegisterEffect(e1)
end
function card.spcost(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        return Duel.CheckLPCost(tp, 1000)
    end
    Duel.PayLPCost(tp, 1000)
end
function card.spfilter(c, e, tp)
    return c:IsCode(CARD_OJAMA_YELLOW, CARD_OJAMA_BLACK, CARD_OJAMA_GREEN) and
        c:IsCanBeSpecialSummoned(e, 0, tp, false, false)
end
function card.rescon(sg, e, tp, mg)
    --3 different names when the filter requires all cards have one of three names ensures one of each name
    return aux.ChkfMMZ(3)(sg, e, tp, mg) and sg:GetClassCount(Card.GetCode) > 2
end
function card.sptg(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
    local g = Duel.GetMatchingGroup(card.spfilter, tp, LOCATION_GRAVE, 0, nil, e, tp)
    if chkc then
        return c:IsControler(tp) and c:IsLocation(LOCATION_GRAVE) and card.spfilter(c, e, tp, tid)
    end
    if chk == 0 then
        --SelectUnselect not strictly necessary here but makes selection nicer
        return aux.SelectUnselectGroup(g, e, tp, 3, 3, card.rescon, chk) and
            not Duel.IsPlayerAffectedByEffect(tp, CARD_BLUEEYES_SPIRIT)
    end
    local tg = aux.SelectUnselectGroup(g, e, tp, 3, 3, card.rescon, 1, tp, HINTMSG_SPSUMMON)
    Duel.SetTargetCard(tg)
    Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, tg, #tg, 0, 0)
end
function card.spop(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    local ft = Duel.GetLocationCount(tp, LOCATION_MZONE)
    if ft <= 0 then
        return
    end
    local g = Duel.GetChainInfo(0, CHAININFO_TARGET_CARDS)
    local sg = g:Filter(Card.IsRelateToEffect, nil, e)
    if #sg > 1 and Duel.IsPlayerAffectedByEffect(tp, CARD_BLUEEYES_SPIRIT) then
        return
    end
    if sg:GetCount() > ft then
        Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
        sg = sg:Select(tp, ft, ft, nil)
    end
    if #sg > 0 then
        Duel.SpecialSummon(sg, 0, tp, tp, false, false, POS_FACEUP)
    end
end
