--ハイドライブ・トレランス
--Hydradrive Tolerance
--Scripted by Playmaker 772211
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttacker()
	return at and at:IsControler(1-tp) and at:IsRelateToBattle()
end
function s.filter(c,dam,tid)
	return c:IsSetCard(0x577) and c:IsType(TYPE_LINK) and c:GetTurnID()==tid and bit.band(c:GetReason(),REASON_BATTLE)~=0 and (not dam or c:GetLink()>0)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tid=Duel.GetTurnCount()
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and s.filter(chkc,c,tid) end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,c,tid) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,s.filter,tp,LOCATION_GRAVE,0,1,1,nil,c,tid)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PRE_BATTLE_DAMAGE)
		e1:SetLabel(tc:GetLink())
		e1:SetOperation(s.rdop)
		e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(c)
	    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	    e2:SetCode(EVENT_DAMAGE_STEP_END)
	    e2:SetOperation(s.damop)
	    Duel.RegisterEffect(e2,tp)
	end
end
function s.rdop(e,tp,eg,ep,ev,re,r,rp)
	local dam=e:GetLabel()*300
	local cid=Duel.GetChainInfo(ev,CHAININFO_CHAIN_ID)
	Duel.ChangeBattleDamage(ep,math.max(Duel.GetBattleDamage(tp)-dam,0))
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(s.damval)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function s.damval(e,re,val,r,rp,rc)
	if bit.band(r,REASON_BATTLE)~=0 then return 0
	else return val end
end