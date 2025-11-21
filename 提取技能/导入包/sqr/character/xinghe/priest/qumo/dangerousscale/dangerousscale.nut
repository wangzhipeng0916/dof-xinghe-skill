// ---------------------codeStart---------------------// 

/**
 * 檢查是否可以執行危險鱗片技能
 * @param {對象} skillUser - 技能使用者
 * @return {布林值} 是否可執行技能
 */
function checkExecutableSkill_priest_dangerousscale(skillUser)
{
    if(!skillUser) return false;
    
    local isSkillActive = skillUser.sq_IsUseSkill(240);
    if(isSkillActive)
    {
        skillUser.sq_IsEnterSkillLastKeyUnits(240);
        skillUser.sq_IntVectClear();
        skillUser.sq_IntVectPush(0);
        skillUser.sq_AddSetStatePacket(240, STATE_PRIORITY_USER, true);
        return true;
    }
    return false;
};

/**
 * 檢查技能指令是否可用
 * @param {對象} obj - 技能對象
 * @return {布林值} 指令是否可用
 */
function checkCommandEnable_priest_dangerousscale(obj)
{
    if(!obj) return false;
    return true;
};

/**
 * 設置技能狀態
 * @param {對象} caster - 施法者
 * @param {整數} state - 狀態編號
 * @param {數組} dataArray - 數據數組
 * @param {對象} customData - 自定義數據
 */
function onSetState_priest_dangerousscale(caster, state, dataArray, customData)
{
    if(!caster) return;
    
    caster.sq_StopMove();
    caster.sq_ZStop();
    
    local subState = caster.sq_GetVectorData(dataArray, 0);
    caster.setSkillSubState(subState);
    
    switch(subState)
    {
        case 0:
            caster.sq_SetCurrentAnimation(130);
            local skillLevel = sq_GetSkillLevel(caster, 66);
            caster.getVar("move").clear_vector();
            caster.getVar().clear_vector();
            caster.getVar().push_vector(180);
            caster.getVar().push_vector(100);
            
            if(skillLevel > 0)
            {
                caster.getVar().push_vector(caster.sq_GetLevelData(240, 1, skillLevel));
                caster.getVar().push_vector(caster.sq_GetLevelData(240, 2, skillLevel) + caster.sq_GetLevelData(240, 4, skillLevel) * skillLevel);
                caster.getVar().push_vector(caster.sq_GetLevelData(240, 3, skillLevel) + caster.sq_GetLevelData(240, 5, skillLevel) * skillLevel);
                caster.getVar().setBool(0, true);
            }
            else
            {
                caster.getVar().setBool(0, false);
            }
            caster.getVar().setBool(1, false);
            break;
            
        case 1:
            caster.sq_SetCurrentAnimation(131);
            local timerValue = caster.sq_GetVectorData(dataArray, 1);
            if(timerValue != -1)
            {
                local totalTime = caster.getVar().get_vector(2);
                caster.getVar().set_vector(0, sq_GetUniformVelocity(caster.getVar().get_vector(0), caster.getVar().get_vector(3), timerValue, totalTime));
                caster.getVar().set_vector(1, sq_GetUniformVelocity(caster.getVar().get_vector(1), caster.getVar().get_vector(4), timerValue, totalTime));
            }
            break;
            
        case 2:
            caster.sq_SetCurrentAnimation(132);
            caster.sq_AddStateLayerAnimation(1, caster.sq_CreateCNRDAnimation("effect/animation/dangerousscale/dangerousscale03_01.ani"), 0, 0);
            
            if(caster.sq_IsMyControlObject())
            {
                sq_SetMyShake(caster, 15, 200);
                sq_flashScreen(caster, 0, 150, 150, 204, sq_RGB(0, 0, 0), GRAPHICEFFECT_NONE, ENUM_DRAWLAYER_BOTTOM);
                caster.sq_StartWrite();
                caster.sq_WriteDword(240);
                caster.sq_WriteDword(caster.getVar().get_vector(1));
                caster.sq_WriteDword(caster.sq_GetBonusRateWithPassive(240, 240, 0, 1.0));
                caster.sq_SendCreatePassiveObjectPacket(24374, 0, 100, 0, 0);
            }
            break;
    }
    
    caster.sq_SetStaticSpeedInfo(SPEED_TYPE_ATTACK_SPEED, SPEED_TYPE_ATTACK_SPEED, SPEED_VALUE_DEFAULT, SPEED_VALUE_DEFAULT, 1.0, 1.0);
};

/**
 * 處理關鍵幀標誌
 * @param {對象} caster - 施法者
 * @param {整數} flag - 標誌值
 * @return {布林值} 處理結果
 */
