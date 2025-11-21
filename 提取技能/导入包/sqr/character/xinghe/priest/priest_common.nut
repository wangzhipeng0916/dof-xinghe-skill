// 神職者通用函數文件
// 此文件包含了神職者職業的各種通用函數實現

/**
 * 設置神職者技能可取消狀態
 * @param playerObj 玩家對象
 * @param enable 是否啟用取消
 * @return bool 操作是否成功
 */
function setEnableCancelSkill_Priest(playerObj, enable)
{
    // 檢查玩家對象是否存在
    if (!playerObj)
        return false;
        
    // 檢查是否為當前控制的角色
    if (!playerObj.isMyControlObject())
        return false;
        
    // 如果enable為空，直接返回true
    if (!enable)
        return true;
        
    // 設置基本技能命令啟用狀態 (237-251為神職者技能ID範圍)
    playerObj.setSkillCommandEnable(237, enable); 
    playerObj.setSkillCommandEnable(238, enable); 
    playerObj.setSkillCommandEnable(239, enable); 
    playerObj.setSkillCommandEnable(240, enable); 
    
    // 根據當前附加組件狀態設置特定技能啟用狀態
    if (CNSquirrelAppendage.sq_IsAppendAppendage(playerObj, "character/xinghe/priest/appendage/ap_buff_chakraofcalmness.nut") 
        || CNSquirrelAppendage.sq_IsAppendAppendage(playerObj, "character/xinghe/priest/appendage/ap_buff_chakraofpassion.nut")) 
        playerObj.setSkillCommandEnable(241, enable); 
        
    // 如果沒有攜帶武器，設置無武器技能啟用狀態
    if (!playerObj.isCarryWeapon()) 
    {
        playerObj.setSkillCommandEnable(242, enable); 
        playerObj.setSkillCommandEnable(243, enable); 
        playerObj.setSkillCommandEnable(244, enable); 
        playerObj.setSkillCommandEnable(245, enable); 
    }
    
    // 設置其他技能命令啟用狀態
    playerObj.setSkillCommandEnable(246, enable); 
    playerObj.setSkillCommandEnable(247, enable); 
    playerObj.setSkillCommandEnable(248, enable); 
    playerObj.setSkillCommandEnable(249, enable); 
    playerObj.setSkillCommandEnable(250, enable); 
    playerObj.setSkillCommandEnable(251, enable); 
    playerObj.setSkillCommandEnable(132, enable); 
    playerObj.setSkillCommandEnable(135, enable); 
    playerObj.setSkillCommandEnable(136, enable); 
    playerObj.setSkillCommandEnable(137, enable); 
    playerObj.setSkillCommandEnable(138, enable); 
    
    // 如果沒有變身組件，設置變身技能啟用狀態
    if (!CNSquirrelAppendage.sq_IsAppendAppendage(playerObj, "character/xinghe/priest/metamorphosis/ap_metamorphosis.nut")) 
        playerObj.setSkillCommandEnable(139, enable); 
        
    return true;
} 

/**
 * 處理神職者技能效果變化
 * @param playerObj 玩家對象
 * @param skillId 技能ID
 * @param dataStream 數據流
 */
function onChangeSkillEffect_xinghe_Priest(playerObj, skillId, dataStream)
{
    // 檢查玩家對象是否存在
    if (!playerObj) 
        return;
        
    // 根據技能ID處理不同的效果
    switch(skillId)
    {
        case 250: 
            local subState = dataStream.readWord(); 
            switch(subState)
            {
                case 1:
                    // 處理木星守護者附加組件
                    onAppendAppendage_priest_jupiter(playerObj); 
                    break;
            }
            break;
            
        case 47: 
            local subState = dataStream.readWord(); 
            switch(subState)
            {
                case 1: 
                    // 移除平靜脈輪組件（如果存在）
                    if (CNSquirrelAppendage.sq_IsAppendAppendage(playerObj, "character/xinghe/priest/appendage/ap_buff_chakraofcalmness.nut")) 
                        CNSquirrelAppendage.sq_RemoveAppendage(playerObj, "character/xinghe/priest/appendage/ap_buff_chakraofcalmness.nut"); 
                    // 移除激情脈輪組件（如果存在）
                    else if (CNSquirrelAppendage.sq_IsAppendAppendage(playerObj, "character/xinghe/priest/appendage/ap_buff_chakraofpassion.nut")) 
                        CNSquirrelAppendage.sq_RemoveAppendage(playerObj, "character/xinghe/priest/appendage/ap_buff_chakraofpassion.nut"); 
                        
                    // 獲取技能等級數據
                    local skillDuration = playerObj.sq_GetLevelData(skillId, 0, sq_GetSkillLevel(playerObj, skillId)); 
                    // 添加激情脈輪附加組件
                    local passionAppendage = CNSquirrelAppendage.sq_AppendAppendage(playerObj, playerObj, skillId, true, "character/xinghe/priest/appendage/ap_buff_chakraofpassion.nut", false); 
                    passionAppendage.sq_SetValidTime(skillDuration); 
                    CNSquirrelAppendage.sq_Append(passionAppendage, playerObj, playerObj, false);
                    break;
            }
            break;
            
        case 48: 
            local subState = dataStream.readWord(); 
            switch(subState)
            {
                case 1: 
                    // 移除激情脈輪組件（如果存在）
                    if (CNSquirrelAppendage.sq_IsAppendAppendage(playerObj, "character/xinghe/priest/appendage/ap_buff_chakraofpassion.nut")) 
                        CNSquirrelAppendage.sq_RemoveAppendage(playerObj, "character/xinghe/priest/appendage/ap_buff_chakraofpassion.nut"); 
                    // 移除平靜脈輪組件（如果存在）
                    else if (CNSquirrelAppendage.sq_IsAppendAppendage(playerObj, "character/xinghe/priest/appendage/ap_buff_chakraofcalmness.nut")) 
                        CNSquirrelAppendage.sq_RemoveAppendage(playerObj, "character/xinghe/priest/appendage/ap_buff_chakraofcalmness.nut"); 
                        
                    // 獲取技能等級數據
                    local skillDuration = playerObj.sq_GetLevelData(skillId, 0, sq_GetSkillLevel(playerObj, skillId)); 
                    // 添加平靜脈輪附加組件
                    local calmAppendage = CNSquirrelAppendage.sq_AppendAppendage(playerObj, playerObj, skillId, true, "character/xinghe/priest/appendage/ap_buff_chakraofcalmness.nut", false); 
                    calmAppendage.sq_SetValidTime(skillDuration); 
                    CNSquirrelAppendage.sq_Append(calmAppendage, playerObj, playerObj, false);
                    break;
            }
            break;
            
        case 139: 
            local subState = dataStream.readWord(); 
            switch(subState)
            {
                case 1: 
                    // 添加神職者變身附加組件
                    addAppendAppendage_priest_metamorphosis(playerObj); 
                    break;
                case 2: 
                    // 移除神職者變身附加組件
                    if (CNSquirrelAppendage.sq_IsAppendAppendage(playerObj, "character/xinghe/priest/metamorphosis/ap_metamorphosis.nut"))
                        CNSquirrelAppendage.sq_RemoveAppendage(playerObj, "character/xinghe/priest/metamorphosis/ap_metamorphosis.nut");
                    break;
            }
            break;
    }
} 

