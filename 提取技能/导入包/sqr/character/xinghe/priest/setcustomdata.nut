function setCustomData_po_qq506807329new_priest_24374(passiveObject, binaryDataReader)
{
    // 如果被動對象不存在則返回
    if (!passiveObject) return;
    
    // 讀取技能ID
    local skillId = binaryDataReader.readDword(); 
    passiveObject.getVar("skill").clear_vector(); 
    passiveObject.getVar("skill").push_vector(skillId);
    
    // 根據技能ID進行不同處理
    handleSkillById(passiveObject, binaryDataReader, skillId);
}

function handleSkillById(passiveObject, binaryDataReader, skillId)
{
    switch(skillId) 
    {
        case 226: handleSkill226(passiveObject, binaryDataReader); break; // 破壞氣功波相關技能
        case 237: handleSkill237(passiveObject, binaryDataReader); break; // 毀滅神像相關技能
        case 238: handleSkill238(passiveObject, binaryDataReader); break; // 聖潔之盾相關技能
        case 240: handleSkill240(passiveObject, binaryDataReader); break; // 危險刻印相關技能
        case 241: handleSkill241(passiveObject, binaryDataReader); break; // 龍之怒相關技能
        case 242: handleSkill242(passiveObject, binaryDataReader); break; // 核爆拳相關技能
        case 243: handleSkill243(passiveObject, binaryDataReader); break; // 爆裂拳相關技能
        case 245: handleSkill245(passiveObject, binaryDataReader); break; // 天譴之怒相關技能
        case 248: handleSkill248(passiveObject, binaryDataReader); break; // 神聖之矛相關技能
        case 249: handleSkill249(passiveObject, binaryDataReader); break; // 命運之矛相關技能
        case 250: handleSkill250(passiveObject, binaryDataReader); break; // 木星錘相關技能
        case 251: handleSkill251(passiveObject, binaryDataReader); break; // 神罰相關技能
        case 246: handleSkill246(passiveObject, binaryDataReader); break; // 洗禮相關技能
        case 135: handleSkill135(passiveObject, binaryDataReader); break; // 惡魔之拳相關技能
        case 136: handleSkill136(passiveObject, binaryDataReader); break; // 黑暗嚎叫相關技能
        case 137: handleSkill137(passiveObject, binaryDataReader); break; // 毀滅壓制相關技能
        case 139: handleSkill139(passiveObject, binaryDataReader); break; // 變身相關技能
        case 132: handleSkill132(passiveObject, binaryDataReader); break; // 惡魔邀請相關技能
        case 116: handleSkill116(passiveObject, binaryDataReader); break; // 刺猬防禦相關技能
        default: break;
    }
}

function handleSkill226(passiveObject, binaryDataReader)
{
    local subType = binaryDataReader.readDword(); 
    local attackInfo = sq_GetCustomAttackInfo(passiveObject, 1); 
    sq_SetCurrentAttackBonusRate(attackInfo, binaryDataReader.readDword()); 
    local hitEffectType = binaryDataReader.readDword(); 
    sq_SetCurrentAttackInfo(passiveObject, attackInfo); 
    local hitEffectPath = "passiveobject/chang_qing_skill/priest/Animation/ChakraOfGod/HitFire_Hit.ani";
    
    // 根據子類型選擇不同的打擊特效
    if(hitEffectType == 1)
        hitEffectPath = "passiveobject/chang_qing_skill/priest/animation/chakraofgod/hitlight_hit.ani";
    if(hitEffectType == 2)
        hitEffectPath = "passiveobject/chang_qing_skill/priest/animation/chakraofgod/hit_throwhit.ani";
    if(hitEffectType == 3)
        hitEffectPath = "passiveobject/chang_qing_skill/priest/animation/chakraofgod/hit_throwhitlight.ani";
        
    if(subType == 0)
    {
        local animation = sq_CreateAnimation("", hitEffectPath);
        passiveObject.setCurrentAnimation(animation); 
    }
    else if(subType == 1)
    {
        local animation = sq_CreateAnimation("", hitEffectPath);
        local sizeRate = 2.0;
        animation.setImageRateFromOriginal(sizeRate, sizeRate);
        animation.setAutoLayerWorkAnimationAddSizeRate(sizeRate);
        sq_SetAttackBoundingBoxSizeRate(animation, sizeRate, sizeRate, sizeRate);
        passiveObject.setCurrentAnimation(animation); 
    }
}

