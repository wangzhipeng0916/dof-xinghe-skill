function setState_po_qq506807329new_priest_24374(passiveObject, state, stateVector)
{
    if(!passiveObject) return;
    passiveObject.getVar("state").clear_vector(); 
    passiveObject.getVar("state").push_vector(state);
    local skillId = passiveObject.getVar("skill").get_vector(0);
    
    // 根據技能ID進行不同處理
    handleSkillStateById(passiveObject, skillId, state, stateVector);
}

function handleSkillStateById(passiveObject, skillId, state, stateVector)
{
    switch(skillId)
    {
        case 237: handleSkill237State(passiveObject, state, stateVector); break; // 毀滅神像相關技能
        case 238: handleSkill238State(passiveObject, state, stateVector); break; // 聖潔五角星相關技能
        case 241: handleSkill241State(passiveObject, state, stateVector); break; // 龍之怒相關技能
        case 245: handleSkill245State(passiveObject, state, stateVector); break; // 天譴之怒相關技能
        case 248: handleSkill248State(passiveObject, state, stateVector); break; // 神聖庇護所相關技能
        case 136: handleSkill136State(passiveObject, state, stateVector); break; // 黑暗嚎叫相關技能
        case 132: handleSkill132State(passiveObject, state, stateVector); break; // 惡魔邀請相關技能
    }
}

function handleSkill237State(passiveObject, state, stateVector)
{
    local subType = passiveObject.getVar("subType").get_vector(0); 
    switch(subType)
    {
        case 1:
            switch(state)
            {
                case 10:
                    passiveObject.setTimeEvent(0, 20, 0, true); 
                    break;
                case 11:
                    passiveObject.stopTimeEvent(0); 
                    break;
            }
            break;
        case 2:
            switch(state)
            {
                case 10:
                    local animation = sq_CreateAnimation("", "passiveobject/script_sqr_nut_qq506807329/priest/animation/destroyspirittalisman/fluttering.ani");
                    passiveObject.setCurrentAnimation(animation); 
                    sq_SetCurrentAttackInfoFromCustomIndex(passiveObject, 0); 
                    break;
                case 11:
                    local targetObject = sq_GetObject(passiveObject, sq_GetVectorData(stateVector, 0), sq_GetVectorData(stateVector, 1)); 
                    if(targetObject)
                    {
                        passiveObject.setCurrentPos(targetObject.getXPos(), targetObject.getYPos() + 1, targetObject.getZPos() + sq_GetObjectHeight(targetObject) / 2); 
                        sq_moveWithParent(targetObject, passiveObject); 
                        local animation = sq_CreateAnimation("", "passiveobject/script_sqr_nut_qq506807329/priest/animation/destroyspirittalisman/talisman.ani");
                        passiveObject.setCurrentAnimation(animation); 
                        passiveObject.setTimeEvent(1, passiveObject.getVar().get_vector(4), 1, false); 
                        passiveObject.setTimeEvent(2, passiveObject.getVar().get_vector(5), 0, true); 
                    }
                    break;
            }
            break;
    }
}

