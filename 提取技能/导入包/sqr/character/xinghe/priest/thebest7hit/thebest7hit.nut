// ---------------------codeStart---------------------//

/**
 * 檢查是否可以執行技能"thebest7hit"
 * @param {對象} obj - 技能使用者對象
 * @return {布林值} 是否可執行技能
 */
function checkExecutableSkill_priest_thebest7hit(obj)
{
    if (!obj) return false;
    local isSkillUsed = obj.sq_IsUseSkill(239);
    if (isSkillUsed)
    {
        obj.sq_IntVectClear();
        obj.sq_IntVectPush(0);
        obj.sq_AddSetStatePacket(239, STATE_PRIORITY_USER, true);
        return true;
    }
    return false;
};

/**
 * 檢查技能命令是否可用
 * @param {對象} obj - 技能使用者對象
 * @return {布林值} 命令是否可用
 */
function checkCommandEnable_priest_thebest7hit(obj)
{
    if (!obj) return false;
    return true;
};

/**
 * 設置技能狀態處理
 * @param {對象} obj - 技能使用者對象
 * @param {整數} state - 狀態ID
 * @param {數據} data - 狀態數據
 * @param {整數} skillSubState - 技能子狀態
 */
function onSetState_priest_thebest7hit(obj, state, data, skillSubState)
{
    if (!obj) return;
    local subState = obj.sq_GetVectorData(data, 0);
    obj.setSkillSubState(subState);
    switch (subState)
    {
        case 0:
            obj.sq_StopMove();
            obj.sq_ZStop();
            obj.sq_SetCurrentAnimation(123);
            obj.sq_SetCurrentAttackInfo(98);
            obj.sq_SetCurrentAttackBonusRate(sq_GetCurrentAttackBonusRate(obj) + obj.sq_GetBonusRateWithPassive(239, 239, 2, 1.0));
            local skillLevel = sq_GetSkillLevel(obj, 239);
            obj.getVar().clear_vector();
            obj.getVar().push_vector(0);
            obj.getVar().push_vector(obj.sq_GetLevelData(239, 0, skillLevel));
            obj.getVar().push_vector(100);
            obj.getVar().push_vector(obj.sq_GetLevelData(239, 1, skillLevel));
            obj.getVar().setBool(0, false);
            sq_SetMyShake(obj, 2, 80);
            break;
        case 1:
            obj.sq_SetCurrentAnimation(124);
            obj.sq_SetCurrentAttackInfo(99);
            obj.sq_SetCurrentAttackBonusRate(sq_GetCurrentAttackBonusRate(obj) + obj.sq_GetBonusRateWithPassive(239, 239, 3, 1.0));
            break;
        case 2:
            obj.sq_SetCurrentAnimation(125);
            obj.sq_SetCurrentAttackInfo(100);
            obj.sq_SetCurrentAttackBonusRate(sq_GetCurrentAttackBonusRate(obj) + obj.sq_GetBonusRateWithPassive(239, 239, 4, 1.0));
            break;
        case 3:
            obj.sq_SetCurrentAnimation(126);
            obj.sq_SetCurrentAttackInfo(101);
            obj.sq_SetCurrentAttackBonusRate(sq_GetCurrentAttackBonusRate(obj) + obj.sq_GetBonusRateWithPassive(239, 239, 5, 1.0));
            break;
        case 4:
            obj.sq_SetCurrentAnimation(127);
            obj.sq_SetCurrentAttackInfo(102);
            obj.sq_SetCurrentAttackBonusRate(sq_GetCurrentAttackBonusRate(obj) + obj.sq_GetBonusRateWithPassive(239, 239, 6, 1.0));
            break;
        case 5:
            obj.sq_SetCurrentAnimation(128);
            obj.sq_SetCurrentAttackInfo(103);
            obj.sq_SetCurrentAttackBonusRate(sq_GetCurrentAttackBonusRate(obj) + obj.sq_GetBonusRateWithPassive(239, 239, 7, 1.0));
            obj.getVar("move").clear_vector();
            obj.getVar("move").push_vector(obj.getZPos());
            obj.getVar("move").push_vector(200);
            if (obj.sq_IsMyControlObject())
                sq_flashScreen(obj, 0, 160, 80, 204, sq_RGB(0, 0, 0), GRAPHICEFFECT_NONE, ENUM_DRAWLAYER_BOTTOM);
            break;
        case 6:
            obj.sq_SetCurrentAnimation(129);
            obj.sq_SetCurrentAttackInfo(104);
            obj.sq_SetCurrentAttackBonusRate(sq_GetCurrentAttackBonusRate(obj) + obj.sq_GetBonusRateWithPassive(239, 239, 8, 1.0));
            obj.getVar("move").clear_vector();
            obj.getVar("move").push_vector(obj.getZPos());
            obj.getVar("move").push_vector(0);
            break;
    }
    local animRate = sq_GetUniformVelocity(obj.getVar().get_vector(2),
        obj.getVar().get_vector(3),
        obj.getVar().get_vector(0),
        obj.getVar().get_vector(1)).tofloat();
    if (subState != 6)
    {
        local textAniFiles = ["atk1text_b.ani", "atk2text_b.ani", "atk3text_b.ani", "atk4text_a.ani", "atk5text_b.ani", "atk6text_b.ani"];
        CreateAniRate(obj, "character/priest/effect/animation/thebest7hit/" + textAniFiles[subState], ENUM_DRAWLAYER_NORMAL, obj.getXPos(), obj.getYPos(), obj.getZPos(), false, animRate);
        local slashAniFiles = ["atk1slash_eff_b.ani", "atk2slash_eff_b.ani", "atk3slash_eff_a.ani", "atk4slash_eff_a.ani", "atk5slash_eff_b.ani", "atk6slash_eff_c.ani"];
        local slashEffect = CreateAniRate(obj, "character/priest/effect/animation/thebest7hit/" + slashAniFiles[subState], ENUM_DRAWLAYER_NORMAL, obj.getXPos(), obj.getYPos(), obj.getZPos(), false, animRate);
        sq_moveWithParent(obj, slashEffect);
    }
};