/**
 * 獲取神職者攻擊取消起始幀大小
 * @param playerObj 玩家對象
 * @return int 攻擊取消起始幀大小
 */
function getAttackCancelStartFrameSize_Priest(playerObj)
{
    local defaultFrameSize = playerObj.sq_GetAttackCancelStartFrameSize();
    // 如果有木星守護者附加組件，則設置固定值
    if (CNSquirrelAppendage.sq_IsAppendAppendage(playerObj, "character/xinghe/priest/jupiter/ap_jupiter.nut") == true)
        defaultFrameSize = 2;
    return defaultFrameSize;
} 

/**
 * 獲取神職者攻擊取消起始幀
 * @param playerObj 玩家對象
 * @param attackType 攻擊類型
 * @return int 攻擊取消起始幀
 */
function getAttackCancelStartFrame_Priest(playerObj, attackType)
{
    // 檢查玩家對象是否存在
    if (!playerObj) 
        return null;
        
    local frameStart = 0;
    // 如果有木星守護者附加組件，根據攻擊類型返回特定幀數
    if (CNSquirrelAppendage.sq_IsAppendAppendage(playerObj, "character/xinghe/priest/jupiter/ap_jupiter.nut") == true)
    {
        switch(attackType)
        {
            case 0:
                frameStart = 7;
                break;
            case 1:
                frameStart = 5;
                break;
        }
    }
    else
        // 否則使用默認方法獲取
        frameStart = playerObj.sq_GetAttackCancelStartFrame(attackType);
        
    return frameStart;
} 

/**
 * 獲取神職者攻擊動畫
 * @param playerObj 玩家對象
 * @param attackIndex 攻擊索引
 * @return 動畫對象
 */
function getAttackAni_Priest(playerObj, attackIndex)
{
    // 檢查玩家對象是否存在
    if (!playerObj) 
        return null;
        
    local attackAnimation = playerObj.sq_GetAttackAni(attackIndex);
    // 如果有木星守護者附加組件，使用自定義動畫
    if (CNSquirrelAppendage.sq_IsAppendAppendage(playerObj, "character/xinghe/priest/jupiter/ap_jupiter.nut") == true)
        attackAnimation = playerObj.sq_GetCustomAni(189 + attackIndex);
        
    return attackAnimation;
} 

/**
 * 獲取神職者默認攻擊信息
 * @param playerObj 玩家對象
 * @param attackIndex 攻擊索引
 * @return 攻擊信息
 */
function getDefaultAttackInfo_Priest(playerObj, attackIndex)
{
    // 檢查玩家對象是否存在
    if (!playerObj) 
        return null;
        
    local attackInfo = playerObj.sq_GetDefaultAttackInfo(attackIndex);
    // 如果有木星守護者附加組件，使用自定義攻擊信息
    if (CNSquirrelAppendage.sq_IsAppendAppendage(playerObj, "character/xinghe/priest/jupiter/ap_jupiter.nut") == true)
        attackInfo = sq_GetCustomAttackInfo(playerObj, 115 + attackIndex);
        
    return attackInfo;
} 

/**
 * 獲取神職者跳躍攻擊動畫
 * @param playerObj 玩家對象
 * @return 動畫對象
 */
function getJumpAttackAni_Priest(playerObj)
{
    // 檢查玩家對象是否存在
    if (!playerObj) 
        return null;
        
    local jumpAttackAnimation = null;
    // 如果有木星守護者附加組件，使用自定義動畫
    if (CNSquirrelAppendage.sq_IsAppendAppendage(playerObj, "character/xinghe/priest/jupiter/ap_jupiter.nut") == true)
    {
        jumpAttackAnimation = sq_GetCustomAni(playerObj, 192);
    }
    else
    {
        // 否則使用默認跳躍攻擊動畫
        jumpAttackAnimation = playerObj.sq_GetJumpAttackAni();
    }
    
    return jumpAttackAnimation;
} 

/**
 * 獲取神職者跳躍攻擊信息
 * @param playerObj 玩家對象
 * @return 攻擊信息
 */
function getJumpAttackInfo_Priest(playerObj)
{
    // 檢查玩家對象是否存在
    if (!playerObj) 
        return null;
        
    local jumpAttackInfo = playerObj.sq_GetJumpAttackInfo();
    // 如果有木星守護者附加組件，使用自定義攻擊信息
    if (CNSquirrelAppendage.sq_IsAppendAppendage(playerObj, "character/xinghe/priest/jupiter/ap_jupiter.nut") == true)
        jumpAttackInfo = sq_GetCustomAttackInfo(playerObj, 118);
        
    return jumpAttackInfo;
} 

/**
 * 獲取神職者衝刺攻擊信息
 * @param playerObj 玩家對象
 * @return 攻擊信息
 */
function getDashAttackInfo_Priest(playerObj)
{
    // 檢查玩家對象是否存在
    if (!playerObj) 
        return null;
        
    local dashAttackInfo = playerObj.sq_GetDashAttackInfo();
    // 如果有木星守護者附加組件，使用自定義攻擊信息
    if (CNSquirrelAppendage.sq_IsAppendAppendage(playerObj, "character/xinghe/priest/jupiter/ap_jupiter.nut") == true)
        dashAttackInfo = sq_GetCustomAttackInfo(playerObj, 119);
        
    return dashAttackInfo;
} 

/**
 * 獲取神職者衝刺攻擊動畫
 * @param playerObj 玩家對象
 * @return 動畫對象
 */
function getDashAttackAni_Priest(playerObj)
{
    // 檢查玩家對象是否存在
    if (!playerObj) 
        return null;
        
    local dashAttackAnimation = null;
    // 如果有木星守護者附加組件，使用自定義動畫
    if (CNSquirrelAppendage.sq_IsAppendAppendage(playerObj, "character/xinghe/priest/jupiter/ap_jupiter.nut") == true)
    {
        dashAttackAnimation = sq_GetCustomAni(playerObj, 193);
    }
    else
    {
        // 否則使用默認衝刺攻擊動畫
        dashAttackAnimation = playerObj.sq_GetDashAttackAni();
    }
    
    return dashAttackAnimation;
} 