function handleSkill237(passiveObject, binaryDataReader)
{
    local subType = binaryDataReader.readDword(); 
    passiveObject.getVar("subType").clear_vector(); 
    passiveObject.getVar("subType").push_vector(subType);
    
    switch(subType)
    {
        case 1:
            passiveObject.getVar().clear_vector(); 
            local varContainer = passiveObject.getVar(); 
            varContainer.push_vector(binaryDataReader.readDword()); 
            varContainer.push_vector(binaryDataReader.readDword()); 
            varContainer.push_vector(binaryDataReader.readDword()); 
            if(passiveObject.isMyControlObject())
                passiveObject.addSetStatePacket(10, null, STATE_PRIORITY_AUTO, false, ""); 
            break;
            
        case 2:
            local xPos = passiveObject.getXPos(); 
            local yPos = passiveObject.getYPos(); 
            passiveObject.getVar().clear_vector(); 
            local varContainer = passiveObject.getVar(); 
            varContainer.push_vector(xPos);
            varContainer.push_vector(yPos);
            varContainer.push_vector(sq_GetDistancePos(xPos, passiveObject.getDirection(), binaryDataReader.readDword())); 
            varContainer.push_vector(yPos + binaryDataReader.readDword()); 
            varContainer.push_vector(binaryDataReader.readDword()); 
            varContainer.push_vector(binaryDataReader.readDword()); 
            varContainer.push_vector(binaryDataReader.readDword()); 
            if(passiveObject.isMyControlObject())
                passiveObject.addSetStatePacket(10, null, STATE_PRIORITY_AUTO, false, ""); 
            break;
            
        case 3:
            local attackInfo = sq_GetCustomAttackInfo(passiveObject, 1); 
            sq_SetCurrentAttackBonusRate(attackInfo, binaryDataReader.readDword()); 
            sq_SetCurrentAttackInfo(passiveObject, attackInfo); 
            local animation = sq_CreateAnimation("", "passiveobject/script_sqr_nut_qq506807329/priest/animation/destroyspirittalisman/explosion_explosion_circle_normal.ani");
            passiveObject.setCurrentAnimation(animation); 
            break;
    }
}

function handleSkill238(passiveObject, binaryDataReader)
{
    local subType = binaryDataReader.readDword(); 
    passiveObject.getVar("subType").clear_vector(); 
    passiveObject.getVar("subType").push_vector(subType);
    
    if(subType == 1)
    {
        sq_ChangeDrawLayer(passiveObject, ENUM_DRAWLAYER_BOTTOM); 
        passiveObject.getVar().clear_vector(); 
        local varContainer = passiveObject.getVar(); 
        varContainer.push_vector(binaryDataReader.readDword()); 
        varContainer.push_vector(binaryDataReader.readDword()); 
        varContainer.push_vector(binaryDataReader.readDword()); 
        varContainer.push_vector(binaryDataReader.readDword()); 
        varContainer.push_vector(binaryDataReader.readDword()); 
        passiveObject.getVar().setBool(0, false); 
        if(passiveObject.isMyControlObject())
            passiveObject.addSetStatePacket(10, null, STATE_PRIORITY_AUTO, false, ""); 
    }
}

function handleSkill240(passiveObject, binaryDataReader)
{
    local animation = sq_CreateAnimation("", "passiveobject/script_sqr_nut_qq506807329/priest/animation/dangerousscale/dangerousscaleattackexplosion_00.ani");
    local scaleRate = (binaryDataReader.readDword()).tofloat() / 100.0; 
    animation.setImageRateFromOriginal(scaleRate, scaleRate); 
    animation.setAutoLayerWorkAnimationAddSizeRate(scaleRate); 
    sq_SetAttackBoundingBoxSizeRate(animation, scaleRate, scaleRate, scaleRate); 
    passiveObject.setCurrentAnimation(animation); 
    local attackInfo = sq_GetCustomAttackInfo(passiveObject, 4); 
    sq_SetCurrentAttackBonusRate(attackInfo, binaryDataReader.readDword()); 
    sq_SetCurrentAttackInfo(passiveObject, attackInfo); 
    local xPos = passiveObject.getXPos();
    local yPos = passiveObject.getYPos();
    local zPos = passiveObject.getZPos();
    CreateAniRate(passiveObject, "character/priest/effect/animation/dangerousscale/dangerousscaleattackstoneback_00.ani", ENUM_DRAWLAYER_NORMAL, xPos, yPos - 1, zPos, scaleRate, false); 
    CreateAniRate(passiveObject, "character/priest/effect/animation/dangerousscale/dangerousscaleattackstonefront_00.ani", ENUM_DRAWLAYER_NORMAL, xPos, yPos, zPos, scaleRate, false); 
    CreateAniRate(passiveObject, "character/priest/effect/animation/dangerousscale/dangerousscaleattackdust_00.ani", ENUM_DRAWLAYER_NORMAL, xPos, yPos + 1, zPos, scaleRate, false); 
    CreateAniRate(passiveObject, "character/priest/effect/animation/dangerousscale/dangerousscaleattackbottom_00.ani", ENUM_DRAWLAYER_BOTTOM, xPos, yPos, zPos, scaleRate, false); 
}