/**
 * 攻擊命中處理
 * @param {對象} attacker - 攻擊者對象
 * @param {對象} target - 目標對象
 * @param {整數} attackInfo - 攻擊信息
 * @param {布林值} isNotTarget - 是否不是有效目標
 */
function onAttack_priest_thebest7hit(attacker, target, attackInfo, isNotTarget)
{
    if (!attacker) return;
    if (isNotTarget || !target.isObjectType(OBJECTTYPE_ACTIVE)) return;
    local subState = attacker.getSkillSubState();
    switch (subState)
    {
        case 0:
            if (attacker.getVar().getBool(0) == false)
            {
                attacker.getVar().setBool(0, true);
                if (sq_IsGrabable(attacker, target)
                    && sq_IsHoldable(attacker, target)
                    && !sq_IsFixture(target))
                {
                    if (CNSquirrelAppendage.sq_IsAppendAppendage(target, "character/xinghe/priest/thebest7hit/ap_thebest7hit.nut"))
                        CNSquirrelAppendage.sq_RemoveAppendage(target, "character/xinghe/priest/thebest7hit/ap_thebest7hit.nut");
                    local appendage = CNSquirrelAppendage.sq_AppendAppendage(target, attacker, 239, true, "character/xinghe/priest/thebest7hit/ap_thebest7hit.nut", true);
                    sq_HoldAndDelayDie(target, attacker, true, true, false, 0, 0, ENUM_DIRECTION_NEUTRAL, appendage);
                    sq_MoveToAppendageForce(target, attacker, attacker, 160, 0, 0, 100, true, appendage);
                }
            }
            break;
    }

    local crashAnimation = sq_CreateAnimation("", "character/priest/effect/animation/thebest7hit/powerstrikeseven_crasha.ani");
    crashAnimation.addLayerAnimation(-1, sq_CreateAnimation("", "character/priest/effect/animation/thebest7hit/powerstrikeseven_crashb.ani"), true);;
    local crashEffect = sq_CreatePooledObject(crashAnimation, true);
    sq_SetCurrentDirection(crashEffect, attacker.getDirection());
    crashEffect.setCurrentPos(target.getXPos(), target.getYPos(), target.getZPos() + sq_GetCenterZPos(attackInfo));
    crashEffect = sq_SetEnumDrawLayer(crashEffect, ENUM_DRAWLAYER_NORMAL);
    sq_AddObject(attacker, crashEffect, OBJECTTYPE_DRAWONLY, false);
};

