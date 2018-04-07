(* ************************************************************************** *)
(*                                                                            *)
(*                                                        :::      ::::::::   *)
(*   timer.ml                                           :+:      :+:    :+:   *)
(*                                                    +:+ +:+         +:+     *)
(*   By: tvermeil <tvermeil@student.42.fr>          +#+  +:+       +#+        *)
(*                                                +#+#+#+#+#+   +#+           *)
(*   Created: 2018/04/07 15:19:52 by tvermeil          #+#    #+#             *)
(*   Updated: 2018/04/07 15:47:09 by tvermeil         ###   ########.fr       *)
(*                                                                            *)
(* ************************************************************************** *)

(* Adds a specific event to to the event queue every second *)
let rec timer_loop () =
    Thread.delay 1.0;
    Sdlevent.add [USER 0];
    timer_loop ()
    

(* Initialize the 1-second timer thread *)
let init_timer () =
    ignore(Thread.create timer_loop ())

