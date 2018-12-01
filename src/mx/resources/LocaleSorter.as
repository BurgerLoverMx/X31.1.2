// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//mx.resources.LocaleSorter

package mx.resources
{
    import mx.core.mx_internal;

    use namespace mx_internal;

    public class LocaleSorter 
    {

        mx_internal static const VERSION:String = "4.6.0.23201";


        public static function sortLocalesByPreference(appLocales:Array, systemPreferences:Array, ultimateFallbackLocale:String=null, addAll:Boolean=false):Array
        {
            var result:Array;
            var hasLocale:Object;
            var i:int;
            var j:int;
            var k:int;
            var l:int;
            var locale:String;
            var plocale:LocaleID;
            var promote:Function = function (_arg_1:String):void
            {
                if (typeof(hasLocale[_arg_1]) != "undefined")
                {
                    result.push(appLocales[hasLocale[_arg_1]]);
                    delete hasLocale[_arg_1];
                };
            };
            result = [];
            hasLocale = {};
            var locales:Array = trimAndNormalize(appLocales);
            var preferenceLocales:Array = trimAndNormalize(systemPreferences);
            addUltimateFallbackLocale(preferenceLocales, ultimateFallbackLocale);
            j = 0;
            while (j < locales.length)
            {
                hasLocale[locales[j]] = j;
                j = (j + 1);
            };
            i = 0;
            l = preferenceLocales.length;
            while (i < l)
            {
                plocale = LocaleID.fromString(preferenceLocales[i]);
                (promote(preferenceLocales[i]));
                (promote(plocale.toString()));
                while (plocale.transformToParent())
                {
                    (promote(plocale.toString()));
                };
                plocale = LocaleID.fromString(preferenceLocales[i]);
                j = 0;
                while (j < l)
                {
                    locale = preferenceLocales[j];
                    if (plocale.isSiblingOf(LocaleID.fromString(locale)))
                    {
                        (promote(locale));
                    };
                    j = (j + 1);
                };
                j = 0;
                k = locales.length;
                while (j < k)
                {
                    locale = locales[j];
                    if (plocale.isSiblingOf(LocaleID.fromString(locale)))
                    {
                        (promote(locale));
                    };
                    j = (j + 1);
                };
                i = (i + 1);
            };
            if (addAll)
            {
                j = 0;
                k = locales.length;
                while (j < k)
                {
                    (promote(locales[j]));
                    j = (j + 1);
                };
            };
            return (result);
        }

        private static function trimAndNormalize(_arg_1:Array):Array
        {
            var _local_2:Array = [];
            var _local_3:int;
            while (_local_3 < _arg_1.length)
            {
                _local_2.push(normalizeLocale(_arg_1[_local_3]));
                _local_3++;
            };
            return (_local_2);
        }

        private static function normalizeLocale(_arg_1:String):String
        {
            return (_arg_1.toLowerCase().replace(/-/g, "_"));
        }

        private static function addUltimateFallbackLocale(_arg_1:Array, _arg_2:String):void
        {
            var _local_3:String;
            if (((!(_arg_2 == null)) && (!(_arg_2 == ""))))
            {
                _local_3 = normalizeLocale(_arg_2);
                if (_arg_1.indexOf(_local_3) == -1)
                {
                    _arg_1.push(_local_3);
                };
            };
        }


    }
}//package mx.resources

class LocaleID 
{

    public static const STATE_PRIMARY_LANGUAGE:int = 0;
    public static const STATE_EXTENDED_LANGUAGES:int = 1;
    public static const STATE_SCRIPT:int = 2;
    public static const STATE_REGION:int = 3;
    public static const STATE_VARIANTS:int = 4;
    public static const STATE_EXTENSIONS:int = 5;
    public static const STATE_PRIVATES:int = 6;

    /*private*/ var lang:String = "";
    /*private*/ var script:String = "";
    /*private*/ var region:String = "";
    /*private*/ var extended_langs:Array = [];
    /*private*/ var variants:Array = [];
    /*private*/ var extensions:Object = {};
    /*private*/ var privates:Array = [];
    /*private*/ var privateLangs:Boolean = false;


