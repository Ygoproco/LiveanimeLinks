--復讐のソード・ストーカー (Anime)
--Swordstalker (Anime)
--rescripted by Larry126
function c810000114.initial_effect(c)
	--atk change
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(810000114,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetTarget(c810000114.target)
	e1:SetOperation(c810000114.operation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	if not c810000114.global_check then
		c810000114.global_check=true
		local ge1=Effect.GlobalEffect()
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_BATTLE_DESTROYED)
		ge1:SetOperation(c810000114.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c810000114.cfilter(c,p)
	return c:GetPreviousControler()==p
end
function c810000114.checkop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(c810000114.cfilter,1,nil,0) then
		Duel.RegisterFlagEffect(0,810000114,RESET_PHASE+PHASE_END,0,2)
	end
	if eg:IsExists(c810000114.cfilter,1,nil,1) then
		Duel.RegisterFlagEffect(1,810000114,RESET_PHASE+PHASE_END,0,2)
	end
end
function c810000114.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,810000114)>0 end
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,e:GetHandler(),1,tp,e:GetHandler():GetAttack()/5)
end
function c810000114.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(c:GetAttack()/5)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1)
	end
end