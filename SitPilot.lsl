/**
    @name: SitPilot
    @description:
    @note:

    @author: Zai Dium
    @license: MIT

    @version: 1.0
    @updated: "2023-07-31 00:44:41"
    @revision: 125
    @localfile: ?defaultpath\\DieselPunkPlane\?@name.lsl
*/

string animation;

vector Target=<0.35, 0, 0.1>;

setTarget()
{
    vector pos = (vector)llGetObjectDesc();
    if (pos==ZERO_VECTOR)
        pos = Target;
    llSitTarget(pos, ZERO_ROTATION);
}

default
{
    state_entry()
    {
        setTarget();
    }

    on_rez(integer r)
    {
        llResetScript();
    }

    changed(integer change)
    {
        if (change & CHANGED_LINK)
        {
            if (llAvatarOnSitTarget() != NULL_KEY)
            {
                setTarget();
                llRequestPermissions(llAvatarOnSitTarget(), PERMISSION_TRIGGER_ANIMATION);
            }
            else
            {
                integer perm=llGetPermissions();
                if ((perm & PERMISSION_TRIGGER_ANIMATION) && animation!="")
                    llStopAnimation(animation);
            }
        }
    }

    run_time_permissions(integer perm)
    {
        if (perm & PERMISSION_TRIGGER_ANIMATION)
        {
            llStopAnimation("sit");
            integer c = llGetInventoryNumber(INVENTORY_ANIMATION);
            if (c == 0)
                animation = "sit";
            else
                animation = llGetInventoryName(INVENTORY_ANIMATION, (integer)llFrand(c));
            llStartAnimation(animation);
        }
    }
}
