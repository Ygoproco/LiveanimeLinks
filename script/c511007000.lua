--coded by Lyris
--DDアーク
function c511007000.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--When this card is in a Pendulum Zone, and there is a card in the other Pendulum Zone, you may ignore the Pendulum Summons scale.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCode(511007000)
	c:RegisterEffect(e1)
end
