--ＢＫ スイッチヒッター
--Battlin' Boxer Switchitter (Anime)
function c511002761.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(511001225)
	e1:SetOperation(c511002761.tgval)
	e1:SetValue(1)
	c:RegisterEffect(e1)
end
function c511002761.tgval(e,c)
	return c:IsSetCard(0x84)
end