function handleSkill238State(passiveObject, state, stateVector)
{
    local subType = passiveObject.getVar("subType").get_vector(0); 
    if(subType == 1)
    {
        switch(state)
        {
            case 10:
                local animation = sq_CreateAnimation("", "passiveobject/script_sqr_nut_qq506807329/priest/animation/pentagonobject/pentagon/startpentagon_01.ani");
                passiveObject.setCurrentAnimation(animation); 
                local scaleRate = (passiveObject.getVar().get_vector(0)).tofloat() / 340.0; 
                animation.setImageRateFromOriginal(scaleRate, scaleRate); 
                animation.setAutoLayerWorkAnimationAddSizeRate(scaleRate); 
                
                local xPos = passiveObject.getXPos(); 
                local yPos = passiveObject.getYPos(); 
                local direction = passiveObject.getDirection(); 
                local blueDragonObj = sq_CreateDrawOnlyObject(passiveObject, "passiveobject/script_sqr_nut_qq506807329/priest/animation/pentagonobject/" + "bluedragon/startbluedragon_02.ani", ENUM_DRAWLAYER_NORMAL, false);
                local redPhoenixObj = sq_CreateDrawOnlyObject(passiveObject, "passiveobject/script_sqr_nut_qq506807329/priest/animation/pentagonobject/" + "RedPhoenix/StartPhoenix_03.ani", ENUM_DRAWLAYER_NORMAL, false);
                local turtleObj = sq_CreateDrawOnlyObject(passiveObject, "passiveobject/script_sqr_nut_qq506807329/priest/animation/pentagonobject/" + "Turtle/StartHyunmu_02.ani", ENUM_DRAWLAYER_NORMAL, false);
                local whiteTigerObj = sq_CreateDrawOnlyObject(passiveObject, "passiveobject/script_sqr_nut_qq506807329/priest/animation/pentagonobject/" + "WhiteTiger/StartWhiteTiger_02.ani", ENUM_DRAWLAYER_NORMAL, false);
                sq_SetCurrentPos(blueDragonObj, sq_GetDistancePos(xPos, direction, (250.0 * scaleRate).tointeger()), yPos - (15.0 * scaleRate).tointeger(), 0); 
                sq_SetCurrentPos(redPhoenixObj, sq_GetDistancePos(xPos, direction, (140.0 * scaleRate).tointeger()), yPos + (50.0 * scaleRate).tointeger(), 0); 
                sq_setCurrentAxisPos(turtleObj, 1, yPos - (55.0 * scaleRate).tointeger()); 
                sq_SetCurrentPos(whiteTigerObj, sq_GetDistancePos(xPos, direction, (-160.0 * scaleRate).tointeger()), yPos + (50.0 * scaleRate).tointeger(), 0); 
                passiveObject.getVar("aniobj").clear_obj_vector(); 
                passiveObject.getVar("aniobj").push_obj_vector(blueDragonObj); 
                passiveObject.getVar("aniobj").push_obj_vector(redPhoenixObj); 
                passiveObject.getVar("aniobj").push_obj_vector(turtleObj); 
                passiveObject.getVar("aniobj").push_obj_vector(whiteTigerObj); 
                passiveObject.sq_PlaySound("PENTAGON_START");
                break;
            case 11:
                local animation = sq_CreateAnimation("", "passiveobject/script_sqr_nut_qq506807329/priest/animation/pentagonobject/pentagon/castworkpentagon_03.ani");
                passiveObject.setCurrentAnimation(animation); 
                local scaleRate = (passiveObject.getVar().get_vector(0)).tofloat() / 340.0; 
                animation.setImageRateFromOriginal(scaleRate, scaleRate); 
                animation.setAutoLayerWorkAnimationAddSizeRate(scaleRate); 
                
                (passiveObject.getVar("aniobj").get_obj_vector(0)).setCurrentAnimation(sq_CreateAnimation("passiveobject/script_sqr_nut_qq506807329/priest/animation/pentagonobject/", "BlueDragon/CastWorkBlueDragon_03.ani"));
                (passiveObject.getVar("aniobj").get_obj_vector(1)).setCurrentAnimation(sq_CreateAnimation("passiveobject/script_sqr_nut_qq506807329/priest/animation/pentagonobject/", "RedPhoenix/CastWorkPhoenix_03.ani"));
                (passiveObject.getVar("aniobj").get_obj_vector(2)).setCurrentAnimation(sq_CreateAnimation("passiveobject/script_sqr_nut_qq506807329/priest/animation/pentagonobject/", "Turtle/CastWorkHyunmu_03.ani"));
                (passiveObject.getVar("aniobj").get_obj_vector(3)).setCurrentAnimation(sq_CreateAnimation("passiveobject/script_sqr_nut_qq506807329/priest/animation/pentagonobject/", "WhiteTiger/CastWorkWhiteTiger_03.ani"));
                
                local backBarrierObj = sq_CreateDrawOnlyObject(passiveObject, "passiveobject/script_sqr_nut_qq506807329/priest/animation/pentagonobject/" + "Barrier/CastBarrierBack_01.ani", ENUM_DRAWLAYER_NORMAL, false);
                local frontBarrierObj = sq_CreateDrawOnlyObject(passiveObject, "passiveobject/script_sqr_nut_qq506807329/priest/animation/pentagonobject/" + "Barrier/CastBarrierFront_01.ani", ENUM_DRAWLAYER_NORMAL, false);
                sq_setCurrentAxisPos(backBarrierObj, 1, passiveObject.getYPos() - 1); 
                passiveObject.getVar("aniobj").push_obj_vector(backBarrierObj); 
                passiveObject.getVar("aniobj").push_obj_vector(frontBarrierObj); 
                local backBarrierAni = backBarrierObj.getCurrentAnimation(); 
                local frontBarrierAni = frontBarrierObj.getCurrentAnimation(); 
                backBarrierAni.setImageRateFromOriginal(scaleRate, scaleRate); 
                backBarrierAni.setAutoLayerWorkAnimationAddSizeRate(scaleRate); 
                frontBarrierAni.setImageRateFromOriginal(scaleRate, scaleRate); 
                frontBarrierAni.setAutoLayerWorkAnimationAddSizeRate(scaleRate); 
                local xPos = passiveObject.getXPos(); 
                local yPos = passiveObject.getYPos(); 
                local zPos = passiveObject.getZPos(); 
                local range = passiveObject.getVar().get_vector(0); 
                local verticalRange = (85.0 * scaleRate).tointeger(); 
                local heightRange = (380.0 * scaleRate).tointeger(); 
                local objectManager = passiveObject.getObjectManager(); 
                for(local i = 0; i < objectManager.getCollisionObjectNumber(); i++)
                {
                    local collisionObj = objectManager.getCollisionObject(i); 
                    if(collisionObj
                        && collisionObj.isObjectType(OBJECTTYPE_ACTIVE)
                        && passiveObject.isEnemy(collisionObj)
                        && collisionObj.isInDamagableState(passiveObject)
                        && sq_IsGrabable(passiveObject, collisionObj) 
                        && sq_IsHoldable(passiveObject, collisionObj) 
                        && !sq_IsFixture(collisionObj))
                    {
                        local activeObj = sq_GetCNRDObjectToActiveObject(collisionObj); 
                        if(!activeObj.isDead()
                            && !CNSquirrelAppendage.sq_IsAppendAppendage(collisionObj, "character/xinghe/priest/qumo/pentagon/ap_pentagon.nut")) 
                        {
                            if(sq_Abs(activeObj.getXPos() - xPos) <= range
                                && sq_Abs(activeObj.getYPos() - yPos) <= verticalRange
                                && sq_Abs(activeObj.getZPos() - zPos) <= heightRange)
                            {
                                CNSquirrelAppendage.sq_AppendAppendage(collisionObj, passiveObject, 238, true, "character/xinghe/priest/qumo/pentagon/ap_pentagon.nut", true);
                                passiveObject.getVar().push_obj_vector(collisionObj); 
                            }
                        }
                    }
                }
                passiveObject.sq_PlaySound("PENTAGON_BARRIER");
                break;
            case 12:
                local animation = sq_CreateAnimation("", "passiveobject/script_sqr_nut_qq506807329/priest/animation/pentagonobject/pentagon/workpentagon_01.ani");
                passiveObject.setCurrentAnimation(animation); 
                local scaleRate = (passiveObject.getVar().get_vector(0)).tofloat() / 340.0; 
                animation.setImageRateFromOriginal(scaleRate, scaleRate); 
                animation.setAutoLayerWorkAnimationAddSizeRate(scaleRate); 
                sq_SetAttackBoundingBoxSizeRate(animation, scaleRate, scaleRate, scaleRate); 
                sq_SetCurrentAttackInfo(passiveObject, null);
                passiveObject.setTimeEvent(0, passiveObject.getVar().get_vector(1), 1, false); 
                passiveObject.setTimeEvent(1, passiveObject.getVar().get_vector(2), 0, false); 
                
                (passiveObject.getVar("aniobj").get_obj_vector(0)).setCurrentAnimation(sq_CreateAnimation("passiveobject/script_sqr_nut_qq506807329/priest/animation/pentagonobject/", "BlueDragon/WorkBlueDragon_02.ani"));
                (passiveObject.getVar("aniobj").get_obj_vector(1)).setCurrentAnimation(sq_CreateAnimation("passiveobject/script_sqr_nut_qq506807329/priest/animation/pentagonobject/", "RedPhoenix/WorkPhoenix_02.ani"));
                (passiveObject.getVar("aniobj").get_obj_vector(2)).setCurrentAnimation(sq_CreateAnimation("passiveobject/script_sqr_nut_qq506807329/priest/animation/pentagonobject/", "Turtle/WorkHyunmu_02.ani"));
                (passiveObject.getVar("aniobj").get_obj_vector(3)).setCurrentAnimation(sq_CreateAnimation("passiveobject/script_sqr_nut_qq506807329/priest/animation/pentagonobject/", "WhiteTiger/WorkWhiteTiger_02.ani"));
                
                local backBarrierAni = passiveObject.getVar().GetAnimationMap("GatherBarrierBack_01", "passiveobject/script_sqr_nut_qq506807329/priest/animation/pentagonobject/Barrier/GatherBarrierBack_01.ani");
                local frontBarrierAni = passiveObject.getVar().GetAnimationMap("GatherBarrierFront_01", "passiveobject/script_sqr_nut_qq506807329/priest/animation/pentagonobject/Barrier/GatherBarrierFront_01.ani");
                backBarrierAni.setImageRateFromOriginal(scaleRate, scaleRate); 
                backBarrierAni.setAutoLayerWorkAnimationAddSizeRate(scaleRate); 
                frontBarrierAni.setImageRateFromOriginal(scaleRate, scaleRate); 
                frontBarrierAni.setAutoLayerWorkAnimationAddSizeRate(scaleRate); 
                (passiveObject.getVar("aniobj").get_obj_vector(4)).setCurrentAnimation(backBarrierAni);
                (passiveObject.getVar("aniobj").get_obj_vector(5)).setCurrentAnimation(frontBarrierAni);
                
                local scaledRate = scaleRate * 1000000.0;
                passiveObject.getVar("rate").clear_vector(); 
                passiveObject.getVar("rate").push_vector(scaledRate.tointeger()); 
                passiveObject.getVar("rate").push_vector((scaledRate * 0.442307).tointeger()); 
                passiveObject.getVar("rate").push_vector(0); 
                passiveObject.getVar("time").clear_vector(); 
                passiveObject.getVar("time").push_vector(sq_GetObjectTime(passiveObject)); 
                passiveObject.sq_PlaySound("PENTAGON_BARRIER_GATHER");
                break;
            case 13:
                passiveObject.stopTimeEvent(1); 
                sq_SetCurrentAttackInfo(passiveObject, null);
                local animation = sq_CreateAnimation("", "passiveobject/script_sqr_nut_qq506807329/priest/animation/pentagonobject/pentagon/endpentagon_03.ani");
                passiveObject.setCurrentAnimation(animation); 
                local scaleRate = (passiveObject.getVar().get_vector(0)).tofloat() / 340.0; 
                animation.setImageRateFromOriginal(scaleRate, scaleRate); 
                animation.setAutoLayerWorkAnimationAddSizeRate(scaleRate); 
                sq_SetAttackBoundingBoxSizeRate(animation, scaleRate, scaleRate, scaleRate); 
                
                (passiveObject.getVar("aniobj").get_obj_vector(0)).setCurrentAnimation(sq_CreateAnimation("passiveobject/script_sqr_nut_qq506807329/priest/animation/pentagonobject/", "BlueDragon/EndBlueDragon_02.ani"));
                (passiveObject.getVar("aniobj").get_obj_vector(1)).setCurrentAnimation(sq_CreateAnimation("passiveobject/script_sqr_nut_qq506807329/priest/animation/pentagonobject/", "RedPhoenix/EndPhoenix_02.ani"));
                (passiveObject.getVar("aniobj").get_obj_vector(2)).setCurrentAnimation(sq_CreateAnimation("passiveobject/script_sqr_nut_qq506807329/priest/animation/pentagonobject/", "Turtle/EndHyunmu_02.ani"));
                (passiveObject.getVar("aniobj").get_obj_vector(3)).setCurrentAnimation(sq_CreateAnimation("passiveobject/script_sqr_nut_qq506807329/priest/animation/pentagonobject/", "WhiteTiger/EndWhiteTiger_02.ani"));
                
                local currentRate = (passiveObject.getVar("rate").get_vector(2)).tofloat() / 1000000.0;
                local backBarrierAni = sq_CreateAnimation("passiveobject/script_sqr_nut_qq506807329/priest/animation/pentagonobject/", "Barrier/EndBarrierBack_01.ani");
                local frontBarrierAni = sq_CreateAnimation("passiveobject/script_sqr_nut_qq506807329/priest/animation/pentagonobject/", "Barrier/EndBarrierFront_01.ani");
                backBarrierAni.setImageRateFromOriginal(currentRate, currentRate); 
                backBarrierAni.setAutoLayerWorkAnimationAddSizeRate(currentRate); 
                frontBarrierAni.setImageRateFromOriginal(currentRate, currentRate); 
                frontBarrierAni.setAutoLayerWorkAnimationAddSizeRate(currentRate); 
                (passiveObject.getVar("aniobj").get_obj_vector(4)).setCurrentAnimation(backBarrierAni);
                (passiveObject.getVar("aniobj").get_obj_vector(5)).setCurrentAnimation(frontBarrierAni);
                break;
        }
    }
}

