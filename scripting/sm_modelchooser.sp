/*
 * sm_modelchooser: Give players an option for changing their model.  Workaround for Steampipe model problems.
 * Thrown together by [foo] bar <foobarhl@gmail.com> | http://steamcommunity.com/id/foo-bar/
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 */


#include <sourcemod>
#include <sdktools>
#include <smlib>
#include <clientprefs>

#define VERSION "0.2"

new String:Models[19][46] = {
	"models/combine_soldier.mdl",
	"models/combine_soldier_prisonguard.mdl",
	"models/combine_super_soldier.mdl",
	"models/police.mdl",
	"models/humans/group03/female_01.mdl",
	"models/humans/group03/female_02.mdl",
	"models/humans/group03/female_03.mdl",
	"models/humans/group03/female_04.mdl",
	"models/humans/group03/female_06.mdl",
	"models/humans/group03/female_07.mdl",
	"models/humans/group03/male_01.mdl",
	"models/humans/group03/male_02.mdl",
	"models/humans/group03/male_03.mdl",
	"models/humans/group03/male_04.mdl",
	"models/humans/group03/male_05.mdl",
	"models/humans/group03/male_06.mdl",
	"models/humans/group03/male_07.mdl",
	"models/humans/group03/male_08.mdl",
	"models/humans/group03/male_09.mdl"
}

public Plugin:myinfo =
{
	name = "Model Chooser",
	author = "[foo] bar",
	description = "Give players a menu to select their model",
	version = VERSION,
	url = "https://github.com/foobarhl/sourcemod"
}

public OnPluginStart()
{
	new i;
	for(i=0;i<sizeof(Models);i++){
		PrecacheModel(Models[i]);
	}
	SetCookieMenuItem(MenuModelPref,0,"Player model");
	RegConsoleCmd("model",MenuModel);
}

public MenuHandlerModel(Handle:menu, MenuAction:action, param1, param2)
{
	decl String:info[50];
	GetMenuItem(menu,param2,info,sizeof(info));
	if(action==MenuAction_Select) {
		changeModel(param1,info);
	} else if(action==MenuAction_End) {
		CloseHandle(menu);
	}

}

public MenuModelPref(client, CookieMenuAction:action, any:info, String:buffer[], maxlen)
{
	if(action == CookieMenuAction_SelectOption){
		ShowModelMenu(client);
	}
}

public Action:MenuModel(client,args)
{
	ShowModelMenu(client);
	return(Plugin_Handled);
}

ShowModelMenu(client)
{
	new Handle:menu = CreateMenu(MenuHandlerModel);
	decl String:buffer[255];
	new i;

	for(i=0;i<sizeof(Models);i++){
		File_GetFileName(Models[i],buffer,sizeof(buffer));
		AddMenuItem(menu,Models[i],buffer)
	}
	SetMenuExitButton(menu,true);
	DisplayMenu(menu,client,20);
}



public changeModel(client,String:model[])
{
	ClientCommand(client, "cl_playermodel %s", model);
	SetEntityRenderColor(client, 255, 255, 255, 255);
}