# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: tvermeil <tvermeil@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2018/03/29 13:26:15 by tvermeil          #+#    #+#              #
#    Updated: 2018/04/07 18:48:29 by tvermeil         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

OCAMLMAKEFILE = ./OCamlMakefile

SOURCES = timer.ml Tama.ml Button.ml Progress_bar.ml main.ml
RESULT  = tama

SDLDIR = $(HOME)/.brew/lib

LIBS         = bigarray sdl sdlttf sdlloader sdlmixer
INCDIRS	     = +sdl
OCAMLLDFLAGS = -cclib "-L$(SDLDIR) -framework Cocoa"
THREADS      = true

include $(OCAMLMAKEFILE)