function handleSkill241(passiveObject, binaryDataReader)
{
    local subType = binaryDataReader.readDword(); 
    passiveObject.getVar("subType").clear_vector(); 
    passiveObject.getVar("subType").push_vector(subType);
    
    switch(subType)
    {
        case 1:
            local damageValue = (binaryDataReader.readDword()).tofloat(); 
            passiveObject.getVar().setFloat(0, damageValue / 300.0); 
            passiveObject.getVar().setFloat(1, damageValue / 250.0); 
            passiveObject.getVar().clear_vector(); 
            local varContainer = passiveObject.getVar(); 
            varContainer.push_vector(binaryDataReader.readDword()); 
            varContainer.push_vector(binaryDataReader.readDword()); 
            varContainer.push_vector(binaryDataReader.readDword()); 
            varContainer.push_vector(binaryDataReader.readDword()); 
            if(passiveObject.isMyControlObject())
                passiveObject.addSetStatePacket(10, null, STATE_PRIORITY_AUTO, false, ""); 
            break;
                
        case 2:
            local speedRate = binaryDataReader.readFloat(); 
            passiveObject.getVar().setFloat(0, speedRate); 
            local animation = sq_CreateAnimation("", "passiveobject/script_sqr_nut_qq506807329/priest/animation/advanceddragon/advanceddragon_passion/attack_smallfrag.ani");
            animation.setSpeedRate(speedRate); 
            passiveObject.setCurrentAnimation(animation); 
            local attackInfo = sq_GetCustomAttackInfo(passiveObject, 7); 
            sq_SetCurrentAttackBonusRate(attackInfo, binaryDataReader.readDword()); 
            sq_SetCurrentAttackInfo(passiveObject, attackInfo); 
            break;
    }
}

function handleSkill242(passiveObject, binaryDataReader)
{
    local animation = sq_CreateAnimation("", "passiveobject/script_sqr_nut_qq506807329/priest/animation/nuclearpunch/nuclearpunch_attack_shockbackglow.ani");
    passiveObject.setCurrentAnimation(animation); 
    local attackInfo = sq_GetCustomAttackInfo(passiveObject, 8); 
    sq_SetCurrentAttackBonusRate(attackInfo, binaryDataReader.readDword()); 
    sq_SetCurrentAttackInfo(passiveObject, attackInfo); 
}

function handleSkill243(passiveObject, binaryDataReader)
{
    local animation = sq_CreateAnimation("", "passiveobject/script_sqr_nut_qq506807329/priest/animation/demolitionpunch/demolitionpunch_c_shockb.ani");
    passiveObject.setCurrentAnimation(animation); 
    local attackInfo = sq_GetCustomAttackInfo(passiveObject, 9); 
    sq_SetCurrentAttackBonusRate(attackInfo, binaryDataReader.readDword()); 
    sq_SetCurrentAttackInfo(passiveObject, attackInfo); 
}

function handleSkill245(passiveObject, binaryDataReader)
{
    local subType = binaryDataReader.readDword(); 
    passiveObject.getVar("subType").clear_vector(); 
    passiveObject.getVar("subType").push_vector(subType);
    
    switch(subType)
    {
        case 1:
            local parentObject = sq_GetCNRDObjectToSQRCharacter(passiveObject.getParent()); 
            if(parentObject)
            {
                local animation = sq_GetCustomAni(parentObject, binaryDataReader.readDword()); 
                sq_Rewind(animation); 
                animation.setSpeedRate(150.0); 
                passiveObject.setCurrentAnimation(animation); 
                local attackInfo = sq_GetCustomAttackInfo(parentObject, 109); 
                sq_SetCurrentAttackBonusRate(attackInfo, binaryDataReader.readDword()); 
                sq_SetCurrentAttackInfo(passiveObject, attackInfo); 
                passiveObject.setDirection(binaryDataReader.readDword()); 
                passiveObject.sq_PlaySound("R_WRATH_GOD_HIT"); 
            }
            break;
            
        case 2:
            passiveObject.getVar().clear_vector(); 
            passiveObject.getVar().push_vector(binaryDataReader.readDword()); 
            passiveObject.setDirection(sq_GetOppositeDirection(passiveObject.getDirection())); 
            if(passiveObject.isMyControlObject())
                passiveObject.addSetStatePacket(10, null, STATE_PRIORITY_AUTO, false, ""); 
            break;
            
        case 3:
            local scaleRate = 2.0; 
            local animation = sq_CreateAnimation("", "passiveobject/script_sqr_nut_qq506807329/priest/animation/wrathofgod/finishatkeff_smoke.ani");
            animation.setImageRateFromOriginal(scaleRate, scaleRate); 
            animation.setAutoLayerWorkAnimationAddSizeRate(scaleRate); 
            sq_SetAttackBoundingBoxSizeRate(animation, scaleRate, scaleRate, scaleRate); 
            passiveObject.setCurrentAnimation(animation); 
            local attackInfo = sq_GetCustomAttackInfo(passiveObject, 10); 
            sq_SetCurrentAttackBonusRate(attackInfo, binaryDataReader.readDword()); 
            sq_SetCurrentAttackInfo(passiveObject, attackInfo); 
            passiveObject.sq_PlaySound("WRATH_GOD_EXP"); 
            break;
            
        case 4:
            local parentObject = sq_GetCNRDObjectToSQRCharacter(passiveObject.getParent()); 
            if(parentObject)
            {
                local animation = sq_GetCustomAni(parentObject, 158); 
                sq_Rewind(animation); 
                passiveObject.setCurrentAnimation(animation); 
            }
            break;
    }
}

