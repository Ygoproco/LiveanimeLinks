--天地の宝札
--Card of Heaven and Earth
--Fixed by Larry126
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(id,ACTIVITY_SUMMON,s.counterfilter)
end
function s.counterfilter(c)
	return not c:IsLevelAbove(7)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCustomActivityCount(id,tp,ACTIVITY_SUMMON)>0
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if e:GetHandler():IsLocation(LOCATION_HAND) then ft=ft-1 end
	if chk==0 then return ft>0 and Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function s.filter(c)
	return c:IsSSetable() or c:IsMSetable(true,nil)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	local g=Duel.GetDecktopGroup(p,d)
	Duel.Draw(p,d,REASON_EFFECT)
	if g:IsExists(s.filter,1,nil) then
		local sc=g:FilterSelect(p,s.filter,1,1,nil):GetFirst()
		if sc:IsMSetable(true,nil) then
			Duel.MSet(p,sc,true,nil)
		else
			Duel.SSet(p,sc)
		end
		Duel.ConfirmCards(1-p,sc)
	else
		Duel.ConfirmCards(1-p,g)
		Duel.ShuffleHand(p)
	end
	for tc in aux.Next(g) do
		tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetCode(EFFECT_FORBIDDEN)
	e2:SetTargetRange(0xff,0xff)
	e2:SetTarget(s.bantg)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function s.bantg(e,c)
	return c:GetFlagEffect(id)>0
end
