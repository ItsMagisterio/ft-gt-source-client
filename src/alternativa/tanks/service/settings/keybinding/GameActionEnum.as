package alternativa.tanks.service.settings.keybinding
{
   import alternativa.tanks.AbstractEnum;

   public class GameActionEnum extends AbstractEnum
   {

      private static var _values:Vector.<GameActionEnum> = new Vector.<GameActionEnum>();

      public static const ROTATE_TURRET_LEFT:alternativa.tanks.service.settings.keybinding.GameActionEnum = create("ROTATE_TURRET_LEFT");

      public static const ROTATE_TURRET_RIGHT:alternativa.tanks.service.settings.keybinding.GameActionEnum = create("ROTATE_TURRET_RIGHT");

      public static const ROTATE_TURRET_LEFT_MOUSE:alternativa.tanks.service.settings.keybinding.GameActionEnum = create("ROTATE_TURRET_LEFT_MOUSE");

      public static const ROTATE_TURRET_RIGHT_MOUSE:alternativa.tanks.service.settings.keybinding.GameActionEnum = create("ROTATE_TURRET_RIGHT_MOUSE");

      public static const CENTER_TURRET:alternativa.tanks.service.settings.keybinding.GameActionEnum = create("CENTER_TURRET");

      public static const CHASSIS_LEFT_MOVEMENT:alternativa.tanks.service.settings.keybinding.GameActionEnum = create("CHASSIS_LEFT_MOVEMENT");

      public static const CHASSIS_RIGHT_MOVEMENT:alternativa.tanks.service.settings.keybinding.GameActionEnum = create("CHASSIS_RIGHT_MOVEMENT");

      public static const CHASSIS_FORWARD_MOVEMENT:alternativa.tanks.service.settings.keybinding.GameActionEnum = create("CHASSIS_FORWARD_MOVEMENT");

      public static const CHASSIS_BACKWARD_MOVEMENT:alternativa.tanks.service.settings.keybinding.GameActionEnum = create("CHASSIS_BACKWARD_MOVEMENT");

      public static const FOLLOW_CAMERA_UP:alternativa.tanks.service.settings.keybinding.GameActionEnum = create("FOLLOW_CAMERA_UP");

      public static const FOLLOW_CAMERA_DOWN:alternativa.tanks.service.settings.keybinding.GameActionEnum = create("FOLLOW_CAMERA_DOWN");

      public static const DROP_FLAG:alternativa.tanks.service.settings.keybinding.GameActionEnum = create("DROP_FLAG");

      public static const BATTLE_PAUSE:alternativa.tanks.service.settings.keybinding.GameActionEnum = create("BATTLE_PAUSE");

      public static const BATTLE_VIEW_INCREASE:alternativa.tanks.service.settings.keybinding.GameActionEnum = create("BATTLE_VIEW_INCREASE");

      public static const BATTLE_VIEW_DECREASE:alternativa.tanks.service.settings.keybinding.GameActionEnum = create("BATTLE_VIEW_DECREASE");

      public static const FULL_SCREEN:alternativa.tanks.service.settings.keybinding.GameActionEnum = create("FULL_SCREEN");

      public static const SUICIDE:alternativa.tanks.service.settings.keybinding.GameActionEnum = create("SUICIDE");

      public static const SHOW_TANK_PARAMETERS:alternativa.tanks.service.settings.keybinding.GameActionEnum = create("SHOW_TANK_PARAMETERS");

      public static const USE_FIRS_AID:alternativa.tanks.service.settings.keybinding.GameActionEnum = create("USE_FIRS_AID");

      public static const USE_DOUBLE_ARMOR:alternativa.tanks.service.settings.keybinding.GameActionEnum = create("USE_DOUBLE_ARMOR");

      public static const USE_DOUBLE_DAMAGE:alternativa.tanks.service.settings.keybinding.GameActionEnum = create("USE_DOUBLE_DAMAGE");

      public static const USE_NITRO:alternativa.tanks.service.settings.keybinding.GameActionEnum = create("USE_NITRO");

      public static const USE_MINE:alternativa.tanks.service.settings.keybinding.GameActionEnum = create("USE_MINE");

      public static const DROP_GOLD_BOX:alternativa.tanks.service.settings.keybinding.GameActionEnum = create("DROP_GOLD_BOX");

      public static const SHOT:alternativa.tanks.service.settings.keybinding.GameActionEnum = create("SHOT");

      public static const ULTIMATE:alternativa.tanks.service.settings.keybinding.GameActionEnum = create("ULTIMATE");

      public static const OPEN_GARAGE:alternativa.tanks.service.settings.keybinding.GameActionEnum = create("OPEN_GARAGE");

      public static const SHOW_BATTLE_STATS_TABLE:alternativa.tanks.service.settings.keybinding.GameActionEnum = create("SHOW_BATTLE_STATS_TABLE");

      public static const LOOK_AROUND:alternativa.tanks.service.settings.keybinding.GameActionEnum = create("LOOK_AROUND");

      public static const STOP_TURRET:alternativa.tanks.service.settings.keybinding.GameActionEnum = create("STOP_TURRET");

      public function GameActionEnum(param1:int, param2:String)
      {
         super(param1, param2);
      }

      private static function create(param1:String):alternativa.tanks.service.settings.keybinding.GameActionEnum
      {
         var _loc2_:GameActionEnum = new GameActionEnum(_values.length, param1);
         _values.push(_loc2_);
         return _loc2_;
      }

      public static function get values():Vector.<alternativa.tanks.service.settings.keybinding.GameActionEnum>
      {
         return _values;
      }
   }
}
