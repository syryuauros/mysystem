let

  jj = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIXifjBn6gkBCKkpJJAbB1pJC1zSUljf8SFnPqvB6vIR";

  lima = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHa5Zv/30dGQMZEopanUblhbpCm3BER/YRX8YJh/VktD";
  urubamba = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOw4J9vtIT4/Juac+bp06Yf5lk5/hlzGeqJBEKOaZsvZ";
  bogota = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAl5/ozkuWmVXtqSOJetfMA1OWF+LZ4IqsYkNhsQcGb6";
  lapaz = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKa+MtYN20MlkctttUkg2RpOTNLRbfvqeTLwqbJoUj2o";
  antofagasta = "";

  systems = [ lima urubamba bogota lapaz antofagasta ];

in
{

  # pubkey = A0nB+yJRcUHqIC4PzFN8EgYcvVyYek0kJReYOGLLLHA=
  "wg-lima.age".publicKeys = [ jj lima ];

  # pubkey = EXbdmddEY2KMf+Z2eb77gWrSCsAAJQiS1LDXa1nCElk=
  "wg-urubamba.age".publicKeys = [ jj urubamba ];

  # pubkey = /P8HtebCmkXt+17xEeCsMpzsukG2ZpCm8Lh6jjsgRzo=
  "wg-bogota.age".publicKeys = [ jj bogota ];

  # pubkey = GaDfcKdWItmWd3Raj3Ak5Kr5PNagVG4sCaQiBR3XIC0=
  "wg-lapaz.age".publicKeys = [ jj lapaz ];

   # pubkey = 9FS4y8jInY0xizUqAZvONoaTYL6ZN+MyngmPDi5HNHo=
  "wg-antofagasta.age".publicKeys = [ jj antofagasta ];

  # swarm.key for the private ipfs
  "ipfs-swarm-key.age".publicKeys = [ jj ] ++ systems;

}