function handleSkill248(passiveObject, binaryDataReader)
{
    local subType = binaryDataReader.readDword(); 
    passiveObject.getVar("subType").clear_vector(); 
    passiveObject.getVar("subType").push_vector(subType);
    
    switch(subType)
    {
        case 1:
            local parentObject = sq_GetCNRDObjectToSQRCharacter(passiveObject.getParent()); 
            if(parentObject)
                parentObject.getVar().push_obj_vector(passiveObject); 
            sq_ChangeDrawLayer(passiveObject, ENUM_DRAWLAYER_BOTTOM); 
            passiveObject.getVar().clear_vector(); 
            local varContainer = passiveObject.getVar(); 
            varContainer.push_vector(binaryDataReader.readDword()); 
            varContainer.push_vector(binaryDataReader.readDword()); 
            varContainer.push_vector(binaryDataReader.readDword()); 
            varContainer.push_vector(binaryDataReader.readDword()); 
            if(passiveObject.isMyControlObject())
                passiveObject.addSetStatePacket(10, null, STATE_PRIORITY_AUTO, false, ""); 
            break;
    }
}

function handleSkill249(passiveObject, binaryDataReader)
{
    local subType = binaryDataReader.readDword(); 
    passiveObject.getVar("subType").clear_vector(); 
    passiveObject.getVar("subType").push_vector(subType);
    
    switch(subType)
    {
        case 0:
            sq_ChangeDrawLayer(passiveObject, ENUM_DRAWLAYER_COVER); 
            passiveObject.getVar().clear_vector(); 
            local varContainer = passiveObject.getVar(); 
            varContainer.push_vector(binaryDataReader.readDword()); 
            varContainer.push_vector(binaryDataReader.readDword()); 
            varContainer.push_vector(binaryDataReader.readDword()); 
            varContainer.push_vector(passiveObject.getYPos()); 
            local backgroundAnimation = sq_CreateAnimation("", "character/priest/effect/animation/spearofdestiny/spearofdestiny_bgeff_cloud01.ani"); 
            passiveObject.setCurrentAnimation(backgroundAnimation); 
            local foregroundAnimation = sq_CreateDrawOnlyObject(passiveObject, "character/priest/effect/animation/spearofdestiny/spearofdestiny_usereff_glow04.ani", ENUM_DRAWLAYER_COVER, true); 
            passiveObject.getVar("aniobj").clear_obj_vector(); 
            passiveObject.getVar("aniobj").push_obj_vector(foregroundAnimation); 
            local parentObject = passiveObject.getParent(); 
            if(parentObject && !parentObject.isMyControlObject()) 
            {
                sq_setCurrentAxisPos(passiveObject, 2, 99999); 
                sq_setCurrentAxisPos(foregroundAnimation, 2, 99999); 
            }
            break;
            
        case 1:
            local animation = sq_CreateAnimation("", "passiveobject/script_sqr_nut_qq506807329/priest/animation/spearofdestiny/spearofdestiny_dropspear_thunder.ani"); 
            passiveObject.setCurrentAnimation(animation); 
            local attackInfo = sq_GetCustomAttackInfo(passiveObject, 13); 
            sq_SetCurrentAttackBonusRate(attackInfo, binaryDataReader.readDword()); 
            sq_SetCurrentAttackInfo(passiveObject, attackInfo); 
            passiveObject.getVar().clear_vector(); 
            local varContainer = passiveObject.getVar(); 
            varContainer.push_vector(binaryDataReader.readDword()); 
            varContainer.push_vector(binaryDataReader.readDword()); 
            break;
            
        case 2:
            sq_ChangeDrawLayer(passiveObject, ENUM_DRAWLAYER_BOTTOM); 
            local animation = sq_CreateAnimation("", "passiveobject/script_sqr_nut_qq506807329/priest/animation/spearofdestiny/spearofdestiny_explosion_floor_eff06.ani"); 
            passiveObject.setCurrentAnimation(animation); 
            local attackInfo = sq_GetCustomAttackInfo(passiveObject, 14); 
            sq_SetCurrentAttackBonusRate(attackInfo, binaryDataReader.readDword()); 
            sq_SetCurrentAttackInfo(passiveObject, attackInfo); 
            break;
            
        case 3:
            local animation = sq_CreateAnimation("", "passiveobject/script_sqr_nut_qq506807329/priest/animation/spearofdestiny/spearofdestiny_explosion_back_eff01.ani"); 
            passiveObject.setCurrentAnimation(animation); 
            local attackInfo = sq_GetCustomAttackInfo(passiveObject, 15); 
            sq_SetCurrentAttackBonusRate(attackInfo, binaryDataReader.readDword()); 
            sq_SetCurrentAttackInfo(passiveObject, attackInfo); 
            sq_SetMyShake(passiveObject, 4, 180); 
            break;
    }
}

