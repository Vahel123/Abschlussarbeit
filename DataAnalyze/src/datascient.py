# Daten einlesen und plotten
# von Vahel Hassan 
# Abschlussarbeit 2020

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