﻿// Decompiled by AS3 Sorcerer 6.30
// www.as3sorcerer.com

// projects.tanks.client.battlefield.gui.models.statistics.UserStat

package projects.tanks.client.battlefield.gui.models.statistics
{
    import projects.tanks.client.battleservice.model.team.BattleTeamType;

    public class UserStat
    {

        public var name:String;
        public var rank:int;
        public var isPremium:Boolean;
        public var teamType:BattleTeamType;
        public var userId:String;
        public var kills:int;
        public var deaths:int;
        public var score:int;
        public var reward:int;
        public var weapon:String;

        public function UserStat(kills:int, deaths:int, name:String, rank:int, score:int, reward:int, teamType:BattleTeamType, userId:String, weapon:String, isPremium:Boolean)
        {
            this.name = name;
            this.rank = rank;
            this.teamType = teamType;
            this.userId = userId;
            this.kills = kills;
            this.deaths = deaths;
            this.score = score;
            this.reward = reward;
            this.weapon = weapon;
            this.isPremium = isPremium;
        }
    }
} // package projects.tanks.client.battlefield.gui.models.statistics