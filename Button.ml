class button x margin name action =
	object (self)
		val _start_x = x

		method get_x :int = _start_x

		method get_margin :int = margin

		method get_name :string = name

		method private is_in_y y = y > 450 && y < 550

		method is_inside x y = x > _start_x && x < (_start_x  + 80) && self#is_in_y y

		method action (tama : Tama.tama option) : Tama.tama option = 
            match tama with
            | None -> None
            | Some(tama) -> action tama

	end