function handleSkill241State(passiveObject, state, stateVector)
{
    local subType = passiveObject.getVar("subType").get_vector(0); 
    switch(subType)
    {
        case 1:
            switch(state)
            {
                case 10:
                    sq_ChangeDrawLayer(passiveObject, ENUM_DRAWLAYER_BOTTOM); 
                    local animation = sq_CreateAnimation("", "passiveobject/script_sqr_nut_qq506807329/priest/animation/advanceddragon/advanceddragon_bright/startmagiccircle_1.ani"); 
                    local scaleRate = passiveObject.getVar().getFloat(0); 
                    animation.setImageRateFromOriginal(scaleRate, scaleRate); 
                    animation.setAutoLayerWorkAnimationAddSizeRate(scaleRate); 
                    passiveObject.setCurrentAnimation(animation); 
                    
                    local xPos = passiveObject.getXPos(); local yPos = passiveObject.getYPos();
                    local direction = sq_GetDirection(passiveObject); 
                    local sizeRate = passiveObject.getVar().getFloat(1); 
                    local blueDragonObj = sq_CreateDrawOnlyObject(passiveObject, "passiveobject/script_sqr_nut_qq506807329/priest/animation/advanceddragon/advanceddragon_bright/startbluedragon_1.ani", ENUM_DRAWLAYER_NORMAL, false); 
                    local whiteTigerObj = sq_CreateDrawOnlyObject(passiveObject, "passiveobject/script_sqr_nut_qq506807329/priest/animation/advanceddragon/advanceddragon_bright/startwhitetiger_1.ani", ENUM_DRAWLAYER_NORMAL, false); 
                    local turtleObj = sq_CreateDrawOnlyObject(passiveObject, "passiveobject/script_sqr_nut_qq506807329/priest/animation/advanceddragon/advanceddragon_bright/starthyunmu_1.ani", ENUM_DRAWLAYER_NORMAL, false); 
                    local phoenixObj = sq_CreateDrawOnlyObject(passiveObject, "passiveobject/script_sqr_nut_qq506807329/priest/animation/advanceddragon/advanceddragon_bright/startlphoenix_1.ani", ENUM_DRAWLAYER_NORMAL, false); 
                    sq_setCurrentAxisPos(blueDragonObj, 0, sq_GetDistancePos(xPos, direction, (172.0 * sizeRate).tointeger())); 
                    sq_setCurrentAxisPos(whiteTigerObj, 0, sq_GetDistancePos(xPos, direction, (-172.0 * sizeRate).tointeger())); 
                    sq_setCurrentAxisPos(turtleObj, 1, yPos + (50.0 * sizeRate).tointeger()); 
                    sq_setCurrentAxisPos(phoenixObj, 1, yPos + (-50.0 * sizeRate).tointeger()); 
                    passiveObject.getVar("aniobj").clear_obj_vector(); 
                    passiveObject.getVar("aniobj").push_obj_vector(blueDragonObj); 
                    passiveObject.getVar("aniobj").push_obj_vector(whiteTigerObj); 
                    passiveObject.getVar("aniobj").push_obj_vector(turtleObj); 
                    passiveObject.getVar("aniobj").push_obj_vector(phoenixObj); 
                    break;
                case 11:
                    sq_ChangeDrawLayer(passiveObject, ENUM_DRAWLAYER_NORMAL); 
                    local animation = sq_CreateAnimation("", "passiveobject/script_sqr_nut_qq506807329/priest/Animation/AdvancedDragon/AdvancedDragon_Bright/StartDragon_circle_aura_front.ani"); 
                    local scaleRate = passiveObject.getVar().getFloat(0); 
                    animation.setImageRateFromOriginal(scaleRate, scaleRate); 
                    animation.setAutoLayerWorkAnimationAddSizeRate(scaleRate); 
                    passiveObject.setCurrentAnimation(animation); 
                    local backgroundAni = CreateAniRate(passiveObject, "passiveobject/script_sqr_nut_qq506807329/priest/animation/advanceddragon/advanceddragon_bright/workmagiccircle_1.ani", ENUM_DRAWLAYER_BOTTOM, passiveObject.getXPos(), passiveObject.getYPos(), passiveObject.getZPos(), scaleRate, false); 
                    passiveObject.getVar("aniobj_new").clear_obj_vector(); 
                    passiveObject.getVar("aniobj_new").push_obj_vector(backgroundAni); 
                    sq_SetMyShake(passiveObject, 100, 3); 
                    break;
                case 12:
                    local animation = sq_CreateAnimation("", "passiveobject/script_sqr_nut_qq506807329/priest/animation/advanceddragon/advanceddragon_bright/workdragon_dragon_normal.ani"); 
                    local scaleRate = passiveObject.getVar().getFloat(0); 
                    animation.setImageRateFromOriginal(scaleRate, scaleRate); 
                    animation.setAutoLayerWorkAnimationAddSizeRate(scaleRate); 
                    sq_SetAttackBoundingBoxSizeRate(animation, scaleRate, scaleRate, scaleRate); 
                    animation.setSpeedRate(220.0); 
                    passiveObject.setCurrentAnimation(animation); 
                    local attackInfo = sq_GetCustomAttackInfo(passiveObject, 5); 
                    sq_SetCurrentAttackBonusRate(attackInfo, passiveObject.getVar().get_vector(2)); 
                    sq_SetCurrentAttackInfo(passiveObject, attackInfo); 
                    passiveObject.setTimeEvent(0, passiveObject.getVar().get_vector(1), 1, false); 
                    passiveObject.setTimeEvent(1, passiveObject.getVar().get_vector(0), 0, false); 
                    break;
                case 13:
                    passiveObject.stopTimeEvent(1); 
                    local animation = sq_CreateAnimation("", "passiveobject/script_sqr_nut_qq506807329/priest/animation/advanceddragon/advanceddragon_bright/enddragon_dragon_normal.ani"); 
                    local scaleRate = passiveObject.getVar().getFloat(0); 
                    animation.setImageRateFromOriginal(scaleRate, scaleRate); 
                    animation.setAutoLayerWorkAnimationAddSizeRate(scaleRate); 
                    animation.setSpeedRate(170.0); 
                    passiveObject.setCurrentAnimation(animation); 
                    if(passiveObject.isMyControlObject())
                        sq_flashScreen(passiveObject, 100, 100, 200, 204, sq_RGB(255, 255, 255), GRAPHICEFFECT_NONE, ENUM_DRAWLAYER_BOTTOM); 
                    
                    (passiveObject.getVar("aniobj").get_obj_vector(0)).setCurrentAnimation(sq_CreateAnimation("passiveobject/script_sqr_nut_qq506807329/priest/animation/advanceddragon/advanceddragon_bright/", "endbluedragon_1.ani"));
                    (passiveObject.getVar("aniobj").get_obj_vector(1)).setCurrentAnimation(sq_CreateAnimation("passiveobject/script_sqr_nut_qq506807329/priest/animation/advanceddragon/advanceddragon_bright/", "endwhitetiger_1.ani"));
                    (passiveObject.getVar("aniobj").get_obj_vector(2)).setCurrentAnimation(sq_CreateAnimation("passiveobject/script_sqr_nut_qq506807329/priest/animation/advanceddragon/advanceddragon_bright/", "endhyunmu_1.ani"));
                    (passiveObject.getVar("aniobj").get_obj_vector(3)).setCurrentAnimation(sq_CreateAnimation("passiveobject/script_sqr_nut_qq506807329/priest/animation/advanceddragon/advanceddragon_bright/", "endphoenix_1.ani"));
                    break;
                case 14:
                    local animation = sq_CreateAnimation("", "passiveobject/script_sqr_nut_qq506807329/priest/animation/advanceddragon/advanceddragon_bright/finish/finishdragon_11.ani"); 
                    local scaleRate = passiveObject.getVar().getFloat(1); 
                    local finalScaleRate = scaleRate + 0.4; 
                    animation.setImageRateFromOriginal(finalScaleRate, finalScaleRate); 
                    animation.setAutoLayerWorkAnimationAddSizeRate(finalScaleRate); 
                    sq_SetAttackBoundingBoxSizeRate(animation, finalScaleRate, finalScaleRate, finalScaleRate); 
                    passiveObject.setCurrentAnimation(animation); 
                    local attackInfo = sq_GetCustomAttackInfo(passiveObject, 6); 
                    sq_SetCurrentAttackBonusRate(attackInfo, passiveObject.getVar().get_vector(3)); 
                    sq_SetCurrentAttackInfo(passiveObject, attackInfo); 
                    local xPos = passiveObject.getXPos(); local yPos = passiveObject.getYPos(); local zPos = passiveObject.getZPos();
                    CreateAniRate(passiveObject, "passiveobject/script_sqr_nut_qq506807329/priest/animation/advanceddragon/advanceddragon_bright/finish/finishdragonbottom_5.ani", ENUM_DRAWLAYER_BOTTOM, xPos, yPos, zPos, scaleRate, false); 
                    CreateAniRate(passiveObject, "passiveobject/script_sqr_nut_qq506807329/priest/animation/advanceddragon/advanceddragon_bright/finish/finishdragonhead_6.ani", ENUM_DRAWLAYER_NORMAL, xPos, yPos, zPos, scaleRate, false); 
                    CreateAniRate(passiveObject, "passiveobject/script_sqr_nut_qq506807329/priest/animation/advanceddragon/advanceddragon_bright/flash_red_doom.ani", ENUM_DRAWLAYER_NORMAL, xPos, yPos, zPos, scaleRate, false); 
                    sq_CreateDrawOnlyObject(passiveObject, "passiveobject/script_sqr_nut_qq506807329/priest/animation/advanceddragon/advanceddragon_bright/finish/finishdragon_focusline.ani", ENUM_DRAWLAYER_COVER, true); 
                    RemoveAllFlash(passiveObject); 
                    if(passiveObject.isMyControlObject())
                        sq_flashScreen(passiveObject, 0, 0, 1000, 150, sq_RGB(0, 0, 0), GRAPHICEFFECT_NONE, ENUM_DRAWLAYER_BOTTOM); 
                    
                    local backgroundScale = passiveObject.getVar().getFloat(0); 
                    local endAnimation = sq_CreateAnimation("", "passiveobject/script_sqr_nut_qq506807329/priest/animation/advanceddragon/advanceddragon_bright/endmagiccircle_1.ani");
                    endAnimation.setImageRateFromOriginal(backgroundScale, backgroundScale); 
                    endAnimation.setAutoLayerWorkAnimationAddSizeRate(backgroundScale); 
                    local backgroundObj = passiveObject.getVar("aniobj_new").get_obj_vector(0); 
                    backgroundObj.setCurrentAnimation(endAnimation); 
                    sq_ChangeDrawLayer(backgroundObj, ENUM_DRAWLAYER_BOTTOM); 
                    break;
            }
            break;
    }
}