/**
 * 獲取神職者站立動畫
 * @param playerObj 玩家對象
 * @return 動畫對象
 */
function getStayAni_Priest(playerObj)
{
    // 檢查玩家對象是否存在
    if (!playerObj) 
        return null;
        
    local stayAnimation = null;
    // 如果有木星守護者附加組件，使用自定義動畫
    if (CNSquirrelAppendage.sq_IsAppendAppendage(playerObj, "character/xinghe/priest/jupiter/ap_jupiter.nut") == true)
    {
        stayAnimation = sq_GetCustomAni(playerObj, 169);
    }
    else
    {
        // 否則使用默認站立動畫
        stayAnimation = playerObj.sq_GetStayAni();
    }
    
    return stayAnimation;
} 

/**
 * 獲取神職者移動動畫
 * @param playerObj 玩家對象
 * @return 動畫對象
 */
function getMoveAni_Priest(playerObj)
{
    // 檢查玩家對象是否存在
    if (!playerObj) 
        return null;
        
    local moveAnimation = null;
    // 如果有木星守護者附加組件，使用自定義動畫
    if (CNSquirrelAppendage.sq_IsAppendAppendage(playerObj, "character/xinghe/priest/jupiter/ap_jupiter.nut") == true)
    {
        moveAnimation = sq_GetCustomAni(playerObj, 170);
    }
    else
    {
        // 否則使用默認移動動畫
        moveAnimation = playerObj.sq_GetMoveAni();
    }
    
    return moveAnimation;
} 

/**
 * 獲取神職者坐下動畫
 * @param playerObj 玩家對象
 * @return 動畫對象
 */
function getSitAni_Priest(playerObj)
{
    // 檢查玩家對象是否存在
    if (!playerObj) 
        return null;
        
    local sitAnimation = null;
    // 如果有木星守護者附加組件，使用自定義動畫
    if (CNSquirrelAppendage.sq_IsAppendAppendage(playerObj, "character/xinghe/priest/jupiter/ap_jupiter.nut") == true)
    {
        sitAnimation = sq_GetCustomAni(playerObj, 171);
    }
    else
    {
        // 否則使用默認坐下動畫
        sitAnimation = playerObj.sq_GetSitAni();
    }
    
    return sitAnimation;
} 

/**
 * 獲取神職者受傷動畫
 * @param playerObj 玩家對象
 * @param damageType 傷害類型
 * @return 動畫對象
 */
function getDamageAni_Priest(playerObj, damageType)
{
    // 檢查玩家對象是否存在
    if (!playerObj) 
        return null;
        
    local damageAnimation = null;
    // 如果有木星守護者附加組件，根據傷害類型使用自定義動畫
    if (CNSquirrelAppendage.sq_IsAppendAppendage(playerObj, "character/xinghe/priest/jupiter/ap_jupiter.nut") == true)
    {
        switch(damageType)
        {
            case 0: 
                damageAnimation = sq_GetCustomAni(playerObj, 172); 
                break;
            case 1: 
                damageAnimation = sq_GetCustomAni(playerObj, 173); 
                break;
        }
    }
    else
    {
        // 否則使用默認受傷動畫
        damageAnimation = playerObj.sq_GetDamageAni(damageType);
    }
    
    return damageAnimation;
} 

/**
 * 獲取神職者倒地動畫
 * @param playerObj 玩家對象
 * @return 動畫對象
 */
function getDownAni_Priest(playerObj)
{
    // 檢查玩家對象是否存在
    if (!playerObj) 
        return null;
        
    local downAnimation = null;
    // 如果有木星守護者附加組件，使用自定義動畫
    if (CNSquirrelAppendage.sq_IsAppendAppendage(playerObj, "character/xinghe/priest/jupiter/ap_jupiter.nut") == true)
    {
        downAnimation = sq_GetCustomAni(playerObj, 174);
    }
    else
    {
        // 否則使用默認倒地動畫
        downAnimation = playerObj.sq_GetDownAni();
    }
    
    return downAnimation;
} 

/**
 * 處理神職者二轉三技能狀態
 * @param obj 玩家對象
 * @param state 狀態
 * @param datas 數據
 */
