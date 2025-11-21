// ---------------------codeStart---------------------// 

/**
 * 檢查是否可執行「牧師-破魔符」技能
 * @param {對象} skillUser - 技能使用者對象
 * @return {布林值} 是否成功執行技能
 */
function checkExecutableSkill_priest_destroyspirittalisman(skillUser)
{
    if (!skillUser) return false;
    local isSkillUsed = skillUser.sq_IsUseSkill(237);
    if (isSkillUsed)
    {
        skillUser.sq_AddSetStatePacket(237, STATE_PRIORITY_USER, false);
        return true;
    }
    return false;
}

/**
 * 檢查「牧師-破魔符」技能命令是否可用
 * @param {對象} obj - 技能對象
 * @return {布林值} 是否可用
 */
function checkCommandEnable_priest_destroyspirittalisman(obj)
{
    if (!obj) return false;
    return true;
}

/**
 * 設置「牧師-破魔符」技能狀態
 * @param {對象} skillUser - 技能使用者對象
 * @param {整數} state - 狀態值
 * @param {整數} skillSubState - 技能子狀態
 * @param {整數} skillCustomData - 技能自訂數據
 */
function onSetState_priest_destroyspirittalisman(skillUser, state, skillSubState, skillCustomData)
{
    if (!skillUser) return;
    skillUser.sq_StopMove();
    skillUser.sq_SetCurrentAnimation(122);
    skillUser.sq_SetStaticSpeedInfo(SPEED_TYPE_ATTACK_SPEED, SPEED_TYPE_ATTACK_SPEED, SPEED_VALUE_DEFAULT, SPEED_VALUE_DEFAULT, 1.0, 1.0);
}

/**
 * 處理「牧師-破魔符」技能關鍵幀標誌
 * @param {對象} skillUser - 技能使用者對象
 * @param {整數} keyFrameFlag - 關鍵幀標誌值
 * @return {布林值} 處理結果
 */
function onKeyFrameFlag_priest_destroyspirittalisman(skillUser, keyFrameFlag)
{
    if (!skillUser) return false;
    if (keyFrameFlag == 1 && skillUser.sq_IsMyControlObject())
    {
        local skillLevel = sq_GetSkillLevel(skillUser, 237);
        skillUser.sq_StartWrite();
        skillUser.sq_WriteDword(237);
        skillUser.sq_WriteDword(1);
        skillUser.sq_WriteDword(skillUser.sq_GetLevelData(237, 0, skillLevel));
        skillUser.sq_WriteDword(skillUser.sq_GetLevelData(237, 1, skillLevel));
        skillUser.sq_WriteDword(skillUser.sq_GetBonusRateWithPassive(237, 237, 2, 1.0));
        skillUser.sq_SendCreatePassiveObjectPacket(24374, 0, 60, 0, 60);
    }
    return true;
}

/**
 * 「牧師-破魔符」技能當前動畫結束處理
 * @param {對象} skillUser - 技能使用者對象
 */
function onEndCurrentAni_priest_destroyspirittalisman(skillUser)
{
    if (!skillUser) return;
    if (!skillUser.sq_IsMyControlObject()) return;
    skillUser.sq_AddSetStatePacket(STATE_STAND, STATE_PRIORITY_USER, false);
}

// ---------------------codeEnd---------------------//