function onKeyFrameFlag_priest_dangerousscale(caster, flag)
{
    if(!caster) return false;
    
    local subState = caster.getSkillSubState();
    
    switch(subState)
    {
        case 0:
            if(flag == 1)
            {
                if(caster.getVar().getBool(0) == true)
                {
                    caster.sq_AddStateLayerAnimation(1, caster.sq_CreateCNRDAnimation("effect/animation/dangerousscale/dangerousscale01_casting.ani"), -150, -90);
                    caster.sq_AddStateLayerAnimation(1, caster.sq_CreateCNRDAnimation("effect/animation/dangerousscale/dangerousscalecasting_00.ani"), -150, -90);
                    caster.sq_PlaySound("LIGH_GET_01", 9401);
                    caster.getVar().push_vector(caster.sq_GetStateTimer());
                }
            }
            break;
            
        case 1:
            switch(flag)
            {
                case 1:
                    caster.getVar("move").clear_vector();
                    caster.getVar("move").push_vector(caster.getZPos());
                    caster.getVar("move").push_vector(0);
                    caster.getVar("move").push_vector(0);
                    caster.getVar("move").push_vector(1);
                    caster.getVar("move").push_vector(4);
                    
                    sq_AddDrawOnlyAniFromParent(caster, "character/priest/effect/animation/dangerousscale/dangerousscale02dust_front.ani", 0, 0, 0);
                    sq_AddDrawOnlyAniFromParent(caster, "character/priest/effect/animation/dangerousscale/dangerousscale02dust_back.ani", 0, -1, 0);
                    break;
                    
                case 2:
                    caster.getVar("move").clear_vector();
                    caster.getVar("move").push_vector(caster.getZPos());
                    caster.getVar("move").push_vector(0);
                    caster.getVar("move").push_vector(6);
                    caster.getVar("move").push_vector(7);
                    caster.getVar("move").push_vector(7);
                    caster.getVar().set_vector(0, 0);
                    break;
            }
            break;
    }
    return true;
};

/**
 * 技能結束狀態處理
 * @param {對象} caster - 施法者
 * @param {整數} state - 狀態編號
 */
function onEndState_priest_dangerousscale(caster, state)
{
    if(!caster) return;
    caster.stopSound(9401);
};

/**
 * 技能處理過程
 * @param {對象} caster - 施法者
 */
function onProc_priest_dangerousscale(caster)
{
    if(!caster) return;
    
    local subState = caster.getSkillSubState();
    
    switch(subState)
    {
        case 0:
            if(caster.getVar().size_vector() != 6) return;
            
            if(caster.sq_IsMyControlObject())
            {
                if(!caster.isDownSkillLastKey())
                {
                    caster.sq_IntVectClear();
                    caster.sq_IntVectPush(subState + 1);
                    caster.sq_IntVectPush(caster.sq_GetStateTimer() - caster.getVar().get_vector(5));
                    caster.sq_AddSetStatePacket(240, STATE_PRIORITY_USER, true);
                }
            }
            
            if(caster.getVar().getBool(0) == true && caster.getVar().getBool(1) == false)
            {
                local elapsedTime = caster.sq_GetStateTimer() - caster.getVar().get_vector(5);
                local maxTime = caster.getVar().get_vector(2);
                
                if(elapsedTime >= maxTime)
                {
                    sq_AddDrawOnlyAniFromParent(caster, "character/priest/effect/animation/dangerousscale/castingend_02.ani", -150, 0, 90);
                    caster.stopSound(9401);
                    caster.sq_PlaySound("LIGH_GET_02");
                    caster.getVar().setBool(1, true);
                }
            }
            break;
    }
    
    if(caster.getVar("move").size_vector() > 0)
    {
        local moveData = caster.getVar("move");
        local currentAnim = caster.getCurrentAnimation();
        local elapsedFrameTime = sq_GetCurrentTime(currentAnim) - currentAnim.getDelaySum(moveData.get_vector(1), moveData.get_vector(2));
        local totalFrameTime = currentAnim.getDelaySum(moveData.get_vector(3), moveData.get_vector(4));
        local newZPos = sq_GetAccel(moveData.get_vector(0), caster.getVar().get_vector(0), elapsedFrameTime, totalFrameTime, true);
        sq_setCurrentAxisPos(caster, 2, newZPos);
    }
};

/**
 * 當前動畫結束處理
 * @param {對象} caster - 施法者
 */
function onEndCurrentAni_priest_dangerousscale(caster)
{
    if(!caster) return;
    if(!caster.sq_IsMyControlObject()) return;
    
    local subState = caster.getSkillSubState();
    
    if(subState != 2)
    {
        if(caster.getVar().getBool(0) == false)
        {
            caster.sq_IntVectClear();
            caster.sq_IntVectPush(subState + 1);
            caster.sq_AddSetStatePacket(240, STATE_PRIORITY_USER, true);
        }
        else if(subState != 0)
        {
            caster.sq_IntVectClear();
            caster.sq_IntVectPush(subState + 1);
            caster.sq_AddSetStatePacket(240, STATE_PRIORITY_USER, true);
        }
    }
    else
    {
        caster.sq_AddSetStatePacket(STATE_STAND, STATE_PRIORITY_USER, false);
    }
};

// ---------------------codeEnd---------------------//