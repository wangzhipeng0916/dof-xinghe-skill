// ---------------------codeStart---------------------// 

/**
 * 檢查是否可以執行核能拳技能
 * @param {對象} obj - 技能施放者對象
 * @return {布林值} 是否可以執行技能
 */
function checkExecutableSkill_priest_nuclearpunch(obj)
{
    if (!obj) return false;
    if (obj.isCarryWeapon()) return false;
    local isUseSkill = obj.sq_IsUseSkill(242);
    if (isUseSkill)
    {
        obj.sq_IntVectClear();
        obj.sq_IntVectPush(0);
        obj.sq_AddSetStatePacket(242, STATE_PRIORITY_USER, true);
        return true;
    }
    return false;
};

/**
 * 檢查核能拳技能指令是否可用
 * @param {對象} obj - 技能施放者對象
 * @return {布林值} 技能指令是否可用
 */
function checkCommandEnable_priest_nuclearpunch(obj)
{
    if (!obj) return false;
    if (obj.isCarryWeapon()) return false;
    local state = obj.sq_GetState();
    if (state == STATE_STAND)
        return true;
    if (state == STATE_ATTACK)
    {
        return obj.sq_IsCommandEnable(242);
    }
    return true;
};

/**
 * 設置核能拳技能狀態
 * @param {對象} obj - 技能施放者對象
 * @param {整數} state - 技能狀態
 * @param {數據} datas - 狀態數據
 * @param {布林值} isResetTimer - 是否重置計時器
 */
function onSetState_priest_nuclearpunch(obj, state, datas, isResetTimer)
{
    if (!obj) return;
    obj.sq_StopMove();
    local subState = obj.sq_GetVectorData(datas, 0);
    obj.setSkillSubState(subState);
    switch (subState)
    {
        case 0:
            obj.sq_SetCurrentAnimation(135);
            local animation = obj.getCurrentAnimation();
            local originalDelay = animation.getDelaySum(false);
            obj.sq_SetStaticSpeedInfo(SPEED_TYPE_ATTACK_SPEED, SPEED_TYPE_ATTACK_SPEED, SPEED_VALUE_DEFAULT, SPEED_VALUE_DEFAULT, 1.0, 1.0);
            local newDelay = animation.getDelaySum(false);
            local speedRatio = originalDelay.tofloat() / newDelay.tofloat();
            locakonhit(obj, "character/priest/effect/animation/nuclearpunch/talisman/windfront_00.ani", 0, 0, 0, 0, 100, 0, 1, speedRatio, 0);
            locakonhit(obj, "character/priest/effect/animation/nuclearpunch/talisman/windfloor_bottom00.ani", 0, -1, 0, 0, 100, 0, 1, speedRatio, 0);
            local appendage = sq_AttractToMe(obj, 550, 120, 1500);
            obj.getVar("nuclearpunch").setAppendage(0, appendage);
            break;
        case 1:
            obj.sq_SetCurrentAnimation(136);
            obj.sq_SetCurrentAttackInfo(105);
            obj.sq_SetCurrentAttackBonusRate(obj.sq_GetBonusRateWithPassive(242, 242, 0, 1.0));
            obj.getVar().setBool(0, false);
            obj.sq_SetStaticSpeedInfo(SPEED_TYPE_ATTACK_SPEED, SPEED_TYPE_ATTACK_SPEED, SPEED_VALUE_DEFAULT, SPEED_VALUE_DEFAULT, 1.0, 1.0);
            local appendage = obj.getVar("nuclearpunch").getAppendage(0);
            if (appendage)
                appendage.setValid(false);
            break;
        case 2:
            obj.sq_SetCurrentAnimation(137);
            obj.sq_SetStaticSpeedInfo(SPEED_TYPE_ATTACK_SPEED, SPEED_TYPE_ATTACK_SPEED, SPEED_VALUE_DEFAULT, SPEED_VALUE_DEFAULT, 1.0, 1.0);
            sq_SetMyShake(obj, 5, 200);
            if (obj.sq_IsMyControlObject())
                sq_flashScreen(obj, 10, 60, 120, 104, sq_RGB(0, 0, 0), GRAPHICEFFECT_NONE, ENUM_DRAWLAYER_BOTTOM);
            break;
        case 3:
            obj.sq_SetCurrentAnimation(138);
            obj.sq_SetStaticSpeedInfo(SPEED_TYPE_ATTACK_SPEED, SPEED_TYPE_ATTACK_SPEED, SPEED_VALUE_DEFAULT, SPEED_VALUE_DEFAULT, 1.0, 1.0);
            break;
    }
};