/**
 * 關鍵幀標誌處理
 * @param {對象} obj - 技能使用者對象
 * @param {整數} flag - 關鍵幀標誌
 * @return {布林值} 處理結果
 */
function onKeyFrameFlag_priest_thebest7hit(obj, flag)
{
    if (!obj) return false;
    local subState = obj.getSkillSubState();
    switch (subState)
    {
        case 0:
            if (flag == 1 && obj.sq_IsMyControlObject())
            {
                sq_SetMyShake(obj, 8, 560);
                sq_flashScreen(obj, 0, 160, 80, 204, sq_RGB(0, 0, 0), GRAPHICEFFECT_NONE, ENUM_DRAWLAYER_BOTTOM);
            }
            break;
        case 1:
            if (flag == 1 && obj.sq_IsMyControlObject())
            {
                sq_SetMyShake(obj, 5, 320);
                sq_flashScreen(obj, 0, 160, 80, 204, sq_RGB(0, 0, 0), GRAPHICEFFECT_NONE, ENUM_DRAWLAYER_BOTTOM);
            }
            break;
        case 2:
            if (flag == 1 && obj.sq_IsMyControlObject())
            {
                sq_SetMyShake(obj, 7, 240);
                sq_flashScreen(obj, 0, 160, 80, 204, sq_RGB(0, 0, 0), GRAPHICEFFECT_NONE, ENUM_DRAWLAYER_BOTTOM);
            }
            break;
        case 3:
            if (flag == 1 && obj.sq_IsMyControlObject())
            {
                sq_SetMyShake(obj, 5, 240);
                sq_flashScreen(obj, 0, 160, 80, 204, sq_RGB(0, 0, 0), GRAPHICEFFECT_NONE, ENUM_DRAWLAYER_BOTTOM);
            }
            break;
        case 4:
            if (flag == 1 && obj.sq_IsMyControlObject())
                sq_flashScreen(obj, 0, 160, 80, 204, sq_RGB(0, 0, 0), GRAPHICEFFECT_NONE, ENUM_DRAWLAYER_BOTTOM);
            else if (flag == 2)
                sq_SetMyShake(obj, 7, 160);
            else if (flag == 3)
                sq_SetMyShake(obj, 7, 240);
            break;
        case 6:
            if (flag == 1)
            {
                sq_SetMyShake(obj, 7, 320);
                if (obj.sq_IsMyControlObject())
                    sq_flashScreen(obj, 0, 160, 400, 255, sq_RGB(0, 0, 0), GRAPHICEFFECT_NONE, ENUM_DRAWLAYER_BOTTOM);
                sq_CreateDrawOnlyObject(obj, "character/priest/effect/animation/thebest7hit/atk7body_light.ani", ENUM_DRAWLAYER_NORMAL, true);
                sq_CreateDrawOnlyObject(obj, "character/priest/effect/animation/thebest7hit/atk7finish_word_7th.ani", ENUM_DRAWLAYER_NORMAL, true);
            }
            break;
    }
    return true;
};

/**
 * 控制處理
 * @param {對象} obj - 技能使用者對象
 */
