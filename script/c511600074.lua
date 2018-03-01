--デストーイ・ボーンダイバー
--Frightfur Bone Diver
--scripted by Larry126
function c511600074.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--Double LP
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetCondition(c511600074.lpcon)
	e1:SetOperation(c511600074.lpop)
	c:RegisterEffect(e1)
end
function c511600074.lpcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(tp)<=2000
end
function c511600074.lpop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetLP(tp,Duel.GetLP(tp)*2)
end