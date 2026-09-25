#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\scriptbundle_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace scene;

/*
	Name: __init__sytem__
	Namespace: scene
	Checksum: 0x90CC8E04
	Offset: 0x1A8
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	/#
		system::register("Dev Block strings are not supported", &__init__, undefined, undefined);
	#/
}

/*
	Name: __init__
	Namespace: scene
	Checksum: 0x945419C1
	Offset: 0x1E8
	Size: 0x11B
	Parameters: 0
	Flags: None
*/
function __init__()
{
	/#
		if(GetDvarString("Dev Block strings are not supported", "Dev Block strings are not supported") == "Dev Block strings are not supported")
		{
			SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
		}
		SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
		SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
		SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
		level thread run_scene_tests();
		level thread toggle_scene_menu();
		level thread function_12727f7b();
		level thread function_f69ab75e();
	#/
}

/*
	Name: function_f69ab75e
	Namespace: scene
	Checksum: 0xF81A5076
	Offset: 0x310
	Size: 0xD7
	Parameters: 0
	Flags: None
*/
function function_f69ab75e()
{
	/#
		while(1)
		{
			level flagsys::wait_till("Dev Block strings are not supported");
			foreach(var_4d881e03 in function_c4a37ed9())
			{
				var_4d881e03 thread debug_display();
			}
			level flagsys::wait_till_clear("Dev Block strings are not supported");
		}
	#/
}

/*
	Name: function_c4a37ed9
	Namespace: scene
	Checksum: 0xB19F2FFC
	Offset: 0x3F0
	Size: 0x103
	Parameters: 0
	Flags: None
*/
function function_c4a37ed9()
{
	/#
		a_scenes = ArrayCombine(struct::get_array("Dev Block strings are not supported", "Dev Block strings are not supported"), struct::get_array("Dev Block strings are not supported", "Dev Block strings are not supported"), 0, 0);
		foreach(a_active_scenes in level.active_scenes)
		{
			a_scenes = ArrayCombine(a_scenes, a_active_scenes, 0, 0);
		}
		return a_scenes;
	#/
}

/*
	Name: run_scene_tests
	Namespace: scene
	Checksum: 0x8208F8CA
	Offset: 0x500
	Size: 0x697
	Parameters: 0
	Flags: None
*/
function run_scene_tests()
{
	/#
		level endon("run_scene_tests");
		level.var_999f0f4e = spawnstruct();
		level.var_999f0f4e.origin = (0, 0, 0);
		level.var_999f0f4e.angles = (0, 0, 0);
		while(1)
		{
			str_scene = GetDvarString("Dev Block strings are not supported");
			var_a8ca2595 = GetDvarString("Dev Block strings are not supported");
			str_mode = ToLower(GetDvarString("Dev Block strings are not supported", "Dev Block strings are not supported"));
			var_fe725d7e = str_mode == "Dev Block strings are not supported" || str_mode == "Dev Block strings are not supported";
			if(var_fe725d7e)
			{
				if(IsPC())
				{
					if(str_scene != "Dev Block strings are not supported")
					{
						SetDvar("Dev Block strings are not supported", str_scene);
						SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
					}
				}
				else
				{
					SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
				}
			}
			else if(var_a8ca2595 != "Dev Block strings are not supported")
			{
				level util::clientNotify(var_a8ca2595 + "Dev Block strings are not supported");
				util::wait_network_frame();
			}
			if(str_scene != "Dev Block strings are not supported")
			{
				SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
				function_68a9014b(str_scene);
				b_found = 0;
				a_scenes = struct::get_array(str_scene, "Dev Block strings are not supported");
				foreach(s_instance in a_scenes)
				{
					if(isdefined(s_instance))
					{
						b_found = 1;
						s_instance thread function_fc5821e2(undefined, str_mode);
					}
				}
				if(!b_found && isdefined(level.active_scenes[str_scene]))
				{
					foreach(s_instance in level.active_scenes[str_scene])
					{
						b_found = 1;
						s_instance thread function_fc5821e2(str_scene, str_mode);
					}
				}
				else if(!b_found)
				{
					level.var_999f0f4e thread function_fc5821e2(str_scene, str_mode);
				}
			}
			str_scene = GetDvarString("Dev Block strings are not supported");
			var_a8ca2595 = GetDvarString("Dev Block strings are not supported");
			if(var_a8ca2595 != "Dev Block strings are not supported")
			{
				level util::clientNotify(var_a8ca2595 + "Dev Block strings are not supported");
				util::wait_network_frame();
			}
			if(str_scene != "Dev Block strings are not supported")
			{
				SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
				function_68a9014b(str_scene);
				b_found = 0;
				a_scenes = struct::get_array(str_scene, "Dev Block strings are not supported");
				foreach(s_instance in a_scenes)
				{
					if(isdefined(s_instance))
					{
						b_found = 1;
						s_instance thread function_1b5ca25a();
					}
				}
				if(!b_found)
				{
					level.var_999f0f4e thread function_1b5ca25a(str_scene);
				}
				if(var_fe725d7e)
				{
					function_c7dd4c10(str_scene, str_mode);
				}
			}
			str_scene = GetDvarString("Dev Block strings are not supported");
			var_a8ca2595 = GetDvarString("Dev Block strings are not supported");
			if(var_a8ca2595 != "Dev Block strings are not supported")
			{
				level util::clientNotify(var_a8ca2595 + "Dev Block strings are not supported");
				util::wait_network_frame();
			}
			if(str_scene != "Dev Block strings are not supported")
			{
				SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
				level stop(str_scene, 1);
			}
			wait(0.05);
		}
	#/
}

