// ---------------------codeStart---------------------//

/**
 * 當前動畫結束時觸發的處理函數
 * @param {object} passiveObject - 被動物件實例
 */
function onEndCurrentAni_po_qq506807329new_priest_24374(passiveObject)
{
    if (!passiveObject) return;
    
    local skillId = passiveObject.getVar("skill").get_vector(0);
    
    // 根據技能ID進行不同處理
    handleSkillAnimationEndById(passiveObject, skillId);
}

function handleSkillAnimationEndById(passiveObject, skillId)
{
    switch (skillId)
    {
    case 237: handleSkill237AnimationEnd(passiveObject); break; // 毀滅神像相關技能
    case 238: handleSkill238AnimationEnd(passiveObject); break; // 聖潔五角星相關技能
    case 240: // 危險刻印相關技能
    case 226: handleSkill226AnimationEnd(passiveObject); break; // 破壞氣功波相關技能
    case 241: handleSkill241AnimationEnd(passiveObject); break; // 龍之怒相關技能
    case 242: handleSkill242AnimationEnd(passiveObject); break; // 核爆拳相關技能
    case 243: handleSkill243AnimationEnd(passiveObject); break; // 爆裂拳相關技能
    case 245: handleSkill245AnimationEnd(passiveObject); break; // 天譴之怒相關技能
    case 248: handleSkill248AnimationEnd(passiveObject); break; // 神聖庇護所相關技能
    case 249: handleSkill249AnimationEnd(passiveObject); break; // 命運之矛相關技能
    case 250: handleSkill250AnimationEnd(passiveObject); break; // 木星錘相關技能
    case 251: handleSkill251AnimationEnd(passiveObject); break; // 神罰相關技能
    case 246: handleSkill246AnimationEnd(passiveObject); break; // 洗禮相關技能
    case 135: handleSkill135AnimationEnd(passiveObject); break; // 惡魔之拳相關技能
    case 136: handleSkill136AnimationEnd(passiveObject); break; // 黑暗嚎叫相關技能
    case 137: handleSkill137AnimationEnd(passiveObject); break; // 毀滅壓制相關技能
    case 139: handleSkill139AnimationEnd(passiveObject); break; // 變身相關技能
    case 132: handleSkill132AnimationEnd(passiveObject); break; // 惡魔邀請相關技能
    case 116: handleSkill116AnimationEnd(passiveObject); break; // 刺猬防禦相關技能
    }
}

function handleSkill237AnimationEnd(passiveObject)
{
    if (!passiveObject.isMyControlObject()) return;
    
    local subType = passiveObject.getVar("subType").get_vector(0);
    if (subType == 3)
        sq_SendDestroyPacketPassiveObject(passiveObject);
}

function handleSkill238AnimationEnd(passiveObject)
{
    if (!passiveObject.isMyControlObject()) return;
    
    local subType = passiveObject.getVar("subType").get_vector(0);
    if (subType == 1)
    {
        local currentState = passiveObject.getVar("state").get_vector(0);
        if (currentState != 13)
        {
            if (currentState == 12)
            {
                sq_BinaryStartWrite();
                sq_BinaryWriteWord(1);
                sq_SendChangeSkillEffectPacket(passiveObject, 238);
            }
            else
                passiveObject.addSetStatePacket(currentState + 1, null, STATE_PRIORITY_AUTO, false, "");
        }
        else
            sq_SendDestroyPacketPassiveObject(passiveObject);
    }
}

function handleSkill226AnimationEnd(passiveObject)
{
    if (!passiveObject.isMyControlObject()) return;
    sq_SendDestroyPacketPassiveObject(passiveObject);
}

function handleSkill241AnimationEnd(passiveObject)
{
    if (!passiveObject.isMyControlObject()) return;
    
    local subType = passiveObject.getVar("subType").get_vector(0);
    if (subType == 1)
    {
        local currentState = passiveObject.getVar("state").get_vector(0);
        if (currentState != 14)
            passiveObject.addSetStatePacket(currentState + 1, null, STATE_PRIORITY_AUTO, false, "");
        else
            sq_SendDestroyPacketPassiveObject(passiveObject);
    }
    else if (subType == 2)
        sq_SendDestroyPacketPassiveObject(passiveObject);
}

function handleSkill242AnimationEnd(passiveObject)
{
    if (!passiveObject.isMyControlObject()) return;
    sq_SendDestroyPacketPassiveObject(passiveObject);
}

function handleSkill243AnimationEnd(passiveObject)
{
    if (!passiveObject.isMyControlObject()) return;
    sq_SendDestroyPacketPassiveObject(passiveObject);
}

function handleSkill245AnimationEnd(passiveObject)
{
    if (!passiveObject.isMyControlObject()) return;
    
    local subType = passiveObject.getVar("subType").get_vector(0);
    if (subType == 1)
        passiveObject.addSetStatePacket(10, null, STATE_PRIORITY_AUTO, false, "");
    else if (subType == 2)
    {
        local currentState = passiveObject.getVar("state").get_vector(0);
        if (currentState != 11)
            passiveObject.addSetStatePacket(currentState + 1, null, STATE_PRIORITY_AUTO, false, "");
        else
            sq_SendDestroyPacketPassiveObject(passiveObject);
    }
    else if (subType == 3 || subType == 4)
        sq_SendDestroyPacketPassiveObject(passiveObject);
}

