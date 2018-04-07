exception TamaUnserializeException of string

class tama =
	object (self)
		val _health = 100
		val _hygiene = 100
		val _energy = 100
		val _happyness = 100

		method eat = 
            let new_tama = 
                     {< _health = min 100 (_health + 25);
						_energy = _energy - 10;
						_hygiene = _hygiene - 20;
						_happyness = min 100 (_happyness + 5) >}
            in 
            if (new_tama#is_alive) then Some(new_tama) else None

		method thunder = 
            let new_tama = 
                     {< _health = min 100 (_health - 20);
						_energy = min 100 (_energy + 25);
						_hygiene = min 100 (_hygiene);
						_happyness = min 100 (_happyness - 20) >}
            in 
            if (new_tama#is_alive) then Some(new_tama) else None

		method bath = 
            let new_tama = 
                     {< _health = _health - 20;
						_energy = _energy - 10;
						_hygiene = min 100 (_hygiene + 25);
						_happyness = min 100 (_happyness + 5) >}
            in 
            if (new_tama#is_alive) then Some(new_tama) else None

		method kill = 
            let new_tama = 
                     {< _health = _health - 20;
						_energy = _energy - 10;
						_hygiene = _hygiene;
						_happyness = min 100 (_happyness + 20) >}
            in
            if (new_tama#is_alive) then Some(new_tama) else None


		method take_damage =
			let new_tama = {< _health = _health - 1 >} in
            if (new_tama#is_alive) then Some(new_tama) else None

		method is_alive = _health > 0 && _hygiene > 0 && _energy > 0 && _happyness > 0

        method get_health_percent     = _health
        method get_hygiene_percent    = _hygiene
        method get_energy_percent     = _energy
        method get_happyness_percent  = _happyness

        method save = 
            let ser_str = Printf.sprintf "%d\n%d\n%d\n%d\n" _health _hygiene _energy _happyness in
            try
                let oc = open_out "save.itama" in
                output_string oc ser_str;
                close_out oc
            with
            | Sys_error(error_str) -> print_endline error_str;

        method from_save_file filename = 
            try
                let ic = open_in filename in
                let read_int line_nbr = 
                    let line = input_line ic in
                    match (int_of_string_opt line) with
                    | Some(i) when ((i > 0) && (i <= 100)) -> i
                    | _ -> raise (TamaUnserializeException(
                        "Error: Wrong value format on line " ^ (string_of_int line_nbr)))
                in 
                Some({< _health    = read_int 1; 
                        _hygiene   = read_int 2; 
                        _energy    = read_int 3; 
                        _happyness = read_int 4 >})
            with
            | Sys_error(error_str) -> print_endline error_str; None
            | End_of_file -> print_endline "Unexpected end of file"; None
            | TamaUnserializeException(error_str) -> print_endline error_str; None
	end