function onProcCon_priest_thebest7hit(obj)
{
    if (!obj) return;
    local subState = obj.getSkillSubState();
    if (subState < 6)
    {
        obj.setSkillCommandEnable(239, true);
        sq_SetKeyxEnable(obj, 0, true);
        if (obj.sq_IsEnterSkill(239) != -1 || sq_IsEnterCommand(obj, 0))
        {
            local currentState = obj.getVar().get_vector(0);
            local maxState = obj.getVar().get_vector(1);
            if (currentState < maxState)
            {
                sq_BinaryStartWrite();
                sq_BinaryWriteWord(1);
                sq_BinaryWriteWord(currentState + 1);
                sq_SendChangeSkillEffectPacket(obj, 239);
            }
        }
    }
};

/**
 * 持續處理
 * @param {對象} obj - 技能使用者對象
 */
function onProc_priest_thebest7hit(obj)
{
    if (!obj) return;
    local subState = obj.getSkillSubState();
    switch (subState)
    {
        case 5:
            local currentAnim = obj.getCurrentAnimation();
            local currentTime = sq_GetCurrentTime(currentAnim);
            local totalTime = currentAnim.getDelaySum(0, 1);
            local startZPos = obj.getVar("move").get_vector(0);
            local targetZPos = obj.getVar("move").get_vector(1);
            local newZPos = sq_GetUniformVelocity(0, targetZPos, currentTime, totalTime);
            sq_setCurrentAxisPos(obj, 2, startZPos + newZPos);
            break;
        case 6:
            local currentAnim = obj.getCurrentAnimation();
            local currentTime = sq_GetCurrentTime(currentAnim);
            local totalTime = currentAnim.getDelaySum(0, 0);
            local startZPos = obj.getVar("move").get_vector(0);
            local targetZPos = obj.getVar("move").get_vector(1);
            local newZPos = sq_GetUniformVelocity(startZPos, targetZPos, currentTime, totalTime);
            sq_setCurrentAxisPos(obj, 2, newZPos);
            break;
    }
};

/**
 * 技能效果變化處理
 * @param {對象} obj - 技能使用者對象
 * @param {整數} skillId - 技能ID
 * @param {數據包} dataPacket - 數據包
 */
function onChangeSkillEffect_priest_thebest7hit(obj, skillId, dataPacket)
{
    if (!obj) return;
    local subState = obj.getSkillSubState();
    if (subState != 6)
    {
        local packetType = dataPacket.readWord();
        switch (packetType)
        {
            case 1:
                local newState = dataPacket.readWord();
                local maxState = obj.getVar().get_vector(1);
                local speedRatio = sq_GetUniformVelocity(obj.getVar().get_vector(2), obj.getVar().get_vector(3), newState, maxState) / 100.0;
                obj.sq_SetStaticSpeedInfo(0, 0, SPEED_VALUE_DEFAULT, (SPEED_VALUE_DEFAULT * speedRatio).tointeger(), 1.0, 1.0);
                obj.getVar().set_vector(0, newState);
                break;
        }
    }
};

/**
 * 動畫結束處理
 * @param {對象} obj - 技能使用者對象
 */
function onEndCurrentAni_priest_thebest7hit(obj)
{
    if (!obj) return;
    if (!obj.sq_IsMyControlObject()) return;
    local subState = obj.getSkillSubState();
    if (subState != 6)
    {
        if (obj.getVar().getBool(0) == false && subState == 0)
            obj.sq_AddSetStatePacket(STATE_STAND, STATE_PRIORITY_USER, false);
        else
        {
            obj.sq_IntVectClear();
            obj.sq_IntVectPush(subState + 1);
            obj.sq_AddSetStatePacket(239, STATE_PRIORITY_USER, true);
        }
    }
    else
        obj.sq_AddSetStatePacket(STATE_STAND, STATE_PRIORITY_USER, false);
};

// ---------------------codeEnd---------------------//