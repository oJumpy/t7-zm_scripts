#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
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
	Checksum: 0x190B6660
	Offset: 0x180
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
	Checksum: 0x8F374282
	Offset: 0x1C0
	Size: 0xA3
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
		level thread run_scene_tests();
		level thread toggle_scene_menu();
		level thread function_f69ab75e();
	#/
}

/*
	Name: function_f69ab75e
	Namespace: scene
	Checksum: 0xA6AB3BD5
	Offset: 0x270
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
			foreach(e_scene in function_c4a37ed9())
			{
				e_scene thread debug_display();
			}
			level flagsys::wait_till_clear("Dev Block strings are not supported");
		}
	#/
}

/*
	Name: function_c4a37ed9
	Namespace: scene
	Checksum: 0x8A28E2C5
	Offset: 0x350
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
	Checksum: 0x712831C9
	Offset: 0x460
	Size: 0x49F
	Parameters: 0
	Flags: None
*/
function run_scene_tests()
{
	/#
		level endon("run_scene_tests");
		level.scene_test_struct = spawnstruct();
		level.scene_test_struct.origin = (0, 0, 0);
		level.scene_test_struct.angles = (0, 0, 0);
		while(1)
		{
			str_scene = GetDvarString("Dev Block strings are not supported");
			str_mode = ToLower(GetDvarString("Dev Block strings are not supported", "Dev Block strings are not supported"));
			if(str_scene != "Dev Block strings are not supported")
			{
				SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
				clear_old_ents(str_scene);
				b_found = 0;
				a_scenes = struct::get_array(str_scene, "Dev Block strings are not supported");
				foreach(s_instance in a_scenes)
				{
					if(isdefined(s_instance))
					{
						b_found = 1;
						s_instance thread test_play(undefined, str_mode);
					}
				}
				if(isdefined(level.active_scenes[str_scene]))
				{
					foreach(s_instance in level.active_scenes[str_scene])
					{
						if(!IsInArray(a_scenes, s_instance))
						{
							b_found = 1;
							s_instance thread test_play(str_scene, str_mode);
						}
					}
				}
				else if(!b_found)
				{
					level.scene_test_struct thread test_play(str_scene, str_mode);
				}
			}
			str_scene = GetDvarString("Dev Block strings are not supported");
			if(str_scene != "Dev Block strings are not supported")
			{
				SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
				clear_old_ents(str_scene);
				b_found = 0;
				a_scenes = struct::get_array(str_scene, "Dev Block strings are not supported");
				foreach(s_instance in a_scenes)
				{
					if(isdefined(s_instance))
					{
						b_found = 1;
						s_instance thread test_init();
					}
				}
				if(!b_found)
				{
					level.scene_test_struct thread test_init(str_scene);
				}
			}
			str_scene = GetDvarString("Dev Block strings are not supported");
			if(str_scene != "Dev Block strings are not supported")
			{
				SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
				level stop(str_scene, 1);
			}
			wait(0.016);
		}
	#/
}

/*
	Name: clear_old_ents
	Namespace: scene
	Checksum: 0xF9D73B94
	Offset: 0x908
	Size: 0xD1
	Parameters: 1
	Flags: None
*/
function clear_old_ents(str_scene)
{
	/#
		foreach(ent in GetEntArray(0))
		{
			if(ent.scene_spawned === str_scene && ent.finished_scene === str_scene)
			{
				ent delete();
			}
		}
	#/
}

/*
	Name: toggle_scene_menu
	Namespace: scene
	Checksum: 0xA9046D1B
	Offset: 0x9E8
	Size: 0x157
	Parameters: 0
	Flags: None
*/
function toggle_scene_menu()
{
	/#
		SetDvar("Dev Block strings are not supported", 0);
		n_scene_menu_last = -1;
		while(1)
		{
			n_scene_menu = GetDvarString("Dev Block strings are not supported");
			if(n_scene_menu != "Dev Block strings are not supported")
			{
				n_scene_menu = Int(n_scene_menu);
				if(n_scene_menu != n_scene_menu_last)
				{
					switch(n_scene_menu)
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
							SetDvar("Dev Block strings are not supported", 1);
						}
					}
					n_scene_menu_last = n_scene_menu;
				}
			}
			wait(0.05);
		}
	#/
}

