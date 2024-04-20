Ce script permet la lecture par espeak d'un document .txt en adaptant la lecture à la personne qui entend
le texte : notamment la vitesse de lecture.

#!/usr/bin/python3
# Auteur : Pierre Estrem février 2024
# script pour lire à haute voix les documents txt obtenus avec le script A-lire-et-obtenir-le-texte
# nécessite le fichier help.txt - voir ligne 46 et la ligne 332.
"""
Lecteur de fichier texte avec les fonctions :
	- lecture accélérée (Flèche HAUT)
	- lecture ralentie (Flèche BAS)
	- vitesse de lecture normale (Touche =)
	- avance rapide (Flèche DROITE)
	- recul rapide (Flèche GAUCHE)
	- aller au début (CTRL+ FlècheGAUCHE)
	- aller à la fin (CTRL+ FlècheDROITE)
	- quitter (CTRL+Q) ou (Alt + F4)
	- possibilité de lire toutes les ponctuations (Touche P)
"""

import subprocess
import os
import sys
import re
from time import *
from tkinter import *
from tkinter import messagebox
from tkinter import scrolledtext
import signal

class Player(Tk):
	def __init__(self, file):
		super().__init__()
		self.title("Player 1.0")
		self.wscreen = self.winfo_screenwidth()
		self.hscreen = self.winfo_screenheight()
		self.w = 800
		self.h = 700
		self.posx = (self.wscreen - self.w)//2
		self.posy = (self.hscreen - self.h)//2

		self.geometry(f'{self.w}x{self.h}+{self.posx}+{self.posy}')
		self.update()
		
		self.filename = file
		self.helpfile = "/opt/player/help.txt"
		self.HELP = ""
		for l in open(self.helpfile).readlines():
			self.HELP += l
		self.TEXT = ""
		for l in open(self.filename).readlines():
			self.TEXT += l
		self.curText = self.TEXT
		self.curword = 0
		self.WORDS = re.findall("\w+ *[\n\.,:;!]*", self.TEXT)
		self.N_WORDS = len(self.WORDS)
		self.SPEED =140
		self.curspeed = self.SPEED
		self.stepSpeed = 20
		self.STEP = 20
		self.voice = "mb-fr1"
		self.punct = ""
		self.EXEC = "/usr/bin/espeak "
		self.exec = self.EXEC
		self.running = BooleanVar(value=False)
		self.proc = 0
		self.espeak = BooleanVar(value=False)
		self.execTime = 0
		self.Times = []

		self.fr1 = Frame(self,width=self.w).grid(row=0,column=0,columnspan=5)
		self.fr2 = Frame(self,width=self.w).grid(row=1,column=0,rowspan=4,columnspan=5)

		self.text = scrolledtext.ScrolledText(self.fr1, font = "Times" , bg  = 'White', bd = 1, padx = 50,pady = 50)
		self.text.grid(row=0,column=0, rowspan=1,columnspan=5, sticky=E)

		for l in self.TEXT:
			self.text.insert(END, l)
		
		self.btn1 = Button(self.fr2,text = "Accélérer", command = lambda e: self.keymanager(e))
		self.btn1.grid(row=1, column=2, sticky=N)

		self.btn2 = Button(self.fr2,text="Début", command = lambda e: self.keymanager(e))
		self.btn2.grid(row=2, column=0, sticky=W)

		self.btn3 = Button(self.fr2,text="Reculer", command = lambda e: self.keymanager(e))
		self.btn3.grid(row=2, column=1, sticky=W)
		
		self.btn7 = Button(self.fr2,text="Valider pour lire le texte", height=2, bg = 'Cyan') #, width=1, command = lambda e: self.keymanager(e))
		self.btn7.grid(row=2, column=2, sticky=S)

		self.btn4 = Button(self.fr2,text="Avancer", command = lambda e: self.keymanager(e))
		self.btn4.grid(row=2, column=3, sticky=E)		

		self.btn5 = Button(self.fr2,text="Fin", command = lambda e: self.keymanager(e))
		self.btn5.grid(row=2, column=4, sticky=E)

		self.btn6 = Button(self.fr2,text="Ralentir", command = lambda e: self.keymanager(e))
		self.btn6.grid(row=3, column=2, sticky=S)

		self.btn8 = Button(self.fr2,text="Quitter CTRL+Q", command = lambda e: self.keymanager(e))
		self.btn8.grid(row=4, column=4, sticky=E)

		self.btn9 = Button(self.fr2,text="Aide", command = self.helpBox)
		self.btn9.grid(row=4, column=0, sticky=W)

		self.punctState = IntVar()
		self.cb1 = Checkbutton(text = "Lire les ponctuations", variable = self.punctState)

		self.bind_class("Button", "<FocusIn>", lambda e: subprocess.Popen(f'{self.exec} -s {self.curspeed} -v {self.voice} "{e.widget["text"]}"', shell = True, stdout=subprocess.PIPE))

		self.bind_class("Button", "<Button-1>", self.click)
		
		self.bind_class("Checkbutton", "<FocusIn>", lambda e: subprocess.Popen(f'{self.exec} -s {self.curspeed} -v {self.voice} "{e.widget["text"]}"', shell = True, stdout=subprocess.PIPE))

		self.bind("h", self.keymanager)

		self.bind_all("<Return>", self.keymanager)

		self.bind("<space>", self.keymanager)

		self.bind("<KP_Enter>", self.keymanager)

		self.bind("<Left>", self.backward)

		self.bind("<Right>", self.forward)
		
		self.bind("<Up>", self.incSpeed)

		self.bind("<Down>", self.decSpeed)

		self.bind("=", self.resetSpeed)
		
		self.bind("<Control-Left>", self.gotobegin)

		self.bind("<Control-Right>", self.gotoend)
		
		self.bind("<Control-q>", self.onExit)

	def helpBox(self):
		self.proc = subprocess.Popen(f'{self.exec} -s {self.curspeed} -v {self.voice} "{self.HELP}"', shell = True, stdout=subprocess.PIPE)
		messagebox.showinfo("Aide", self.HELP)

	def escape(self, e):
		if not isinstance(self.proc, int):
			self.proc.kill()

	def play(self):
		self.Times.append(perf_counter())
		self.proc = subprocess.Popen(f'{self.exec} -s {self.curspeed} -v {self.voice}'.split()+[self.curText], stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
		self.running.set(True)
		self.espeak.set(True)

	def stop_restart(self, e):
		if self.espeak.get():
			if not self.running.get():
				self.restart()
			else:
				self.stop()
				
	def backward(self, e):
		self.stop()
		self.curword = int(self.execTime / 60 * self.curspeed) - self.STEP
		if self.curword < 0:
			self.curword = 0
		self.execTime -= self.STEP / self.curspeed * 60
		self.chgText()
		self.play()

	def forward(self, e):
		self.stop()
		self.curword = int(self.execTime / 60 * self.curspeed) + self.STEP
		if self.curword >= self.N_WORDS:
			self.curword = self.N_WORDS - 1
		self.execTime += self.STEP / self.curspeed * 60
		self.chgText()
		self.play()

	def decSpeed(self, e):
		if self.curspeed > 10 + self.stepSpeed:
			self.curspeed -= self.stepSpeed
			self.stop()
			self.curword = int(self.execTime / 60 * self.curspeed) - self.STEP
			if self.curword < 0:
				self.curword = 0
			self.execTime -= self.STEP / self.curspeed * 60
			self.chgText()
			self.play()

	def incSpeed(self, e):
		self.curspeed += self.stepSpeed
		self.stop()
		self.curword = int(self.execTime / 60 * self.curspeed) - self.STEP
		if self.curword < 0:
			self.curword = 0
		self.execTime -= self.STEP / self.curspeed * 60
		self.chgText()
		self.play()

	def resetSpeed(self, e):
		self.curspeed = self.SPEED
		self.stop()
		self.curword = int(self.execTime / 60 * self.curspeed) - self.STEP
		if self.curword < 0:
			self.curword = 0
		self.execTime -= self.STEP / self.curspeed * 60
		self.chgText()
		self.play()

	def chgText(self,):
		self.curText = ""
		for w in self.WORDS[self.curword :  ]:
			self.curText += w

	def stop(self):
		self.Times.append(perf_counter())
		self.execTime += self.Times[-1] - self.Times[-2]
		self.proc.send_signal(signal.SIGSTOP)
		self.running.set(False)

	def restart(self):
		self.Times.append(perf_counter())
		self.proc.send_signal(signal.SIGCONT)
		self.running.set(True)

	def gotobegin(self, e):
		if self.espeak.get():
			self.proc.send_signal(signal.SIGKILL)
		self.curword = 0
		self.curText = self.TEXT
		self.Times.clear()
		self.play()

	def gotoend(self, e):
		if self.espeak.get():
			self.proc.send_signal(signal.SIGKILL)
		self.curword = self.N_WORDS - 1
		self.curText = self.WORDS[-1]
		self.Times.clear()
		self.play()

	def click(self, e):
		if e.num == 1:
			w =  e.widget
			if w["text"] == "Valider pour lire le texte":
				if not self.espeak.get():
					self.play()
				elif self.running.get():
					self.stop()
				else: self.restart()
			elif w["text"] == "Avancer":
				self.forward(e)
			elif w["text"] == "Reculer":
				self.backward(e)
			elif w["text"] == "Début":
				self.gotobegin(e)
			elif w["text"] == "Fin":
				self.gotoend(e)
			elif w["text"] == "Accélérer":
				self.incSpeed(e)
			elif w["text"] == "Ralentir":
				self.decSpeed(e)
			elif w["text"] == "Aide":
				messagebox.showinfo("Aide", self.HELP)
			elif w["text"] == "Quitter":
				self.onExit(e)
			elif w["text"] == "Lire les ponctuations":
				if self.punctState.get() == 1:
					self.exec += '--punct=".,:;!?"'
				else: self.exec = self.EXEC
				self.punctuation(e)

	def keymanager(self, e):
		if e.keysym == "Return" or e.keysym == "space" or e.keysym == "KP_Enter":
			w =  self.focus_get()
			if w["text"] == "Valider pour lire le texte":
				if not self.espeak.get():
					self.play()
				elif self.running.get():
					self.stop()
				else: self.restart()
			elif w["text"] == "Avancer":
				self.forward(e)
			elif w["text"] == "Reculer":
				self.backward(e)
			elif w["text"] == "Début":
				self.gotobegin(e)
			elif w["text"] == "Fin":
				self.gotoend(e)
			elif w["text"] == "Accélérer":
				self.incSpeed(e)
			elif w["text"] == "Ralentir":
				self.decSpeed(e)
			elif w["text"] == "Quitter":
				self.onExit(e)
			elif w["text"] == "Lire les ponctuations":
				if self.punctState.get() == 1:
					self.exec += '--punct=".,:;!?"'
				else: self.exec = self.EXEC
				self.punctuation(e)
		if e.keysym == "h":
			self.helpBox()

	def punctuation(self, e):
		self.stop()
		self.curword = int(self.execTime / 60 * self.curspeed) + self.STEP
		self.chgText()
		self.play()

	def onExit(self, e):
		if not isinstance(self.proc, int):
			self.proc.kill()
		self.quit()

if __name__ == '__main__':
	if len(sys.argv) == 2:
		f = sys.argv[1]
	else:
		print('Syntax is:',sys.argv[0],' <fichier texte>')
		exit(-1)

	if os.path.isfile(f) == False:
		print(f'File \'{f}\' not exists')
		exit(-1)	

	p = Player(f)
	p.btn7.focus_set()
	p.mainloop()
	exit(0)

""""""
Le fichier help.txt est ici : 
Pour fermer cette fenêtre, tapez Echap.

 - lecture accélérée :
	Flèche HAUT.
 - lecture ralentie :
	Flèche BASSE.
 - vitesse de lecture normale :
	Touche = (égal).

 - avance rapide :
	Flèche DROITE.
 - recul rapide :
	Flèche GAUCHE.
 - lire au début :
	CTRL+FlècheGAUCHE.
 - aller à la fin :
	CTRL+FlècheDROITE.

 - quitter : CTRL+Q .
	ou Alt + F4 .
 - lire les ponctuations :
	Touche P.
 - consulter l'aide :
	Touche H .

Tabuler 8 fois pour obtenir
le focus sur le texte.

""""""""

