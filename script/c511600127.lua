--ドタキャン (Anime)
--Last Minute Cancel (Anime)
--scripted by Larry126
function c511600127.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCondition(c511600127.condition)
	e1:SetTarget(c511600127.target)
	e1:SetOperation(c511600127.activate)
	c:RegisterEffect(e1)
end
function c511600127.condition(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
end
function c511600127.filter(c)
	return c:IsAttackPos() and c:IsCanChangePosition()
end
function c511600127.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c511600127.filter,tp,LOCATION_MZONE,0,1,nil) end
end
function c511600127.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c511600127.filter,tp,LOCATION_MZONE,0,nil)
	if g:GetCount()>0 then
		Duel.ChangePosition(g,POS_FACEUP_DEFENSE)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c511600127.rtg)
	e1:SetValue(LOCATION_HAND)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c511600127.rtg(e,c)
	return c:IsReason(REASON_BATTLE+REASON_DESTROY) and c:IsSetCard(0x9f)
end