function priest_SetState_2ndPass3Priest(obj, state, datas)
{
    // 檢查技能等級
    if (sq_GetSkillLevel(obj, 226) < 1) 
        return;
        
    local subState = obj.sq_GetVectorData(datas, 0);
    
    // 根據不同狀態處理相應效果
    if (state == 48 && subState == 1)
    {
        if (obj.isMyControlObject())
        {
            local chakraofcalmness = "character/xinghe/priest/appendage/ap_buff_chakraofcalmness.nut";
            local chakraofpassion = "character/xinghe/priest/appendage/ap_buff_chakraofpassion.nut";
            
            // 平靜脈輪效果處理
            if (CNSquirrelAppendage.sq_IsAppendAppendage(obj, chakraofcalmness))
            {
                local ani = obj.getCurrentAnimation();
                local delay = ani.getDelaySum(false);
                obj.sq_SetStaticSpeedInfo(SPEED_TYPE_ATTACK_SPEED, SPEED_TYPE_ATTACK_SPEED,
                    SPEED_VALUE_DEFAULT, SPEED_VALUE_DEFAULT, 1.0, 1.0);
                local ndelay = ani.getDelaySum(false);
                local speed = delay.tofloat() / ndelay.tofloat();
                locakonhit(obj, "character/priest/effect/animation/chakraofgod/light/galesmash_smashg.ani", 0, 0, 0, 0, 100, 0, 1, speed, 0);
            }
            // 激情脈輪效果處理
            else if (CNSquirrelAppendage.sq_IsAppendAppendage(obj, chakraofpassion))
            {
                local ani = obj.getCurrentAnimation();
                local delay = ani.getDelaySum(false);
                obj.sq_SetStaticSpeedInfo(SPEED_TYPE_ATTACK_SPEED, SPEED_TYPE_ATTACK_SPEED,
                    SPEED_VALUE_DEFAULT, SPEED_VALUE_DEFAULT, 1.0, 1.0);
                local ndelay = ani.getDelaySum(false);
                local speed = delay.tofloat() / ndelay.tofloat();
                locakonhit(obj, "character/priest/effect/animation/chakraofgod/fire/galesmash_smashg.ani", 0, 0, 0, 0, 100, 0, 1, speed, 0);
            }
        }
    }
    else if (state == 23 && subState == 1)
    {
        if (obj.isMyControlObject())
        {
            local chakraofcalmness = "character/xinghe/priest/appendage/ap_buff_chakraofcalmness.nut";
            local chakraofpassion = "character/xinghe/priest/appendage/ap_buff_chakraofpassion.nut";
            
            // 平靜脈輪效果處理
            if (CNSquirrelAppendage.sq_IsAppendAppendage(obj, chakraofcalmness))
            {
                local ani = obj.getCurrentAnimation();
                local delay = ani.getDelaySum(false);
                obj.sq_SetStaticSpeedInfo(SPEED_TYPE_ATTACK_SPEED, SPEED_TYPE_ATTACK_SPEED,
                    SPEED_VALUE_DEFAULT, SPEED_VALUE_DEFAULT, 1.0, 1.0);
                local ndelay = ani.getDelaySum(false);
                local speed = delay.tofloat() / ndelay.tofloat();
                locakonhit(obj, "character/priest/effect/animation/chakraofgod/light/giantswing_weaponloopi.ani", 0, 0, 0, 0, 100, 1, 1, speed, 0);
            }
            // 激情脈輪效果處理
            else if (CNSquirrelAppendage.sq_IsAppendAppendage(obj, chakraofpassion))
            {
                local ani = obj.getCurrentAnimation();
                local delay = ani.getDelaySum(false);
                obj.sq_SetStaticSpeedInfo(SPEED_TYPE_ATTACK_SPEED, SPEED_TYPE_ATTACK_SPEED,
                    SPEED_VALUE_DEFAULT, SPEED_VALUE_DEFAULT, 1.0, 1.0);
                local ndelay = ani.getDelaySum(false);
                local speed = delay.tofloat() / ndelay.tofloat();
                locakonhit(obj, "character/priest/effect/animation/chakraofgod/fire/giantswing_weaponloopi.ani", 0, 0, 0, 0, 100, 1, 1, speed, 0);
            }
        }
    }
    else if (state == 24 && subState == 0)
    {
        if (obj.isMyControlObject())
        {
            local chakraofcalmness = "character/xinghe/priest/appendage/ap_buff_chakraofcalmness.nut";
            local chakraofpassion = "character/xinghe/priest/appendage/ap_buff_chakraofpassion.nut";
            
            // 平靜脈輪效果處理
            if (CNSquirrelAppendage.sq_IsAppendAppendage(obj, chakraofcalmness))
            {
                local ani = obj.getCurrentAnimation();
                local delay = ani.getDelaySum(false);
                obj.sq_SetStaticSpeedInfo(SPEED_TYPE_ATTACK_SPEED, SPEED_TYPE_ATTACK_SPEED,
                    SPEED_VALUE_DEFAULT, SPEED_VALUE_DEFAULT, 1.0, 1.0);
                local ndelay = ani.getDelaySum(false);
                local speed = delay.tofloat() / ndelay.tofloat();
                locakonhit(obj, "character/priest/effect/animation/chakraofgod/light/repeatedsmash_swingrepeat.ani", 0, 0, 0, 0, 100, 0, 1, speed, 0);
            }
            // 激情脈輪效果處理
            else if (CNSquirrelAppendage.sq_IsAppendAppendage(obj, chakraofpassion))
            {
                local ani = obj.getCurrentAnimation();
                local delay = ani.getDelaySum(false);
                obj.sq_SetStaticSpeedInfo(SPEED_TYPE_ATTACK_SPEED, SPEED_TYPE_ATTACK_SPEED,
                    SPEED_VALUE_DEFAULT, SPEED_VALUE_DEFAULT, 1.0, 1.0);
                local ndelay = ani.getDelaySum(false);
                local speed = delay.tofloat() / ndelay.tofloat();
                locakonhit(obj, "character/priest/effect/animation/chakraofgod/fire/repeatedsmash_swingrepeat.ani", 0, 0, 0, 0, 100, 0, 1, speed, 0);
            }
        }
    }
    else if (state == 8 && subState == 0)
    {
        if (obj.isMyControlObject())
        {
            local chakraofcalmness = "character/xinghe/priest/appendage/ap_buff_chakraofcalmness.nut";
            local chakraofpassion = "character/xinghe/priest/appendage/ap_buff_chakraofpassion.nut";
            
            // 平靜脈輪效果處理
            if (CNSquirrelAppendage.sq_IsAppendAppendage(obj, chakraofcalmness))
            {
                local ani = obj.getCurrentAnimation();
                local delay = ani.getDelaySum(false);
                obj.sq_SetStaticSpeedInfo(SPEED_TYPE_ATTACK_SPEED, SPEED_TYPE_ATTACK_SPEED,
                    SPEED_VALUE_DEFAULT, SPEED_VALUE_DEFAULT, 1.0, 1.0);
                local ndelay = ani.getDelaySum(false);
                local speed = delay.tofloat() / ndelay.tofloat();
                locakonhit(obj, "character/priest/effect/animation/chakraofgod/light/exorcistattack1_attack.ani", 0, 0, 0, 0, 100, 0, 1, speed, 0);
            }
            // 激情脈輪效果處理
            else if (CNSquirrelAppendage.sq_IsAppendAppendage(obj, chakraofpassion))
            {
                local ani = obj.getCurrentAnimation();
                local delay = ani.getDelaySum(false);
                obj.sq_SetStaticSpeedInfo(SPEED_TYPE_ATTACK_SPEED, SPEED_TYPE_ATTACK_SPEED,
                    SPEED_VALUE_DEFAULT, SPEED_VALUE_DEFAULT, 1.0, 1.0);
                local ndelay = ani.getDelaySum(false);
                local speed = delay.tofloat() / ndelay.tofloat();
                locakonhit(obj, "character/priest/effect/animation/chakraofgod/fire/exorcistattack1_attack.ani", 0, 0, 0, 0, 100, 0, 1, speed, 0);
            }
        }
    }
    else if (state == 8 && subState == 1)
    {
        if (obj.isMyControlObject())
        {
            local chakraofcalmness = "character/xinghe/priest/appendage/ap_buff_chakraofcalmness.nut";
            local chakraofpassion = "character/xinghe/priest/appendage/ap_buff_chakraofpassion.nut";
            
            // 平靜脈輪效果處理
            if (CNSquirrelAppendage.sq_IsAppendAppendage(obj, chakraofcalmness))
            {
                local ani = obj.getCurrentAnimation();
                local delay = ani.getDelaySum(false);
                obj.sq_SetStaticSpeedInfo(SPEED_TYPE_ATTACK_SPEED, SPEED_TYPE_ATTACK_SPEED,
                    SPEED_VALUE_DEFAULT, SPEED_VALUE_DEFAULT, 1.0, 1.0);
                local ndelay = ani.getDelaySum(false);
                local speed = delay.tofloat() / ndelay.tofloat();
                locakonhit(obj, "character/priest/effect/animation/chakraofgod/light/exorcistattack2_attack2.ani", 0, 0, 0, 0, 100, 0, 1, speed, 0);
            }
            // 激情脈輪效果處理
            else if (CNSquirrelAppendage.sq_IsAppendAppendage(obj, chakraofpassion))
            {
                local ani = obj.getCurrentAnimation();
                local delay = ani.getDelaySum(false);
                obj.sq_SetStaticSpeedInfo(SPEED_TYPE_ATTACK_SPEED, SPEED_TYPE_ATTACK_SPEED,
                    SPEED_VALUE_DEFAULT, SPEED_VALUE_DEFAULT, 1.0, 1.0);
                local ndelay = ani.getDelaySum(false);
                local speed = delay.tofloat() / ndelay.tofloat();
                locakonhit(obj, "character/priest/effect/animation/chakraofgod/fire/exorcistattack2_attack2.ani", 0, 0, 0, 0, 100, 0, 1, speed, 0);
            }
        }
    }
    else if (state == 58)
    {
        if (obj.isMyControlObject())
        {
            local chakraofcalmness = "character/xinghe/priest/appendage/ap_buff_chakraofcalmness.nut";
            local chakraofpassion = "character/xinghe/priest/appendage/ap_buff_chakraofpassion.nut";
            
            // 平靜脈輪效果處理
            if (CNSquirrelAppendage.sq_IsAppendAppendage(obj, chakraofcalmness))
            {
                local ani = obj.getCurrentAnimation();
                local delay = ani.getDelaySum(false);
                obj.sq_SetStaticSpeedInfo(SPEED_TYPE_ATTACK_SPEED, SPEED_TYPE_ATTACK_SPEED,
                    SPEED_VALUE_DEFAULT, SPEED_VALUE_DEFAULT, 1.0, 1.0);
                local ndelay = ani.getDelaySum(false);
                local speed = delay.tofloat() / ndelay.tofloat();
                locakonhit(obj, "character/priest/effect/animation/chakraofgod/light/groundcrashsmash_smashf1.ani", 0, 0, 0, 0, 100, 0, 1, speed, 0);
            }
            // 激情脈輪效果處理
            else if (CNSquirrelAppendage.sq_IsAppendAppendage(obj, chakraofpassion))
            {
                local ani = obj.getCurrentAnimation();
                local delay = ani.getDelaySum(false);
                obj.sq_SetStaticSpeedInfo(SPEED_TYPE_ATTACK_SPEED, SPEED_TYPE_ATTACK_SPEED,
                    SPEED_VALUE_DEFAULT, SPEED_VALUE_DEFAULT, 1.0, 1.0);
                local ndelay = ani.getDelaySum(false);
                local speed = delay.tofloat() / ndelay.tofloat();
                locakonhit(obj, "character/priest/effect/animation/chakraofgod/fire/groundcrashsmash_smashf1.ani", 0, 0, 0, 0, 100, 0, 1, speed, 0);
            }
        }
    }
    else if (state == 49)
    {
        if (obj.isMyControlObject())
        {
            local chakraofcalmness = "character/xinghe/priest/appendage/ap_buff_chakraofcalmness.nut";
            local chakraofpassion = "character/xinghe/priest/appendage/ap_buff_chakraofpassion.nut";
            
            // 平靜脈輪效果處理
            if (CNSquirrelAppendage.sq_IsAppendAppendage(obj, chakraofcalmness))
            {
                local ani = obj.getCurrentAnimation();
                local delay = ani.getDelaySum(false);
                obj.sq_SetStaticSpeedInfo(SPEED_TYPE_ATTACK_SPEED, SPEED_TYPE_ATTACK_SPEED,
                    SPEED_VALUE_DEFAULT, SPEED_VALUE_DEFAULT, 1.0, 1.0);
                local ndelay = ani.getDelaySum(false);
                local speed = delay.tofloat() / ndelay.tofloat();
                locakonhit(obj, "character/priest/effect/animation/chakraofgod/light/atomicsmash_effecth2.ani", 0, 0, 0, 0, 100, 0, 1, speed, 0);
            }
            // 激情脈輪效果處理
            else if (CNSquirrelAppendage.sq_IsAppendAppendage(obj, chakraofpassion))
            {
                local ani = obj.getCurrentAnimation();
                local delay = ani.getDelaySum(false);
                obj.sq_SetStaticSpeedInfo(SPEED_TYPE_ATTACK_SPEED, SPEED_TYPE_ATTACK_SPEED,
                    SPEED_VALUE_DEFAULT, SPEED_VALUE_DEFAULT, 1.0, 1.0);
                local ndelay = ani.getDelaySum(false);
                local speed = delay.tofloat() / ndelay.tofloat();
                locakonhit(obj, "character/priest/effect/animation/chakraofgod/fire/atomicsmash_effecth2.ani", 0, 0, 0, 0, 100, 0, 1, speed, 0);
            }
        }
    }
    else if (state == 35 && subState == 2)
    {
        if (obj.isMyControlObject())
        {
            local chakraofcalmness = "character/xinghe/priest/appendage/ap_buff_chakraofcalmness.nut";
            local chakraofpassion = "character/xinghe/priest/appendage/ap_buff_chakraofpassion.nut";
            
            // 平靜脈輪效果處理
            if (CNSquirrelAppendage.sq_IsAppendAppendage(obj, chakraofcalmness))
            {
                local ani = obj.getCurrentAnimation();
                local delay = ani.getDelaySum(false);
                obj.sq_SetStaticSpeedInfo(SPEED_TYPE_ATTACK_SPEED, SPEED_TYPE_ATTACK_SPEED,
                    SPEED_VALUE_DEFAULT, SPEED_VALUE_DEFAULT, 1.0, 1.0);
                local ndelay = ani.getDelaySum(false);
                local speed = delay.tofloat() / ndelay.tofloat();
                locakonhit(obj, "character/priest/effect/animation/chakraofgod/light/giantswing_homerun.ani", 0, 0, 0, 0, 100, 0, 1, speed, 0);
            }
            // 激情脈輪效果處理
            else if (CNSquirrelAppendage.sq_IsAppendAppendage(obj, chakraofpassion))
            {
                local ani = obj.getCurrentAnimation();
                local delay = ani.getDelaySum(false);
                obj.sq_SetStaticSpeedInfo(SPEED_TYPE_ATTACK_SPEED, SPEED_TYPE_ATTACK_SPEED,
                    SPEED_VALUE_DEFAULT, SPEED_VALUE_DEFAULT, 1.0, 1.0);
                local ndelay = ani.getDelaySum(false);
                local speed = delay.tofloat() / ndelay.tofloat();
                locakonhit(obj, "character/priest/effect/animation/chakraofgod/fire/giantswing_homerun.ani", 0, 0, 0, 0, 100, 0, 1, speed, 0);
            }
        }
    }
    else if (state == 38 && subState == 3)
    {
        local chakraofcalmness = "character/xinghe/priest/appendage/ap_buff_chakraofcalmness.nut";
        local chakraofpassion = "character/xinghe/priest/appendage/ap_buff_chakraofpassion.nut";
        
        // 平靜脈輪效果處理
        if (CNSquirrelAppendage.sq_IsAppendAppendage(obj, chakraofcalmness))
        {
            local ani = obj.getCurrentAnimation();
            local delay = ani.getDelaySum(false);
            obj.sq_SetStaticSpeedInfo(SPEED_TYPE_ATTACK_SPEED, SPEED_TYPE_ATTACK_SPEED,
                SPEED_VALUE_DEFAULT, SPEED_VALUE_DEFAULT, 1.0, 1.0);
            local ndelay = ani.getDelaySum(false);
            local speed = delay.tofloat() / ndelay.tofloat();
            locakonhit(obj, "character/priest/effect/animation/chakraofgod/light/throwweapon_chargethrowh2.ani", 0, 0, 0, 0, 100, 0, 1, speed, 0);
        }
        // 激情脈輪效果處理
        else if (CNSquirrelAppendage.sq_IsAppendAppendage(obj, chakraofpassion))
        {
            local ani = obj.getCurrentAnimation();
            local delay = ani.getDelaySum(false);
            obj.sq_SetStaticSpeedInfo(SPEED_TYPE_ATTACK_SPEED, SPEED_TYPE_ATTACK_SPEED,
                SPEED_VALUE_DEFAULT, SPEED_VALUE_DEFAULT, 1.0, 1.0);
            local ndelay = ani.getDelaySum(false);
            local speed = delay.tofloat() / ndelay.tofloat();
            locakonhit(obj, "character/priest/effect/animation/chakraofgod/fire/throwweapon_chargethrowh2.ani", 0, 0, 0, 0, 100, 0, 1, speed, 0);
        }
    }
    else if (state == 23 && subState == 2)
    {
        if (obj.isMyControlObject())
        {
            local chakraofcalmness = "character/xinghe/priest/appendage/ap_buff_chakraofcalmness.nut";
            local chakraofpassion = "character/xinghe/priest/appendage/ap_buff_chakraofpassion.nut";
            
            // 平靜脈輪效果處理
            if (CNSquirrelAppendage.sq_IsAppendAppendage(obj, chakraofcalmness))
            {
                local ani = obj.getCurrentAnimation();
                local delay = ani.getDelaySum(false);
                obj.sq_SetStaticSpeedInfo(SPEED_TYPE_ATTACK_SPEED, SPEED_TYPE_ATTACK_SPEED,
                    SPEED_VALUE_DEFAULT, SPEED_VALUE_DEFAULT, 1.0, 1.0);
                local ndelay = ani.getDelaySum(false);
                local speed = delay.tofloat() / ndelay.tofloat();
                locakonhit(obj, "character/priest/effect/animation/chakraofgod/light/giantswing_weaponfinali.ani", 0, 0, 0, 0, 100, 0, 1, speed, 0);
            }
            // 激情脈輪效果處理
            else if (CNSquirrelAppendage.sq_IsAppendAppendage(obj, chakraofpassion))
            {
                local ani = obj.getCurrentAnimation();
                local delay = ani.getDelaySum(false);
                obj.sq_SetStaticSpeedInfo(SPEED_TYPE_ATTACK_SPEED, SPEED_TYPE_ATTACK_SPEED,
                    SPEED_VALUE_DEFAULT, SPEED_VALUE_DEFAULT, 1.0, 1.0);
                local ndelay = ani.getDelaySum(false);
                local speed = delay.tofloat() / ndelay.tofloat();
                locakonhit(obj, "character/priest/effect/animation/chakraofgod/fire/giantswing_weaponfinali.ani", 0, 0, 0, 0, 100, 0, 1, speed, 0);
            }
        }
    }
}

