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
    /**
	 * Data parsing method.
	 * Override it in subclasses if you want to implement support for new atlas formats
	 */
    override public function parseData():Void
    {
        // No need to parse data again
        if (frames.length != 0)	return;

        if ((assetName == null) || (description == null)) return;

        asset = FlxG.bitmap.add(assetName).bitmap;
        var data:Dynamic = Json.parse(Assets.getText(description));

        var animation = data[0].animation;
        var parts = animation.parts;
        var ssa = animation.ssa;

        var i = 0;
        // 0フレームの値でUVを切り出す
        for (frame in Lambda.array(ssa[0]))
        {
            var texFrame:TextureAtlasFrame = new TextureAtlasFrame();
            texFrame.trimmed = false;
            texFrame.rotated = false;
            texFrame.name = parts[i + 1];

            var IDX_SRC_X = 2;
            var IDX_SRC_Y = 3;
            var IDX_SRC_W = 4;
            var IDX_SRC_H = 5;

//            texFrame.sourceSize = FlxPoint.get(frame.sourceSize.w, frame.sourceSize.h);
            texFrame.sourceSize = FlxPoint.get(frame[IDX_SRC_W], frame[IDX_SRC_H]);
            texFrame.offset = FlxPoint.get(0, 0);
//            texFrame.offset.set(frame.spriteSourceSize.x, frame.spriteSourceSize.y);
            texFrame.offset.set(0, 0);

            if (texFrame.rotated)
            {
//                texFrame.frame = new Rectangle(frame.frame.x, frame.frame.y, frame.frame.h, frame.frame.w);
                texFrame.frame = new Rectangle(frame[IDX_SRC_X], frame[IDX_SRC_Y], frame[IDX_SRC_W], frame[IDX_SRC_H]);
                texFrame.additionalAngle = -90;
            }
            else
            {
//                texFrame.frame = new Rectangle(frame.frame.x, frame.frame.y, frame.frame.w, frame.frame.h);
                texFrame.frame = new Rectangle(frame[IDX_SRC_X], frame[IDX_SRC_Y], frame[IDX_SRC_W], frame[IDX_SRC_H]);
                texFrame.additionalAngle = 0;
            }

            frames.push(texFrame);

            i++;
        }
    }

}
