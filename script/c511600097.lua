--ＤＤエクストラ・サーベイヤー
--D/D Extra Surveyor
--scripted by Larry126
function c511600097.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--peffect
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_DECK)
	e1:SetRange(LOCATION_PZONE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCondition(c511600097.condition)
	e1:SetCost(c511600097.cost)
	e1:SetTarget(c511600097.target)
	e1:SetOperation(c511600097.operation)
	c:RegisterEffect(e1)
end
function c511600097.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsLocation,1,nil,LOCATION_EXTRA)
end
function c511600097.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(Card.IsAbleToRemoveAsCost,tp,LOCATION_PZONE,0,1,c)
	end
	Duel.Remove(Duel.GetFieldGroup(tp,LOCATION_PZONE,0),POS_FACEUP,REASON_COST)
end
function c511600097.pfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM)
end
function c511600097.filter(c)
	return c:IsSetCard(0xaf) and c:IsFaceup()
end
function c511600097.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetMatchingGroupCount(c511600097.pfilter,tp,0,LOCATION_EXTRA,nil)
	local rg=Duel.GetDecktopGroup(1-tp,ct)
	if chk==0 then return ct>0 and #rg>=ct
		and Duel.IsExistingMatchingCard(c511600097.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,nil,1,0,#rg*200)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,rg,#rg,0,0)
end
function c511600097.operation(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(c511600097.pfilter,tp,0,LOCATION_EXTRA,nil)
	local rg=Duel.GetDecktopGroup(1-tp,ct)
	if Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)>0
		and Duel.IsExistingMatchingCard(c511600097.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) then
		local og=Duel.GetOperatedGroup()
		local tc=Duel.SelectMatchingCard(tp,c511600097.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil):GetFirst()
		local c=e:GetHandler()
		if tc then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+0x1ff0000)
			e1:SetValue(#og*100)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_EXTRA_ATTACK)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetValue(1)
			e2:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e2)
		end
	end
end