/**
 * 處理關鍵幀標誌事件
 * @param {對象} obj - 技能施放者對象
 * @param {整數} flagIndex - 標誌索引
 * @return {布林值} 處理結果
 */
function onKeyFrameFlag_priest_nuclearpunch(obj, flagIndex)
{
    if (!obj) return true;
    local subState = obj.getSkillSubState();
    if (subState == 0)
    {
        if (flagIndex == 1)
        {
            obj.sq_PlaySound("PR_NUCLEAR_PUNCH");
            sq_SetMyShake(obj, 1, 120);
            if (obj.sq_IsMyControlObject())
                sq_flashScreen(obj, 50, 80, 10, 153, sq_RGB(255, 255, 255), GRAPHICEFFECT_NONE, ENUM_DRAWLAYER_BOTTOM);
        }
    }
    return true;
};

/**
 * 處理攻擊事件
 * @param {對象} obj - 技能施放者對象
 * @param {對象} damager - 受攻擊者對象
 * @param {區域} boundingBox - 攻擊區域
 * @param {布林值} isStuck - 是否卡住
 */
function onAttack_priest_nuclearpunch(obj, damager, boundingBox, isStuck)
{
    if (!obj) return;
    if (isStuck || !damager.isObjectType(OBJECTTYPE_ACTIVE)) return;
    local subState = obj.getSkillSubState();
    switch (subState)
    {
        case 1:
            if (obj.getVar().getBool(0) == false)
            {
                obj.getVar().setBool(0, true);
                if (obj.sq_IsMyControlObject())
                {
                    obj.sq_StartWrite();
                    obj.sq_WriteDword(242);
                    obj.sq_WriteDword(obj.sq_GetBonusRateWithPassive(242, 242, 1, 1.0));
                    obj.sq_SendCreatePassiveObjectPacket(24374, 0, 150, 0, 60);
                }
            }
            break;
    }
};

/**
 * 處理當前動畫結束事件
 * @param {對象} obj - 技能施放者對象
 */
function onEndCurrentAni_priest_nuclearpunch(obj)
{
    if (!obj) return;
    if (!obj.sq_IsMyControlObject()) return;
    local subState = obj.getSkillSubState();
    if (subState == 0)
    {
        obj.sq_IntVectClear();
        obj.sq_IntVectPush(subState + 1);
        obj.sq_AddSetStatePacket(242, STATE_PRIORITY_USER, true);
    }
    else if (subState == 1)
    {
        obj.sq_IntVectClear();
        if (obj.getVar().getBool(0) == true)
            obj.sq_IntVectPush(2);
        else
            obj.sq_IntVectPush(3);
        obj.sq_AddSetStatePacket(242, STATE_PRIORITY_USER, true);
    }
    else
        obj.sq_AddSetStatePacket(STATE_STAND, STATE_PRIORITY_USER, false);
};

/**
 * 處理技能狀態結束事件
 * @param {對象} obj - 技能施放者對象
 * @param {整數} new_state - 新狀態
 */
function onEndState_nuclearpunch(obj, new_state)
{
    if (!obj) return;
    if (new_state != 242)
    {
        local appendage = obj.getVar("nuclearpunch").getAppendage(0);
        if (appendage)
            appendage.setValid(false);
    }
}

// ---------------------codeEnd---------------------//