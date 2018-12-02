//io.decagames.rotmg.social.signals.FriendActionSignal

package io.decagames.rotmg.social.signals
{
    import org.osflash.signals.Signal;
    import io.decagames.rotmg.social.model.FriendRequestVO;

    public class FriendActionSignal extends Signal 
    {

        public function FriendActionSignal()
        {
            super(FriendRequestVO);
        }

    }
}//package io.decagames.rotmg.social.signals