/**
 * 獲取神職者翻滾動畫
 * @param playerObj 玩家對象
 * @return 動畫對象
 */
function getOverturnAni_Priest(playerObj)
{
    // 檢查玩家對象是否存在
    if (!playerObj) 
        return null;
        
    local overturnAnimation = null;
    // 如果有木星守護者附加組件，使用自定義動畫
    if (CNSquirrelAppendage.sq_IsAppendAppendage(playerObj, "character/xinghe/priest/jupiter/ap_jupiter.nut") == true)
    {
        overturnAnimation = sq_GetCustomAni(playerObj, 175);
    }
    else
    {
        // 否則使用默認翻滾動畫
        overturnAnimation = playerObj.sq_GetOverturnAni();
    }
    
    return overturnAnimation;
} 

/**
 * 獲取神職者跳躍動畫
 * @param playerObj 玩家對象
 * @return 動畫對象
 */
function getJumpAni_Priest(playerObj)
{
    // 檢查玩家對象是否存在
    if (!playerObj) 
        return null;
        
    local jumpAnimation = null;
    // 如果有木星守護者附加組件，使用自定義動畫
    if (CNSquirrelAppendage.sq_IsAppendAppendage(playerObj, "character/xinghe/priest/jupiter/ap_jupiter.nut") == true)
    {
        jumpAnimation = sq_GetCustomAni(playerObj, 176);
    }
    else
    {
        // 否則使用默認跳躍動畫
        jumpAnimation = playerObj.sq_GetJumpAni();
    }
    
    return jumpAnimation;
} 