/*
	Name: function_c7dd4c10
	Namespace: scene
	Checksum: 0xCDC90501
	Offset: 0xBA0
	Size: 0x5B
	Parameters: 2
	Flags: None
*/
function function_c7dd4c10(str_scene, str_mode)
{
	/#
		SetDvar("Dev Block strings are not supported", 0);
		level Play(str_scene, undefined, undefined, 1, undefined, str_mode);
	#/
}

/*
	Name: function_68a9014b
	Namespace: scene
	Checksum: 0xB17ABB79
	Offset: 0xC08
	Size: 0xC1
	Parameters: 1
	Flags: None
*/
function function_68a9014b(str_scene)
{
	/#
		foreach(ent in GetEntArray(str_scene, "Dev Block strings are not supported"))
		{
			if(ent.scene_spawned === str_scene)
			{
				ent delete();
			}
		}
	#/
}

/*
	Name: toggle_scene_menu
	Namespace: scene
	Checksum: 0xCCF595B1
	Offset: 0xCD8
	Size: 0x177
	Parameters: 0
	Flags: None
*/
function toggle_scene_menu()
{
	/#
		SetDvar("Dev Block strings are not supported", 0);
		var_d5df0f79 = -1;
		while(1)
		{
			var_68c04b0a = GetDvarString("Dev Block strings are not supported");
			if(var_68c04b0a != "Dev Block strings are not supported")
			{
				var_68c04b0a = Int(var_68c04b0a);
				if(var_68c04b0a != var_d5df0f79)
				{
					switch(var_68c04b0a)
					{
						case 1:
						{
							level thread display_scene_menu("Dev Block strings are not supported");
							break;
						}
						case 2:
						{
							level thread display_scene_menu("Dev Block strings are not supported");
							break;
						}
						case default:
						{
							level flagsys::clear("Dev Block strings are not supported");
							level notify("scene_menu_cleanup");
							SetDvar("Dev Block strings are not supported", 0);
							SetDvar("Dev Block strings are not supported", 1);
						}
					}
					var_d5df0f79 = var_68c04b0a;
				}
			}
			wait(0.05);
		}
	#/
}