function handleSkill250(passiveObject, binaryDataReader)
{
    local subType = binaryDataReader.readDword(); 
    passiveObject.getVar("subType").clear_vector(); 
    passiveObject.getVar("subType").push_vector(subType);
    
    switch(subType)
    {
        case 1:
            local animation = sq_CreateAnimation("", "passiveobject/script_sqr_nut_qq506807329/priest/animation/jupiter/jupiterhammerlightningtower.ani");
            passiveObject.setCurrentAnimation(animation); 
            local attackInfo = sq_GetCustomAttackInfo(passiveObject, 16); 
            sq_SetCurrentAttackBonusRate(attackInfo, binaryDataReader.readDword()); 
            sq_SetCurrentAttackInfo(passiveObject, attackInfo); 
            break;
            
        case 2:
            local scaleRate = 0.5; 
            local animation = sq_CreateAnimation("", "passiveobject/script_sqr_nut_qq506807329/priest/animation/jupiter/jupiterhammerupperadd_addeff_a.ani");
            animation.setImageRateFromOriginal(scaleRate, scaleRate); 
            animation.setAutoLayerWorkAnimationAddSizeRate(scaleRate); 
            sq_SetAttackBoundingBoxSizeRate(animation, scaleRate, scaleRate, scaleRate); 
            passiveObject.setCurrentAnimation(animation); 
            local attackInfo = sq_GetCustomAttackInfo(passiveObject, 17); 
            sq_SetCurrentAttackBonusRate(attackInfo, binaryDataReader.readDword()); 
            sq_SetCurrentAttackInfo(passiveObject, attackInfo); 
            break;
            
        case 3:
            local animation = sq_CreateAnimation("", "passiveobject/script_sqr_nut_qq506807329/priest/animation/jupiter/jupiterhammerdashatk_floor_dodge.ani");
            passiveObject.setCurrentAnimation(animation); 
            local damageValue = binaryDataReader.readDword(); 
            passiveObject.getVar().clear_vector(); 
            passiveObject.getVar().push_vector(damageValue); 
            local attackInfo = sq_GetCustomAttackInfo(passiveObject, 18); 
            sq_SetCurrentAttackBonusRate(attackInfo, damageValue); 
            sq_SetCurrentAttackInfo(passiveObject, attackInfo); 
            passiveObject.sq_PlaySound("R_THUNDERHAMMER_ATK_ELEC");
            break;
            
        case 4:
            local animation = sq_CreateAnimation("", "passiveobject/script_sqr_nut_qq506807329/priest/animation/jupiter/jupiterhammerupperadd_addeff_a.ani");
            passiveObject.setCurrentAnimation(animation); 
            local attackInfo = sq_GetCustomAttackInfo(passiveObject, 17); 
            sq_SetCurrentAttackBonusRate(attackInfo, binaryDataReader.readDword()); 
            sq_SetCurrentAttackInfo(passiveObject, attackInfo); 
            break;
    }
    passiveObject.sq_PlaySound("R_THUNDERHAMMER_ATK_ELEC"); 
}

function handleSkill251(passiveObject, binaryDataReader)
{
    local subType = binaryDataReader.readDword(); 
    passiveObject.getVar("subType").clear_vector(); 
    passiveObject.getVar("subType").push_vector(subType);
    
    switch(subType)
    {
        case 1:
            local animation = sq_CreateAnimation("", "passiveobject/script_sqr_nut_qq506807329/priest/animation/divinepunishment/boom_04.ani");
            passiveObject.setCurrentAnimation(animation); 
            local attackInfo = sq_GetCustomAttackInfo(passiveObject, 20); 
            sq_SetCurrentAttackBonusRate(attackInfo, binaryDataReader.readDword()); 
            sq_SetCurrentAttackInfo(passiveObject, attackInfo); 
            sq_CreateDrawOnlyObject(passiveObject, "passiveobject/script_sqr_nut_qq506807329/priest/animation/divinepunishment/boom_floor_01.ani", ENUM_DRAWLAYER_BOTTOM, true); 
            sq_SetMyShake(passiveObject, 3, 100); 
            break;
            
        case 2:
            local animation = sq_CreateAnimation("", "passiveobject/script_sqr_nut_qq506807329/priest/animation/divinepunishment/finish01_09.ani");
            passiveObject.setCurrentAnimation(animation); 
            local attackInfo = sq_GetCustomAttackInfo(passiveObject, 21); 
            sq_SetCurrentAttackBonusRate(attackInfo, binaryDataReader.readDword()); 
            sq_SetCurrentAttackInfo(passiveObject, attackInfo); 
            sq_SetMyShake(passiveObject, 6, 400); 
            break;
    }
}

