--幻魔帝トリロジーグ
--Phantasm Emperor Trilojig
--updated by Larry126
function c511009001.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcMixN(c,false,false,aux.FilterBoolFunction(Card.IsLevel,10),3)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(5114932,0))
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCondition(c511009001.damcon)
	e1:SetTarget(c511009001.damtg)
	e1:SetOperation(c511009001.damop)
	c:RegisterEffect(e1)
end
function c511009001.filter(c,tp)
	return c:GetPreviousLocation()==LOCATION_GRAVE and c:IsControler(tp)
end
function c511009001.damcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c511009001.filter,1,nil,tp)
end
function c511009001.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.nzatk,tp,0,LOCATION_MZONE,1,nil) end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,0)
end
function c511009001.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local tc=Duel.SelectMatchingCard(tp,aux.nzatk,tp,0,LOCATION_MZONE,1,1,nil):GetFirst()
	if tc then
		local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
		Duel.Damage(p,tc:GetAttack()/2,REASON_EFFECT)
	end
end