function handleSkill245State(passiveObject, state, stateVector)
{
    local subType = passiveObject.getVar("subType").get_vector(0); 
    if(subType == 1)
    {
        if(state == 10)
        {
            local animation = passiveObject.getCurrentAnimation(); 
            animation.setCurrentFrameWithChildLayer(sq_GetAniFrameNumber(animation, 0) - 1); 
            passiveObject.getVar().clear_vector(); 
            passiveObject.getVar().push_vector(sq_GetObjectTime(passiveObject)); 
        }
    }
    else if(subType == 2)
    {
        if(state == 10)
        {
            local parentObject = sq_GetCNRDObjectToSQRCharacter(passiveObject.getParent()); 
            if(parentObject)
            {
                local animation = sq_GetCustomAni(parentObject, 161); 
                sq_Rewind(animation); 
                passiveObject.setCurrentAnimation(animation); 
                passiveObject.getVar("move").clear_vector(); 
                passiveObject.getVar("move").push_vector(passiveObject.getXPos()); 
                passiveObject.getVar("move").push_vector(passiveObject.getYPos()); 
            }
        }
        else if(state == 11)
        {
            passiveObject.getVar("move").clear_vector(); 
            local parentObject = sq_GetCNRDObjectToSQRCharacter(passiveObject.getParent()); 
            if(parentObject)
            {
                local animation = sq_GetCustomAni(parentObject, 159); 
                sq_Rewind(animation); 
                passiveObject.setCurrentAnimation(animation); 
                local attackInfo = sq_GetCustomAttackInfo(parentObject, 111); 
                sq_SetCurrentAttackBonusRate(attackInfo, passiveObject.getVar().get_vector(0)); 
                sq_SetCurrentAttackInfo(passiveObject, attackInfo); 
                passiveObject.setDirection(sq_GetOppositeDirection(passiveObject.getDirection())); 
            }
        }
    }
}