function handleSkill246(passiveObject, binaryDataReader)
{
    local subType = binaryDataReader.readDword(); 
    passiveObject.getVar("subType").clear_vector(); 
    passiveObject.getVar("subType").push_vector(subType);
    
    switch(subType)
    {
        case 1:
            local animation = sq_CreateAnimation("", "passiveobject/script_sqr_nut_qq506807329/priest/animation/haptism/haptism1front_1.ani");
            passiveObject.setCurrentAnimation(animation); 
            local attackInfo = sq_GetCustomAttackInfo(passiveObject, 22); 
            sq_SetCurrentAttackBonusRate(attackInfo, binaryDataReader.readDword()); 
            sq_SetCurrentAttackInfo(passiveObject, attackInfo); 
            break;
            
        case 2:
            sq_ChangeDrawLayer(passiveObject, ENUM_DRAWLAYER_BOTTOM); 
            local animation = sq_CreateAnimation("", "passiveobject/script_sqr_nut_qq506807329/priest/animation/haptism/haptism1floor_1.ani");
            passiveObject.setCurrentAnimation(animation); 
            local attackInfo = sq_GetCustomAttackInfo(passiveObject, 23); 
            sq_SetCurrentAttackBonusRate(attackInfo, binaryDataReader.readDword()); 
            sq_SetCurrentAttackInfo(passiveObject, attackInfo); 
            break;
            
        case 3:
            sq_ChangeDrawLayer(passiveObject, ENUM_DRAWLAYER_BOTTOM); 
            local animation = sq_CreateAnimation("", "passiveobject/script_sqr_nut_qq506807329/priest/animation/haptism/haptism2floor_1.ani");
            passiveObject.setCurrentAnimation(animation); 
            local attackInfo = sq_GetCustomAttackInfo(passiveObject, 24); 
            sq_SetCurrentAttackBonusRate(attackInfo, binaryDataReader.readDword()); 
            sq_SetCurrentAttackInfo(passiveObject, attackInfo); 
            sq_SetMyShake(passiveObject, 3, 160); 
            sq_CreateDrawOnlyObject(passiveObject, "passiveobject/script_sqr_nut_qq506807329/priest/animation/haptism/haptism2front_1.ani", ENUM_DRAWLAYER_NORMAL, true); 
            break;
    }
}

function handleSkill135(passiveObject, binaryDataReader)
{
    local animation = sq_CreateAnimation("", "passiveobject/script_sqr_nut_qq506807329/priest/animation/devilfist/explosion_08.ani");
    passiveObject.setCurrentAnimation(animation); 
    local attackInfo = sq_GetCustomAttackInfo(passiveObject, 25); 
    sq_SetCurrentAttackBonusRate(attackInfo, binaryDataReader.readDword()); 
    sq_SetCurrentAttackInfo(passiveObject, attackInfo); 
    local scaleRate = binaryDataReader.readFloat(); 
    animation.setImageRateFromOriginal(scaleRate, scaleRate); 
    animation.setAutoLayerWorkAnimationAddSizeRate(scaleRate); 
    sq_SetAttackBoundingBoxSizeRate(animation, scaleRate, scaleRate, scaleRate); 
}

function handleSkill136(passiveObject, binaryDataReader)
{
    local subType = binaryDataReader.readDword(); 
    passiveObject.getVar("subType").clear_vector(); 
    passiveObject.getVar("subType").push_vector(subType);
    
    switch(subType)
    {
        case 1:
            local animation = sq_CreateAnimation("", "passiveobject/script_sqr_nut_qq506807329/priest/animation/darkhowling/dh1_shockwave_normal.ani");
            passiveObject.setCurrentAnimation(animation); 
            local attackInfo = sq_GetCustomAttackInfo(passiveObject, binaryDataReader.readDword()); 
            sq_SetCurrentAttackBonusRate(attackInfo, binaryDataReader.readDword()); 
            local curseTime = binaryDataReader.readDword(); 
            sq_SetChangeStatusIntoAttackInfo(attackInfo, 0, ACTIVESTATUS_CURSE, binaryDataReader.readDword(), binaryDataReader.readDword(), binaryDataReader.readDword(), curseTime, curseTime, curseTime, curseTime); 
            sq_SetCurrentAttackInfo(passiveObject, attackInfo); 
            local repeatCount = binaryDataReader.readDword(); 
            if(repeatCount != 0)
                passiveObject.setTimeEvent(0, animation.getDelaySum(0, 4) / repeatCount, repeatCount - 1, false); 
            passiveObject.getVar().clear_obj_vector(); 
            passiveObject.getVar().clear_vector(); 
            passiveObject.getVar().push_vector(binaryDataReader.readDword()); 
            sq_SetMyShake(passiveObject, 4, 200); 
            break;
            
        case 2:
            passiveObject.getVar().clear_vector(); 
            passiveObject.getVar().push_vector(binaryDataReader.readDword()); 
            if(passiveObject.isMyControlObject())
                passiveObject.addSetStatePacket(10, null, STATE_PRIORITY_AUTO, false, ""); 
            break;
            
        case 3:
            local animation = sq_CreateAnimation("", "passiveobject/script_sqr_nut_qq506807329/priest/animation/darkhowling/shock_dodge.ani");
            passiveObject.setCurrentAnimation(animation); 
            local attackInfo = sq_GetCustomAttackInfo(passiveObject, 28); 
            sq_SetCurrentAttackBonusRate(attackInfo, binaryDataReader.readDword()); 
            local curseTime = binaryDataReader.readDword(); 
            sq_SetChangeStatusIntoAttackInfo(attackInfo, 0, ACTIVESTATUS_CURSE, binaryDataReader.readDword(), binaryDataReader.readDword(), binaryDataReader.readDword(), curseTime, curseTime, curseTime, curseTime); 
            sq_SetCurrentAttackInfo(passiveObject, attackInfo); 
            passiveObject.getVar().clear_obj_vector(); 
            passiveObject.getVar().clear_vector(); 
            passiveObject.getVar().push_vector(binaryDataReader.readDword()); 
            sq_SetMyShake(passiveObject, 4, 200); 
            sq_CreateDrawOnlyObject(passiveObject, "passiveobject/script_sqr_nut_qq506807329/priest/animation/darkhowling/circle_normal.ani", ENUM_DRAWLAYER_BOTTOM, true); 
            break;
    }
}

