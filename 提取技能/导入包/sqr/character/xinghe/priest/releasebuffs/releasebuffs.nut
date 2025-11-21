// ---------------------codeStart---------------------// 

/**
 * 檢查是否可執行釋放增益技能
 * @param {對象} obj - 技能執行對象
 * @return {布林值} 是否可執行技能
 */
function checkExecutableSkill_ReleaseBuffs(obj)
{
    if(!obj) return false;
    local isUse = obj.sq_IsUseSkill(222);
    if(isUse)
    {
        initUseBuffSkills(obj);
        return true;
    }
    return false;
}

/**
 * 檢查指令是否可用於釋放增益技能
 * @param {對象} obj - 技能執行對象
 * @return {布林值} 指令是否可用
 */
function checkCommandEnable_ReleaseBuffs(obj)
{
    if(!obj) return false;
    return true;
}

/**
 * 初始化使用的增益技能列表
 * @param {對象} obj - 技能執行對象
 */
function initUseBuffSkills(obj)
{
    obj.getVar("releaseBuffSkills").setBool(0,true);
    obj.getVar("releaseBuffSkills").clear_vector();
    obj.getVar("releaseBuffSkills").push_vector(0);
    obj.getVar("passBuffSkills").setBool(0,false);
    obj.getVar("realBuffSkills").clear_vector();
    
    local skillArray = [7, 51, 52, 53, 23, 19, 20, 55, 22, 45, 21];
    for(local i = 0; i < skillArray.len(); ++i)
    {
        local skillIndex = skillArray[i];
        local skillLevel = sq_GetSkillLevel(obj, skillIndex);
        if(skillLevel <= 0) continue;
        
        local skill = sq_GetSkill(obj, skillIndex);
        local isCool = skill.isInCoolTime();
        if(isCool) continue;
        
        obj.getVar("realBuffSkills").push_vector(skillIndex);
    }
}

/**
 * 使用增益技能
 * @param {對象} obj - 技能執行對象
 */
function useBuffSkills(obj)
{
    local size = obj.getVar("realBuffSkills").size_vector();
    if(!size) return;
    
    local interval = 50;
    local castTime1 = interval / 2;
    local castTime2 = interval / 2;

    if(obj.getVar("releaseBuffSkills").getBool(0))
    {
        if(!IsInterval(obj, interval)) return;
        
        local index = obj.getVar("releaseBuffSkills").get_vector(0);
        if(index >= size)
        {
            obj.getVar("releaseBuffSkills").setBool(0, false);
            obj.setEnableChangeState(true);
            return;
        }
        
        local skillIndex = obj.getVar("realBuffSkills").get_vector(index);
        local isUse = obj.sq_IsUseSkill(skillIndex);
        
        if(!isUse && !obj.getVar("passBuffSkills").getBool(0))
        {
            obj.getVar("releaseBuffSkills").set_vector(0, index + 1);
        }
        else
        {
            local aniIndex = 2;
            if(skillIndex == 45)
                aniIndex = 3;
                
            obj.sq_IntVectClear();
            obj.sq_IntVectPush(0);    // 參數1
            obj.sq_IntVectPush(0);    // 參數2
            obj.sq_IntVectPush(skillIndex);    // 技能索引
            obj.sq_IntVectPush(castTime1);    // 施法時間1
            obj.sq_IntVectPush(castTime2);    // 施法時間2
            obj.sq_IntVectPush(aniIndex);    // 動畫索引
            obj.sq_IntVectPush(4);    // 參數7
            obj.sq_IntVectPush(4);    // 參數8
            obj.sq_IntVectPush(1000);    // 參數9
            obj.sq_IntVectPush(1000);    // 參數10
            obj.sq_IntVectPush(450);    // 參數11
            
            obj.sq_AddSetStatePacket(13, STATE_PRIORITY_IGNORE_FORCE, true);
            obj.getVar("releaseBuffSkills").set_vector(0, index + 1);
            obj.getVar("passBuffSkills").setBool(0, false);
        }
    }
}

// ---------------------codeEnd---------------------//