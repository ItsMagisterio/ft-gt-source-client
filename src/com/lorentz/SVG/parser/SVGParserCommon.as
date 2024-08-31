package com.lorentz.SVG.parser
{
    import __AS3__.vec.Vector;
    import com.lorentz.SVG.data.path.SVGPathCommand;
    import com.lorentz.SVG.data.path.SVGClosePathCommand;
    import com.lorentz.SVG.data.path.SVGMoveToCommand;
    import com.lorentz.SVG.data.path.SVGLineToCommand;
    import com.lorentz.SVG.data.path.SVGLineToHorizontalCommand;
    import com.lorentz.SVG.data.path.SVGLineToVerticalCommand;
    import com.lorentz.SVG.data.path.SVGCurveToQuadraticCommand;
    import com.lorentz.SVG.data.path.SVGCurveToQuadraticSmoothCommand;
    import com.lorentz.SVG.data.path.SVGCurveToCubicCommand;
    import com.lorentz.SVG.data.path.SVGCurveToCubicSmoothCommand;
    import com.lorentz.SVG.data.path.SVGArcToCommand;
    import flash.geom.Matrix;
    import com.lorentz.SVG.utils.MathUtils;
    import flash.geom.Rectangle;
    import __AS3__.vec.*;

    public class SVGParserCommon
    {

        public static function parsePathData(input:String):Vector.<SVGPathCommand>
        {
            var commandString:String;
            var _local_4:String;
            var args:Vector.<String>;
            var a:int;
            var commands:Vector.<SVGPathCommand> = new Vector.<SVGPathCommand>();
            for each (commandString in input.match(/[A-DF-Za-df-z][^A-Za-df-z]*/g))
            {
                _local_4 = commandString.charAt(0);
                args = SVGParserCommon.splitNumericArgs(commandString.substr(1));
                if (((_local_4 == "Z") || (_local_4 == "z")))
                {
                    commands.push(new SVGClosePathCommand());
                }
                else
                {
                    a = 0;
                    while (a < args.length)
                    {
                        if (((_local_4 == "M") && (a > 0)))
                        {
                            _local_4 = "L";
                        }
                        if (((_local_4 == "m") && (a > 0)))
                        {
                            _local_4 = "l";
                        }
                        switch (_local_4)
                        {
                            case "M":
                            case "m":
                                commands.push(new SVGMoveToCommand((_local_4 == "M"), Number(args[a++ ]), Number(args[a++ ])));
                                break;
                            case "L":
                            case "l":
                                commands.push(new SVGLineToCommand((_local_4 == "L"), Number(args[a++ ]), Number(args[a++ ])));
                                break;
                            case "H":
                            case "h":
                                commands.push(new SVGLineToHorizontalCommand((_local_4 == "H"), Number(args[a++ ])));
                                break;
                            case "V":
                            case "v":
                                commands.push(new SVGLineToVerticalCommand((_local_4 == "V"), Number(args[a++ ])));
                                break;
                            case "Q":
                            case "q":
                                commands.push(new SVGCurveToQuadraticCommand((_local_4 == "Q"), Number(args[a++ ]), Number(args[a++ ]), Number(args[a++ ]), Number(args[a++ ])));
                                break;
                            case "T":
                            case "t":
                                commands.push(new SVGCurveToQuadraticSmoothCommand((_local_4 == "T"), Number(args[a++ ]), Number(args[a++ ])));
                                break;
                            case "C":
                            case "c":
                                commands.push(new SVGCurveToCubicCommand((_local_4 == "C"), Number(args[a++ ]), Number(args[a++ ]), Number(args[a++ ]), Number(args[a++ ]), Number(args[a++ ]), Number(args[a++ ])));
                                break;
                            case "S":
                            case "s":
                                commands.push(new SVGCurveToCubicSmoothCommand((_local_4 == "S"), Number(args[a++ ]), Number(args[a++ ]), Number(args[a++ ]), Number(args[a++ ])));
                                break;
                            case "A":
                            case "a":
                                commands.push(new SVGArcToCommand((_local_4 == "A"), Number(args[a++ ]), Number(args[a++ ]), Number(args[a++ ]), (!(args[a++ ] == "0")), (!(args[a++ ] == "0")), Number(args[a++ ]), Number(args[a++ ])));
                                break;
                            default:
                                trace(("Invalid PathCommand type: " + _local_4));
                                a = args.length;
                        }
                    }
                }
            }
            return (commands);
        }
        public static function splitNumericArgs(input:String):Vector.<String>
        {
            var numberString:String;
            var returnData:Vector.<String> = new Vector.<String>();
            var matchedNumbers:Array = input.match(/(?:\+|-)?(?:(?:\d*\.\d+)|(?:\d+))(?:e(?:\+|-)?\d+)?/g);
            for each (numberString in matchedNumbers)
            {
                returnData.push(numberString);
            }
            return (returnData);
        }
        public static function parseTransformation(m:String):Matrix
        {
            var i:int;
            var parts:Array;
            var name:String;
            var args:Vector.<String>;
            var skewXMatrix:Matrix;
            var skewYMatrix:Matrix;
            var tx:Number;
            var ty:Number;
            if (m.length == 0)
            {
                return (new Matrix());
            }
            var transformations:Array = m.match(/(\w+?\s*\([^)]*\))/g);
            var mat:Matrix = new Matrix();
            if ((transformations is Array))
            {
                i = (transformations.length - 1);
                while (i >= 0)
                {
                    parts = /(\w+?)\s*\(([^)]*)\)/.exec(transformations[i]);
                    if ((parts is Array))
                    {
                        name = parts[1].toLowerCase();
                        args = splitNumericArgs(parts[2]);
                        switch (name)
                        {
                            case "matrix":
                                mat.concat(new Matrix(Number(args[0]), Number(args[1]), Number(args[2]), Number(args[3]), Number(args[4]), Number(args[5])));
                                break;
                            case "translate":
                                mat.translate(Number(args[0]), ((args.length > 1) ? Number(args[1]) : 0));
                                break;
                            case "scale":
                                mat.scale(Number(args[0]), ((args.length > 1) ? Number(args[1]) : Number(args[0])));
                                break;
                            case "rotate":
                                if (args.length > 1)
                                {
                                    tx = ((args.length > 1) ? Number(args[1]) : 0);
                                    ty = ((args.length > 2) ? Number(args[2]) : 0);
                                    mat.translate(-(tx), -(ty));
                                    mat.rotate(MathUtils.degressToRadius(Number(args[0])));
                                    mat.translate(tx, ty);
                                }
                                else
                                {
                                    mat.rotate(MathUtils.degressToRadius(Number(args[0])));
                                }
                                break;
                            case "skewx":
                                skewXMatrix = new Matrix();
                                skewXMatrix.c = Math.tan(MathUtils.degressToRadius(Number(args[0])));
                                mat.concat(skewXMatrix);
                                break;
                            case "skewy":
                                skewYMatrix = new Matrix();
                                skewYMatrix.b = Math.tan(MathUtils.degressToRadius(Number(args[0])));
                                mat.concat(skewYMatrix);
                                break;
                        }
                    }
                    i--;
                }
            }
            return (mat);
        }
        public static function parseViewBox(viewBox:String):Rectangle
        {
            if (((viewBox == null) || (viewBox == "")))
            {
                return (null);
            }
            var params:Object = viewBox.split(/\s/);
            return (new Rectangle(params[0], params[1], params[2], params[3]));
        }
        public static function parsePreserveAspectRatio(text:String):Object
        {
            var parts:Array = /(?:(defer)\s+)?(\w*)(?:\s+(meet|slice))?/gi.exec(text.toLowerCase());
            return ( {
                        "defer": (!(parts[1] == undefined)),
                        "align": ((parts[2]) || ("xmidymid")),
                        "meetOrSlice": ((parts[3]) || ("meet"))
                    });
        }

    }
}