function handleSkill137(passiveObject, binaryDataReader)
{
    local subType = binaryDataReader.readDword(); 
    passiveObject.getVar("subType").clear_vector(); 
    passiveObject.getVar("subType").push_vector(subType);
    
    switch(subType)
    {
        case 1:
            local effectPath = "passiveobject/script_sqr_nut_qq506807329/priest/animation/doomcrush/doomcrush_boom_finish_20.ani"; 
            if(binaryDataReader.readDword() == 2) 
                effectPath = "passiveobject/script_sqr_nut_qq506807329/priest/animation/doomcrush/doomcrush_boom_finish_charge_24.ani"; 
            passiveObject.setCurrentAnimation(sq_CreateAnimation("", effectPath)); 
            local attackInfo = sq_GetCustomAttackInfo(passiveObject, 29); 
            sq_SetCurrentAttackBonusRate(attackInfo, binaryDataReader.readDword()); 
            sq_SetCurrentAttackInfo(passiveObject, attackInfo); 
            local damageValue = binaryDataReader.readDword(); 
            if(passiveObject.isMyControlObject())
            {
                sq_BinaryStartWrite();
                sq_BinaryWriteDword(137); 
                sq_BinaryWriteDword(2); 
                sq_BinaryWriteDword(damageValue); 
                sq_SendCreatePassiveObjectPacket(passiveObject, 24374, 0, 0, 0, 0, passiveObject.getDirection());
            }
            passiveObject.getVar().clear_obj_vector(); 
            passiveObject.getVar().clear_vector(); 
            passiveObject.getVar().push_vector(binaryDataReader.readDword()); 
            passiveObject.getVar().setBool(0, false); 
            break;
            
        case 2:
            local attackInfo = sq_GetCustomAttackInfo(passiveObject, 30); 
            sq_SetCurrentAttackBonusRate(attackInfo, binaryDataReader.readDword()); 
            sq_SetCurrentAttackInfo(passiveObject, attackInfo); 
            break;
    }
}

function handleSkill139(passiveObject, binaryDataReader)
{
    local subType = binaryDataReader.readDword(); 
    passiveObject.getVar("subType").clear_vector(); 
    passiveObject.getVar("subType").push_vector(subType);
    
    switch(subType)
    {
        case 1:
            local animation = sq_CreateAnimation("", "passiveobject/script_sqr_nut_qq506807329/priest/animation/metamorphosis/change/change_dodge.ani");
            passiveObject.setCurrentAnimation(animation); 
            local attackInfo = sq_GetCustomAttackInfo(passiveObject, 31); 
            sq_SetCurrentAttackBonusRate(attackInfo, binaryDataReader.readDword()); 
            sq_SetCurrentAttackInfo(passiveObject, attackInfo); 
            local scaleRate = (binaryDataReader.readDword()).tofloat() / 100.0; 
            animation.setImageRateFromOriginal(scaleRate, scaleRate); 
            animation.setAutoLayerWorkAnimationAddSizeRate(scaleRate); 
            sq_SetAttackBoundingBoxSizeRate(animation, scaleRate, scaleRate, scaleRate); 
            break;
            
        case 2:
            local animation = sq_CreateAnimation("", "passiveobject/script_sqr_nut_qq506807329/priest/animation/metamorphosis/quakearea/quakearea_shock.ani");
            passiveObject.setCurrentAnimation(animation); 
            local attackInfo = sq_GetCustomAttackInfo(passiveObject, 36); 
            sq_SetCurrentAttackBonusRate(attackInfo, binaryDataReader.readDword()); 
            sq_SetCurrentAttackInfo(passiveObject, attackInfo); 
            local scaleRate = (binaryDataReader.readDword()).tofloat() / 100.0; 
            animation.setImageRateFromOriginal(scaleRate, scaleRate); 
            animation.setAutoLayerWorkAnimationAddSizeRate(scaleRate); 
            sq_SetAttackBoundingBoxSizeRate(animation, scaleRate, scaleRate, scaleRate); 
            sq_CreateDrawOnlyObject(passiveObject, "passiveobject/script_sqr_nut_qq506807329/priest/animation/metamorphosis/quakearea/quakeareaearth.ani", ENUM_DRAWLAYER_BOTTOM, true); 
            sq_CreateDrawOnlyObject(passiveObject, "passiveobject/script_sqr_nut_qq506807329/priest/animation/metamorphosis/quakearea/quakeareastone.ani", ENUM_DRAWLAYER_BOTTOM, true) 
            break;
            
        case 3:
            local animation = sq_CreateAnimation("", "passiveobject/script_sqr_nut_qq506807329/priest/animation/metamorphosis/awakening/awakeningend_dodge.ani");
            passiveObject.setCurrentAnimation(animation); 
            local attackInfo = sq_GetCustomAttackInfo(passiveObject, 37); 
            sq_SetCurrentAttackBonusRate(attackInfo, binaryDataReader.readDword()); 
            sq_SetCurrentAttackInfo(passiveObject, attackInfo); 
            local scaleRate = (binaryDataReader.readDword()).tofloat() / 100.0; 
            animation.setImageRateFromOriginal(scaleRate, scaleRate); 
            animation.setAutoLayerWorkAnimationAddSizeRate(scaleRate); 
            sq_SetAttackBoundingBoxSizeRate(animation, scaleRate, scaleRate, scaleRate); 
            break;
    }
}

