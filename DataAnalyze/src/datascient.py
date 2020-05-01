# Daten einlesen und plotten
# von Vahel Hassan 
# Abschlussarbeit 2020
#Quelle foer matplotlib: https://matplotlib.org/gallery/index.html

import matplotlib.pyplot as plt
import numpy as np

# Die CSV Datei lesen und oefnen
#Anfang 
dateihandler = open('abalone.data.csv')  

inhalt = dateihandler.read()

zeilen = inhalt.split('\n')

tabelle = []

for zeile in range(len(zeilen)):
	spalten = zeilen[zeile].split(',')
	tabelle.append(spalten)
#Ende

# Die zeilen in Float casten
#Anfang 
tabelle[zeile][1:] = [float(zahl) for zahl in tabelle[zeile][1:]]
#Ende

# Die Zeile die wir benoetigen aus der Tabelle herausziehen und plotten
#Anfang
laenge = [zeile[1] for zeile in tabelle]
hoehe = [zeile[3] for zeile in tabelle]



# Fixing random state for reproducibility
np.random.seed(19680801)


laenge, hoehe = np.random.randn(2, 100)
fig, [ax1, ax2] = plt.subplots(2, 1, sharex=True)
ax1.xcorr(laenge, hoehe, usevlines=True, maxlags=50, normed=True, lw=2)
ax1.grid(True)

ax2.acorr(laenge, usevlines=True, normed=True, maxlags=50, lw=2)
ax2.grid(True)

plt.show()
#Ende