// ---------------------codeStart---------------------//

/**
 * 檢查是否可執行技能"命運之矛"
 * @param {對象} skillOwner - 技能擁有者對象
 * @return {布林值} 是否成功執行技能
 */
function checkExecutableSkill_priest_spearofdestiny(skillOwner)
{
    if(!skillOwner) return false;
    local isSkillUsed = skillOwner.sq_IsUseSkill(249);
    if(isSkillUsed)
    {
        skillOwner.sq_AddSetStatePacket(249, STATE_PRIORITY_USER, false);
        return true;
    }
    return false;
};

/**
 * 檢查指令是否可用
 * @param {對象} commandOwner - 指令擁有者對象
 * @return {布林值} 指令是否可用
 */
function checkCommandEnable_priest_spearofdestiny(commandOwner)
{
    if(!commandOwner) return false;
    return true;
};

/**
 * 設置技能狀態處理函數
 * @param {對象} stateOwner - 狀態擁有者對象
 * @param {整數} stateType - 狀態類型
 * @param {整數} param1 - 參數1
 * @param {對象} param2 - 參數2
 */
function onSetState_priest_spearofdestiny(stateOwner, stateType, param1, param2)
{
    if(!stateOwner) return;
    stateOwner.sq_StopMove();
    
    // 根據附加狀態選擇不同動畫
    if(CNSquirrelAppendage.sq_IsAppendAppendage(stateOwner, "character/xinghe/priest/shengqi/jupiter/ap_jupiter.nut") == true)
        stateOwner.sq_SetCurrentAnimation(198);
    else
        stateOwner.sq_SetCurrentAnimation(168);
    
    stateOwner.sq_SetCurrentAttackInfo(114);
    
    // 創建地面效果動畫
    sq_CreateDrawOnlyObject(stateOwner, "character/priest/effect/animation/spearofdestiny/spearofdestiny_cast_flooreff.ani", ENUM_DRAWLAYER_BOTTOM, true);
    
    if(stateOwner.sq_IsMyControlObject())
    {
        // 屏幕閃爍效果
        sq_flashScreen(stateOwner, 120, 60, 360, 153, sq_RGB(0, 0, 0), GRAPHICEFFECT_NONE, ENUM_DRAWLAYER_BOTTOM);
        
        // 發送被動對象創建數據包
        stateOwner.sq_StartWrite();
        stateOwner.sq_WriteDword(249);
        stateOwner.sq_WriteDword(0);
        stateOwner.sq_WriteDword(stateOwner.sq_GetBonusRateWithPassive(249, 249, 0, 1.0));
        stateOwner.sq_WriteDword(stateOwner.sq_GetBonusRateWithPassive(249, 249, 1, 1.0));
        stateOwner.sq_WriteDword(stateOwner.sq_GetBonusRateWithPassive(249, 249, 2, 1.0));
        stateOwner.sq_SendCreatePassiveObjectPacket(24374, 0, 300, 0, 0);
    }
    
    stateOwner.sq_SetStaticSpeedInfo(SPEED_TYPE_ATTACK_SPEED, SPEED_TYPE_ATTACK_SPEED, SPEED_VALUE_DEFAULT, SPEED_VALUE_DEFAULT, 1.0, 1.0);
};

/**
 * 關鍵幀標誌處理函數
 * @param {對象} keyframeOwner - 關鍵幀擁有者對象
 * @param {整數} flagValue - 標誌值
 * @return {布林值} 處理是否成功
 */
function onKeyFrameFlag_priest_spearofdestiny(keyframeOwner, flagValue)
{
    if(!keyframeOwner) return false;
    if(flagValue == 100)
    {
        keyframeOwner.sq_PlaySound("PR_SPEAR_DESTINY");
        sq_CreateDrawOnlyObject(keyframeOwner, "character/priest/effect/animation/spearofdestiny/spearofdestiny_shot_eff05.ani", ENUM_DRAWLAYER_NORMAL, true);
    }
    return true;
};

/**
 * 當前動畫結束處理函數
 * @param {對象} aniOwner - 動畫擁有者對象
 */
function onEndCurrentAni_priest_spearofdestiny(aniOwner)
{
    if(!aniOwner) return;
    if(aniOwner.sq_IsMyControlObject())
        aniOwner.sq_AddSetStatePacket(STATE_STAND, STATE_PRIORITY_USER, false);
};

// ---------------------codeEnd---------------------//