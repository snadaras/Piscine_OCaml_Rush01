class progress_bar x name get_stat =
	object

		method get_x :int = x

		method get_name :string = name

		method stat_pourcent (tama:Tama.tama option) =
			match tama with
			| Some tama -> float_of_int (get_stat tama) /. 100.
			| _ -> 0.

	end