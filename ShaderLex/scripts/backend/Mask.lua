-- Script made by Ledonic (Edited by Chara Maker to work with all 3)

function characterExists(char)
    return getProperty(char) ~= nil and getProperty(char..'.visible') == true
end

function onCreatePost()
    if shadersEnabled == true then
        for _, char in ipairs({'boyfriend', 'dad', 'gf'}) do
            if characterExists(char) then
                setShaderSampler2D(char, 'altMask', 'MaskChange')
                setShaderFloat(char, 'thr2', 1)
                setShaderBool(char, 'useMask', false)
            end
        end
    end
end

function onEvent(event, value1, value2)
    if event == 'Change Character' and shadersEnabled == true then
        for _, char in ipairs({'boyfriend', 'dad', 'gf'}) do
            if characterExists(char) then
                runHaxeCode([[
                    import flixel.math.FlxAngle;
                    var object = switch("]]..char..[[") {
                        case "boyfriend": game.boyfriend;
                        case "dad": game.dad;
                        case "gf": game.gf;
                        default: null;
                    };
                    if (object != null && object.animation != null) {
                        object.animation.callback = function(name:String, frameNumber:Int, frameIndex:Int) {
                            if (object.shader != null) {
                                object.shader.setFloatArray('uFrameBounds', [object.frame.uv.x, object.frame.uv.y, object.frame.uv.width, object.frame.uv.height]);
                                object.shader.setFloat('angOffset', object.frame.angle * FlxAngle.TO_RAD);
                            }
                        };
                    }
                ]])
                setShaderBool(char, 'useMask', true)
            end
        end
    end
end