/**
 * 獲取神職者休息動畫
 * @param playerObj 玩家對象
 * @return 動畫對象
 */
function getRestAni_Priest(playerObj)
{
    // 檢查玩家對象是否存在
    if (!playerObj) 
        return null;
        
    local restAnimation = null;
    // 如果有木星守護者附加組件，使用自定義動畫
    if (CNSquirrelAppendage.sq_IsAppendAppendage(playerObj, "character/xinghe/priest/jupiter/ap_jupiter.nut") == true)
    {
        restAnimation = sq_GetCustomAni(playerObj, 177);
    }
    else
    {
        // 否則使用默認休息動畫
        restAnimation = playerObj.sq_GetRestAni();
    }
    
    return restAnimation;
} 

/**
 * 獲取神職者投擲蓄力動畫
 * @param playerObj 玩家對象
 * @param chargeType 蓄力類型
 * @return 動畫對象
 */
function getThrowChargeAni_Priest(playerObj, chargeType)
{
    // 檢查玩家對象是否存在
    if (!playerObj) 
        return null;
        
    local throwChargeAnimation = null;
    // 如果有木星守護者附加組件，根據蓄力類型使用自定義動畫
    if (CNSquirrelAppendage.sq_IsAppendAppendage(playerObj, "character/xinghe/priest/jupiter/ap_jupiter.nut") == true)
    {
        switch(chargeType)
        {
            case 0: 
                throwChargeAnimation = sq_GetCustomAni(playerObj, 178); 
                break;
            case 1: 
                throwChargeAnimation = sq_GetCustomAni(playerObj, 179); 
                break;
            case 2: 
                throwChargeAnimation = sq_GetCustomAni(playerObj, 180); 
                break;
            case 3: 
                throwChargeAnimation = sq_GetCustomAni(playerObj, 181); 
                break;
        }
    }
    else
    {
        // 否則使用默認投擲蓄力動畫
        throwChargeAnimation = playerObj.sq_GetThrowChargeAni(chargeType);
    }
    
    return throwChargeAnimation;
} 

