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
    private static inline var IDX_IMAGE_NO = 1;
    private static inline var IDX_SRC_X = 2;
    private static inline var IDX_SRC_Y = 3;
    private static inline var IDX_SRC_W = 4;
    private static inline var IDX_SRC_H = 5;

    // 登録したUV情報のテーブル
    private var _uvTbl:Map<String,Int>;

    // 登録したテクスチャ名のテーブル
    private var _texTbl:Array<String>;

//    public var assets:BitmapData;
//    public var assetNames:String;

    // アニメーションの最大数
    private var _animationMax:Int = 0;

    public var animationMax(get, null):Int;

    public function getAssetName(Index:Int):String {
        return _texTbl[Index];
    }

    /**
	 * Data parsing method.
	 * Override it in subclasses if you want to implement support for new atlas formats
	 */
    override public function parseData():Void
    {
        // No need to parse data again
        if (frames.length != 0)	return;

        if ((assetName == null) || (description == null)) return;

        // UVテーブル生成
        _uvTbl = new Map<String,Int>();

        // テクスチャ名テーブル
        _texTbl = new Array<String>();

//        asset = FlxG.bitmap.add(assetName).bitmap;
//        assets = FlxG.bitmap.add(assetName).bitmap;
//        assetNames = assetName;

        var data:Dynamic = Json.parse(Assets.getText(description));

        var images = data[0].images;
        for(image in Lambda.array(images)) {
            // 画像ファイル名を格納
            _texTbl.push(assetName + "/" + image);
        }

        var animation = data[0].animation;
        var ssa = animation.ssa;

        var i = 0;
        // UVを切り出す
        for (allframe in Lambda.array(ssa)) {

            // 1フレーム内の最大アニメ数を数える
            var cntAnim:Int = 0;

            for (frame in Lambda.array(allframe)) {

                cntAnim++;

                var nImage:Int = frame[IDX_IMAGE_NO];
                var ox:Int = frame[IDX_SRC_X];
                var oy:Int = frame[IDX_SRC_Y];
                var ow:Int = frame[IDX_SRC_W];
                var oh:Int = frame[IDX_SRC_H];
                var name = nImage + ":" + ox + "," + oy + "," + ow + "," + oh;
                if(_uvTbl.exists(name)) {
                    // 既に生成済み
                    continue;
                }

                var texFrame:TextureAtlasFrame = new TextureAtlasFrame();
                texFrame.trimmed = false;
                texFrame.rotated = false;
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
                _uvTbl[name] = i;

                i++;
            }

            if(cntAnim >_animationMax) {
                // アニメーション最大数更新
                _animationMax = cntAnim;
            }
        }
    }

    private function get_animationMax():Int {
        return _animationMax;
    }

    public function dump():Void {
        for(k in _uvTbl.keys()) {
            trace(k + " = " + _uvTbl[k]);
        }
    }

}
