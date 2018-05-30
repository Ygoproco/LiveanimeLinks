--Dinowrestler Capaptera
function c511009721.initial_effect(c)
    --atk up
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(511009721,0))
    e1:SetCategory(CATEGORY_ATKCHANGE)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_BE_MATERIAL)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCondition(c511009721.ddcon)
    e1:SetTarget(c511009721.ddtg)
    e1:SetOperation(c511009721.ddop)
    c:RegisterEffect(e1)
    --to deck
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_TODECK)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCondition(aux.exccon)
    e2:SetCost(aux.bfgcost)
    e2:SetTarget(c511009721.tdtg)
    e2:SetOperation(c511009721.tdop)
    c:RegisterEffect(e2)
end
function c511009721.ddcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local rc=c:GetReasonCard()
    return c:IsLocation(LOCATION_GRAVE) and r & REASON_LINK == REASON_LINK
        and rc:IsSetCard(0x580) and rc:IsType(TYPE_LINK)
end
function c511009721.ddtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetTargetCard(e:GetHandler():GetReasonCard())
end
function c511009721.ddop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local sync=c:GetReasonCard()
    if sync:IsRelateToEffect(e) and sync:IsFaceup() and sync:IsSetCard(0x580) and sync:IsType(TYPE_LINK) then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(1000)
        e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
        sync:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_CANNOT_ATTACK)
		e2:SetProperty(EFFECT_FLAG_OATH)
		e2:SetTargetRange(LOCATION_MZONE,0)
		e2:SetTarget(c511009721.ftarget)
		e2:SetLabel(g:GetFirst():GetFieldID())
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
    end
end
function c511009721.ftarget(e,c)
	return e:GetLabel()~=c:GetFieldID()
end