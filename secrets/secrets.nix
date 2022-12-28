let

  jj = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIXifjBn6gkBCKkpJJAbB1pJC1zSUljf8SFnPqvB6vIR";

  lima = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFqf/d1LL7NEVjpmwlX4vfesfP7w8Tw+m7cX5oIkcuHg";
  urubamba = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOpfMBpKwyVj6WAdMbNoDvH3v68C0oiQoqf5EvLBcYAJ";
  bogota = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAl5/ozkuWmVXtqSOJetfMA1OWF+LZ4IqsYkNhsQcGb6";
  lapaz = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKa+MtYN20MlkctttUkg2RpOTNLRbfvqeTLwqbJoUj2o";
  antofagasta = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPYe7j/BoueCTsYF4BrNojPC+Y0MMCDqia4QkS7KmVNG";

  systems = [ lima urubamba bogota lapaz antofagasta ];

in
{

  # pubkey = A0nB+yJRcUHqIC4PzFN8EgYcvVyYek0kJReYOGLLLHA=
  "wg-lima.age".publicKeys = [ jj lima ];

  # pubkey = EXbdmddEY2KMf+Z2eb77gWrSCsAAJQiS1LDXa1nCElk=
  "wg-urubamba.age".publicKeys = [ jj urubamba ];

  # pubkey = /P8HtebCmkXt+17xEeCsMpzsukG2ZpCm8Lh6jjsgRzo=
  "wg-bogota.age".publicKeys = [ jj bogota ];

  # pubkey = 35WCxg6asdsW7+v67RO9eG+/mVG4pbYz0bJtvxyR5Cc=
  "wg-lapaz.age".publicKeys = [ jj lapaz ];

   # pubkey = 9FS4y8jInY0xizUqAZvONoaTYL6ZN+MyngmPDi5HNHo=
  "wg-antofagasta.age".publicKeys = [ jj antofagasta ];

  # swarm.key for the private ipfs
  "ipfs-swarm-key.age".publicKeys = [ jj ] ++ systems;

  # peerix key, pubkey = peerix:5In6cUHRQgQUhvnlefNBd/0e7g1TMhmck15UsJv9hxY=
  "peerix.age".publicKeys = [jj] ++ systems;

}