/**
 * 獲取神職者投擲射擊動畫
 * @param playerObj 玩家對象
 * @param shootType 射擊類型
 * @return 動畫對象
 */
function getThrowShootAni_Priest(playerObj, shootType)
{
    // 檢查玩家對象是否存在
    if (!playerObj) 
        return null;
        
    local throwShootAnimation = null;
    // 如果有木星守護者附加組件，根據射擊類型使用自定義動畫
    if (CNSquirrelAppendage.sq_IsAppendAppendage(playerObj, "character/xinghe/priest/jupiter/ap_jupiter.nut") == true)
    {
        switch(shootType)
        {
            case 0: 
                throwShootAnimation = sq_GetCustomAni(playerObj, 182); 
                break;
            case 1: 
                throwShootAnimation = sq_GetCustomAni(playerObj, 183); 
                break;
            case 2: 
                throwShootAnimation = sq_GetCustomAni(playerObj, 184); 
                break;
            case 3: 
                throwShootAnimation = sq_GetCustomAni(playerObj, 185); 
                break;
        }
    }
    else
    {
        // 否則使用默認投擲射擊動畫
        throwShootAnimation = playerObj.sq_GetThrowShootAni(shootType);
    }
    
    return throwShootAnimation;
} 

/**
 * 獲取神職者衝刺動畫
 * @param playerObj 玩家對象
 * @return 動畫對象
 */
function getDashAni_Priest(playerObj)
{
    // 檢查玩家對象是否存在
    if (!playerObj) 
        return null;
        
    local dashAnimation = null;
    // 如果有木星守護者附加組件，使用自定義動畫
    if (CNSquirrelAppendage.sq_IsAppendAppendage(playerObj, "character/xinghe/priest/jupiter/ap_jupiter.nut") == true)
    {
        dashAnimation = sq_GetCustomAni(playerObj, 186);
    }
    else
    {
        // 否則使用默認衝刺動畫
        dashAnimation = playerObj.sq_GetDashAni();
    }
    
    return dashAnimation;
} 

/**
 * 獲取神職者拾取物品動畫
 * @param playerObj 玩家對象
 * @return 動畫對象
 */
function getGetItemAni_Priest(playerObj)
{
    // 檢查玩家對象是否存在
    if (!playerObj) 
        return null;
        
    local getItemAnimation = null;
    // 如果有木星守護者附加組件，使用自定義動畫
    if (CNSquirrelAppendage.sq_IsAppendAppendage(playerObj, "character/xinghe/priest/jupiter/ap_jupiter.nut") == true)
    {
        getItemAnimation = sq_GetCustomAni(playerObj, 187);
    }
    else
    {
        // 否則使用默認拾取物品動畫
        getItemAnimation = playerObj.sq_GetGetItemAni();
    }
    
    return getItemAnimation;
} 

/**
 * 獲取神職者增益動畫
 * @param playerObj 玩家對象
 * @return 動畫對象
 */
function getBuffAni_Priest(playerObj)
{
    // 檢查玩家對象是否存在
    if (!playerObj) 
        return null;
        
    local buffAnimation = null;
    // 如果有木星守護者附加組件，使用自定義動畫
    if (CNSquirrelAppendage.sq_IsAppendAppendage(playerObj, "character/xinghe/priest/jupiter/ap_jupiter.nut") == true)
    {
        buffAnimation = sq_GetCustomAni(playerObj, 188);
    }
    else
    {
        // 否則使用默認增益動畫
        buffAnimation = playerObj.sq_GetBuffAni();
    }
    
    return buffAnimation;
} 

/**
 * 設置神職者狀態
 * @param obj 玩家對象
 * @param state 狀態
 * @param datas 數據
 * @param isResetTimer 是否重置計時器
 */
function setState_Priest(obj, state, datas, isResetTimer)
{
    // 處理神職者二轉三技能狀態
    priest_SetState_2ndPass3Priest(obj, state, datas);
    // 處理範圍增益狀態設置
    useRangeBuff_setState(obj, state, datas);
    // 處理龍之獵手激光狀態設置
    setState_dragonslayerlaser(obj, state, datas, isResetTimer);
    // 處理全職業成長技能狀態設置
    setState_AllGrowJob(obj, state, datas, isResetTimer);
    return;
}

/**
 * 啟示錄技能處理
 * @param obj 玩家對象
 */
function Apocalypse(obj)
{
    // 檢查玩家對象是否存在
    if (!obj) 
        return;
        
    local skill = sq_GetSkill(obj, 222);
    // 檢查技能是否未被封印
    if (!skill.isSealFunction())
    {
        local skillLevel = sq_GetSkillLevel(obj, 222);
        // 檢查技能等級
        if (skillLevel <= 0) 
            return;
            
        local xPos = obj.getXPos();
        local yPos = obj.getYPos();
        local objectCount = obj.getMyPassiveObjectCount(24029);
        
        // 遍歷所有被動對象並設置位置
        for(local i = 0; i < objectCount; ++i)
        {
            local passiveObject = obj.getMyPassiveObject(24029, i);
            if (!passiveObject) 
                continue;
                
            local zPos = passiveObject.getZPos();
            passiveObject.setCurrentPos(xPos, yPos, zPos);
            passiveObject.setMapFollowType(1);
            passiveObject.setMapFollowParent(obj);
        }
    }
}

/**
 * 雷霆護符處理
 * @param obj 玩家對象
 */
