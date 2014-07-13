package ;

import flixel.util.loaders.TexturePackerData;
import flixel.util.loaders.TextureAtlasFrame;
import flash.display.BitmapData;
import flash.geom.Rectangle;
import flixel.FlxG;
import flixel.util.FlxPoint;
import haxe.Json;
import openfl.Assets;

/**
 * SpriteStudio用のアトラステクスチャ読み込み
 **/
class SSTexturePackerData extends TexturePackerData
{
    private static inline var IDX_SRC_X = 2;
    private static inline var IDX_SRC_Y = 3;
    private static inline var IDX_SRC_W = 4;
    private static inline var IDX_SRC_H = 5;

    private var _texTbl:Map<String,Int>;
    /**
	 * Data parsing method.
	 * Override it in subclasses if you want to implement support for new atlas formats
	 */
    override public function parseData():Void
    {
        // No need to parse data again
        if (frames.length != 0)	return;

        if ((assetName == null) || (description == null)) return;

        _texTbl = new Map<String,Int>();

        asset = FlxG.bitmap.add(assetName).bitmap;
        var data:Dynamic = Json.parse(Assets.getText(description));

        var animation = data[0].animation;
        var parts = animation.parts;
        var ssa = animation.ssa;

        var i = 0;
        // UVを切り出す
        for (allframe in Lambda.array(ssa)) {

            for (frame in Lambda.array(allframe)) {

                var ox:Int = frame[IDX_SRC_X];
                var oy:Int = frame[IDX_SRC_Y];
                var ow:Int = frame[IDX_SRC_W];
                var oh:Int = frame[IDX_SRC_H];
                var name = "" + ox + "," + oy + "," + ow + "," + oh;
                if(_texTbl.exists(name)) {
                    // 既に生成済み
                    continue;
                }

                var texFrame:TextureAtlasFrame = new TextureAtlasFrame();
                texFrame.trimmed = false;
                texFrame.rotated = false;
//                texFrame.name = parts[i + 1];
                texFrame.name = name;

                // サイズを設定
                texFrame.sourceSize = FlxPoint.get(frame[IDX_SRC_W], frame[IDX_SRC_H]);
                texFrame.offset = FlxPoint.get(0, 0);
                // オフセットはしない
                texFrame.offset.set(0, 0);

                if (texFrame.rotated)
                {
                    // 切り取りサイズを設定
                    texFrame.frame = new Rectangle(frame[IDX_SRC_X], frame[IDX_SRC_Y], frame[IDX_SRC_W], frame[IDX_SRC_H]);
                    texFrame.additionalAngle = -90;
                }
                else
                {
                    // 切り取りサイズを設定
                    texFrame.frame = new Rectangle(frame[IDX_SRC_X], frame[IDX_SRC_Y], frame[IDX_SRC_W], frame[IDX_SRC_H]);
                    texFrame.additionalAngle = 0;
                }

                frames.push(texFrame);
                _texTbl[name] = i;

                i++;
            }
        }
    }

    public function dump():Void {
        for(k in _texTbl.keys()) {
            trace(k + " = " + _texTbl[k]);
        }
    }

}
