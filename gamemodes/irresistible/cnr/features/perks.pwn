/*
 * Irresistible Gaming (c) 2018
 * Developed by Lorenc Pekaj
 * Module: cnr\features\perks.pwn
 * Purpose: perks system
 */

/* ** Includes ** */
#include 							< YSI\y_hooks >

/* ** Hooks ** */
hook OnDialogResponse( playerid, dialogid, response, listitem, inputtext[ ] )
{
	if ( dialogid == DIALOG_PERKS && response )
	{
		switch( listitem )
		{
			case 0: ShowPlayerDialog( playerid, DIALOG_PERKS_P, DIALOG_STYLE_TABLIST_HEADERS, "{FFFFFF}Game Perks", ""COL_WHITE"Item Name\t"COL_WHITE"Total Level Req.\t"COL_WHITE"Cost ($)\nUnlimited Ammunition\t"COL_GOLD"50\t"COL_GREEN"$9,900", "Select", "Back" );
			case 1: ShowPlayerDialog( playerid, DIALOG_PERKS_V, DIALOG_STYLE_TABLIST_HEADERS, "{FFFFFF}Game Perks", ""COL_WHITE"Item Name\t"COL_WHITE"Total Level Req.\t"COL_WHITE"Cost ($)\nFix & Flip vehicle\t"COL_GOLD"75\t"COL_GREEN"$9,900\nRepair Vehicle\t"COL_GOLD"75\t"COL_GREEN"$7,500\nAdd NOS\t"COL_GOLD"50\t"COL_GREEN"$3,000\nFlip vehicle\t"COL_GOLD"40\t"COL_GREEN"$2,500", "Select", "Back" );
		}
	}
	else if ( dialogid == DIALOG_PERKS_P )
	{
	    if ( !response )
	        return ShowPlayerDialog( playerid, DIALOG_PERKS, DIALOG_STYLE_LIST, "{FFFFFF}Game Perks", "Player Perks\nVehicle Perks", "Select", "Cancel" );

	    new
	    	total_level = GetPlayerTotalLevel( playerid );

	    switch( listitem )
	    {
	        case 0:
	        {
	        	if ( total_level < 50 ) {
	        		return SendError( playerid, "Your total level must be at least 50 to use this (/level)." );
	        	}

	        	if ( GetPlayerCash( playerid ) < 9900 ) {
	        		return SendError( playerid, "You do not have enough money for this item ($9,900)" );
	        	}

                for ( new i = 0; i < MAX_WEAPONS; i++ )
				{
				    if ( IsWeaponInAnySlot( playerid, i ) && i != 0 && !( 16 <= i <= 18 ) && i != 35 && i != 47 && i != WEAPON_BOMB )
				    {
				        GivePlayerWeapon( playerid, i, 15000 );
				    }
				}

				GivePlayerCash( playerid, -9900 );
				SendServerMessage( playerid, "You have bought unlimited ammunition for $9,900." );
				SetPlayerArmedWeapon( playerid, 0 );
				Beep( playerid );
	        }
	    }
	}
	else if ( dialogid == DIALOG_PERKS_V )
	{
	    if ( !response )
	        return ShowPlayerDialog( playerid, DIALOG_PERKS, DIALOG_STYLE_LIST, "{FFFFFF}Game Perks", "Player Perks\nVehicle Perks", "Select", "Cancel" );

		if ( !IsPlayerInAnyVehicle( playerid ) || GetPlayerState( playerid ) != PLAYER_STATE_DRIVER )
		    return SendError( playerid, "You are not in any vehicle as a driver." );

	    new
	    	total_level = GetPlayerTotalLevel( playerid );


	    switch( listitem )
	    {
	    	case 0:
	        {
	        	if ( total_level < 75 ) {
	        		return SendError( playerid, "Your total level must be at least 75 to use this (/level)." );
	        	}

	        	if ( GetPlayerCash( playerid ) < 9900 ) {
	        		return SendError( playerid, "You do not have enough money for this item ($9,900)" );
	        	}

	            new Float: vZ, vehicleid = GetPlayerVehicleID( playerid );
				GetVehicleZAngle( vehicleid, vZ ), SetVehicleZAngle( vehicleid, vZ );
				p_DamageSpamCount{ playerid } = 0;
                RepairVehicle( vehicleid );
                GivePlayerCash( playerid, -9900 );
				SendServerMessage( playerid, "You have fixed and flipped your vehicle for $9,900." );
				PlayerPlaySound( playerid, 1133, 0.0, 0.0, 5.0 );
	        }
	        case 1:
	        {
	        	if ( total_level < 75 ) {
	        		return SendError( playerid, "Your total level must be at least 75 to use this (/level)." );
	        	}

	        	if ( GetPlayerCash( playerid ) < 7500 ) {
	        		return SendError( playerid, "You do not have enough money for this item ($7,500)" );
	        	}

            	new vehicleid = GetPlayerVehicleID( playerid );
				PlayerPlaySound( playerid, 1133, 0.0, 0.0, 5.0 );
				p_DamageSpamCount{ playerid } = 0;
                RepairVehicle( vehicleid );
                GivePlayerCash( playerid, -7500 );
				SendServerMessage( playerid, "You have repaired your car for $7,500." );
	        }
	        case 2:
	        {
	        	if ( total_level < 50 ) {
	        		return SendError( playerid, "Your total level must be at least 50 to use this (/level)." );
	        	}

	        	if ( GetPlayerCash( playerid ) < 3000 ) {
	        		return SendError( playerid, "You do not have enough money for this item ($3,000)" );
	        	}

                AddVehicleComponent( GetPlayerVehicleID( playerid ), 1010 );
                GivePlayerCash( playerid, -3000 );
				SendServerMessage( playerid, "You have installed nitro on your car for $3,000." );
				PlayerPlaySound( playerid, 1133, 0.0, 0.0, 5.0 );
	        }
	        case 3:
	        {
	        	if ( total_level < 40 ) {
	        		return SendError( playerid, "Your total level must be at least 40 to use this (/level)." );
	        	}

	        	if ( GetPlayerCash( playerid ) < 2500 ) {
	        		return SendError( playerid, "You do not have enough money for this item ($2,500)" );
	        	}

	            new Float: vZ, vehicleid = GetPlayerVehicleID( playerid );
				GetVehicleZAngle( vehicleid, vZ ), SetVehicleZAngle( vehicleid, vZ );
                GivePlayerCash( playerid, -2500 );
				SendServerMessage( playerid, "You have flipped your vehicle for $2,500." );
				PlayerPlaySound( playerid, 1133, 0.0, 0.0, 5.0 );
	        }
	    }
	}
	return 1;
}

/* ** Commands ** */
CMD:perks( playerid, params[ ] )
{
	if ( IsPlayerInEvent( playerid ) ) {
		return SendError( playerid, "You cannot use this command since you're in an event." );
	}
	return ShowPlayerDialog( playerid, DIALOG_PERKS, DIALOG_STYLE_LIST, "{FFFFFF}Game Perks", "Player Perks\nVehicle Perks", "Select", "Cancel" );
}

/* ** Functions ** */