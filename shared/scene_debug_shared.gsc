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
		level thread toggle_postfx_igc_loop();
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
		level.scene_test_struct = spawnstruct();
		level.scene_test_struct.origin = (0, 0, 0);
		level.scene_test_struct.angles = (0, 0, 0);
		while(1)
		{
			str_scene = GetDvarString("Dev Block strings are not supported");
			str_client_scene = GetDvarString("Dev Block strings are not supported");
			str_mode = ToLower(GetDvarString("Dev Block strings are not supported", "Dev Block strings are not supported"));
			b_capture = str_mode == "Dev Block strings are not supported" || str_mode == "Dev Block strings are not supported";
			if(b_capture)
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
			else if(str_client_scene != "Dev Block strings are not supported")
			{
				level util::clientNotify(str_client_scene + "Dev Block strings are not supported");
				util::wait_network_frame();
			}
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
				if(!b_found && isdefined(level.active_scenes[str_scene]))
				{
					foreach(s_instance in level.active_scenes[str_scene])
					{
						b_found = 1;
						s_instance thread test_play(str_scene, str_mode);
					}
				}
				else if(!b_found)
				{
					level.scene_test_struct thread test_play(str_scene, str_mode);
				}
			}
			str_scene = GetDvarString("Dev Block strings are not supported");
			str_client_scene = GetDvarString("Dev Block strings are not supported");
			if(str_client_scene != "Dev Block strings are not supported")
			{
				level util::clientNotify(str_client_scene + "Dev Block strings are not supported");
				util::wait_network_frame();
			}
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
				if(b_capture)
				{
					capture_scene(str_scene, str_mode);
				}
			}
			str_scene = GetDvarString("Dev Block strings are not supported");
			str_client_scene = GetDvarString("Dev Block strings are not supported");
			if(str_client_scene != "Dev Block strings are not supported")
			{
				level util::clientNotify(str_client_scene + "Dev Block strings are not supported");
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
	Name: capture_scene
	Namespace: scene
	Checksum: 0xCDC90501
	Offset: 0xBA0
	Size: 0x5B
	Parameters: 2
	Flags: None
*/
function capture_scene(str_scene, str_mode)
{
	/#
		SetDvar("Dev Block strings are not supported", 0);
		level Play(str_scene, undefined, undefined, 1, undefined, str_mode);
	#/
}

/*
	Name: clear_old_ents
	Namespace: scene
	Checksum: 0xB17ABB79
	Offset: 0xC08
	Size: 0xC1
	Parameters: 1
	Flags: None
*/
function clear_old_ents(str_scene)
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
							SetDvar("Dev Block strings are not supported", 0);
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
		level thread display_mode();
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
				if(level.host util::up_button_pressed())
				{
					up_pressed = 1;
					selected--;
				}
			}
			else if(level.host util::up_button_held())
			{
				held = 1;
				selected = selected - 10;
			}
			else if(!level.host util::up_button_pressed())
			{
				held = 0;
				up_pressed = 0;
			}
			if(!down_pressed)
			{
				if(level.host util::down_button_pressed())
				{
					down_pressed = 1;
					selected++;
				}
			}
			else if(level.host util::down_button_held())
			{
				held = 1;
				selected = selected + 10;
			}
			else if(!level.host util::down_button_pressed())
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
					level.host move_to_scene(names[selected]);
					while(level.host buttonpressed("Dev Block strings are not supported") || level.host buttonpressed("Dev Block strings are not supported"))
					{
						wait(0.05);
					}
					break;
				}
				if(level.host buttonpressed("Dev Block strings are not supported") || level.host buttonpressed("Dev Block strings are not supported"))
				{
					level.host move_to_scene(names[selected], 1);
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
	Name: display_mode
	Namespace: scene
	Checksum: 0x1B325CC0
	Offset: 0x1948
	Size: 0x233
	Parameters: 0
	Flags: None
*/
function display_mode()
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
			if(is_scene_playing(text))
			{
				level.host SetLUIMenuData(hud_array[i], "Dev Block strings are not supported", 1);
				text = text + "Dev Block strings are not supported";
			}
			else if(is_scene_initialized(text))
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
	Name: is_scene_playing
	Namespace: scene
	Checksum: 0x6A7FE4C7
	Offset: 0x1E30
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
	Checksum: 0x2672DE33
	Offset: 0x1E98
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
	Name: test_init
	Namespace: scene
	Checksum: 0xF08F4948
	Offset: 0x1FC0
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
	Checksum: 0x712082F7
	Offset: 0x1FF8
	Size: 0x3B
	Parameters: 2
	Flags: None
*/
function test_play(arg1, str_mode)
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
	Name: move_to_scene
	Namespace: scene
	Checksum: 0x2546C035
	Offset: 0x2328
	Size: 0x223
	Parameters: 2
	Flags: None
*/
function move_to_scene(str_scene, b_reverse_dir)
{
	/#
		if(!isdefined(b_reverse_dir))
		{
			b_reverse_dir = 0;
		}
		if(!level.debug_current_scene_name === str_scene)
		{
			level.debug_current_scene_instances = struct::get_array(str_scene, "Dev Block strings are not supported");
			level.debug_current_scene_index = 0;
			level.debug_current_scene_name = str_scene;
		}
		else if(b_reverse_dir)
		{
			level.debug_current_scene_index--;
			if(level.debug_current_scene_index == -1)
			{
				level.debug_current_scene_index = level.debug_current_scene_instances.size - 1;
			}
		}
		else
		{
			level.debug_current_scene_index++;
			if(level.debug_current_scene_index == level.debug_current_scene_instances.size)
			{
				level.debug_current_scene_index = 0;
			}
		}
		if(level.debug_current_scene_instances.size == 0)
		{
			s_bundle = struct::get_script_bundle("Dev Block strings are not supported", str_scene);
			if(isdefined(s_bundle.aligntarget))
			{
				e_align = get_existing_ent(s_bundle.aligntarget, 0, 1);
				if(isdefined(e_align))
				{
					level.host set_origin(e_align.origin);
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
			s_scene = level.debug_current_scene_instances[level.debug_current_scene_index];
			level.host set_origin(s_scene.origin);
		}
	#/
}

/*
	Name: set_origin
	Namespace: scene
	Checksum: 0x6126F971
	Offset: 0x2558
	Size: 0x63
	Parameters: 1
	Flags: None
*/
function set_origin(v_origin)
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
	Name: toggle_postfx_igc_loop
	Namespace: scene
	Checksum: 0xF20F5BAF
	Offset: 0x25C8
	Size: 0x73
	Parameters: 0
	Flags: None
*/
function toggle_postfx_igc_loop()
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

