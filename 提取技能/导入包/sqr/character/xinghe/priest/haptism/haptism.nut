// ---------------------codeStart---------------------// 

/**
 * 檢查是否可以執行技能"priest_haptism"
 * @param {對象} character - 角色對象
 * @return {布林值} 是否可執行技能
 */
function checkExecutableSkill_priest_haptism(character)
{
    if (!character) return false;
    
    local isSkillUsed = character.sq_IsUseSkill(246);
    if (isSkillUsed)
    {
        character.sq_IntVectClear();
        character.sq_IntVectPush(0);
        character.sq_AddSetStatePacket(246, STATE_PRIORITY_USER, true);
        return true;
    }
    return false;
};

/**
 * 檢查技能指令是否可用
 * @param {對象} obj - 角色對象
 * @return {布林值} 指令是否可用
 */
function checkCommandEnable_priest_haptism(obj)
{
    if (!obj) return false;
    return true;
};

/**
 * 設置技能狀態處理函數
 * @param {對象} character - 角色對象
 * @param {對象} state - 狀態對象
 * @param {對象} data - 數據對象
 * @param {對象} appendage - 附加對象
 */
function onSetState_priest_haptism(character, state, data, appendage)
{
    if (!character) return;
    
    character.sq_StopMove();
    local subState = character.sq_GetVectorData(data, 0);
    character.setSkillSubState(subState);
    
    switch (subState)
    {
        case 0:
            if (CNSquirrelAppendage.sq_IsAppendAppendage(character, "character/xinghe/priest/jupiter/ap_jupiter.nut") == true)
                character.sq_SetCurrentAnimation(225);
            else
                character.sq_SetCurrentAnimation(217);
            
            if (character.sq_IsMyControlObject())
            {
                character.sq_StartWrite();
                character.sq_WriteDword(246);
                character.sq_WriteDword(1);
                character.sq_WriteDword(character.sq_GetBonusRateWithPassive(246, 246, 0, 1.0));
                character.sq_SendCreatePassiveObjectPacket(24374, 0, 0, 0, 0);
                
                character.sq_StartWrite();
                character.sq_WriteDword(246);
                character.sq_WriteDword(2);
                character.sq_WriteDword(character.sq_GetBonusRateWithPassive(246, 246, 1, 1.0));
                character.sq_SendCreatePassiveObjectPacket(24374, 0, 0, 0, 0);
            }
            break;
            
        case 1:
            if (CNSquirrelAppendage.sq_IsAppendAppendage(character, "character/xinghe/priest/jupiter/ap_jupiter.nut") == true)
                character.sq_SetCurrentAnimation(226);
            else
                character.sq_SetCurrentAnimation(218);
            
            if (character.sq_IsMyControlObject())
            {
                character.sq_StartWrite();
                character.sq_WriteDword(246);
                character.sq_WriteDword(3);
                character.sq_WriteDword(character.sq_GetBonusRateWithPassive(246, 246, 2, 1.0));
                character.sq_SendCreatePassiveObjectPacket(24374, 0, 0, 0, 0);
            }
            break;
    }
    
    character.sq_SetStaticSpeedInfo(SPEED_TYPE_ATTACK_SPEED, SPEED_TYPE_ATTACK_SPEED, SPEED_VALUE_DEFAULT, SPEED_VALUE_DEFAULT, 1.0, 1.0);
};

/**
 * 當前動畫結束時處理函數
 * @param {對象} character - 角色對象
 */
function onEndCurrentAni_priest_haptism(character)
{
    if (!character) return;
    if (!character.sq_IsMyControlObject()) return;
    
    local subState = character.getSkillSubState();
    
    switch (subState)
    {
        case 0:
            character.sq_IntVectClear();
            character.sq_IntVectPush(1);
            character.sq_AddSetStatePacket(246, STATE_PRIORITY_USER, true);
            break;
            
        case 1:
            character.sq_AddSetStatePacket(STATE_STAND, STATE_PRIORITY_USER, false);
            break;
    }
};

// ---------------------codeEnd---------------------//