# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Pento.Repo.insert!(%Pento.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Pento.Repo
alias Pento.Catalog.Quiz

quizs = [
  %Quiz{
    body:
      "Le rotaie del tram sono particolarmente pericolose per la circolazione dei veicoli a due ruote quando il fondo stradale è bagnato"
  },
  %Quiz{
    body: "Il semaforo di corsie reversibili in figura indica la corsia per i veicoli lenti",
    image: ""
  },
  %Quiz{
    body:
      "Lo specchio retrovisore posto sul lato destro del veicolo deve essere utilizzato solo da conducenti esperti"
  },
  %Quiz{
    body:
      "Le rotaie del tram sono particolarmente pericolose per la circolazione dei veicoli a due ruote quando il fondo stradale è bagnato"
  },
  %Quiz{
    body: "Il semaforo di corsie reversibili in figura indica la corsia per i veicoli lenti",
    image: ""
  },
  %Quiz{
    body:
      "Lo specchio retrovisore posto sul lato destro del veicolo deve essere utilizzato solo da conducenti esperti"
  },
  %Quiz{
    body:
      "Il segnale raffigurato impone di dare la precedenza ai veicoli che escono dal cantiere",
    translation:
      "The represented signal imposes to give priority to the vehicles that exit from the construction site",
    solution: false,
    image:
      "https://upload.wikimedia.org/wikipedia/commons/thumb/a/a7/Italian_traffic_signs_-_lavori.svg/180px-Italian_traffic_signs_-_lavori.svg.png"
  },
  %Quiz{
    body: "Il pannello raffigurato (A) indica una strada in salita",
    translation: "The pictured panel (A) indicates an uphill road",
    solution: false
  },
  %Quiz{
    body:
      "Il pannello integrativo raffigurato indica che il segnale al quale è abbinato vale nei giorni festivi",
    translation:
      "The supplementary panel shown indicates that the signal to which it is matched is valid on public holidays",
    solution: false,
    image:
      "https://upload.wikimedia.org/wikipedia/commons/thumb/6/6b/Italian_traffic_signs_-_validit%C3%A0_%28modello_II_3-d%29.svg/180px-Italian_traffic_signs_-_validit%C3%A0_%28modello_II_3-d%29.svg.png"
  },
  %Quiz{
    body:
      "Sulle autostrade e strade extraurbane principali è vietata la circolazione di veicoli a tenuta non stagna e con carico scoperto, se trasportano materiali che possono disperdersi"
  },
  %Quiz{
    body:
      "Lo specchio retrovisore posto sul lato destro del veicolo deve essere utilizzato solo da conducenti esperti"
  },
  %Quiz{
    body:
      "Le rotaie del tram sono particolarmente pericolose per la circolazione dei veicoli a due ruote quando il fondo stradale è bagnato"
  },
  %Quiz{
    body: "Il semaforo di corsie reversibili in figura indica la corsia per i veicoli lenti",
    image: ""
  },
  %Quiz{
    body:
      "Lo specchio retrovisore posto sul lato destro del veicolo deve essere utilizzato solo da conducenti esperti"
  }
]

for q <- quizs ++ quizs ++ quizs do
  Repo.insert!(q)
end

for topic <- [
      "Definizioni generali e doveri nell'uso della strada",
      "Segnali di pericolo",
      "Segnali di divieto",
      "Segnali d'obbligo",
      "Segnali di precedenza",
      "Segnaletica orizzontale e segni sugli ostacoli",
      "Segnalazioni semaforiche e degli agenti del traffico",
      "Segnali di indicazione",
      "Segnali complementari, segnali temporanei e di cantiere",
      "Limiti di velocità, pericolo e intralcio alla circolazione"
    ] do
  Pento.Catalog.create_topic!(topic)
end