    /*private*/ static function appendElements(_arg_1:Array, _arg_2:Array):void
    {
        var _local_3:uint;
        var _local_4:uint = _arg_2.length;
        while (_local_3 < _local_4)
        {
            _arg_1.push(_arg_2[_local_3]);
            _local_3++;
        };
    }

    public static function fromString(_arg_1:String):LocaleID
    {
        var _local_5:Array;
        var _local_8:String;
        var _local_9:int;
        var _local_10:String;
        var _local_2:LocaleID = new (LocaleID)();
        var _local_3:int = STATE_PRIMARY_LANGUAGE;
        var _local_4:Array = _arg_1.replace(/-/g, "_").split("_");
        var _local_6:int;
        var _local_7:int = _local_4.length;
        while (_local_6 < _local_7)
        {
            _local_8 = _local_4[_local_6].toLowerCase();
            if (_local_3 == STATE_PRIMARY_LANGUAGE)
            {
                if (_local_8 == "x")
                {
                    _local_2.privateLangs = true;
                }
                else
                {
                    if (_local_8 == "i")
                    {
                        _local_2.lang = (_local_2.lang + "i-");
                    }
                    else
                    {
                        _local_2.lang = (_local_2.lang + _local_8);
                        _local_3 = STATE_EXTENDED_LANGUAGES;
                    };
                };
            }
            else
            {
                _local_9 = _local_8.length;
                if (_local_9 != 0)
                {
                    _local_10 = _local_8.charAt(0).toLowerCase();
                    if (((_local_3 <= STATE_EXTENDED_LANGUAGES) && (_local_9 == 3)))
                    {
                        _local_2.extended_langs.push(_local_8);
                        if (_local_2.extended_langs.length == 3)
                        {
                            _local_3 = STATE_SCRIPT;
                        };
                    }
                    else
                    {
                        if (((_local_3 <= STATE_SCRIPT) && (_local_9 == 4)))
                        {
                            _local_2.script = _local_8;
                            _local_3 = STATE_REGION;
                        }
                        else
                        {
                            if (((_local_3 <= STATE_REGION) && ((_local_9 == 2) || (_local_9 == 3))))
                            {
                                _local_2.region = _local_8;
                                _local_3 = STATE_VARIANTS;
                            }
                            else
                            {
                                if (((_local_3 <= STATE_VARIANTS) && ((((_local_10 >= "a") && (_local_10 <= "z")) && (_local_9 >= 5)) || (((_local_10 >= "0") && (_local_10 <= "9")) && (_local_9 >= 4)))))
                                {
                                    _local_2.variants.push(_local_8);
                                    _local_3 = STATE_VARIANTS;
                                }
                                else
                                {
                                    if (((_local_3 < STATE_PRIVATES) && (_local_9 == 1)))
                                    {
                                        if (_local_8 == "x")
                                        {
                                            _local_3 = STATE_PRIVATES;
                                            _local_5 = _local_2.privates;
                                        }
                                        else
                                        {
                                            _local_3 = STATE_EXTENSIONS;
                                            _local_5 = ((_local_2.extensions[_local_8]) || ([]));
                                            _local_2.extensions[_local_8] = _local_5;
                                        };
                                    }
                                    else
                                    {
                                        if (_local_3 >= STATE_EXTENSIONS)
                                        {
                                            _local_5.push(_local_8);
                                        };
                                    };
                                };
                            };
                        };
                    };
                };
            };
            _local_6++;
        };
        _local_2.canonicalize();
        return (_local_2);
    }


