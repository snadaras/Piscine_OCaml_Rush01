(* ************************************************************************** *)
(*                                                                            *)
(*                                                        :::      ::::::::   *)
(*   main.ml                                            :+:      :+:    :+:   *)
(*                                                    +:+ +:+         +:+     *)
(*   By: tvermeil <tvermeil@student.42.fr>          +#+  +:+       +#+        *)
(*                                                +#+#+#+#+#+   +#+           *)
(*   Created: 2018/04/07 12:28:44 by tvermeil          #+#    #+#             *)
(*   Updated: 2018/04/07 21:17:13 by tvermeil         ###   ########.fr       *)
(*                                                                            *)
(* ************************************************************************** *)

let buttons =  [new Button.button 25 32 "Eat" (fun tama -> tama#eat);
                new Button.button 175 10 "Thunder" (fun tama -> tama#thunder);
                new Button.button 325 26 "Bath" (fun tama -> tama#bath);
                new Button.button 475 32 "Kill" (fun tama -> tama#kill);]

let bars =  [new Progress_bar.progress_bar 25 "Health" (fun tama -> tama#get_health_percent);
                new Progress_bar.progress_bar 175 "Energy" (fun tama -> tama#get_energy_percent);
                new Progress_bar.progress_bar 325 "Hygiene" (fun tama -> tama#get_hygiene_percent);
                new Progress_bar.progress_bar 475 "Happy" (fun tama -> tama#get_happyness_percent);]

let print_bars screen (_, font, _) tama =
    let print_one bar =
        let text = Sdlttf.render_text_blended font bar#get_name ~fg:Sdlvideo.black in
        let text_background = Sdlvideo.rect bar#get_x 30 100 20 in
        let background = Sdlvideo.rect bar#get_x 50 100 25 in
        let void = Sdlvideo.rect ((int_of_float (bar#stat_pourcent tama *. 96.)) + bar#get_x + 2) 52 (96 - (int_of_float (bar#stat_pourcent tama *. 96.))) 21 in
        let position_text = Sdlvideo.rect (bar#get_x) 30 100 20 in
        Sdlvideo.fill_rect ~rect:background screen (Sdlvideo.map_RGB screen Sdlvideo.black);
        Sdlvideo.fill_rect ~rect:void screen (Sdlvideo.map_RGB screen Sdlvideo.white);
        Sdlvideo.fill_rect ~rect:text_background screen (Sdlvideo.map_RGB screen Sdlvideo.white);
        Sdlvideo.blit_surface ~dst_rect:position_text ~src:text ~dst:screen ()
    in
    List.iter print_one bars;
    Sdlvideo.flip screen


let print_buttons screen (font, _, _) =
	let print_one button =
	    let text = Sdlttf.render_text_blended font button#get_name ~fg:Sdlvideo.black in
        let position_button_border = Sdlvideo.rect button#get_x 475 100 75 in
        let position_button = Sdlvideo.rect (button#get_x + 2) 477 96 71 in
	    let position_text = Sdlvideo.rect (button#get_x + button#get_margin) 503 100 100 in
        Sdlvideo.fill_rect ~rect:position_button_border screen (Sdlvideo.map_RGB screen Sdlvideo.black);
        Sdlvideo.fill_rect ~rect:position_button screen (Sdlvideo.map_RGB screen Sdlvideo.white);
	    Sdlvideo.blit_surface ~dst_rect:position_text ~src:text ~dst:screen ()
	in
	List.iter print_one buttons;
    Sdlvideo.flip screen

let print_gamover screen (_, _, font) =
    let text = Sdlttf.render_text_blended font "GAME OVER" ~fg:Sdlvideo.black in
    let position_text = Sdlvideo.rect ((600 - (fst (Sdlttf.size_text font "GAME OVER"))) / 2) 250 600 200 in
    Sdlvideo.fill_rect screen (Sdlvideo.map_RGB screen Sdlvideo.white);
    Sdlvideo.blit_surface ~dst_rect:position_text ~src:text ~dst:screen ()

let press_button x y tama =
    try
        (List.find (fun b -> b#is_inside x y) buttons)#action tama
    with
    | Not_found -> tama

let take_damage tama : Tama.tama option =
    match tama with
    | Some tama -> tama#take_damage
    | None -> None

let save_tama_before_exit tama =
    match tama with
    | None -> ()
    | Some(tama) -> tama#save

let rec wait_for_escape screen font (tama: Tama.tama option) =
	print_buttons screen font;
    print_bars screen font tama;
    if tama = None
    then print_gamover screen font;
    match Sdlevent.wait_event () with
    | Sdlevent.KEYDOWN { Sdlevent.keysym = Sdlkey.KEY_ESCAPE } -> save_tama_before_exit tama; print_endline "Bye."
    | Sdlevent.MOUSEBUTTONDOWN event                           -> wait_for_escape screen font (press_button event.mbe_x event.mbe_y tama)
    | USER 0                                                   -> wait_for_escape screen font (take_damage tama)
    | event                                                    -> wait_for_escape screen font tama

let recover_save () =
    try 
        let filename = Sys.argv.(1) in
        match (new Tama.tama)#from_save_file filename with
        | Some(tama) -> Some(tama)
        | None -> exit 2
    with
    | Invalid_argument(_) -> Some(new Tama.tama)

let main () = 
    Sdl.init [`VIDEO];
    at_exit Sdl.quit;
    Sdlttf.init ();
    at_exit Sdlttf.quit;
    Sdlkey.enable_unicode true;
    let tama = recover_save () in
    let screen = Sdlvideo.set_video_mode 600 600 [`DOUBLEBUF] in
    let image = Sdlloader.load_image "pikachu.png" in
    let font_button = Sdlttf.open_font "8bit_font.ttf" 24 in
    let font_bars = Sdlttf.open_font "8bit_font.ttf" 20 in
    let font_gameover = Sdlttf.open_font "8bit_font.ttf" 96 in

    Sdlvideo.fill_rect screen (Sdlvideo.map_RGB screen Sdlvideo.white);
    let position_of_image = Sdlvideo.rect 210 190 200 200 in
    Sdlvideo.blit_surface ~dst_rect:position_of_image ~src:image ~dst:screen ();
    Sdlvideo.flip screen;

    ignore(Timer.init_timer ());

    wait_for_escape screen (font_button, font_bars, font_gameover) tama

(* ************************************************************************** *)
let () = main ()