/*
	Name: create_scene_hud
	Namespace: scene
	Checksum: 0x85068A1F
	Offset: 0xB48
	Size: 0x199
	Parameters: 2
	Flags: None
*/
function create_scene_hud(scene_name, index)
{
	/#
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
		hudelem = CreateLUIMenu(0, "Dev Block strings are not supported");
		SetLUIMenuData(0, hudelem, "Dev Block strings are not supported", scene_name);
		SetLUIMenuData(0, hudelem, "Dev Block strings are not supported", 100);
		SetLUIMenuData(0, hudelem, "Dev Block strings are not supported", 80 + index * 18);
		SetLUIMenuData(0, hudelem, "Dev Block strings are not supported", 1000);
		OpenLUIMenu(0, hudelem);
		return hudelem;
	#/
}

/*
	Name: display_scene_menu
	Namespace: scene
	Checksum: 0x95C64570
	Offset: 0xCF0
	Size: 0x72F
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
		SetDvar("Dev Block strings are not supported", 0);
		level thread display_mode();
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
		level thread scene_menu_cleanup(elems, title);
		while(1)
		{
			scene_list_settext(elems, names, selected);
			if(held)
			{
				wait(0.5);
			}
			if(!up_pressed)
			{
				if(level.localPlayers[0] util::up_button_pressed())
				{
					up_pressed = 1;
					selected--;
				}
			}
			else if(level.localPlayers[0] util::up_button_held())
			{
				held = 1;
				selected = selected - 10;
			}
			else if(!level.localPlayers[0] util::up_button_pressed())
			{
				held = 0;
				up_pressed = 0;
			}
			if(!down_pressed)
			{
				if(level.localPlayers[0] util::down_button_pressed())
				{
					down_pressed = 1;
					selected++;
				}
			}
			else if(level.localPlayers[0] util::down_button_held())
			{
				held = 1;
				selected = selected + 10;
			}
			else if(!level.localPlayers[0] util::down_button_pressed())
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
			if(level.localPlayers[0] buttonpressed("Dev Block strings are not supported"))
			{
				SetDvar("Dev Block strings are not supported", 0);
			}
			if(level.localPlayers[0] buttonpressed("Dev Block strings are not supported") || level.localPlayers[0] buttonpressed("Dev Block strings are not supported") || level.localPlayers[0] buttonpressed("Dev Block strings are not supported"))
			{
				if(names[selected] == "Dev Block strings are not supported")
				{
					SetDvar("Dev Block strings are not supported", 0);
					continue;
				}
				if(is_scene_playing(names[selected]))
				{
					SetDvar("Dev Block strings are not supported", names[selected]);
					continue;
				}
				if(is_scene_initialized(names[selected]))
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
				while(level.localPlayers[0] buttonpressed("Dev Block strings are not supported") || level.localPlayers[0] buttonpressed("Dev Block strings are not supported") || level.localPlayers[0] buttonpressed("Dev Block strings are not supported"))
				{
					wait(0.016);
				}
			}
			wait(0.016);
		}
	#/
}

/*
	Name: display_mode
	Namespace: scene
	Checksum: 0xDDC307AA
	Offset: 0x1428
	Size: 0x233
	Parameters: 0
	Flags: None
*/
function display_mode()
{
	/#
		hudelem = CreateLUIMenu(0, "Dev Block strings are not supported");
		SetLUIMenuData(0, hudelem, "Dev Block strings are not supported", 100);
		SetLUIMenuData(0, hudelem, "Dev Block strings are not supported", 490);
		SetLUIMenuData(0, hudelem, "Dev Block strings are not supported", 500);
		OpenLUIMenu(0, hudelem);
		while(level flagsys::get("Dev Block strings are not supported"))
		{
			str_mode = ToLower(GetDvarString("Dev Block strings are not supported", "Dev Block strings are not supported"));
			switch(str_mode)
			{
				case "Dev Block strings are not supported":
				{
					SetLUIMenuData(0, hudelem, "Dev Block strings are not supported", "Dev Block strings are not supported");
					break;
				}
				case "Dev Block strings are not supported":
				{
					SetLUIMenuData(0, hudelem, "Dev Block strings are not supported", "Dev Block strings are not supported");
					break;
				}
				case "Dev Block strings are not supported":
				{
					SetLUIMenuData(0, hudelem, "Dev Block strings are not supported", "Dev Block strings are not supported");
					break;
				}
				case "Dev Block strings are not supported":
				{
					SetLUIMenuData(0, hudelem, "Dev Block strings are not supported", "Dev Block strings are not supported");
					break;
				}
			}
			wait(0.05);
		}
		CloseLUIMenu(0, hudelem);
	#/
}

