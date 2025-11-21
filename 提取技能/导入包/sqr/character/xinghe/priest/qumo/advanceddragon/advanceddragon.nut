// ---------------------codeStart---------------------//

/**
 * 檢查是否可以執行真龍焚天技能
 * @param {對象} playerObject - 玩家對象
 * @return {布林值} 是否可以執行技能
 */
function checkExecutableSkill_priest_advanceddragon(playerObject)
{
    if (!playerObject) return false;
    if (!CNSquirrelAppendage.sq_IsAppendAppendage(playerObject, "character/xinghe/priest/qumo/appendage/ap_buff_chakraofcalmness.nut")
        && !CNSquirrelAppendage.sq_IsAppendAppendage(playerObject, "character/xinghe/priest/qumo/appendage/ap_buff_chakraofpassion.nut"))
        return false;
    
    local isSkillUsed = playerObject.sq_IsUseSkill(241);
    if (isSkillUsed)
    {
        playerObject.sq_IntVectClear();
        if (CNSquirrelAppendage.sq_IsAppendAppendage(playerObject, "character/xinghe/priest/qumo/appendage/ap_buff_chakraofcalmness.nut"))
            playerObject.sq_IntVectPush(0);
        else
            playerObject.sq_IntVectPush(1);
        playerObject.sq_AddSetStatePacket(241, STATE_PRIORITY_USER, true);
        return true;
    }
    return false;
}

/**
 * 檢查技能命令是否可用
 * @param {對象} playerObject - 玩家對象
 * @return {布林值} 技能命令是否可用
 */
function checkCommandEnable_priest_advanceddragon(playerObject)
{
    if (!playerObject) return false;
    if (!CNSquirrelAppendage.sq_IsAppendAppendage(playerObject, "character/xinghe/priest/qumo/appendage/ap_buff_chakraofcalmness.nut")
        && !CNSquirrelAppendage.sq_IsAppendAppendage(playerObject, "character/xinghe/priest/qumo/appendage/ap_buff_chakraofpassion.nut"))
        return false;
    
    local currentState = playerObject.sq_GetState();
    if (currentState == STATE_STAND)
        return true;
    if (currentState == STATE_ATTACK)
    {
        return playerObject.sq_IsCommandEnable(241);
    }
    return true;
}

/**
 * 設置技能狀態
 * @param {對象} playerObject - 玩家對象
 * @param {對象} stateData - 狀態數據
 * @param {對象} skillData - 技能數據
 * @param {對象} customData - 自定義數據
 */
function onSetState_priest_advanceddragon(playerObject, stateData, skillData, customData)
{
    if (!playerObject) return;
    
    playerObject.sq_StopMove();
    local subState = playerObject.sq_GetVectorData(skillData, 0);
    playerObject.setSkillSubState(subState);
    playerObject.sq_PlaySound("PR_ADVANCED_DRAGON");
    
    switch (subState)
    {
        case 0:
            playerObject.sq_SetCurrentAnimation(133);
            playerObject.sq_SetStaticSpeedInfo(SPEED_TYPE_ATTACK_SPEED, SPEED_TYPE_ATTACK_SPEED, SPEED_VALUE_DEFAULT, SPEED_VALUE_DEFAULT, 1.0, 1.0);
            break;
            
        case 1:
            playerObject.sq_SetCurrentAnimation(134);
            local currentAnim = playerObject.getCurrentAnimation();
            local originalDelay = currentAnim.getDelaySum(false);
            playerObject.sq_SetStaticSpeedInfo(SPEED_TYPE_ATTACK_SPEED, SPEED_TYPE_ATTACK_SPEED, SPEED_VALUE_DEFAULT, SPEED_VALUE_DEFAULT, 1.0, 1.0);
            
            local newDelay = currentAnim.getDelaySum(false);
            local animRate = originalDelay.tofloat() / newDelay.tofloat() * 100.0;
            playerObject.getVar().setFloat(0, animRate);
            
            local posX = playerObject.getXPos();
            local posY = playerObject.getYPos();
            local posZ = playerObject.getZPos();
            
            CreateAniRate(playerObject, "character/priest/effect/animation/advanceddragon_passion/magiccircle/magiccircle_light1.ani", ENUM_DRAWLAYER_BOTTOM, posX, posY, posZ, false, animRate);
            CreateAniRate(playerObject, "passiveobject/script_sqr_nut_qq506807329/priest/animation/advanceddragon/advanceddragon_passion/front/attack_dust_front_normal.ani", ENUM_DRAWLAYER_NORMAL, posX, posY, posZ, false, animRate);
            
            if (playerObject.sq_IsMyControlObject())
            {
                playerObject.sq_StartWrite();
                playerObject.sq_WriteDword(241);
                playerObject.sq_WriteDword(2);
                playerObject.sq_WriteFloat(animRate);
                playerObject.sq_WriteDword(playerObject.sq_GetBonusRateWithPassive(241, 241, 5, 1.0));
                playerObject.sq_SendCreatePassiveObjectPacket(24374, 0, 0, -1, 0);
            }
            break;
    }
}

/**
 * 處理關鍵幀標誌
 * @param {對象} playerObject - 玩家對象
 * @param {整數} flagValue - 標誌值
 * @return {布林值} 處理是否成功
 */
function onKeyFrameFlag_priest_advanceddragon(playerObject, flagValue)
{
    if (!playerObject) return false;
    
    local subState = playerObject.getSkillSubState();
    if (subState == 1)
    {
        if (flagValue == 1)
        {
            CreateAniRate(playerObject, "character/priest/effect/animation/advanceddragon_passion/dust/attack_dusta7.ani", ENUM_DRAWLAYER_NORMAL, playerObject.getXPos(), playerObject.getYPos(), playerObject.getZPos(), false, playerObject.getVar().getFloat(0));
        }
    }
    return true;
}

/**
 * 當前動畫結束時處理
 * @param {對象} playerObject - 玩家對象
 */
function onEndCurrentAni_priest_advanceddragon(playerObject)
{
    if (!playerObject) return;
    if (!playerObject.sq_IsMyControlObject()) return;
    
    local subState = playerObject.getSkillSubState();
    if (subState == 0)
    {
        local skillLevel = sq_GetSkillLevel(playerObject, 241);
        playerObject.sq_StartWrite();
        playerObject.sq_WriteDword(241);
        playerObject.sq_WriteDword(1);
        playerObject.sq_WriteDword(playerObject.sq_GetLevelData(241, 0, skillLevel));
        playerObject.sq_WriteDword(playerObject.sq_GetLevelData(241, 1, skillLevel));
        playerObject.sq_WriteDword(playerObject.sq_GetLevelData(241, 2, skillLevel));
        playerObject.sq_WriteDword(playerObject.sq_GetBonusRateWithPassive(241, 241, 3, 1.0));
        playerObject.sq_WriteDword(playerObject.sq_GetBonusRateWithPassive(241, 241, 4, 1.0));
        playerObject.sq_SendCreatePassiveObjectPacket(24374, 0, 200, 0, 0);
    }
    playerObject.sq_AddSetStatePacket(STATE_STAND, STATE_PRIORITY_USER, false);
}

// ---------------------codeEnd---------------------//