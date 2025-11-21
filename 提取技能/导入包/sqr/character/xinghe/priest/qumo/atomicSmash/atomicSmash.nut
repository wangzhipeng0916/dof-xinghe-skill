// ---------------------codeStart---------------------// 

/**
 * 原子粉碎技能進入幀處理函數
 * @param {對象} obj - 技能施放者對象
 * @param {整數} state - 當前狀態值
 */
function onEnterFrame_AtomicSmash(obj, state)
{
    if (!obj || !obj.isMyControlObject() || sq_GetSkillLevel(obj, 226) < 1) return;
    
    if (state == 15)
    {
        local buffCalmnessPath = "character/xinghe/priest/qumo/appendage/ap_buff_chakraofcalmness.nut";
        local buffPassionPath = "character/xinghe/priest/qumo/appendage/ap_buff_chakraofpassion.nut";
        local skillLevel = obj.sq_GetLevelData(226, 0, sq_GetSkillLevel(obj, 226)) / 100.0;
        
        if (CNSquirrelAppendage.sq_IsAppendAppendage(obj, buffCalmnessPath))
        {
            local animation = obj.getCurrentAnimation();
            local originalDelay = animation.getDelaySum(false);
            obj.sq_SetStaticSpeedInfo(SPEED_TYPE_ATTACK_SPEED, SPEED_TYPE_ATTACK_SPEED,
                SPEED_VALUE_DEFAULT, SPEED_VALUE_DEFAULT, 1.0, 1.0);
            local newDelay = animation.getDelaySum(false);
            local speedRatio = originalDelay.tofloat() / newDelay.tofloat();
            locakonhit(obj, "character/priest/effect/animation/chakraofgod/light/atomicsmash_effectfinalc.ani", 
                0, 0, 0, 0, 100, 0, 1, speedRatio, 0);
        }
        else if (CNSquirrelAppendage.sq_IsAppendAppendage(obj, buffPassionPath))
        {
            local animation = obj.getCurrentAnimation();
            local originalDelay = animation.getDelaySum(false);
            obj.sq_SetStaticSpeedInfo(SPEED_TYPE_ATTACK_SPEED, SPEED_TYPE_ATTACK_SPEED,
                SPEED_VALUE_DEFAULT, SPEED_VALUE_DEFAULT, 1.0, 1.0);
            local newDelay = animation.getDelaySum(false);
            local speedRatio = originalDelay.tofloat() / newDelay.tofloat();
            locakonhit(obj, "character/priest/effect/animation/chakraofgod/fire/atomicsmash_effectfinalc.ani", 
                0, 0, 0, 0, 100, 0, 1, speedRatio, 0);
        }
    }
}


/**
 * 牧師增益效果動畫結束處理函數
 * @param {對象} obj - 增益效果對象
 */
function onEndCurrentAni_priest_buff(obj)
{
    if (!obj) return;
    if (!obj.sq_IsMyControlObject()) return;
    
    local buffSkillIndex = obj.getBuffSkillIndex();
    switch (buffSkillIndex)
    {
        case 47: // 增益技能47
        case 48: // 增益技能48
            sq_BinaryStartWrite();
            sq_BinaryWriteWord(1);
            sq_SendChangeSkillEffectPacket(obj, buffSkillIndex);
            break;
    }
}

// ---------------------codeEnd---------------------//