// ---------------------codeStart---------------------//

/**
 * 檢查是否可以執行奇蹟分裂者技能
 * @param {對象} skillUser - 技能使用者對象
 * @return {布林值} 是否可執行技能
 */
function checkExecutableSkill_priest_miraclespliter(skillUser)
{
    if (!skillUser) return false;
    
    local isSkillActive = skillUser.sq_IsUseSkill(247);
    if (isSkillActive)
    {
        skillUser.sq_IntVectClear();
        skillUser.sq_IntVectPush(0);
        skillUser.sq_AddSetStatePacket(247, STATE_PRIORITY_USER, true);
        return true;
    }
    
    return false;
};

/**
 * 檢查技能命令是否可用
 * @param {對象} skillUser - 技能使用者對象
 * @return {布林值} 命令是否可用
 */
function checkCommandEnable_priest_miraclespliter(skillUser)
{
    if (!skillUser) return false;
    return true;
};

/**
 * 設置技能狀態處理函數
 * @param {對象} skillUser - 技能使用者對象
 * @param {對象} stateData - 狀態數據對象
 * @param {對象} skillData - 技能數據對象
 * @param {對象} customData - 自定義數據對象
 */
function onSetState_priest_miraclespliter(skillUser, stateData, skillData, customData)
{
    if (!skillUser) return;
    
    skillUser.sq_StopMove();
    local subState = skillUser.sq_GetVectorData(skillData, 0);
    skillUser.setSkillSubState(subState);
    
    switch (subState)
    {
        case 0:
            if (CNSquirrelAppendage.sq_IsAppendAppendage(skillUser, "character/xinghe/priest/jupiter/ap_jupiter.nut") == true)
                skillUser.sq_SetCurrentAnimation(164);
            else
                skillUser.sq_SetCurrentAnimation(162);
            
            skillUser.sq_SetCurrentAttackInfo(112);
            skillUser.sq_SetCurrentAttackBonusRate(skillUser.sq_GetBonusRateWithPassive(247, 247, 0, 1.0));
            skillUser.getVar().clear_vector();
            skillUser.getVar().push_vector(skillUser.getXPos());
            skillUser.getVar().clear_obj_vector();
            break;
            
        case 1:
            if (CNSquirrelAppendage.sq_IsAppendAppendage(skillUser, "character/xinghe/priest/jupiter/ap_jupiter.nut") == true)
                skillUser.sq_SetCurrentAnimation(165);
            else
                skillUser.sq_SetCurrentAnimation(163);
            
            skillUser.sq_SetCurrentAttackInfo(113);
            skillUser.sq_SetCurrentAttackBonusRate(skillUser.sq_GetBonusRateWithPassive(247, 247, 1, 1.0));
            skillUser.sq_PlaySound("PR_MIRACLE_SPLITER");
            break;
    }
    
    skillUser.sq_SetStaticSpeedInfo(SPEED_TYPE_ATTACK_SPEED, SPEED_TYPE_ATTACK_SPEED, SPEED_VALUE_DEFAULT, SPEED_VALUE_DEFAULT, 1.0, 1.0);
};

/**
 * 技能處理過程函數
 * @param {對象} skillUser - 技能使用者對象
 */
function onProc_priest_miraclespliter(skillUser)
{
    if (!skillUser) return;
    
    local subState = skillUser.getSkillSubState();
    if (subState == 0 && skillUser.getVar().size_vector() > 0)
    {
        local currentAnim = skillUser.getCurrentAnimation();
        local currentTime = sq_GetCurrentTime(currentAnim);
        local totalTime = currentAnim.getDelaySum(false);
        local targetXPos = sq_GetDistancePos(skillUser.getVar().get_vector(0),
                                            skillUser.getDirection(),
                                            sq_GetAccel(0, 240, currentTime, totalTime, true));
        
        if (skillUser.isMovablePos(targetXPos, skillUser.getYPos()))
            sq_setCurrentAxisPos(skillUser, 0, targetXPos);
        else
            skillUser.getVar().clear_vector();
    }
};

