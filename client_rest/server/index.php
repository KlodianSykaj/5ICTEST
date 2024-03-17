<?php

header("Access-Control-Allow-Origin: *");
$dipendenti=[
         ["codice"=>"aaaa","nome"=>"Laura","cognome"=>"Bianchi","reparto"=>"amministrazione"],
         ["codice"=>"bbbb","nome"=>"Marco","cognome"=>"Rossi","reparto"=>"produzione"],
         ["codice"=>"cccc","nome"=>"Giulio","cognome"=>"Verdi","reparto"=>"ufficio personale"],
         ["codice"=>"dddd","nome"=>"Anna","cognome"=>"Pinco","reparto"=>"produzione"],
         ["codice"=>"eeee","nome"=>"Andrea","cognome"=>"Russo","reparto"=>"ricerca sviluppo"],
            ];
if(isset($_GET["codice"])){
    $codice=$_GET["codice"];
    
    for($i=0;$i<=count($dipendenti)-1;$i=$i+1){
        if($dipendenti[$i]["codice"]==$codice){
            $risposta=[
                       "stato"=>"OK-1",
                       "messaggio"=>"URL valido",
                       "codice"=> $dipendenti[$i]["codice"],
                       "nome"=> $dipendenti[$i]["nome"],
                       "cognome"=> $dipendenti[$i]["cognome"],
                       "reparto"=> $dipendenti[$i]["reparto"]
                       ];
            echo json_encode($risposta);
            exit();  
        }
    }
    $risposta=["stato"=>"OK-2","messaggio"=>"URL valido, codice non esiste"];
    echo json_encode($risposta);
    
}
else{
    $risposta=["stato"=>"ERRORE","messaggio"=>"URL non valido, codice mancante"];
    echo json_encode($risposta);
}