/*
	Name: create_scene_hud
	Namespace: scene
	Checksum: 0x4B1C36ED
	Offset: 0xE58
	Size: 0x191
	Parameters: 2
	Flags: None
*/
function create_scene_hud(scene_name, index)
{
	/#
		player = level.host;
		alpha = 1;
		color = VectorScale((1, 1, 1), 0.9);
		if(index != -1)
		{
			if(index != 5)
			{
				alpha = 1 - Abs(5 - index) / 5;
			}
		}
		if(alpha == 0)
		{
			alpha = 0.05;
		}
		hudelem = player OpenLUIMenu("Dev Block strings are not supported");
		player SetLUIMenuData(hudelem, "Dev Block strings are not supported", scene_name);
		player SetLUIMenuData(hudelem, "Dev Block strings are not supported", 100);
		player SetLUIMenuData(hudelem, "Dev Block strings are not supported", 80 + index * 18);
		player SetLUIMenuData(hudelem, "Dev Block strings are not supported", 1000);
		return hudelem;
	#/
}

/*
	Name: display_scene_menu
	Namespace: scene
	Checksum: 0x8EC5F1B4
	Offset: 0xFF8
	Size: 0x947
	Parameters: 1
	Flags: None
*/
function display_scene_menu(str_type)
{
	/#
		if(!isdefined(str_type))
		{
			str_type = "Dev Block strings are not supported";
		}
		level notify("scene_menu_cleanup");
		level endon("scene_menu_cleanup");
		waittillframeend;
		level flagsys::set("Dev Block strings are not supported");
		SetDvar("Dev Block strings are not supported", 1);
		SetDvar("Dev Block strings are not supported", 0);
		level thread function_96d7ecd1();
		hudelem = level.host OpenLUIMenu("Dev Block strings are not supported");
		level.host SetLUIMenuData(hudelem, "Dev Block strings are not supported", "Dev Block strings are not supported");
		level.host SetLUIMenuData(hudelem, "Dev Block strings are not supported", 100);
		level.host SetLUIMenuData(hudelem, "Dev Block strings are not supported", 520);
		level.host SetLUIMenuData(hudelem, "Dev Block strings are not supported", 500);
		a_scenedefs = get_scenedefs(str_type);
		if(str_type == "Dev Block strings are not supported")
		{
			a_scenedefs = ArrayCombine(a_scenedefs, get_scenedefs("Dev Block strings are not supported"), 0, 1);
		}
		names = [];
		foreach(s_scenedef in a_scenedefs)
		{
			Array::add_sorted(names, s_scenedef.name, 0);
		}
		names[names.size] = "Dev Block strings are not supported";
		elems = scene_list_menu();
		title = create_scene_hud(str_type + "Dev Block strings are not supported", -1);
		selected = 0;
		up_pressed = 0;
		down_pressed = 0;
		held = 0;
		scene_list_settext(elems, names, selected);
		old_selected = selected;
		level thread scene_menu_cleanup(elems, title, hudelem);
		while(1)
		{
			scene_list_settext(elems, names, selected);
			if(held)
			{
				wait(0.5);
			}
			if(!up_pressed)
			{
				if(level.host util::function_5298bc32())
				{
					up_pressed = 1;
					selected--;
				}
			}
			else if(level.host util::function_d286c26d())
			{
				held = 1;
				selected = selected - 10;
			}
			else if(!level.host util::function_5298bc32())
			{
				held = 0;
				up_pressed = 0;
			}
			if(!down_pressed)
			{
				if(level.host util::function_95f33d4f())
				{
					down_pressed = 1;
					selected++;
				}
			}
			else if(level.host util::function_1adfa50a())
			{
				held = 1;
				selected = selected + 10;
			}
			else if(!level.host util::function_95f33d4f())
			{
				held = 0;
				down_pressed = 0;
			}
			if(held)
			{
				if(selected < 0)
				{
					selected = 0;
				}
				else if(selected >= names.size)
				{
					selected = names.size - 1;
				}
			}
			else if(selected < 0)
			{
				selected = names.size - 1;
			}
			else if(selected >= names.size)
			{
				selected = 0;
			}
			if(level.host buttonpressed("Dev Block strings are not supported"))
			{
				SetDvar("Dev Block strings are not supported", 0);
			}
			if(names[selected] != "Dev Block strings are not supported")
			{
				if(level.host buttonpressed("Dev Block strings are not supported") || level.host buttonpressed("Dev Block strings are not supported"))
				{
					level.host function_76dbac0b(names[selected]);
					while(level.host buttonpressed("Dev Block strings are not supported") || level.host buttonpressed("Dev Block strings are not supported"))
					{
						wait(0.05);
					}
					break;
				}
				if(level.host buttonpressed("Dev Block strings are not supported") || level.host buttonpressed("Dev Block strings are not supported"))
				{
					level.host function_76dbac0b(names[selected], 1);
					while(level.host buttonpressed("Dev Block strings are not supported") || level.host buttonpressed("Dev Block strings are not supported"))
					{
						wait(0.05);
					}
				}
			}
			if(level.host buttonpressed("Dev Block strings are not supported") || level.host buttonpressed("Dev Block strings are not supported") || level.host buttonpressed("Dev Block strings are not supported"))
			{
				if(names[selected] == "Dev Block strings are not supported")
				{
					SetDvar("Dev Block strings are not supported", 0);
					continue;
				}
				if(function_d57e2dab(names[selected]))
				{
					SetDvar("Dev Block strings are not supported", names[selected]);
					continue;
				}
				if(function_87fbeee3(names[selected]))
				{
					SetDvar("Dev Block strings are not supported", names[selected]);
					continue;
				}
				if(has_init_state(names[selected]))
				{
					SetDvar("Dev Block strings are not supported", names[selected]);
					continue;
				}
				SetDvar("Dev Block strings are not supported", names[selected]);
				while(level.host buttonpressed("Dev Block strings are not supported") || level.host buttonpressed("Dev Block strings are not supported") || level.host buttonpressed("Dev Block strings are not supported"))
				{
					wait(0.05);
				}
			}
			wait(0.05);
		}
	#/
}