    public function canonicalize():void
    {
        var _local_1:String;
        for (_local_1 in this.extensions)
        {
            if (this.extensions.hasOwnProperty(_local_1))
            {
                if (this.extensions[_local_1].length == 0)
                {
                    delete this.extensions[_local_1];
                }
                else
                {
                    this.extensions[_local_1] = this.extensions[_local_1].sort();
                };
            };
        };
        this.extended_langs = this.extended_langs.sort();
        this.variants = this.variants.sort();
        this.privates = this.privates.sort();
        if (this.script == "")
        {
            this.script = LocaleRegistry.getScriptByLang(this.lang);
        };
        if (((this.script == "") && (!(this.region == ""))))
        {
            this.script = LocaleRegistry.getScriptByLangAndRegion(this.lang, this.region);
        };
        if (((this.region == "") && (!(this.script == ""))))
        {
            this.region = LocaleRegistry.getDefaultRegionForLangAndScript(this.lang, this.script);
        };
    }

    public function toString():String
    {
        var _local_2:String;
        var _local_1:Array = [this.lang];
        appendElements(_local_1, this.extended_langs);
        if (this.script != "")
        {
            _local_1.push(this.script);
        };
        if (this.region != "")
        {
            _local_1.push(this.region);
        };
        appendElements(_local_1, this.variants);
        for (_local_2 in this.extensions)
        {
            if (this.extensions.hasOwnProperty(_local_2))
            {
                _local_1.push(_local_2);
                appendElements(_local_1, this.extensions[_local_2]);
            };
        };
        if (this.privates.length > 0)
        {
            _local_1.push("x");
            appendElements(_local_1, this.privates);
        };
        return (_local_1.join("_"));
    }

    public function equals(_arg_1:LocaleID):Boolean
    {
        return (this.toString() == _arg_1.toString());
    }

    public function isSiblingOf(_arg_1:LocaleID):Boolean
    {
        return ((this.lang == _arg_1.lang) && (this.script == _arg_1.script));
    }

    public function transformToParent():Boolean
    {
        var _local_2:String;
        var _local_3:Array;
        var _local_4:String;
        if (this.privates.length > 0)
        {
            this.privates.splice((this.privates.length - 1), 1);
            return (true);
        };
        var _local_1:String;
        for (_local_2 in this.extensions)
        {
            if (this.extensions.hasOwnProperty(_local_2))
            {
                _local_1 = _local_2;
            };
        };
        if (_local_1)
        {
            _local_3 = this.extensions[_local_1];
            if (_local_3.length == 1)
            {
                delete this.extensions[_local_1];
                return (true);
            };
            _local_3.splice((_local_3.length - 1), 1);
            return (true);
        };
        if (this.variants.length > 0)
        {
            this.variants.splice((this.variants.length - 1), 1);
            return (true);
        };
        if (this.script != "")
        {
            if (LocaleRegistry.getScriptByLang(this.lang) != "")
            {
                this.script = "";
                return (true);
            };
            if (this.region == "")
            {
                _local_4 = LocaleRegistry.getDefaultRegionForLangAndScript(this.lang, this.script);
                if (_local_4 != "")
                {
                    this.region = _local_4;
                    this.script = "";
                    return (true);
                };
            };
        };
        if (this.region != "")
        {
            if (!((this.script == "") && (LocaleRegistry.getScriptByLang(this.lang) == "")))
            {
                this.region = "";
                return (true);
            };
        };
        if (this.extended_langs.length > 0)
        {
            this.extended_langs.splice((this.extended_langs.length - 1), 1);
            return (true);
        };
        return (false);
    }


}

class LocaleRegistry 
{