function handleSkill248State(passiveObject, state, stateVector)
{
    local subType = passiveObject.getVar("subType").get_vector(0); 
    if(subType == 1)
    {
        switch(state)
        {
            case 10:
                if(passiveObject.isMyControlObject())
                {
                    local animation = sq_CreateAnimation("", "common/commoneffect/animation/aimpointmark.ani"); 
                    passiveObject.setCurrentAnimation(animation); 
                }
                break;
            case 11:
                passiveObject.setCurrentPos(sq_GetVectorData(stateVector, 0), sq_GetVectorData(stateVector, 1), 0); 
                sq_CreateDrawOnlyObject(passiveObject, "common/commoneffect/animation/aimpointmarkdisable.ani", ENUM_DRAWLAYER_BOTTOM, true); 
                sq_ChangeDrawLayer(passiveObject, ENUM_DRAWLAYER_BOTTOM); 
                local animation = sq_CreateAnimation("", "passiveobject/script_sqr_nut_qq506807329/priest/animation/hollysanctuary/start_b_magic3.ani"); 
                passiveObject.setCurrentAnimation(animation); 
                break;
            case 12:
                local xPos = sq_GetVectorData(stateVector, 0);
                local yPos = sq_GetVectorData(stateVector, 1);
                if(xPos != -1 && yPos != -1) passiveObject.setCurrentPos(sq_GetVectorData(stateVector, 0), sq_GetVectorData(stateVector, 1), 0); 
                passiveObject.getVar().set_vector(2, passiveObject.getVar().get_vector(2) - 1); 
                local animation = passiveObject.getVar().GetAnimationMap("loop_b_magic2", "passiveobject/script_sqr_nut_qq506807329/priest/animation/hollysanctuary/loop_b_magic2.ani"); 
                animation.setCurrentFrameWithChildLayer(0);
                passiveObject.setCurrentAnimation(animation); 
                local attackInfo = sq_GetCustomAttackInfo(passiveObject, 11); 
                sq_SetCurrentAttackBonusRate(attackInfo, passiveObject.getVar().get_vector(1)); 
                sq_SetCurrentAttackInfo(passiveObject, attackInfo); 
                sq_CreateDrawOnlyObject(passiveObject, "passiveobject/script_sqr_nut_qq506807329/priest/animation/hollysanctuary/loop_b2_1.ani", ENUM_DRAWLAYER_NORMAL, true); 
                break;
            case 13:
                local animation = sq_CreateAnimation("", "passiveobject/script_sqr_nut_qq506807329/priest/animation/hollysanctuary/end_b_magic3.ani"); 
                passiveObject.setCurrentAnimation(animation); 
                local attackInfo = sq_GetCustomAttackInfo(passiveObject, 12); 
                sq_SetCurrentAttackBonusRate(attackInfo, passiveObject.getVar().get_vector(3)); 
                sq_SetCurrentAttackInfo(passiveObject, attackInfo); 
                sq_CreateDrawOnlyObject(passiveObject, "passiveobject/script_sqr_nut_qq506807329/priest/animation/hollysanctuary/end_c6.ani", ENUM_DRAWLAYER_NORMAL, true); 
                passiveObject.sq_PlaySound("HOLYSANCTUARY_EXP");
                break;
        }
    }
}