/*
	Name: function_96d7ecd1
	Namespace: scene
	Checksum: 0x1B325CC0
	Offset: 0x1948
	Size: 0x233
	Parameters: 0
	Flags: None
*/
function function_96d7ecd1()
{
	/#
		hudelem = level.host OpenLUIMenu("Dev Block strings are not supported");
		level.host SetLUIMenuData(hudelem, "Dev Block strings are not supported", 100);
		level.host SetLUIMenuData(hudelem, "Dev Block strings are not supported", 490);
		level.host SetLUIMenuData(hudelem, "Dev Block strings are not supported", 500);
		while(level flagsys::get("Dev Block strings are not supported"))
		{
			str_mode = ToLower(GetDvarString("Dev Block strings are not supported", "Dev Block strings are not supported"));
			switch(str_mode)
			{
				case "Dev Block strings are not supported":
				{
					level.host SetLUIMenuData(hudelem, "Dev Block strings are not supported", "Dev Block strings are not supported");
					break;
				}
				case "Dev Block strings are not supported":
				{
					level.host SetLUIMenuData(hudelem, "Dev Block strings are not supported", "Dev Block strings are not supported");
					break;
				}
				case "Dev Block strings are not supported":
				{
					level.host SetLUIMenuData(hudelem, "Dev Block strings are not supported", "Dev Block strings are not supported");
					break;
				}
				case "Dev Block strings are not supported":
				{
					level.host SetLUIMenuData(hudelem, "Dev Block strings are not supported", "Dev Block strings are not supported");
					break;
				}
			}
			wait(0.05);
		}
		level.host CloseLUIMenu(hudelem);
	#/
}

/*
	Name: scene_list_menu
	Namespace: scene
	Checksum: 0x8C620AE4
	Offset: 0x1B88
	Size: 0x81
	Parameters: 0
	Flags: None
*/
function scene_list_menu()
{
	/#
		hud_array = [];
		for(i = 0; i < 22; i++)
		{
			hud = create_scene_hud("Dev Block strings are not supported", i);
			hud_array[hud_array.size] = hud;
		}
		return hud_array;
	#/
}

