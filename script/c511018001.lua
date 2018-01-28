--クリアクリボー
--Clear Kuriboh
function c511018001.initial_effect(c)
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(46613515,0))
	e1:SetCategory(CATEGORY_NEGATE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCondition(c511018001.negcon)
	e1:SetCost(c511018001.negcost)
	e1:SetTarget(c511018001.negtg)
	e1:SetOperation(c511018001.negop)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(46613515,1))
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c511018001.drcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c511018001.drtg)
	e2:SetOperation(c511018001.drop)
	c:RegisterEffect(e2)
end
function c511018001.negcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsChainNegatable(ev) and (aux.damcon1(e,tp,eg,ep,ev,re,r,rp) or aux.damcon1(e,1-tp,eg,ep,ev,re,r,rp))
		and re:IsActiveType(TYPE_MONSTER) and ep~=tp
end
function c511018001.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c511018001.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c511018001.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
end
function c511018001.drcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():IsControler(1-tp) and Duel.GetAttackTarget()==nil
end
function c511018001.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c511018001.drop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Draw(tp,1,REASON_EFFECT)==0 then return end
	local tc=Duel.GetOperatedGroup():GetFirst()
	local a=Duel.GetAttacker()
	if tc and tc:IsType(TYPE_MONSTER) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false) 
		and Duel.SelectYesNo(tp,aux.Stringid(46613515,2)) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 
		and a and not a:IsImmuneToEffect(e) and a:IsRelateToBattle() and a:GetAttackableTarget() and a:GetAttackableTarget():IsContains(tc) then
		Duel.ChangeAttackTarget(tc)
	end
end
