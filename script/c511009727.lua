--Missile Knight
function c511009727.initial_effect(c)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(511009727,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCondition(c511009727.descon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c511009727.destg)
	e2:SetOperation(c511009727.activate)
	c:RegisterEffect(e2)
	if not c511009727.global_check then
		c511009727.global_check=true
		c511009727[0]=0
		c511009727[1]=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TO_GRAVE)
		ge1:SetOperation(c511009727.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge2:SetOperation(c511009727.clear)
		Duel.RegisterEffect(ge2,0)
	end
end

function c511009727.spfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_MZONE) and (c:IsReason(REASON_BATTLE) or c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()==tp)
end
function c511009727.checkop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(c511009727.spfilter,1,nil,tp) then
		c511009727[tc:GetControler()]=c511009727[tc:GetControler()]+1
	end
end
function c511009727.clear(e,tp,eg,ep,ev,re,r,rp)
	c511009727[0]=0
	c511009727[1]=0
end

function c511009727.descon(e,c)
	if c==nil then return true end
	return c511009727[c:GetControler()]>=1
end

function c511009727.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c511009727.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
