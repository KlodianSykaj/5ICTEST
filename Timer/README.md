# Timer App

## Descrizione
L'app è la ricreazione di un classico timer in flutter con varie impostazioni.

## Caratteristiche
- Inizia il timer.
- Metti in pausa il timer.
- Reimposta il timer.
- Visualizza l'ora trascorsa nel formato "HH:MM:SS".

## Come usare
- Al lancio dell'app, vedrai un timer impostato su "00:00:00".
- Premi il pulsante "Start" per avviare il timer.
- Premi il pulsante "Pause" per mettere in pausa il timer.
- Premi il pulsante "Reset" per reimpostare il timer a "00:00:00".

## Spiegazione del Codice
Il codice sorgente dell'app Timer è stato scritto utilizzando il framework Flutter di Google. Ecco una breve spiegazione di come funziona:

- L'app è costituita da due classi principali: `MyApp` e `MyHomePage`.
- `MyApp` è la classe principale che definisce il tema dell'app e imposta la schermata iniziale su `MyHomePage`.
- `MyHomePage` è la classe che gestisce la logica principale dell'app.
- Utilizza `StreamController` per tenere traccia del tempo trascorso e del numero di tick del timer.
- I pulsanti "Start", "Pause" e "Reset" attivano le rispettive azioni sul timer.
- Il timer è visualizzato nel formato "HH:MM:SS" utilizzando il widget `Text`.
