package controls.chat
{
    import flash.display.MovieClip;
    import flash.display.BitmapData;

    public class ChatPermissionsLevel extends MovieClip
    {

        private static const developer:Class = ChatPermissionsLevel_developer;
        private static const admin:Class = ChatPermissionsLevel_admin;
        private static const moder:Class = ChatPermissionsLevel_moder;
        private static const candidate:Class = ChatPermissionsLevel_candidate;
        private static const event:Class = ChatPermissionsLevel_event;
        private static const event_org:Class = ChatPermissionsLevel_event_org;
        private static const cm:Class = ChatPermissionsLevel_cm;
        private static const tester:Class = ChatPermissionsLevel_tester;
        private static const tester_gold:Class = ChatPermissionsLevel_tester_gold;
        private static const sponsor:Class = ChatPermissionsLevel_sponsor;

        public static function getBD(id:int):BitmapData
        {
            switch (id)
            {
                case 1:
                    return (new cm().bitmapData);
                case 2:
                    return (new developer().bitmapData);
                case 3:
                    return (new admin().bitmapData);
                case 4:
                    return (new moder().bitmapData);
                case 5:
                    return (new candidate().bitmapData);
                case 6:
                    return (new sponsor().bitmapData);
                case 7:
                    return (new tester().bitmapData);
                case 8:
                    return (new tester_gold().bitmapData);
                case 9:
                    return (new event().bitmapData);
                case 10:
                    return (new event_org().bitmapData);
            }
            return (new admin().bitmapData);
        }

    }
}