function handleSkill136State(passiveObject, state, stateVector)
{
    local subType = passiveObject.getVar("subType").get_vector(0); 
    if(subType == 2)
    {
        switch(state)
        {
            case 10:
                local animation = sq_CreateAnimation("", "passiveobject/script_sqr_nut_qq506807329/priest/animation/darkhowling/start_soul _normal.ani"); 
                local scaleRate = 0.65; 
                animation.setImageRateFromOriginal(scaleRate, scaleRate); 
                animation.setAutoLayerWorkAnimationAddSizeRate(scaleRate); 
                passiveObject.setCurrentAnimation(animation); 
                local zPos = passiveObject.getZPos(); 
                passiveObject.getVar("move").clear_vector(); 
                passiveObject.getVar("move").push_vector(zPos); 
                passiveObject.getVar("move").push_vector(zPos + 15); 
                passiveObject.setTimeEvent(1, 40, 0, true); 
                break;
            case 11:
                local animation = sq_CreateAnimation("", "passiveobject/script_sqr_nut_qq506807329/priest/animation/darkhowling/loop_soul _normal.ani"); 
                local scaleRate = 0.65; 
                animation.setImageRateFromOriginal(scaleRate, scaleRate); 
                animation.setAutoLayerWorkAnimationAddSizeRate(scaleRate); 
                passiveObject.setCurrentAnimation(animation); 
                sq_SetCurrentAttackInfoFromCustomIndex(passiveObject, 26); 
                passiveObject.getVar("move").clear_vector(); 
                passiveObject.getVar("move").push_vector(sq_GetObjectTime(passiveObject)); 
                passiveObject.getVar("move").push_vector(passiveObject.getZPos()); 
                break;
            case 12:
                passiveObject.stopTimeEvent(1); 
                local animation = sq_CreateAnimation("", "passiveobject/script_sqr_nut_qq506807329/priest/animation/darkhowling/boom_normal.ani"); 
                local scaleRate = 0.75; 
                animation.setImageRateFromOriginal(scaleRate, scaleRate); 
                animation.setAutoLayerWorkAnimationAddSizeRate(scaleRate); 
                passiveObject.setCurrentAnimation(animation); 
                break;
        }
    }
}

