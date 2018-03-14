--覇王門無限 (Anime)
--Supreme King Gate Infinity (Anime)
--fixed by MLD
--updated by Larry126
function c511009444.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--selfdes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_SELF_DESTROY)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCondition(c511009444.descon)
	c:RegisterEffect(e1)
	--LP gain
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetCode(96227613)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTarget(c511009444.rectg)
	e2:SetOperation(c511009444.recop)
	c:RegisterEffect(e2)
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22211622,2))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCondition(c511009444.thcon)
	e3:SetTarget(c511009444.thtg)
	e3:SetOperation(c511009444.thop)
	c:RegisterEffect(e3)
	if not c511009444.global_check then
		c511009444.global_check=true
		--avatar
		local zero=Effect.CreateEffect(c)
		zero:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		zero:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
		zero:SetCode(EVENT_ADJUST)
		zero:SetCondition(c511009444.zerocon)
		zero:SetOperation(c511009444.zeroop)
		Duel.RegisterEffect(zero,0)
	end
end
function c511009444.zfilter(c)
	local effs={c:GetCardEffect(EVENT_ADJUST)}
	local chk=true
	for _,eff in ipairs(effs) do
		if eff:GetLabel()==511009444 then chk=false end
	end
	return c:GetOriginalCode()==96227613 and chk
end
function c511009444.zerocon(e,tp,eg,ev,ep,re,r,rp)
	return Duel.IsExistingMatchingCard(c511009444.zfilter,tp,0xff,0xff,1,nil)
end
function c511009444.zeroop(e,tp,eg,ev,ep,re,r,rp)
	local g=Duel.GetMatchingGroup(c511009444.zfilter,tp,0xff,0xff,nil)
	g:ForEach(function(c)
		local effs={c:GetCardEffect(EFFECT_CHANGE_DAMAGE)}
		for _,eff in ipairs(effs) do
			if eff:GetProperty()&(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_AVAILABLE_BD)~=0
				and eff:GetType()==EFFECT_TYPE_FIELD and e:GetLabel()==0 then e1=eff end
		end
		--Reset 
		local e0=Effect.CreateEffect(c)
		e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e0:SetCode(EVENT_ADJUST)
		e0:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
		e0:SetRange(LOCATION_PZONE)
		e0:SetLabel(511009444)
		e0:SetLabelObject(e1)
		e0:SetOperation(c511009444.trig)
		c:RegisterEffect(e0)
	end)
end
function c511009444.trig(e,tp,eg,ep,ev,re,r,rp)
	local val=e:GetLabelObject() and e:GetLabelObject():GetLabel() or 0
	if val~=0 then
		Duel.RaiseEvent(e:GetHandler(),96227613,e,REASON_EFFECT,tp,tp,val)
		e:GetLabelObject():SetLabel(0)
	end
end
function c511009444.scfilter(c)
	return c:IsFaceup() and c:IsCode(96227613)
end
function c511009444.descon(e)
	return not Duel.IsExistingMatchingCard(c511009444.scfilter,e:GetHandlerPlayer(),LOCATION_PZONE,0,1,e:GetHandler())
end
function c511009444.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(ev)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,ev)
end
function c511009444.recop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end
function c511009444.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function c511009444.filter(c)
	return c:IsCode(96227613) and c:IsAbleToHand()
end
function c511009444.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c511009444.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c511009444.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c511009444.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end