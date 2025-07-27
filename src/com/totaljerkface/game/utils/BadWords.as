package com.totaljerkface.game.utils
{
    public class BadWords
    {
        public static var regList:Array = ["\\b[a@]+ss[^aeiou]+","\\b[a@]+ss+\\b","[a@4]+[_\\W]*p[_\\W]*p+[_\\W]*n+[_\\W]*[a@4]+[_\\W]*n+[_\\W]*[a@4]+","[^a-z]+[a@]ss[^aiou]+\\b","[^a-z]+[a@]ss\\b","\\ban[a@]l","[a@]n[a@]l","b[a@]st[a@e3]rd","b[i1!]+a*tch","bl[o0]+wj[o0]+b","b[o0][o0]+b+s","bu+tt[-_ ]*h[o0]+l[e3]","c[o0]ck","cl[i1!]+t","\\bcu+m","cu+nt","d[i1!]+ck","d[i1!]+ld[o0]+","f[a@]+gs","f[a@]+g+[0oi]+t","f[-_ ]*u+[-_ ]*c[-_ ]*k","fu+k","g[o0][o0]+k","j[e3]+rk[-_ ]*[o0]+ff","j[i1!]+z+","kunt","m[a@]+st[uea]+rb[a@]+t","n[a4@]+k+[e3]+d","n[i1!]+g+[a@]+","n[i1!]+g+[e3]+r","nu+d[e3]","p[e3]+n[i1!u]+s","pu+ss+[iye3]+","p[o0]+rn","preteen","pr[o0]+n","quee+f","s[e3]+x","s[e3]+m[e3]n","sh[i!1y]+t","sl+u+t","smu+t","t[i1!]+ts*","v[a@]+g[i1!]+n[a@]","wh[o0]+r[e3]","w[o0]p"];
        
        public function BadWords()
        {
            super();
        }
        
        public static function containsBadWord(param1:String) : Boolean
        {
            var _loc5_:String = null;
            var _loc6_:RegExp = null;
            var _loc2_:String = param1;
            var _loc3_:int = int(regList.length);
            var _loc4_:int = 0;
            while(_loc4_ < _loc3_)
            {
                _loc5_ = regList[_loc4_];
                _loc6_ = new RegExp(_loc5_,"i");
                if(_loc6_.test(_loc2_))
                {
                    return true;
                }
                _loc4_++;
            }
            return false;
        }
    }
}

