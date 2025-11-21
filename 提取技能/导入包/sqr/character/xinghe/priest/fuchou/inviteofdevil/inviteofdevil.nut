// ---------------------codeStart---------------------// 

// 檢查是否可以執行技能「惡魔邀請」
function checkExecutableSkill_priest_inviteofdevil(characterObject)
{
    characterObject = sq_GetCNRDObjectToSQRCharacter(characterObject);
    if(!characterObject) return false; 
    local isSkillUsed = characterObject.sq_IsUseSkill(132); 
    if(isSkillUsed) 
    {
        characterObject.sq_IntVectClear();
        if(isAvengerAwakenning(characterObject)) 
            characterObject.sq_IntVectPush(1); 
        else
            characterObject.sq_IntVectPush(0); 
        characterObject.sq_AddSetStatePacket(132, STATE_PRIORITY_USER, true); 
        return true; 
    }
    return false; 
} 

// 檢查技能指令是否可用
function checkCommandEnable_priest_inviteofdevil(characterObject)
{
    characterObject = sq_GetCNRDObjectToSQRCharacter(characterObject);
    if(!characterObject) return false; 
    local characterState = characterObject.sq_GetState(); 
    if(characterState == STATE_STAND) 
        return true; 
    if(characterState == STATE_ATTACK) 
    {
        return characterObject.sq_IsCommandEnable(132); 
    }
    return true; 
} 

// 設定技能狀態
function onSetState_priest_inviteofdevil(characterObject, skillState, dataContainer, skillData)
{
    characterObject = sq_GetCNRDObjectToSQRCharacter(characterObject);
    if(!characterObject) return; 
    characterObject.sq_StopMove(); 
    local subState = characterObject.sq_GetVectorData(dataContainer, 0); 
    characterObject.setSkillSubState(subState); 
    switch(subState)
    {
        case 0:
            characterObject.sq_SetCurrentAnimation(243);
            break;
        case 1:
            local animation = characterObject.getVar().GetAnimationMap("priest_avenger_inviteofdevil", "character/priest/animation/avengerawakening/inviteofdevil/inviteofdevil.ani");
            characterObject.setCurrentAnimation(animation);
            break;
    }
    local originalDelay = characterObject.sq_GetDelaySum(); 
    characterObject.sq_SetStaticSpeedInfo(SPEED_TYPE_ATTACK_SPEED, SPEED_TYPE_ATTACK_SPEED, SPEED_VALUE_DEFAULT, SPEED_VALUE_DEFAULT, 1.0, 1.0); 
    local currentDelay = characterObject.sq_GetDelaySum(); 
    local speedRate = originalDelay.tofloat() / currentDelay.tofloat() * 100.0; 
    characterObject.getVar("speedRate").setFloat(0, speedRate); 
} 

// 處理關鍵幀標誌
function onKeyFrameFlag_priest_inviteofdevil(characterObject, flagIndex)
{
    characterObject = sq_GetCNRDObjectToSQRCharacter(characterObject);
    if(!characterObject) return false;
    local subState = characterObject.getSkillSubState(); 
    if(characterObject.sq_IsMyControlObject())
        switch(subState)
        {
            case 0:
                if(flagIndex == 0) 
                {
                    characterObject.sq_StartWrite();
                    characterObject.sq_WriteDword(132); 
                    characterObject.sq_WriteDword(1); 
                    characterObject.sq_WriteDword(1); 
                    characterObject.sq_WriteFloat(characterObject.getVar("speedRate").getFloat(0)); 
                    characterObject.sq_WriteDword(characterObject.sq_GetBonusRateWithPassive(132, 132, 0, 1.0)); 
                    characterObject.sq_SendCreatePassiveObjectPacket(24374, 0, 0, 0, 0);
                }
                else if(flagIndex == 1) 
                {
                    characterObject.sq_StartWrite();
                    characterObject.sq_WriteDword(132); 
                    characterObject.sq_WriteDword(2); 
                    characterObject.sq_WriteDword(1); 
                    characterObject.sq_WriteFloat(characterObject.getVar("speedRate").getFloat(0)); 
                    characterObject.sq_WriteDword(characterObject.sq_GetBonusRateWithPassive(132, 132, 0, 1.0)); 
                    characterObject.sq_WriteDword(characterObject.sq_GetBonusRateWithPassive(132, 132, 1, 1.0)); 
                    characterObject.sq_SendCreatePassiveObjectPacket(24374, 0, 0, -10, 0);
                }
                break;
            case 1:
                if(flagIndex == 0) 
                {
                    characterObject.sq_StartWrite();
                    characterObject.sq_WriteDword(132); 
                    characterObject.sq_WriteDword(1); 
                    characterObject.sq_WriteDword(2); 
                    characterObject.sq_WriteFloat(characterObject.getVar("speedRate").getFloat(0)); 
                    characterObject.sq_WriteDword(characterObject.sq_GetBonusRateWithPassive(132, 132, 2, 1.0)); 
                    characterObject.sq_SendCreatePassiveObjectPacket(24374, 0, 0, 0, 0);
                }
                else if(flagIndex == 1) 
                {
                    characterObject.sq_StartWrite();
                    characterObject.sq_WriteDword(132); 
                    characterObject.sq_WriteDword(2); 
                    characterObject.sq_WriteDword(2); 
                    characterObject.sq_WriteFloat(characterObject.getVar("speedRate").getFloat(0)); 
                    characterObject.sq_WriteDword(characterObject.sq_GetBonusRateWithPassive(132, 132, 2, 1.0)); 
                    characterObject.sq_WriteDword(characterObject.sq_GetBonusRateWithPassive(132, 132, 3, 1.0)); 
                    characterObject.sq_SendCreatePassiveObjectPacket(24374, 0, 0, -10, 0);
                }
                break;
        }
    return true;
} 

// 當前動畫結束時處理
function onEndCurrentAni_priest_inviteofdevil(characterObject)
{
    characterObject = sq_GetCNRDObjectToSQRCharacter(characterObject);
    if(!characterObject) return;
    if(characterObject.sq_IsMyControlObject())
        characterObject.sq_AddSetStatePacket(STATE_STAND, STATE_PRIORITY_USER, false); 
} 

// ---------------------codeEnd---------------------//