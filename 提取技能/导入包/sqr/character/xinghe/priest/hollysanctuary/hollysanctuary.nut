// ---------------------codeStart---------------------//

/**
 * 檢查是否可以執行神聖聖域技能
 * @param {object} skillOwner - 技能擁有者對象
 * @return {boolean} 是否可以執行技能
 */
function checkExecutableSkill_priest_hollysanctuary(skillOwner)
{
    if (!skillOwner) return false;
    
    local isSkillUsed = skillOwner.sq_IsUseSkill(248);
    if (isSkillUsed)
    {
        skillOwner.sq_IsEnterSkillLastKeyUnits(248);
        skillOwner.sq_IntVectClear();
        skillOwner.sq_IntVectPush(0);
        skillOwner.sq_AddSetStatePacket(248, STATE_PRIORITY_USER, true);
        return true;
    }
    return false;
};

/**
 * 檢查技能命令是否可用
 * @param {object} skillOwner - 技能擁有者對象
 * @return {boolean} 技能命令是否可用
 */
function checkCommandEnable_priest_hollysanctuary(skillOwner)
{
    if (!skillOwner) return false;
    return true;
};

/**
 * 設置神聖聖域技能狀態
 * @param {object} skillOwner - 技能擁有者對象
 * @param {object} stateData - 狀態數據
 * @param {object} skillData - 技能數據
 * @param {object} customData - 自定義數據
 */
function onSetState_priest_hollysanctuary(skillOwner, stateData, skillData, customData)
{
    if (!skillOwner) return;
    
    skillOwner.sq_StopMove();
    local subState = skillOwner.sq_GetVectorData(skillData, 0);
    skillOwner.setSkillSubState(subState);
    
    switch (subState)
    {
        case 0:
            if (CNSquirrelAppendage.sq_IsAppendAppendage(skillOwner, "character/xinghe/priest/jupiter/ap_jupiter.nut") == true)
                skillOwner.sq_SetCurrentAnimation(196);
            else
                skillOwner.sq_SetCurrentAnimation(166);
            
            skillOwner.getVar().clear_obj_vector();
            
            if (skillOwner.sq_IsMyControlObject())
            {
                local skillLevel = sq_GetSkillLevel(skillOwner, 248);
                skillOwner.sq_StartWrite();
                skillOwner.sq_WriteDword(248);
                skillOwner.sq_WriteDword(1);
                skillOwner.sq_WriteDword(skillOwner.sq_GetLevelData(248, 0, skillLevel));
                skillOwner.sq_WriteDword(skillOwner.sq_GetBonusRateWithPassive(248, 248, 1, 1.0));
                skillOwner.sq_WriteDword(skillOwner.sq_GetLevelData(248, 2, skillLevel));
                skillOwner.sq_WriteDword(skillOwner.sq_GetBonusRateWithPassive(248, 248, 3, 1.0));
                skillOwner.sq_SendCreatePassiveObjectPacket(24374, 0, 150, 0, 0);
            }
            break;
            
        case 1:
            if (CNSquirrelAppendage.sq_IsAppendAppendage(skillOwner, "character/xinghe/priest/jupiter/ap_jupiter.nut") == true)
                skillOwner.sq_SetCurrentAnimation(197);
            else
                skillOwner.sq_SetCurrentAnimation(167);
            break;
    }
    
    skillOwner.sq_SetStaticSpeedInfo(SPEED_TYPE_ATTACK_SPEED, SPEED_TYPE_ATTACK_SPEED, SPEED_VALUE_DEFAULT, SPEED_VALUE_DEFAULT, 1.0, 1.0);
};

/**
 * 處理神聖聖域技能的持續邏輯
 * @param {object} skillOwner - 技能擁有者對象
 */
function onProcCon_priest_hollysanctuary(skillOwner)
{
    if (!skillOwner) return;
    
    local subState = skillOwner.getSkillSubState();
    
    if (subState == 0)
    {
        if (skillOwner.sq_GetStateTimer() > 500 || !skillOwner.isDownSkillLastKey())
        {
            skillOwner.sq_IntVectClear();
            skillOwner.sq_IntVectPush(1);
            skillOwner.sq_AddSetStatePacket(248, STATE_PRIORITY_USER, true);
        }
    }
    
    if (skillOwner.getVar().get_obj_vector_size() > 0)
    {
        local moveX = 0;
        local moveY = 0;
        local moveSpeed = 2;
        
        if (sq_IsKeyDown(OPTION_HOTKEY_MOVE_UP, ENUM_SUBKEY_TYPE_ALL))
            moveY -= moveSpeed;
        else if (sq_IsKeyDown(OPTION_HOTKEY_MOVE_DOWN, ENUM_SUBKEY_TYPE_ALL))
            moveY += moveSpeed;
            
        if (sq_IsKeyDown(OPTION_HOTKEY_MOVE_LEFT, ENUM_SUBKEY_TYPE_ALL))
            moveX -= moveSpeed;
        else if (sq_IsKeyDown(OPTION_HOTKEY_MOVE_RIGHT, ENUM_SUBKEY_TYPE_ALL))
            moveX += moveSpeed;
            
        local passiveObject = skillOwner.getVar().get_obj_vector(0);
        if (passiveObject)
        {
            if (moveX != 0)
                sq_setCurrentAxisPos(passiveObject, 0, sq_GetXPos(passiveObject) + moveX);
                
            if (moveY != 0)
                sq_setCurrentAxisPos(passiveObject, 1, sq_GetYPos(passiveObject) + moveY);
        }
    }
};

/**
 * 處理關鍵幀標誌事件
 * @param {object} skillOwner - 技能擁有者對象
 * @param {integer} flagValue - 標誌值
 * @return {boolean} 處理結果
 */
function onKeyFrameFlag_priest_hollysanctuary(skillOwner, flagValue)
{
    if (!skillOwner) return false;
    
    local subState = skillOwner.getSkillSubState();
    if (subState == 1)
    {
        if (flagValue == 1)
            skillOwner.sq_PlaySound("PR_HOLYSANCTUARY_02");
    }
    return true;
};

/**
 * 當前動畫結束時處理
 * @param {object} skillOwner - 技能擁有者對象
 */
function onEndCurrentAni_priest_hollysanctuary(skillOwner)
{
    if (!skillOwner) return;
    if (!skillOwner.sq_IsMyControlObject()) return;
    
    local subState = skillOwner.getSkillSubState();
    if (subState == 1)
        skillOwner.sq_AddSetStatePacket(STATE_STAND, STATE_PRIORITY_USER, false);
};

// ---------------------codeEnd---------------------//