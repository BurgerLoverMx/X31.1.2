// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//com.hurlant.math.MontgomeryReduction

package com.hurlant.math
{
    import com.hurlant.math.BigInteger;
    import com.hurlant.math.bi_internal;
    import com.hurlant.math.*;

    use namespace bi_internal;

    internal class MontgomeryReduction implements IReduction 
    {

        private var m:BigInteger;
        private var mp:int;
        private var mpl:int;
        private var mph:int;
        private var um:int;
        private var mt2:int;

        public function MontgomeryReduction(_arg_1:BigInteger)
        {
            this.m = _arg_1;
            this.mp = _arg_1.invDigit();
            this.mpl = (this.mp & 0x7FFF);
            this.mph = (this.mp >> 15);
            this.um = ((1 << (BigInteger.DB - 15)) - 1);
            this.mt2 = (2 * _arg_1.t);
        }

        public function convert(_arg_1:BigInteger):BigInteger
        {
            var _local_2:BigInteger = new BigInteger();
            _arg_1.abs().dlShiftTo(this.m.t, _local_2);
            _local_2.divRemTo(this.m, null, _local_2);
            if (((_arg_1.s < 0) && (_local_2.compareTo(BigInteger.ZERO) > 0)))
            {
                this.m.subTo(_local_2, _local_2);
            };
            return (_local_2);
        }

        public function revert(_arg_1:BigInteger):BigInteger
        {
            var _local_2:BigInteger = new BigInteger();
            _arg_1.copyTo(_local_2);
            this.reduce(_local_2);
            return (_local_2);
        }

        public function reduce(_arg_1:BigInteger):void
        {
            var _local_3:int;
            var _local_4:int;
            while (_arg_1.t <= this.mt2)
            {
                var _local_5:* = _arg_1.t++;
                _arg_1.a[_local_5] = 0;
            };
            var _local_2:int;
            while (_local_2 < this.m.t)
            {
                _local_3 = (_arg_1.a[_local_2] & 0x7FFF);
                _local_4 = (((_local_3 * this.mpl) + ((((_local_3 * this.mph) + ((_arg_1.a[_local_2] >> 15) * this.mpl)) & this.um) << 15)) & BigInteger.DM);
                _local_3 = (_local_2 + this.m.t);
                _arg_1.a[_local_3] = (_arg_1.a[_local_3] + this.m.am(0, _local_4, _arg_1, _local_2, 0, this.m.t));
                while (_arg_1.a[_local_3] >= BigInteger.DV)
                {
                    _arg_1.a[_local_3] = (_arg_1.a[_local_3] - BigInteger.DV);
                    _arg_1.a[++_local_3]++;
                };
                _local_2++;
            };
            _arg_1.clamp();
            _arg_1.drShiftTo(this.m.t, _arg_1);
            if (_arg_1.compareTo(this.m) >= 0)
            {
                _arg_1.subTo(this.m, _arg_1);
            };
        }

        public function sqrTo(_arg_1:BigInteger, _arg_2:BigInteger):void
        {
            _arg_1.squareTo(_arg_2);
            this.reduce(_arg_2);
        }

        public function mulTo(_arg_1:BigInteger, _arg_2:BigInteger, _arg_3:BigInteger):void
        {
            _arg_1.multiplyTo(_arg_2, _arg_3);
            this.reduce(_arg_3);
        }


    }
}//package com.hurlant.math

