// ---------------------codeStart---------------------// 

/**
 * 處理查克拉之神技能效果
 * @param {對象} obj - 技能施放者對象
 */
function onProcCon_chakraofgod(obj)
{
    if (!obj) return;
    
    local skillLevel = sq_GetSkillLevel(obj, SKILL_CHAKRAOFGOD);
    if (skillLevel > 0)
    {
        // 火焰屬性效果處理
        if (CNSquirrelAppendage.sq_IsAppendAppendage(obj, "character/xinghe/priest/qumo/shishenzhili/ap_mailun_lieyan.nut") == true)
        {
            local passiveObj1 = obj.getMyPassiveObject(24001, obj.getMyPassiveObjectCount(24001) - 1);
            if (passiveObj1 && passiveObj1.getVar("flag").size_vector() == 0)
            {
                if (passiveObj1.isMyControlObject())
                {
                    passiveObj1.getVar("flag").clear_vector();
                    passiveObj1.getVar("flag").push_vector(1);
                    local animation1 = sq_AddDrawOnlyAniFromParent(passiveObj1, "character/priest/effect/animation/chakraofgod/fire/quakearea_crashb.ani", -30, 0, 0);
                    obj.sq_SendCreatePassiveObjectPacket(26060, 0, 40, -50, 0);
                }
            }
            
            local passiveObj2 = obj.getMyPassiveObject(24014, obj.getMyPassiveObjectCount(24014) - 1);
            if (passiveObj2 && passiveObj2.getVar("flag").size_vector() == 0)
            {
                if (passiveObj2.isMyControlObject())
                {
                    passiveObj2.getVar("flag").clear_vector();
                    passiveObj2.getVar("flag").push_vector(1);
                    local imageObj = sq_CreateDrawOnlyObject(passiveObj2, "character/priest/effect/animation/chakraofgod/fire/throwweapon_weaponh3.ani", ENUM_DRAWLAYER_NORMAL, true);
                    local imageAnimation = imageObj.getCurrentAnimation();
                    local sizeValue = obj.sq_GetIntData(50, 5);
                    sizeValue = sizeValue.tofloat() / 100.0;
                    imageAnimation.Proc();
                    imageAnimation.setImageRateFromOriginal(sizeValue, sizeValue);
                    imageAnimation.setAutoLayerWorkAnimationAddSizeRate(sizeValue);
                    sq_moveWithParent(passiveObj2, imageObj);
                }
            }
            
            local passiveObj3 = obj.getMyPassiveObject(24015, obj.getMyPassiveObjectCount(24015) - 1);
            if (passiveObj3 && passiveObj3.getVar("flag").size_vector() == 0)
            {
                if (passiveObj3.isMyControlObject())
                {
                    passiveObj3.getVar("flag").clear_vector();
                    passiveObj3.getVar("flag").push_vector(1);
                    local animation3 = sq_AddDrawOnlyAniFromParent(passiveObj3, "character/priest/effect/animation/chakraofgod/fire/repeatedsmash_swingfinalc.ani", 20, -20, 0);
                    obj.sq_SendCreatePassiveObjectPacket(26060, 0, 170, -50, 0);
                }
            }
            
            local passiveObj4 = obj.getMyPassiveObject(24016, obj.getMyPassiveObjectCount(24016) - 1);
            if (passiveObj4 && passiveObj4.getVar("flag").size_vector() == 0)
            {
                if (passiveObj4.isMyControlObject())
                {
                    passiveObj4.getVar("flag").clear_vector();
                    passiveObj4.getVar("flag").push_vector(1);
                    obj.sq_SendCreatePassiveObjectPacket(26060, 0, 150, -50, 0);
                }
            }
            
            local passiveObj5 = obj.getMyPassiveObject(24018, obj.getMyPassiveObjectCount(24018) - 1);
            if (passiveObj5 && passiveObj5.getVar("flag").size_vector() == 0)
            {
                if (passiveObj5.isMyControlObject())
                {
                    passiveObj5.getVar("flag").clear_vector();
                    passiveObj5.getVar("flag").push_vector(1);
                    local animation5 = sq_AddDrawOnlyAniFromParent(passiveObj5, "character/priest/effect/animation/chakraofgod/fire/antiairupper_a.ani", 170, 0, 0);
                    obj.sq_SendCreatePassiveObjectPacket(26060, 0, -200, -50, 0);
                }
            }
            
            local passiveObj6 = obj.getMyPassiveObject(24041, obj.getMyPassiveObjectCount(24041) - 1);
            if (passiveObj6 && passiveObj6.getVar("flag").size_vector() == 0)
            {
                if (passiveObj6.isMyControlObject())
                {
                    passiveObj6.getVar("flag").clear_vector();
                    passiveObj6.getVar("flag").push_vector(1);
                    local animation6 = sq_AddDrawOnlyAniFromParent(passiveObj6, "character/priest/effect/animation/chakraofgod/fire/groundcrash_smashfinalc.ani", -130, 0, 0);
                    obj.sq_SendCreatePassiveObjectPacket(26060, 0, 130, -50, 0);
                }
            }
            
            local passiveObj7 = obj.getMyPassiveObject(24036, obj.getMyPassiveObjectCount(24036) - 1);
            if (passiveObj7 && passiveObj7.getVar("flag").size_vector() == 0)
            {
                if (passiveObj7.isMyControlObject())
                {
                    passiveObj7.getVar("flag").clear_vector();
                    passiveObj7.getVar("flag").push_vector(1);
                    local animation7 = sq_AddDrawOnlyAniFromParent(passiveObj7, "character/priest/effect/animation/chakraofgod/fire/repeatedsmash_swingfinalc.ani", 20, -20, 0);
                    obj.sq_SendCreatePassiveObjectPacket(26060, 0, 170, -50, 0);
                }
            }
            
            local passiveObj8 = obj.getMyPassiveObject(24037, obj.getMyPassiveObjectCount(24037) - 1);
            if (passiveObj8 && passiveObj8.getVar("flag").size_vector() == 0)
            {
                if (passiveObj8.isMyControlObject())
                {
                    passiveObj8.getVar("flag").clear_vector();
                    passiveObj8.getVar("flag").push_vector(1);
                    local animation8a = sq_AddDrawOnlyAniFromParent(passiveObj8, "character/priest/effect/animation/chakraofgod/fire/repeatedsmash_swingfinalc.ani", 20, -20, 0);
                    local animation8b = sq_AddDrawOnlyAniFromParent(passiveObj8, "character/priest/effect/animation/chakraofgod/fire/repeatedsmashex_effect.ani", -200, 0, 0);
                    obj.sq_SendCreatePassiveObjectPacket(26060, 0, 170, -50, 0);
                }
            }
        }
        
        // 聖光屬性效果處理
        if (CNSquirrelAppendage.sq_IsAppendAppendage(obj, "character/xinghe/priest/qumo/shishenzhili/ap_mailun_shengguang.nut") == true)
        {
            local passiveObj1 = obj.getMyPassiveObject(24001, obj.getMyPassiveObjectCount(24001) - 1);
            if (passiveObj1 && passiveObj1.getVar("flag").size_vector() == 0)
            {
                if (passiveObj1.isMyControlObject())
                {
                    passiveObj1.getVar("flag").clear_vector();
                    passiveObj1.getVar("flag").push_vector(1);
                    local animation1 = sq_AddDrawOnlyAniFromParent(passiveObj1, "character/priest/effect/animation/chakraofgod/light/quakearea_crashb.ani", -30, 0, 0);
                    obj.sq_SendCreatePassiveObjectPacket(26061, 0, 40, -50, 0);
                }
            }
            
            local passiveObj2 = obj.getMyPassiveObject(24014, obj.getMyPassiveObjectCount(24014) - 1);
            if (passiveObj2 && passiveObj2.getVar("flag").size_vector() == 0)
            {
                if (passiveObj2.isMyControlObject())
                {
                    passiveObj2.getVar("flag").clear_vector();
                    passiveObj2.getVar("flag").push_vector(1);
                    local imageObj = sq_CreateDrawOnlyObject(passiveObj2, "character/priest/effect/animation/chakraofgod/light/throwweapon_weaponh3.ani", ENUM_DRAWLAYER_NORMAL, true);
                    local imageAnimation = imageObj.getCurrentAnimation();
                    local sizeValue = obj.sq_GetIntData(50, 5);
                    sizeValue = sizeValue.tofloat() / 100.0;
                    imageAnimation.Proc();
                    imageAnimation.setImageRateFromOriginal(sizeValue, sizeValue);
                    imageAnimation.setAutoLayerWorkAnimationAddSizeRate(sizeValue);
                    sq_moveWithParent(passiveObj2, imageObj);
                }
            }
            
            local passiveObj3 = obj.getMyPassiveObject(24015, obj.getMyPassiveObjectCount(24015) - 1);
            if (passiveObj3 && passiveObj3.getVar("flag").size_vector() == 0)
            {
                if (passiveObj3.isMyControlObject())
                {
                    passiveObj3.getVar("flag").clear_vector();
                    passiveObj3.getVar("flag").push_vector(1);
                    local animation3 = sq_AddDrawOnlyAniFromParent(passiveObj3, "character/priest/effect/animation/chakraofgod/light/repeatedsmash_swingfinalc.ani", 20, -20, 0);
                    obj.sq_SendCreatePassiveObjectPacket(26061, 0, 170, -50, 0);
                }
            }
            
            local passiveObj4 = obj.getMyPassiveObject(24016, obj.getMyPassiveObjectCount(24016) - 1);
            if (passiveObj4 && passiveObj4.getVar("flag").size_vector() == 0)
            {
                if (passiveObj4.isMyControlObject())
                {
                    passiveObj4.getVar("flag").clear_vector();
                    passiveObj4.getVar("flag").push_vector(1);
                    obj.sq_SendCreatePassiveObjectPacket(26061, 0, 150, -50, 0);
                }
            }
            
            local passiveObj5 = obj.getMyPassiveObject(24018, obj.getMyPassiveObjectCount(24018) - 1);
            if (passiveObj5 && passiveObj5.getVar("flag").size_vector() == 0)
            {
                if (passiveObj5.isMyControlObject())
                {
                    passiveObj5.getVar("flag").clear_vector();
                    passiveObj5.getVar("flag").push_vector(1);
                    local animation5 = sq_AddDrawOnlyAniFromParent(passiveObj5, "character/priest/effect/animation/chakraofgod/light/antiairupper_a.ani", 170, 0, 0);
                    obj.sq_SendCreatePassiveObjectPacket(26061, 0, -200, -50, 0);
                }
            }
            
            local passiveObj6 = obj.getMyPassiveObject(24041, obj.getMyPassiveObjectCount(24041) - 1);
            if (passiveObj6 && passiveObj6.getVar("flag").size_vector() == 0)
            {
                if (passiveObj6.isMyControlObject())
                {
                    passiveObj6.getVar("flag").clear_vector();
                    passiveObj6.getVar("flag").push_vector(1);
                    local animation6 = sq_AddDrawOnlyAniFromParent(passiveObj6, "character/priest/effect/animation/chakraofgod/light/groundcrash_smashfinalc.ani", -130, 0, 0);
                    obj.sq_SendCreatePassiveObjectPacket(26061, 0, 130, -50, 0);
                }
            }
            
            local passiveObj7 = obj.getMyPassiveObject(24036, obj.getMyPassiveObjectCount(24036) - 1);
            if (passiveObj7 && passiveObj7.getVar("flag").size_vector() == 0)
            {
                if (passiveObj7.isMyControlObject())
                {
                    passiveObj7.getVar("flag").clear_vector();
                    passiveObj7.getVar("flag").push_vector(1);
                    local animation7 = sq_AddDrawOnlyAniFromParent(passiveObj7, "character/priest/effect/animation/chakraofgod/light/repeatedsmash_swingfinalc.ani", 20, -20, 0);
                    obj.sq_SendCreatePassiveObjectPacket(26061, 0, 170, -50, 0);
                }
            }
            
            local passiveObj8 = obj.getMyPassiveObject(24037, obj.getMyPassiveObjectCount(24037) - 1);
            if (passiveObj8 && passiveObj8.getVar("flag").size_vector() == 0)
            {
                if (passiveObj8.isMyControlObject())
                {
                    passiveObj8.getVar("flag").clear_vector();
                    passiveObj8.getVar("flag").push_vector(1);
                    local animation8a = sq_AddDrawOnlyAniFromParent(passiveObj8, "character/priest/effect/animation/chakraofgod/light/repeatedsmash_swingfinalc.ani", 20, -20, 0);
                    local animation8b = sq_AddDrawOnlyAniFromParent(passiveObj8, "character/priest/effect/animation/chakraofgod/light/repeatedsmashex_effect.ani", -200, 0, 0);
                    obj.sq_SendCreatePassiveObjectPacket(26061, 0, 170, -50, 0);
                }
            }
        }
    }
}

// ---------------------codeEnd---------------------//