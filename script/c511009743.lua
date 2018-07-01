--Medicdrone Dock
function c511009743.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,c511009743.mfilter,2)
	c:EnableReviveLimit()
	--recover
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(511009743,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetCountLimit(1,511009743)
	e1:SetCondition(c511009743.reccon1)
	e1:SetTarget(c511009743.rectg1)
	e1:SetOperation(c511009743.recop1)
	c:RegisterEffect(e1)
	--recover
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(511009743,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetCountLimit(1,511019743)
	e3:SetCondition(c511009743.reccon2)
	e3:SetTarget(c511009743.rectg2)
	e3:SetOperation(c511009743.recop2)
	c:RegisterEffect(e3)
	aux.CallToken(420)
end
function c511009743.mfilter(c,lc,sumtype,tp)
	return c:IsDrone()
end
function c511009743.cfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousPosition(POS_FACEUP) and c:GetPreviousControler()==tp
		and c:IsDrone()
end
function c511009743.reccon(e,tp,eg,ep,ev,re,r,rp)
		local atk=0
	local tc=eg:GetFirst()
	while tc do
		if tc:IsReason(REASON_DESTROY) and tc:IsDrone() and not tc:IsPreviousLocation(LOCATION_SZONE) then
			local tatk=tc:GetAttack()
			if tatk>atk then atk=tatk end
		end
		tc=eg:GetNext()
	end
	if atk>0 then e:SetLabel(atk) end
	return atk>0
end
function c511009743.rectg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local opt=Duel.SelectOption(tp,aux.Stringid(58074572,0),aux.Stringid(58074572,1))
	local p=(opt==0 and tp or 1-tp)
	local lp=e:GetLabel()
	Duel.SetTargetPlayer(p)
	Duel.SetTargetParam(lp)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,p,lp)
end
function c511009743.recop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end

function c511009743.reccon2(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0
end

function c58074572.rectg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local opt=Duel.SelectOption(tp,aux.Stringid(58074572,0),aux.Stringid(58074572,1))
	local p=(opt==0 and tp or 1-tp)
	Duel.SetTargetPlayer(p)
	Duel.SetTargetParam(1000)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,p,1000)
end
function c58074572.recop2(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end