/**
 * 關鍵幀標誌處理函數
 * @param {對象} skillUser - 技能使用者對象
 * @param {整數} flagValue - 標誌值
 * @return {布林值} 處理結果
 */
function onKeyFrameFlag_priest_miraclespliter(skillUser, flagValue)
{
    if (!skillUser) return;
    
    local subState = skillUser.getSkillSubState();
    if (subState == 0)
    {
        switch (flagValue)
        {
            case 1:
                sq_AddDrawOnlyAniFromParent(skillUser, "character/priest/effect/animation/miraclespliter/msdashstonea_eff_03.ani", -20, 30, 0);
                break;
            case 2:
                sq_AddDrawOnlyAniFromParent(skillUser, "character/priest/effect/animation/miraclespliter/msdashstoneb_eff_03.ani", 0, 35, 0);
                break;
            case 3:
                sq_AddDrawOnlyAniFromParent(skillUser, "character/priest/effect/animation/miraclespliter/msdashstonea_eff_03.ani", -4, 5, 0);
                break;
        }
        
        switch (flagValue)
        {
            case 1:
            case 2:
            case 3:
                skillUser.resetHitObjectList();
                sq_AddDrawOnlyAniFromParent(skillUser, "character/priest/effect/animation/miraclespliter/msdash_nndasheff.ani", 0, 0, 0);
                break;
        }
    }
    else if (subState == 1)
    {
        if (flagValue == 1)
        {
            sq_SetMyShake(skillUser, 5, 240);
            if (skillUser.sq_IsMyControlObject())
                sq_flashScreen(skillUser, 0, 0, 240, 204, sq_RGB(255, 255, 255), GRAPHICEFFECT_NONE, ENUM_DRAWLAYER_BOTTOM);
        }
    }
    
    return true;
};

/**
 * 攻擊處理函數
 * @param {對象} attacker - 攻擊者對象
 * @param {對象} target - 目標對象
 * @param {對象} attackInfo - 攻擊信息對象
 * @param {布林值} isCounterAttack - 是否為反擊
 */
function onAttack_priest_miraclespliter(attacker, target, attackInfo, isCounterAttack)
{
    if (!attacker) return;
    if (isCounterAttack || !target.isObjectType(OBJECTTYPE_ACTIVE)) return;
    
    local subState = attacker.getSkillSubState();
    if (subState == 0)
    {
        if (sq_IsGrabable(attacker, target)
            && sq_IsHoldable(attacker, target)
            && !sq_IsFixture(target))
        {
            if (!attacker.getVar().is_obj_vector(target))
            {
                attacker.getVar().push_obj_vector(target);
                
                if (CNSquirrelAppendage.sq_IsAppendAppendage(target, "character/xinghe/priest/miraclespliter/ap_miraclespliter.nut"))
                    CNSquirrelAppendage.sq_RemoveAppendage(target, "character/xinghe/priest/miraclespliter/ap_miraclespliter.nut");
                
                CNSquirrelAppendage.sq_AppendAppendage(target, attacker, 247, true, "character/xinghe/priest/miraclespliter/ap_miraclespliter.nut", true);
            }
        }
    }
};

/**
 * 當前動畫結束處理函數
 * @param {對象} skillUser - 技能使用者對象
 */
function onEndCurrentAni_priest_miraclespliter(skillUser)
{
    if (!skillUser) return;
    if (!skillUser.sq_IsMyControlObject()) return;
    
    local subState = skillUser.getSkillSubState();
    if (subState != 1)
    {
        skillUser.sq_IntVectClear();
        skillUser.sq_IntVectPush(subState + 1);
        skillUser.sq_AddSetStatePacket(247, STATE_PRIORITY_USER, true);
    }
    else
    {
        skillUser.sq_AddSetStatePacket(STATE_STAND, STATE_PRIORITY_USER, false);
    }
};

// ---------------------codeEnd---------------------//