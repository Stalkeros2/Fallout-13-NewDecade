/client/verb/who()
	set name = "Who"
	set category = "OOC"

	var/msg = "<b>Текущие игроки:</b>\n"

	var/list/Lines = list()

	if(holder)
		if(usr.client && usr.client.language == "English")
			if(check_rights(R_ADMIN,0) && isobserver(src.mob))//If they have +ADMIN and are a ghost they can see players IC names and statuses.
				var/mob/dead/observer/G = src.mob
				if(!G.started_as_observer)//If you aghost to do this, KorPhaeron will deadmin you in your sleep.
					log_admin("[key_name(usr)] checked advanced who in-round")
				for(var/client/C in clients)
					var/entry = "\t[C.key]"
					if(C.holder && C.holder.fakekey)
						entry += " <i>(as [C.holder.fakekey])</i>"
					if (isnewplayer(C.mob))
						entry += " - <font color='darkgray'><b>In lobby</b></font>"
					else
						entry += " - Playing as [C.mob.real_name]"
						switch(C.mob.stat)
							if(UNCONSCIOUS)
								entry += " - <font color='darkgray'><b>Unconscious</b></font>"
							if(DEAD)
								if(isobserver(C.mob))
									var/mob/dead/observer/O = C.mob
									if(O.started_as_observer)
										entry += " - <font color='gray'>Observing</font>"
									else
										entry += " - <font color='black'><b>DEAD</b></font>"
								else
									entry += " - <font color='black'><b>DEAD</b></font>"
						if(is_special_character(C.mob))
							entry += " - <b><font color='red'>Antagonist</font></b>"
					entry += " (<A HREF='?_src_=holder;adminmoreinfo=\ref[C.mob]'>?</A>)"
					entry += " ([round(C.avgping, 1)]ms)"
					Lines += entry
			else//If they don't have +ADMIN, only show hidden admins
				for(var/client/C in clients)
					var/entry = "\t[C.key]"
					if(C.holder && C.holder.fakekey)
						entry += " <i>(as [C.holder.fakekey])</i>"
					entry += " ([round(C.avgping, 1)]ms)"
					Lines += entry
				for(var/client/C in clients)
					if(C.holder && C.holder.fakekey)
						Lines += "[C.holder.fakekey] ([round(C.avgping, 1)]ms)"
					else
						Lines += "[C.key] ([round(C.avgping, 1)]ms)"
			for(var/line in sortList(Lines))
				msg += "[line]\n"

			msg += "<b>Online: [length(Lines)]</b>"
			to_chat(src, msg)
		else
			if(check_rights(R_ADMIN,0) && isobserver(src.mob))//If they have +ADMIN and are a ghost they can see players IC names and statuses.
				var/mob/dead/observer/G = src.mob
				if(!G.started_as_observer)//If you aghost to do this, KorPhaeron will deadmin you in your sleep.
					log_admin("[key_name(usr)] проверил advanced who во время раунда")
				for(var/client/C in clients)
					var/entry = "\t[C.key]"
					if(C.holder && C.holder.fakekey)
						entry += " <i>(as [C.holder.fakekey])</i>"
					if (isnewplayer(C.mob))
						entry += " - <font color='darkgray'><b>В лобби</b></font>"
					else
						entry += " - Играет за [C.mob.real_name]"
						switch(C.mob.stat)
							if(UNCONSCIOUS)
								entry += " - <font color='darkgray'><b>Без сознания</b></font>"
							if(DEAD)
								if(isobserver(C.mob))
									var/mob/dead/observer/O = C.mob
									if(O.started_as_observer)
										entry += " - <font color='gray'>Наблюдает</font>"
									else
										entry += " - <font color='black'><b>МЕРТВ</b></font>"
								else
									entry += " - <font color='black'><b>МЕРТВ</b></font>"
						if(is_special_character(C.mob))
							entry += " - <b><font color='red'>Антагонист</font></b>"
					entry += " (<A HREF='?_src_=holder;adminmoreinfo=\ref[C.mob]'>?</A>)"
					entry += " ([round(C.avgping, 1)]ms)"
					Lines += entry
			else//If they don't have +ADMIN, only show hidden admins
				for(var/client/C in clients)
					var/entry = "\t[C.key]"
					if(C.holder && C.holder.fakekey)
						entry += " <i>(как [C.holder.fakekey])</i>"
					entry += " ([round(C.avgping, 1)]ms)"
					Lines += entry
				for(var/client/C in clients)
					if(C.holder && C.holder.fakekey)
						Lines += "[C.holder.fakekey] ([round(C.avgping, 1)]ms)"
					else
						Lines += "[C.key] ([round(C.avgping, 1)]ms)"

			for(var/line in sortList(Lines))
				msg += "[line]\n"
			msg += "<b>Всего игроков: [length(Lines)]</b>"
			to_chat(src, msg)
/client/verb/adminwho()
	set category = "Admin"
	set name = "Adminwho"
	if(usr.client && usr.client.language == "English")
		var/msg = "<b>Current admins:</b>\n"
		if(holder)
			for(var/client/C in admins)
				msg += "\t[C] is a [C.holder.rank]"

				if(C.holder.fakekey)
					msg += " <i>(as [C.holder.fakekey])</i>"

				if(isobserver(C.mob))
					msg += " - Observing"
				else if(isnewplayer(C.mob))
					msg += " - In lobby"
				else
					msg += " - In game"

				if(C.is_afk())
					msg += " (AFK)"
				msg += "\n"
		else
			for(var/client/C in admins)
				if(C.is_afk())
					continue //Don't show afk admins to adminwho
				if(!C.holder.fakekey)
					msg += "\t[C] is a [C.holder.rank]\n"
			msg += "<span class='info'>Adminhelps are also sent to IRC. If no admins are available in game adminhelp anyways and an admin on IRC will see it and respond.</span>"
		to_chat(src, msg)
	else
		var/msg = "<b>Текущие админы:</b>\n"
		if(holder)
			for(var/client/C in admins)
				msg += "\t[C] имеет ранг [C.holder.rank]"

				if(C.holder.fakekey)
					msg += " <i>(как [C.holder.fakekey])</i>"

				if(isobserver(C.mob))
					msg += " - Наблюдает"
				else if(isnewplayer(C.mob))
					msg += " - В лобби"
				else
					msg += " - В игре"

				if(C.is_afk())
					msg += " (AFK)"
				msg += "\n"
		else
			for(var/client/C in admins)
				if(C.is_afk())
					continue //Don't show afk admins to adminwho
				if(!C.holder.fakekey)
					msg += "\t[C] is a [C.holder.rank]\n"
			msg += "<span class='info'>Adminhelps are also sent to IRC. If no admins are available in game adminhelp anyways and an admin on IRC will see it and respond.</span>"
		to_chat(src, msg)