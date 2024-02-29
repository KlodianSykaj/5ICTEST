#L'applicazione è divisa in tre parti principali: MinesweeperApp, Minesweeper, e _MinesweeperState.

MinesweeperApp: Questa classe rappresenta l'applicazione stessa. La sua funzione è quella di definire la struttura generale dell'interfaccia utente. Essa include 
un'app bar con il titolo "Minesweeper" e un corpo che contiene un'istanza della classe Minesweeper.

Minesweeper: Questa classe rappresenta la schermata principale del gioco del campo minato. Essa è un'app Flutter con uno stato mutabile gestito dalla classe 
_MinesweeperState. In questa parte del codice, viene definita l'interfaccia utente del gioco.

_MinesweeperState: Questa classe gestisce il gioco effettivo del campo minato. È responsabile della gestione delle mine, del conteggio delle mine nelle celle 
circostanti, della gestione della fine del gioco e della vittoria. Inoltre, gestisce l'interfaccia utente del gioco, inclusa la griglia di celle e le relative 
interazioni.

-Inizializzazione del Gioco

Nel metodo initState, vengono inizializzate le variabili di gioco. In particolare, vengono generate casualmente le posizioni delle mine all'interno della griglia 
8x8. Questa inizializzazione determina la posizione delle mine per ogni partita.

-Gestione delle Mine e delle Celle Circostanti

Il metodo countMinesAround è utilizzato per conteggiare il numero di mine presenti nelle celle circostanti a una data cella. Esso scorre le celle adiacenti a una 
data posizione e verifica se ciascuna di esse contiene una mina.

-Gestione della Fine del Gioco

Il metodo handleGameOver viene chiamato quando il giocatore colpisce una mina. In questo caso, il gioco termina e tutte le mine vengono rivelate. Viene visualizzata 
una finestra di dialogo che informa il giocatore della fine del gioco e offre la possibilità di ricominciare.

-Gestione della Vittoria

Il metodo checkWin verifica se il gioco è stato vinto. Esso controlla se tutte le celle non contenenti mine sono state rivelate. In caso di vittoria, viene 
visualizzata una finestra di dialogo di congratulazioni e viene offerta la possibilità di iniziare una nuova partita.

-Interazione con l'Interfaccia Utente

Il metodo build è responsabile della costruzione dell'interfaccia utente del gioco. Esso crea una griglia di celle 8x8 utilizzando widget Flutter. Le celle possono 
essere cliccate dagli utenti per rivelarle. La cella rivelata mostra un'icona se contiene una mina o il numero di mine circostanti. La griglia viene generata 
dinamicamente in base al numero di righe e colonne specificate.

-Gestione dei Clic degli Utenti

La funzione revealCell gestisce l'interazione dell'utente con il gioco. Essa determina se una cella può essere rivelata, controlla se è presente una mina e gestisce 
il comportamento in caso di rivelazione di una cella. Se una cella non contiene mine nelle vicinanze, le celle circostanti vengono rivelate automaticamente.

-Riavvio del Gioco

La funzione resetGame reimposta tutte le variabili del gioco e inizializza nuovamente le posizioni delle mine.