function thunderbolttalisman(obj)
{
    // 檢查玩家對象是否存在
    if (!obj) 
        return;
        
    local skill = sq_GetSkill(obj, 226);
    // 檢查技能是否未被封印
    if (!skill.isSealFunction())
    {
        local skillLevel = sq_GetSkillLevel(obj, 226);
        // 檢查技能等級
        if (skillLevel <= 0) 
            return;
            
        local xPos = obj.getXPos();
        local yPos = obj.getYPos();
        local objectCount = obj.getMyPassiveObjectCount(24011);
        
        // 遍歷所有被動對象並設置位置
        for(local i = 0; i < objectCount; ++i)
        {
            local passiveObject = obj.getMyPassiveObject(24011, i);
            if (!passiveObject) 
                continue;
                
            local zPos = passiveObject.getZPos();
            passiveObject.setCurrentPos(xPos, yPos, zPos);
            passiveObject.setMapFollowType(1);
            passiveObject.setMapFollowParent(obj);
        }
    }
}

/**
 * 壓制護符處理
 * @param obj 玩家對象
 */
function oppressiontalisman(obj)
{
    // 檢查玩家對象是否存在
    if (!obj) 
        return;
        
    local skill = sq_GetSkill(obj, 226);
    // 檢查技能是否未被封印
    if (!skill.isSealFunction())
    {
        local skillLevel = sq_GetSkillLevel(obj, 226);
        // 檢查技能等級
        if (skillLevel <= 0) 
            return;
            
        local xPos = obj.getXPos();
        local yPos = obj.getYPos();
        local objectCount = obj.getMyPassiveObjectCount(24010);
        
        // 遍歷所有被動對象並設置位置
        for(local i = 0; i < objectCount; ++i)
        {
            local passiveObject = obj.getMyPassiveObject(24010, i);
            if (!passiveObject) 
                continue;
                
            local zPos = passiveObject.getZPos();
            passiveObject.setCurrentPos(xPos, yPos, zPos);
            passiveObject.setMapFollowType(1);
            passiveObject.setMapFollowParent(obj);
        }
    }
}

/**
 * 處理神職者技能
 * @param obj 玩家對象
 */
function procSkill_Priest(obj)
{
    procSkill_Priest_qumo1(obj); // 處理驅魔第一部分
    procSkill_Priest_qumo2(obj); // 處理驅魔第二部分
    procSkill_Priest_qumo3(obj); // 處理驅魔第三部分
}

/**
 * 處理神職者驅魔技能第一部分
 * @param obj 玩家對象
 */
function procSkill_Priest_qumo1(obj)
{
    // 檢查是否為成長型職業
    if (sq_getGrowType(obj) == 3)
    {
        local skillLevel = sq_GetSkillLevel(obj, SKILL_CHAKRAOFGOD);
        // 檢查技能等級
        if (skillLevel > 0)
        {
            local objectCount = obj.getMyPassiveObjectCount(26060);
            // 遍歷所有被動對象並設置大小比率
            for(local i = 0; i < objectCount; ++i)
            {
                local passiveObject = obj.getMyPassiveObject(26060, i);
                if (!passiveObject) 
                    continue;
                    
                local sizeRate = 100 + 100;
                sizeRate = sizeRate.tofloat() / 100.0;
                local animation = passiveObject.getCurrentAnimation();
                
                // 設置動畫大小比率
                animation.setImageRateFromOriginal(sizeRate, sizeRate);
                animation.setAutoLayerWorkAnimationAddSizeRate(sizeRate);
                
                // 如果尚未設置角色站立標誌，則設置攻擊邊界框大小比率
                if (!passiveObject.getVar("isSetCharacterStand").getBool(0))
                {
                    passiveObject.getVar("isSetCharacterStand").setBool(0, true);
                    sq_SetAttackBoundingBoxSizeRate(animation, sizeRate, sizeRate, sizeRate);
                }
            }
        }
    }
}

/**
 * 處理神職者驅魔技能第二部分
 * @param obj 玩家對象
 */
function procSkill_Priest_qumo2(obj)
{
    // 檢查是否為成長型職業
    if (sq_getGrowType(obj) == 3)
    {
        local skillLevel = sq_GetSkillLevel(obj, SKILL_CHAKRAOFGOD);
        // 檢查技能等級
        if (skillLevel > 0)
        {
            local objectCount = obj.getMyPassiveObjectCount(26061);
            // 遍歷所有被動對象並設置大小比率
            for(local i = 0; i < objectCount; ++i)
            {
                local passiveObject = obj.getMyPassiveObject(26061, i);
                if (!passiveObject) 
                    continue;
                    
                local sizeRate = 100 + 100;
                sizeRate = sizeRate.tofloat() / 100.0;
                local animation = passiveObject.getCurrentAnimation();
                
                // 設置動畫大小比率
                animation.setImageRateFromOriginal(sizeRate, sizeRate);
                animation.setAutoLayerWorkAnimationAddSizeRate(sizeRate);
                
                // 如果尚未設置角色站立標誌，則設置攻擊邊界框大小比率
                if (!passiveObject.getVar("isSetCharacterStand").getBool(0))
                {
                    passiveObject.getVar("isSetCharacterStand").setBool(0, true);
                    sq_SetAttackBoundingBoxSizeRate(animation, sizeRate, sizeRate, sizeRate);
                }
            }
        }
    }
}

/**
 * 處理神職者驅魔技能第三部分
 * @param obj 玩家對象
 */
function procSkill_Priest_qumo3(obj)
{
    // 檢查是否為成長型職業
    if (sq_getGrowType(obj) == 3)
    {
        local skillLevel = sq_GetSkillLevel(obj, 50);
        // 檢查技能等級
        if (skillLevel > 0)
        {
            local objectCount = obj.getMyPassiveObjectCount(24014);
            // 遍歷所有被動對象並設置大小比率
            for(local i = 0; i < objectCount; ++i)
            {
                local passiveObject = obj.getMyPassiveObject(24014, i);
                if (!passiveObject) 
                    continue;
                    
                local range = obj.sq_GetIntData(50, 5);
                local sizeRate = range;
                sizeRate = sizeRate.tofloat() / 100.0;
                local animation = passiveObject.getCurrentAnimation();
                
                // 設置動畫大小比率
                animation.setImageRateFromOriginal(sizeRate, sizeRate);
                animation.setAutoLayerWorkAnimationAddSizeRate(sizeRate);
                
                // 如果尚未設置角色站立標誌，則設置攻擊邊界框大小比率
                if (!passiveObject.getVar("isSetCharacterStand").getBool(0))
                {
                    passiveObject.getVar("isSetCharacterStand").setBool(0, true);
                    sq_SetAttackBoundingBoxSizeRate(animation, sizeRate, sizeRate, sizeRate);
                }
            }
        }
    }
}