/*
	Name: scene_list_settext
	Namespace: scene
	Checksum: 0x6704776F
	Offset: 0x1C18
	Size: 0x20D
	Parameters: 3
	Flags: None
*/
function scene_list_settext(hud_array, strings, num)
{
	/#
		for(i = 0; i < hud_array.size; i++)
		{
			index = i + num - 5;
			if(isdefined(strings[index]))
			{
				text = strings[index];
			}
			else
			{
				text = "Dev Block strings are not supported";
			}
			if(function_d57e2dab(text))
			{
				level.host SetLUIMenuData(hud_array[i], "Dev Block strings are not supported", 1);
				text = text + "Dev Block strings are not supported";
			}
			else if(function_87fbeee3(text))
			{
				level.host SetLUIMenuData(hud_array[i], "Dev Block strings are not supported", 1);
				text = text + "Dev Block strings are not supported";
			}
			else
			{
				level.host SetLUIMenuData(hud_array[i], "Dev Block strings are not supported", 0.5);
			}
			if(i == 5)
			{
				level.host SetLUIMenuData(hud_array[i], "Dev Block strings are not supported", 1);
				text = "Dev Block strings are not supported" + text + "Dev Block strings are not supported";
			}
			level.host SetLUIMenuData(hud_array[i], "Dev Block strings are not supported", text);
		}
	#/
}

/*
	Name: function_d57e2dab
	Namespace: scene
	Checksum: 0x6A7FE4C7
	Offset: 0x1E30
	Size: 0x5F
	Parameters: 1
	Flags: None
*/
function function_d57e2dab(str_scene)
{
	/#
		if(str_scene != "Dev Block strings are not supported" && str_scene != "Dev Block strings are not supported")
		{
			if(level flagsys::get(str_scene + "Dev Block strings are not supported"))
			{
				return 1;
			}
		}
		return 0;
	#/
}

/*
	Name: function_87fbeee3
	Namespace: scene
	Checksum: 0x2672DE33
	Offset: 0x1E98
	Size: 0x5F
	Parameters: 1
	Flags: None
*/
function function_87fbeee3(str_scene)
{
	/#
		if(str_scene != "Dev Block strings are not supported" && str_scene != "Dev Block strings are not supported")
		{
			if(level flagsys::get(str_scene + "Dev Block strings are not supported"))
			{
				return 1;
			}
		}
		return 0;
	#/
}

/*
	Name: scene_menu_cleanup
	Namespace: scene
	Checksum: 0x3FD7833B
	Offset: 0x1F00
	Size: 0xB3
	Parameters: 3
	Flags: None
*/
function scene_menu_cleanup(elems, title, hudelem)
{
	/#
		level waittill("scene_menu_cleanup");
		level.host CloseLUIMenu(title);
		for(i = 0; i < elems.size; i++)
		{
			level.host CloseLUIMenu(elems[i]);
		}
		level.host CloseLUIMenu(hudelem);
	#/
}

/*
	Name: function_1b5ca25a
	Namespace: scene
	Checksum: 0xF08F4948
	Offset: 0x1FC0
	Size: 0x2B
	Parameters: 1
	Flags: None
*/
function function_1b5ca25a(arg1)
{
	/#
		init(arg1, undefined, undefined, 1);
	#/
}

/*
	Name: function_fc5821e2
	Namespace: scene
	Checksum: 0x712082F7
	Offset: 0x1FF8
	Size: 0x3B
	Parameters: 2
	Flags: None
*/
function function_fc5821e2(arg1, str_mode)
{
	/#
		Play(arg1, undefined, undefined, 1, undefined, str_mode);
	#/
}

