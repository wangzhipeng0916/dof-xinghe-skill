// ---------------------codeStart---------------------// 

/**
 * 檢查是否可執行加特林拳技能
 * @param {對象} obj - 技能施放者對象
 * @return {布林值} 是否可執行技能
 */
function checkExecutableSkill_gatlingpunch(obj)
{
    if (!obj) return false;
    if (obj.isCarryWeapon()) return false;
    
    local isSkillUse = obj.sq_IsUseSkill(252);
    if (isSkillUse)
    {
        obj.sq_IntVectClear();
        obj.sq_IntVectPush(0);
        obj.sq_AddSetStatePacket(252, STATE_PRIORITY_USER, true);
        return true;
    }
    return false;
}

/**
 * 檢查加特林拳技能命令是否可用
 * @param {對象} obj - 技能施放者對象
 * @return {布林值} 技能命令是否可用
 */
function checkCommandEnable_gatlingpunch(obj)
{
    if (!obj) return false;
    if (obj.isCarryWeapon()) return false;
    return true;
}

/**
 * 設置加特林拳技能狀態
 * @param {對象} obj - 技能施放者對象
 * @param {整數} state - 技能狀態
 * @param {數據} datas - 技能數據
 * @param {布林值} isResetTimer - 是否重置計時器
 */
function onSetState_gatlingpunch(obj, state, datas, isResetTimer)
{
    if (!obj) return;
    obj.sq_StopMove();

    local attackHook = obj.getVar("gatlingpunch");
    attackHook.clear_vector();
    attackHook.clear_obj_vector();
    local subState = obj.sq_GetVectorData(datas, 0);
    attackHook.setInt(0, subState);

    if (subState == 0)
    {
        obj.sq_SetCurrentAnimation(251);
        obj.sq_SetStaticSpeedInfo(SPEED_TYPE_ATTACK_SPEED, SPEED_TYPE_ATTACK_SPEED, SPEED_VALUE_DEFAULT, SPEED_VALUE_DEFAULT, 1.0, 1.0);
    }

    if (subState == 1)
    {
        obj.sq_SetCurrentAnimation(250);
        obj.sq_SetStaticSpeedInfo(SPEED_TYPE_ATTACK_SPEED, SPEED_TYPE_ATTACK_SPEED, SPEED_VALUE_DEFAULT, SPEED_VALUE_DEFAULT, 1.0, 1.0);
    }
}

/**
 * 加特林拳技能當前動畫結束時處理
 * @param {對象} obj - 技能施放者對象
 */
function onEndCurrentAni_gatlingpunch(obj)
{
    local attackHook = obj.getVar("gatlingpunch");
    attackHook.clear_vector();
    attackHook.clear_obj_vector();
    local subState = attackHook.getInt(0);

    local maxAttackCount = obj.sq_GetIntData(252, 3);

    if (attackHook.getInt(1) < maxAttackCount)
    {
        obj.sq_IntVectClear();
        obj.sq_IntVectPush(0);
        obj.sq_AddSetStatePacket(252, STATE_PRIORITY_USER, true);
    }

    if (subState == 0 && attackHook.getInt(1) >= maxAttackCount)
    {
        obj.sq_IntVectClear();
        obj.sq_IntVectPush(1);
        obj.sq_AddSetStatePacket(252, STATE_PRIORITY_USER, true);
    }
    
    if (subState == 1)
    {
        obj.sq_AddSetStatePacket(STATE_STAND, STATE_PRIORITY_USER, false);
        attackHook.setInt(1, 0);
    }
}

/**
 * 處理加特林拳技能關鍵幀標誌
 * @param {對象} obj - 技能施放者對象
 * @param {整數} flagIndex - 標誌索引
 * @return {布林值} 是否處理成功
 */
function onKeyFrameFlag_gatlingpunch(obj, flagIndex)
{
    if (!obj) return false;

    local attackHook = obj.getVar("gatlingpunch");
    attackHook.clear_vector();
    attackHook.clear_obj_vector();

    local skillLevel = sq_GetSkillLevel(obj, 252);

    if (flagIndex == 1)
    {
        obj.sq_SetCurrentAttackInfo(146);
        local damageRate = obj.sq_GetBonusRateWithPassive(252, 252, 0, 1.0);
        obj.sq_SetCurrentAttackBonusRate(damageRate);
        attackHook.setInt(1, attackHook.getInt(1) + 1);
        return true;
    }

    if (flagIndex == 2)
    {
        obj.sq_SetCurrentAttackInfo(145);
        local damageRate = obj.sq_GetBonusRateWithPassive(252, 252, 1, 1.0);
        obj.sq_SetCurrentAttackBonusRate(damageRate);
        obj.sq_SendCreatePassiveObjectPacket(26081, 0, 120, 1, 0);
        return true;
    }

    return false;
}

// ---------------------codeEnd---------------------//