    /*private*/ static const SCRIPTS:Array = ["", "latn", "ethi", "arab", "beng", "cyrl", "thaa", "tibt", "grek", "gujr", "hebr", "deva", "armn", "jpan", "geor", "khmr", "knda", "kore", "laoo", "mlym", "mymr", "orya", "guru", "sinh", "taml", "telu", "thai", "nkoo", "blis", "hans", "hant", "mong", "syrc"];
    /*private*/ static const SCRIPT_BY_ID:Object = {
        "latn":1,
        "ethi":2,
        "arab":3,
        "beng":4,
        "cyrl":5,
        "thaa":6,
        "tibt":7,
        "grek":8,
        "gujr":9,
        "hebr":10,
        "deva":11,
        "armn":12,
        "jpan":13,
        "geor":14,
        "khmr":15,
        "knda":16,
        "kore":17,
        "laoo":18,
        "mlym":19,
        "mymr":20,
        "orya":21,
        "guru":22,
        "sinh":23,
        "taml":24,
        "telu":25,
        "thai":26,
        "nkoo":27,
        "blis":28,
        "hans":29,
        "hant":30,
        "mong":31,
        "syrc":32
    };
    /*private*/ static const DEFAULT_REGION_BY_LANG_AND_SCRIPT:Object = {
        "bg":{"5":"bg"},
        "ca":{"1":"es"},
        "zh":{
            "30":"tw",
            "29":"cn"
        },
        "cs":{"1":"cz"},
        "da":{"1":"dk"},
        "de":{"1":"de"},
        "el":{"8":"gr"},
        "en":{"1":"us"},
        "es":{"1":"es"},
        "fi":{"1":"fi"},
        "fr":{"1":"fr"},
        "he":{"10":"il"},
        "hu":{"1":"hu"},
        "is":{"1":"is"},
        "it":{"1":"it"},
        "ja":{"13":"jp"},
        "ko":{"17":"kr"},
        "nl":{"1":"nl"},
        "nb":{"1":"no"},
        "pl":{"1":"pl"},
        "pt":{"1":"br"},
        "ro":{"1":"ro"},
        "ru":{"5":"ru"},
        "hr":{"1":"hr"},
        "sk":{"1":"sk"},
        "sq":{"1":"al"},
        "sv":{"1":"se"},
        "th":{"26":"th"},
        "tr":{"1":"tr"},
        "ur":{"3":"pk"},
        "id":{"1":"id"},
        "uk":{"5":"ua"},
        "be":{"5":"by"},
        "sl":{"1":"si"},
        "et":{"1":"ee"},
        "lv":{"1":"lv"},
        "lt":{"1":"lt"},
        "fa":{"3":"ir"},
        "vi":{"1":"vn"},
        "hy":{"12":"am"},
        "az":{
            "1":"az",
            "5":"az"
        },
        "eu":{"1":"es"},
        "mk":{"5":"mk"},
        "af":{"1":"za"},
        "ka":{"14":"ge"},
        "fo":{"1":"fo"},
        "hi":{"11":"in"},
        "ms":{"1":"my"},
        "kk":{"5":"kz"},
        "ky":{"5":"kg"},
        "sw":{"1":"ke"},
        "uz":{
            "1":"uz",
            "5":"uz"
        },
        "tt":{"5":"ru"},
        "pa":{"22":"in"},
        "gu":{"9":"in"},
        "ta":{"24":"in"},
        "te":{"25":"in"},
        "kn":{"16":"in"},
        "mr":{"11":"in"},
        "sa":{"11":"in"},
        "mn":{"5":"mn"},
        "gl":{"1":"es"},
        "kok":{"11":"in"},
        "syr":{"32":"sy"},
        "dv":{"6":"mv"},
        "nn":{"1":"no"},
        "sr":{
            "1":"cs",
            "5":"cs"
        },
        "cy":{"1":"gb"},
        "mi":{"1":"nz"},
        "mt":{"1":"mt"},
        "quz":{"1":"bo"},
        "tn":{"1":"za"},
        "xh":{"1":"za"},
        "zu":{"1":"za"},
        "nso":{"1":"za"},
        "se":{"1":"no"},
        "smj":{"1":"no"},
        "sma":{"1":"no"},
        "sms":{"1":"fi"},
        "smn":{"1":"fi"},
        "bs":{"1":"ba"}
    };
    /*private*/ static const SCRIPT_ID_BY_LANG:Object = {
        "ab":5,
        "af":1,
        "am":2,
        "ar":3,
        "as":4,
        "ay":1,
        "be":5,
        "bg":5,
        "bn":4,
        "bs":1,
        "ca":1,
        "ch":1,
        "cs":1,
        "cy":1,
        "da":1,
        "de":1,
        "dv":6,
        "dz":7,
        "el":8,
        "en":1,
        "eo":1,
        "es":1,
        "et":1,
        "eu":1,
        "fa":3,
        "fi":1,
        "fj":1,
        "fo":1,
        "fr":1,
        "frr":1,
        "fy":1,
        "ga":1,
        "gl":1,
        "gn":1,
        "gu":9,
        "gv":1,
        "he":10,
        "hi":11,
        "hr":1,
        "ht":1,
        "hu":1,
        "hy":12,
        "id":1,
        "in":1,
        "is":1,
        "it":1,
        "iw":10,
        "ja":13,
        "ka":14,
        "kk":5,
        "kl":1,
        "km":15,
        "kn":16,
        "ko":17,
        "la":1,
        "lb":1,
        "ln":1,
        "lo":18,
        "lt":1,
        "lv":1,
        "mg":1,
        "mh":1,
        "mk":5,
        "ml":19,
        "mo":1,
        "mr":11,
        "ms":1,
        "mt":1,
        "my":20,
        "na":1,
        "nb":1,
        "nd":1,
        "ne":11,
        "nl":1,
        "nn":1,
        "no":1,
        "nr":1,
        "ny":1,
        "om":1,
        "or":21,
        "pa":22,
        "pl":1,
        "ps":3,
        "pt":1,
        "qu":1,
        "rn":1,
        "ro":1,
        "ru":5,
        "rw":1,
        "sg":1,
        "si":23,
        "sk":1,
        "sl":1,
        "sm":1,
        "so":1,
        "sq":1,
        "ss":1,
        "st":1,
        "sv":1,
        "sw":1,
        "ta":24,
        "te":25,
        "th":26,
        "ti":2,
        "tl":1,
        "tn":1,
        "to":1,
        "tr":1,
        "ts":1,
        "uk":5,
        "ur":3,
        "ve":1,
        "vi":1,
        "wo":1,
        "xh":1,
        "yi":10,
        "zu":1,
        "cpe":1,
        "dsb":1,
        "frs":1,
        "gsw":1,
        "hsb":1,
        "kok":11,
        "mai":11,
        "men":1,
        "nds":1,
        "niu":1,
        "nqo":27,
        "nso":1,
        "son":1,
        "tem":1,
        "tkl":1,
        "tmh":1,
        "tpi":1,
        "tvl":1,
        "zbl":28
    };
    /*private*/ static const SCRIPT_ID_BY_LANG_AND_REGION:Object = {
        "zh":{
            "cn":29,
            "sg":29,
            "tw":30,
            "hk":30,
            "mo":30
        },
        "mn":{
            "cn":31,
            "sg":5
        },
        "pa":{
            "pk":3,
            "in":22
        },
        "ha":{
            "gh":1,
            "ne":1
        }
    };


    public static function getScriptByLangAndRegion(_arg_1:String, _arg_2:String):String
    {
        var _local_3:Object = SCRIPT_ID_BY_LANG_AND_REGION[_arg_1];
        if (_local_3 == null)
        {
            return ("");
        };
        var _local_4:Object = _local_3[_arg_2];
        if (_local_4 == null)
        {
            return ("");
        };
        return (SCRIPTS[int(_local_4)].toLowerCase());
    }

    public static function getScriptByLang(_arg_1:String):String
    {
        var _local_2:Object = SCRIPT_ID_BY_LANG[_arg_1];
        if (_local_2 == null)
        {
            return ("");
        };
        return (SCRIPTS[int(_local_2)].toLowerCase());
    }

    public static function getDefaultRegionForLangAndScript(_arg_1:String, _arg_2:String):String
    {
        var _local_3:Object = DEFAULT_REGION_BY_LANG_AND_SCRIPT[_arg_1];
        var _local_4:Object = SCRIPT_BY_ID[_arg_2];
        if (((_local_3 == null) || (_local_4 == null)))
        {
            return ("");
        };
        return ((_local_3[int(_local_4)]) || (""));
    }


}