function handleSkill132State(passiveObject, state, stateVector)
{
    local subType = passiveObject.getVar("subType").get_vector(0); 
    switch(subType)
    {
        case 1:
            local effectType = passiveObject.getVar().get_vector(0); 
            switch(state)
            {
                case 10:
                    local animation = null; 
                    if(effectType == 1)
                        animation = sq_CreateAnimation("", "passiveobject/script_sqr_nut_qq506807329/priest/animation/inviteofdevil/devilinvitation_r_loop_02.ani");
                    else if(effectType == 2)
                        animation = sq_CreateAnimation("", "passiveobject/script_sqr_nut_qq506807329/priest/animation/inviteofdevil/devilinvitation_w_r_loop_01.ani");
                    passiveObject.setCurrentAnimation(animation); 
                    if(!passiveObject.isExistTimeEvent(0)) 
                        passiveObject.setTimeEvent(0, 200, 1, false); 
                    break;
                case 11:
                    local animation = null; 
                    if(effectType == 1)
                        animation = sq_CreateAnimation("", "passiveobject/script_sqr_nut_qq506807329/priest/animation/inviteofdevil/devilinvitation_r_hit_loop_01.ani");
                    else if(effectType == 2)
                        animation = sq_CreateAnimation("", "passiveobject/script_sqr_nut_qq506807329/priest/animation/inviteofdevil/devilinvitation_w_r_hit_loop_01.ani");
                    passiveObject.setCurrentAnimation(animation); 
                    break;
                case 12:
                    local animation = null; 
                    if(effectType == 1)
                        animation = sq_CreateAnimation("", "passiveobject/script_sqr_nut_qq506807329/priest/animation/inviteofdevil/devilinvitation_r_boom_02.ani");
                    else if(effectType == 2)
                        animation = sq_CreateAnimation("", "passiveobject/script_sqr_nut_qq506807329/priest/animation/inviteofdevil/devilinvitation_w_r_boom_02.ani");
                    passiveObject.setCurrentAnimation(animation); 
                    break;
            }
            break;
        case 2:
            local effectType = passiveObject.getVar().get_vector(0); 
            switch(state)
            {
                case 10:
                    local animation = null; 
                    if(effectType == 1)
                        animation = sq_CreateAnimation("", "passiveobject/script_sqr_nut_qq506807329/priest/animation/inviteofdevil/devilinvitation_l_loop_01.ani");
                    else if(effectType == 2)
                        animation = sq_CreateAnimation("", "passiveobject/script_sqr_nut_qq506807329/priest/animation/inviteofdevil/devilinvitation_w_l_loop_04.ani");
                    passiveObject.setCurrentAnimation(animation); 
                    if(!passiveObject.isExistTimeEvent(0)) 
                        passiveObject.setTimeEvent(0, 200, 1, false); 
                    break;
                case 11:
                    local animation = null; 
                    if(effectType == 1)
                        animation = sq_CreateAnimation("", "passiveobject/script_sqr_nut_qq506807329/priest/animation/inviteofdevil/devilinvitation_l_hit_loop_01.ani");
                    else if(effectType == 2)
                        animation = sq_CreateAnimation("", "passiveobject/script_sqr_nut_qq506807329/priest/animation/inviteofdevil/devilinvitation_w_l_hit_loop_04.ani");
                    passiveObject.setCurrentAnimation(animation); 
                    break;
                case 12:
                    local animation = null; 
                    if(effectType == 1)
                        animation = sq_CreateAnimation("", "passiveobject/script_sqr_nut_qq506807329/priest/animation/inviteofdevil/devilinvitation_l_boom_02.ani");
                    else if(effectType == 2)
                        animation = sq_CreateAnimation("", "passiveobject/script_sqr_nut_qq506807329/priest/animation/inviteofdevil/devilinvitation_w_l_boom_02.ani");
                    passiveObject.setCurrentAnimation(animation); 
                    break;
            }
            break;
    }
}