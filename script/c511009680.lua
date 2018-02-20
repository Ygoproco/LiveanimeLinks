--Sunavalon Dryatrentiay
function c511009680.initial_effect(c)
	
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c511009680.matfilter,2)
	--Immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c511009680.tgvalue)
	c:RegisterEffect(e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_IGNORE_BATTLE_TARGET)
	e2:SetRange(LOCATION_MZONE)
	c:RegisterEffect(e2)
	
	-- destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(76614340,0))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c511009680.descost)
	e3:SetTarget(c511009666.destg)
	e3:SetOperation(c511009680.desop)
	c:RegisterEffect(e3)
	Duel.AddCustomActivityCounter(511009680,ACTIVITY_ATTACK,c511009680.counterfilter)
end
function c511009680.matfilter(c,lc,sumtype,tp)
	return c:IsType(TYPE_LINK,lc,sumtype,tp) and c:IsRace(RACE_PLANT,lc,sumtype,tp)
end
function c511009680.counterfilter(c)
    return c:GetSequence()<5
end

function c511009680.tgvalue(e,re,rp)
	return rp~=e:GetHandlerPlayer()
end

function c511009680.costfilter(c,lg)
	return c:IsFaceup() and c:IsRace(RACE_PLANT) and c:IsType(TYPE_LINK) and lg:IsContains(c)
end
function c511009680.desfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c511009680.atkfilter(e,c)
	return c:GetSequence()<5
end
function c511009680.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(511009680,tp,ACTIVITY_ATTACK)==0 and Duel.CheckReleaseGroup(tp,c511009680.costfilter,1,e:GetHandler(),e:GetHandler():GetLinkedGroup()) end
	local rg=Duel.SelectReleaseGroup(tp,c511009680.costfilter,1,1,e:GetHandler(),e:GetHandler():GetLinkedGroup())
	e:SetLabel(rg:GetFirst():GetLink())
	Duel.Release(rg,REASON_COST)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e1:SetProperty(EFFECT_FLAG_OATH+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetTarget(c511009680.atkfilter)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c511009680.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c511009680.desfilter(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(c511009680.desfilter,tp,0,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c511009680.desfilter,tp,0,LOCATION_ONFIELD,1,e:GetLabel(),e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c511009680.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	Duel.Destroy(g,REASON_EFFECT)
end
