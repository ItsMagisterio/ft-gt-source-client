﻿// Decompiled by AS3 Sorcerer 6.30
// www.as3sorcerer.com

// projects.tanks.client.panel.model.User

package projects.tanks.client.panel.model
{
    public class User
    {

        public var place:int = 0;
        public var callsign:String;
        public var achiviments:String;
        public var kills:int = 0;
        public var deaths:int = 0;
        public var ratio:int = 0;
        public var rank:int = 0;
        public var score:int = 0;
        public var wealth:int = 0;
        public var rating:Number = 0;

        public function User(callsign:String, achiviments:String, score:int, rank:int, place:int, kills:int, deaths:int, ratio:int, wealth:int, rating:int)
        {
            this.place = place;
            this.callsign = callsign;
            this.achiviments = achiviments;
            this.kills = kills;
            this.deaths = deaths;
            this.ratio = ratio;
            this.rank = rank;
            this.score = score;
            this.wealth = wealth;
            this.rating = rating;
        }
    }
} // package projects.tanks.client.panel.model