/*
	Name: debug_display
	Namespace: scene
	Checksum: 0xFAAE9549
	Offset: 0x2040
	Size: 0x2DD
	Parameters: 0
	Flags: None
*/
function debug_display()
{
System.InvalidOperationException: Stack empty.
   at System.ThrowHelper.ThrowInvalidOperationException(ExceptionResource resource)
   at System.Collections.Generic.Stack`1.Pop()
   at ‍​⁯‮⁪‍‪⁫⁮‎‫⁬‌⁭⁪​‫‬‫​​‌⁬‏‮⁫‪​‪⁫⁭⁮‫​⁮‍‭‌‬‎‮.‍‬‎‎⁯‪‌‌‏⁪‍‬⁯‮‌⁭⁬⁮‬‌‎‎‏‎‫⁪⁮⁭⁪​⁫‌⁯⁯‎⁪​‌‌⁬‮(String , Int32 , Boolean , Boolean )
   at ‍​⁯‮⁪‍‪⁫⁮‎‫⁬‌⁭⁪​‫‬‫​​‌⁬‏‮⁫‪​‪⁫⁭⁮‫​⁮‍‭‌‬‎‮.​‮‍‬⁯⁭‍⁫‌‭‎⁫‪⁮‏‏⁯⁫‏‏‮⁫⁪‫‪⁪⁭⁯‮⁯‭⁯‫⁯‎‏‍‌⁫‪‮(ScriptOp , ⁯‪‪‏⁮‮‎‏‏⁯‍⁬‮⁭‮‏‫‬‌‌‏​⁬‫⁯⁬‮‮⁫⁬‍‫⁮⁫‬⁪⁮‮⁭‌‮ )
   at ‍​⁯‮⁪‍‪⁫⁮‎‫⁬‌⁭⁪​‫‬‫​​‌⁬‏‮⁫‪​‪⁫⁭⁮‫​⁮‍‭‌‬‎‮.‌‏‪‍⁫‮⁮‫‍‬⁯⁮⁮‏‬‪‎‎‍⁪‮⁪‬‬⁪⁭‮‫‭⁮‮‫‭‫‏‭‫‪⁪‪‮(⁯‪‪‏⁮‮‎‏‏⁯‍⁬‮⁭‮‏‫‬‌‌‏​⁬‫⁯⁬‮‮⁫⁬‍‫⁮⁫‬⁪⁮‮⁭‌‮ , Int32 )
   at ‍​⁯‮⁪‍‪⁫⁮‎‫⁬‌⁭⁪​‫‬‫​​‌⁬‏‮⁫‪​‪⁫⁭⁮‫​⁮‍‭‌‬‎‮.‌‏‪‍⁫‮⁮‫‍‬⁯⁮⁮‏‬‪‎‎‍⁪‮⁪‬‬⁪⁭‮‫‭⁮‮‫‭‫‏‭‫‪⁪‪‮(⁯‪‪‏⁮‮‎‏‏⁯‍⁬‮⁭‮‏‫‬‌‌‏​⁬‫⁯⁬‮‮⁫⁬‍‫⁮⁫‬⁪⁮‮⁭‌‮ , Int32 )
   at ‍​⁯‮⁪‍‪⁫⁮‎‫⁬‌⁭⁪​‫‬‫​​‌⁬‏‮⁫‪​‪⁫⁭⁮‫​⁮‍‭‌‬‎‮.‌‏‪‍⁫‮⁮‫‍‬⁯⁮⁮‏‬‪‎‎‍⁪‮⁪‬‬⁪⁭‮‫‭⁮‮‫‭‫‏‭‫‪⁪‪‮(⁯‪‪‏⁮‮‎‏‏⁯‍⁬‮⁭‮‏‫‬‌‌‏​⁬‫⁯⁬‮‮⁫⁬‍‫⁮⁫‬⁪⁮‮⁭‌‮ , Int32 )
   at ‍​⁯‮⁪‍‪⁫⁮‎‫⁬‌⁭⁪​‫‬‫​​‌⁬‏‮⁫‪​‪⁫⁭⁮‫​⁮‍‭‌‬‎‮.‌‏‪‍⁫‮⁮‫‍‬⁯⁮⁮‏‬‪‎‎‍⁪‮⁪‬‬⁪⁭‮‫‭⁮‮‫‭‫‏‭‫‪⁪‪‮(⁯‪‪‏⁮‮‎‏‏⁯‍⁬‮⁭‮‏‫‬‌‌‏​⁬‫⁯⁬‮‮⁫⁬‍‫⁮⁫‬⁪⁮‮⁭‌‮ , Int32 )
   at ‍​⁯‮⁪‍‪⁫⁮‎‫⁬‌⁭⁪​‫‬‫​​‌⁬‏‮⁫‪​‪⁫⁭⁮‫​⁮‍‭‌‬‎‮.‌‏‪‍⁫‮⁮‫‍‬⁯⁮⁮‏‬‪‎‎‍⁪‮⁪‬‬⁪⁭‮‫‭⁮‮‫‭‫‏‭‫‪⁪‪‮(⁯‪‪‏⁮‮‎‏‏⁯‍⁬‮⁭‮‏‫‬‌‌‏​⁬‫⁯⁬‮‮⁫⁬‍‫⁮⁫‬⁪⁮‮⁭‌‮ , Int32 )
   at ‍​⁯‮⁪‍‪⁫⁮‎‫⁬‌⁭⁪​‫‬‫​​‌⁬‏‮⁫‪​‪⁫⁭⁮‫​⁮‍‭‌‬‎‮..ctor(ScriptExport , ScriptBase )
}

/*
	Name: function_76dbac0b
	Namespace: scene
	Checksum: 0x2546C035
	Offset: 0x2328
	Size: 0x223
	Parameters: 2
	Flags: None
*/
function function_76dbac0b(str_scene, var_3130e2d6)
{
	/#
		if(!isdefined(var_3130e2d6))
		{
			var_3130e2d6 = 0;
		}
		if(!level.var_59c5fd21 === str_scene)
		{
			level.var_97358730 = struct::get_array(str_scene, "Dev Block strings are not supported");
			level.var_22bb787c = 0;
			level.var_59c5fd21 = str_scene;
		}
		else if(var_3130e2d6)
		{
			level.var_22bb787c--;
			if(level.var_22bb787c == -1)
			{
				level.var_22bb787c = level.var_97358730.size - 1;
			}
		}
		else
		{
			level.var_22bb787c++;
			if(level.var_22bb787c == level.var_97358730.size)
			{
				level.var_22bb787c = 0;
			}
		}
		if(level.var_97358730.size == 0)
		{
			s_bundle = struct::get_script_bundle("Dev Block strings are not supported", str_scene);
			if(isdefined(s_bundle.aligntarget))
			{
				e_align = get_existing_ent(s_bundle.aligntarget, 0, 1);
				if(isdefined(e_align))
				{
					level.host function_8d3bf7f8(e_align.origin);
				}
				else
				{
					scriptbundle::error_on_screen("Dev Block strings are not supported");
				}
			}
			else
			{
				scriptbundle::error_on_screen("Dev Block strings are not supported");
			}
		}
		else
		{
			s_scene = level.var_97358730[level.var_22bb787c];
			level.host function_8d3bf7f8(s_scene.origin);
		}
	#/
}

/*
	Name: function_8d3bf7f8
	Namespace: scene
	Checksum: 0x6126F971
	Offset: 0x2558
	Size: 0x63
	Parameters: 1
	Flags: None
*/
function function_8d3bf7f8(v_origin)
{
	/#
		if(!self IsInMoveMode("Dev Block strings are not supported", "Dev Block strings are not supported"))
		{
			AddDebugCommand("Dev Block strings are not supported");
		}
		self SetOrigin(v_origin);
	#/
}

/*
	Name: function_12727f7b
	Namespace: scene
	Checksum: 0xF20F5BAF
	Offset: 0x25C8
	Size: 0x73
	Parameters: 0
	Flags: None
*/
function function_12727f7b()
{
	/#
		while(1)
		{
			if(GetDvarInt("Dev Block strings are not supported", 0))
			{
				Array::run_all(level.activePlayers, &clientfield::increment_to_player, "Dev Block strings are not supported", 1);
				wait(4);
			}
			wait(1);
		}
	#/
}

