--エクスカリバー
--Excalibur
--updated by ClaireStanfield
local s,id=GetID()
function s.initial_effect(c)
	aux.AddEquipProcedure(c)
	--double original atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ADJUST)
	e1:SetRange(LOCATION_SZONE)
	e1:SetOperation(s.atkop)
	e1:SetLabel(0)
	c:RegisterEffect(e1)
	--Destroy on Draw
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_DRAW)
	e2:SetRange(LOCATION_SZONE)
	e2:SetOperation(s.ctop)
	c:RegisterEffect(e2)
	--Skip Draw Phase
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(511000694,0))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(1,0)
	e3:SetCode(EVENT_PHASE_START+PHASE_DRAW)
	e3:SetOperation(s.dpop)
	c:RegisterEffect(e3)
	--check for doubling
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(511000694)
	c:RegisterEffect(e4)
end
function s.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if ep~=c:GetControler() then return end
	Duel.Destroy(c,REASON_EFFECT)
end
function s.chkfilter(c,eq)
	local ec=c:GetEquipTarget()
	return c:IsHasEffect(511000694) and ec and ec==eq and not c:IsDisabled()
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local eq=c:GetEquipTarget()
	local g=Duel.GetMatchingGroup(s.chkfilter,tp,LOCATION_SZONE,LOCATION_SZONE,c,eq)
	if eq and c:GetFlagEffect(511000695)==0 and e:GetLabel()~=g:GetCount()+1 then
		c:ResetEffect(RESET_DISABLE,RESET_EVENT)
		local tc=g:GetFirst()
		while tc do
			tc:RegisterFlagEffect(511000695,RESET_EVENT+0x1ff0000,0,0)
			tc=g:GetNext()
		end
		local atk=eq:GetBaseAttack()
		for i=1,g:GetCount()+1 do
			atk=atk*2
		end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_EQUIP)
		e1:SetCode(EFFECT_SET_BASE_ATTACK)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+0x1ff0000)
		c:RegisterEffect(e1)
		e:SetLabel(g:GetCount()+1)
	end
end

function s.dpop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectYesNo(tp,aux.Stringid(511000694,0)) then
		Duel.SkipPhase(tp,PHASE_DRAW,RESET_PHASE+PHASE_DRAW,1)
end