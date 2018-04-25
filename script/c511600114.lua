--Ｄスケイル・トーピード
--D-Scale Torpedo
--scripted by Larry126
function c511600114.initial_effect(c)
	aux.AddEquipProcedure(c,nil,aux.FilterBoolFunction(Card.IsSetCard,0x579))
	--damage
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(54514594,0))
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTarget(c511600114.target)
	e1:SetOperation(c511600114.operation)
	c:RegisterEffect(e1)
	if not c511600114.global_check then
		c511600114.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ADJUST)
		ge1:SetOperation(c511600114.mvchk)
		Duel.RegisterEffect(ge1,0)
	end
end
function c511600114.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetEquipTarget():GetFlagEffect(5116001140)>0 end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,0)
end
function c511600114.operation(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.Damage(p,e:GetHandler():GetEquipTarget():GetFlagEffect(5116001140)*800,REASON_EFFECT)
end
function c511600114.mvchk(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	for tc in aux.Next(g) do
		if not tc:GetFlagEffectLabel(511600114) then
			tc:RegisterFlagEffect(511600114,RESET_EVENT+0x1fe0000,0,1,tc:GetSequence())
		elseif tc:GetSequence()~=tc:GetFlagEffectLabel(511600114) or tc:GetControler()~=tc:GetPreviousControler() then
			tc:SetFlagEffectLabel(511600114,tc:GetSequence())
			tc:RegisterFlagEffect(5116001140,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
		end
	end
end