function handleSkill248AnimationEnd(passiveObject)
{
    if (!passiveObject.isMyControlObject()) return;
    
    local subType = passiveObject.getVar("subType").get_vector(0);
    if (subType == 1)
    {
        local currentState = passiveObject.getVar("state").get_vector(0);
        switch (currentState)
        {
        case 11:
            local positionVector = sq_GetGlobalIntVector();
            sq_IntVectorClear(positionVector);
            sq_IntVectorPush(positionVector, passiveObject.getXPos());
            sq_IntVectorPush(positionVector, passiveObject.getYPos());
            passiveObject.addSetStatePacket(12, positionVector, STATE_PRIORITY_AUTO, false, "");
            break;
            
        case 12:
            local counterValue = passiveObject.getVar().get_vector(2);
            if (counterValue > 0)
                passiveObject.addSetStatePacket(12, null, STATE_PRIORITY_AUTO, false, "");
            else
                passiveObject.addSetStatePacket(13, null, STATE_PRIORITY_AUTO, false, "");
            break;
            
        case 13:
            sq_SendDestroyPacketPassiveObject(passiveObject);
            break;
        }
    }
}

function handleSkill249AnimationEnd(passiveObject)
{
    if (!passiveObject.isMyControlObject()) return;
    
    local subType = passiveObject.getVar("subType").get_vector(0);
    switch (subType)
    {
    case 0:
    case 1:
    case 2:
    case 3:
        sq_SendDestroyPacketPassiveObject(passiveObject);
        break;
    }
}

function handleSkill250AnimationEnd(passiveObject)
{
    if (!passiveObject.isMyControlObject()) return;
    sq_SendDestroyPacketPassiveObject(passiveObject);
}

function handleSkill251AnimationEnd(passiveObject)
{
    if (!passiveObject.isMyControlObject()) return;
    sq_SendDestroyPacketPassiveObject(passiveObject);
}

function handleSkill246AnimationEnd(passiveObject)
{
    if (!passiveObject.isMyControlObject()) return;
    sq_SendDestroyPacketPassiveObject(passiveObject);
}

function handleSkill135AnimationEnd(passiveObject)
{
    if (!passiveObject.isMyControlObject()) return;
    sq_SendDestroyPacketPassiveObject(passiveObject);
}

function handleSkill136AnimationEnd(passiveObject)
{
    if (!passiveObject.isMyControlObject()) return;
    
    local subType = passiveObject.getVar("subType").get_vector(0);
    if (subType != 2)
        sq_SendDestroyPacketPassiveObject(passiveObject);
    else
    {
        local currentState = passiveObject.getVar("state").get_vector(0);
        if (currentState != 12)
            passiveObject.addSetStatePacket(currentState + 1, null, STATE_PRIORITY_AUTO, false, "");
        else
            sq_SendDestroyPacketPassiveObject(passiveObject);
    }
}

function handleSkill137AnimationEnd(passiveObject)
{
    local subType = passiveObject.getVar("subType").get_vector(0);
    if (subType == 1)
    {
        if (passiveObject.getVar().getBool(0) == true)
            passiveObject.setCurrentAnimation(null);
        else
        {
            local passiveObj = passiveObject.getMyPassiveObject(24374, 0);
            if (passiveObj && passiveObj.isMyControlObject())
                sq_SendDestroyPacketPassiveObject(passiveObj);
            if (passiveObject.isMyControlObject())
                sq_SendDestroyPacketPassiveObject(passiveObject);
        }
    }
}

function handleSkill139AnimationEnd(passiveObject)
{
    if (!passiveObject.isMyControlObject()) return;
    sq_SendDestroyPacketPassiveObject(passiveObject);
}

function handleSkill132AnimationEnd(passiveObject)
{
    if (!passiveObject.isMyControlObject()) return;
    
    local subType = passiveObject.getVar("subType").get_vector(0);
    if (subType == 3)
        sq_SendDestroyPacketPassiveObject(passiveObject);
    else
    {
        local currentState = passiveObject.getVar("state").get_vector(0);
        if (currentState == 11)
            passiveObject.addSetStatePacket(currentState + 1, null, STATE_PRIORITY_AUTO, false, "");
        else if (currentState == 12)
            sq_SendDestroyPacketPassiveObject(passiveObject);
        else
            passiveObject.addSetStatePacket(10, null, STATE_PRIORITY_AUTO, false, "");
    }
}

function handleSkill116AnimationEnd(passiveObject)
{
    if (!passiveObject.isMyControlObject()) return;
    
    local subType = passiveObject.getVar("subType").get_vector(0);
    if (subType == 1)
        sq_SendDestroyPacketPassiveObject(passiveObject);
}

// ---------------------codeEnd---------------------//