function handleSkill132(passiveObject, binaryDataReader)
{
    local subType = binaryDataReader.readDword(); 
    passiveObject.getVar("subType").clear_vector(); 
    passiveObject.getVar("subType").push_vector(subType);
    
    switch(subType)
    {
        case 1:
            local effectType = binaryDataReader.readDword(); 
            local animation = null; 
            switch(effectType)
            {
                case 1:animation = sq_CreateAnimation("", "passiveobject/script_sqr_nut_qq506807329/priest/animation/inviteofdevil/devilinvitation_right_04.ani"); break;
                case 2:animation = sq_CreateAnimation("", "passiveobject/script_sqr_nut_qq506807329/priest/animation/inviteofdevil/devilinvitation_w_right_03.ani"); break;
            }
            animation.setSpeedRate(binaryDataReader.readFloat()); 
            passiveObject.setCurrentAnimation(animation); 
            local attackInfo = sq_GetCustomAttackInfo(passiveObject, 32); 
            sq_SetCurrentAttackBonusRate(attackInfo, binaryDataReader.readDword()); 
            sq_SetCurrentAttackInfo(passiveObject, attackInfo); 
            passiveObject.getVar().clear_vector(); 
            passiveObject.getVar().push_vector(effectType); 
            break;
            
        case 2:
            local effectType = binaryDataReader.readDword(); 
            local animation = null; 
            switch(effectType)
            {
                case 1:animation = sq_CreateAnimation("", "passiveobject/script_sqr_nut_qq506807329/priest/animation/inviteofdevil/devilinvitation_left_03.ani"); break;
                case 2:animation = sq_CreateAnimation("", "passiveobject/script_sqr_nut_qq506807329/priest/animation/inviteofdevil/devilinvitation_w_left_04.ani"); break;
            }
            animation.setSpeedRate(binaryDataReader.readFloat()); 
            passiveObject.setCurrentAnimation(animation); 
            local attackInfo = sq_GetCustomAttackInfo(passiveObject, 32); 
            sq_SetCurrentAttackBonusRate(attackInfo, binaryDataReader.readDword()); 
            sq_SetCurrentAttackInfo(passiveObject, attackInfo); 
            passiveObject.getVar().clear_vector(); 
            passiveObject.getVar().push_vector(effectType); 
            passiveObject.getVar().push_vector(binaryDataReader.readDword()); 
            break;
            
        case 3:
            local animation = sq_CreateAnimation("", "passiveobject/script_sqr_nut_qq506807329/priest/animation/inviteofdevil/devilinvitation_boom_04.ani");
            passiveObject.setCurrentAnimation(animation); 
            local attackInfo = sq_GetCustomAttackInfo(passiveObject, 33); 
            sq_SetCurrentAttackBonusRate(attackInfo, binaryDataReader.readDword()); 
            sq_SetCurrentAttackInfo(passiveObject, attackInfo); 
            break;
    }
}

function handleSkill116(passiveObject, binaryDataReader)
{
    local subType = binaryDataReader.readDword(); 
    passiveObject.getVar("subType").clear_vector(); 
    passiveObject.getVar("subType").push_vector(subType);
    
    if(subType == 1)
    {
        local parentObject = passiveObject.getParent(); 
        if(parentObject) sq_moveWithParent(parentObject, passiveObject); 
        local animation = sq_CreateAnimation("", "passiveobject/script_sqr_nut_qq506807329/priest/animation/hedgehog/thorn_normal.ani");
        animation.setSpeedRate(binaryDataReader.readFloat()); 
        passiveObject.setCurrentAnimation(animation); 
        local attackInfo = sq_GetCustomAttackInfo(passiveObject, 34); 
        sq_SetCurrentAttackBonusRate(attackInfo, binaryDataReader.readDword()); 
        sq_SetCurrentAttackInfo(passiveObject, attackInfo); 
    }
}