/*
	Name: scene_list_menu
	Namespace: scene
	Checksum: 0x3BAE486B
	Offset: 0x1668
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
	Checksum: 0xAC6C5028
	Offset: 0x16F8
	Size: 0x1ED
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
			if(is_scene_playing(text))
			{
				SetLUIMenuData(0, hud_array[i], "Dev Block strings are not supported", 1);
				text = text + "Dev Block strings are not supported";
			}
			else if(is_scene_initialized(text))
			{
				SetLUIMenuData(0, hud_array[i], "Dev Block strings are not supported", 1);
				text = text + "Dev Block strings are not supported";
			}
			else
			{
				SetLUIMenuData(0, hud_array[i], "Dev Block strings are not supported", 0.5);
			}
			if(i == 5)
			{
				SetLUIMenuData(0, hud_array[i], "Dev Block strings are not supported", 1);
				text = "Dev Block strings are not supported" + text + "Dev Block strings are not supported";
			}
			SetLUIMenuData(0, hud_array[i], "Dev Block strings are not supported", text);
		}
	#/
}

/*
	Name: is_scene_playing
	Namespace: scene
	Checksum: 0xEFE33B74
	Offset: 0x18F0
	Size: 0x5F
	Parameters: 1
	Flags: None
*/
function is_scene_playing(str_scene)
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
	Name: is_scene_initialized
	Namespace: scene
	Checksum: 0xF642CC53
	Offset: 0x1958
	Size: 0x5F
	Parameters: 1
	Flags: None
*/
function is_scene_initialized(str_scene)
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
	Checksum: 0x5E39B8CD
	Offset: 0x19C0
	Size: 0x85
	Parameters: 2
	Flags: None
*/
function scene_menu_cleanup(elems, title)
{
	/#
		level waittill("scene_menu_cleanup");
		CloseLUIMenu(0, title);
		for(i = 0; i < elems.size; i++)
		{
			CloseLUIMenu(0, elems[i]);
		}
	#/
}

/*
	Name: test_init
	Namespace: scene
	Checksum: 0x5F195845
	Offset: 0x1A50
	Size: 0x2B
	Parameters: 1
	Flags: None
*/
function test_init(arg1)
{
	/#
		init(arg1, undefined, undefined, 1);
	#/
}

/*
	Name: test_play
	Namespace: scene
	Checksum: 0xDAC5A38D
	Offset: 0x1A88
	Size: 0x3B
	Parameters: 2
	Flags: None
*/
function test_play(arg1, str_mode)
{
	/#
		Play(arg1, undefined, undefined, 1, str_mode);
	#/
}

/*
	Name: debug_display
	Namespace: scene
	Checksum: 0x8D177824
	Offset: 0x1AD0
	Size: 0x2CD
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

