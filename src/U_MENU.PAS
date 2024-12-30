
Unit U_Menu;                 { Mise … jour le 21/07/1991. }
{
Logiciel: ED_COBOL.

Auteur: Pr‚martin Patrick.
Date: 09/03/1991.
      10/03/1991.
      18/07/1991.
      21/07/1991.

But: Gestion de la ligne de menu.
}
{ $define demo_vers}
Interface

Uses
    Crt,
    dos,
    U_Disk,
    U_Ecran,
    U_Fenetre,
    U_Informations,
    U_Sgf,
    U_Utilitaire,
    U_Variables;

Procedure Charger;
          { Charge le fichier dont le nom va etre saisi. }
Procedure Sauver;
          { Sauve le fichier courant aprŠs avoir saisi son nom. }
Procedure Infos;
          { Affiche les ‚crans d'information et d'aide. }
Procedure Impression_Listing;
          { Imprime le fichier aprŠs confirmation. }
procedure dos_shell;
          { Sort du programme et retourne sous DOS. }

Function Quitter : Boolean;
         { Demande … l'utilisateur s'il veut quitter le programme. }
Function Nouveau : Boolean;
         { Demande … l'utilisateur s'il veut changer de fichier. }

Implementation
Procedure Charger;
Begin
     If (Question_Alerte ('Voulez-vous sauver le fichier courant ?'))
     Then
         Sauver
     {endif};
     Message_Alerte ('Entrez maintenant le nom du fichier … charger.', True);
     Demande_Nom_Fichier ('Chargement du fichier: ');
     Chargement_Code_Source;
     Initialisation_Ecran
End; { charger }

Procedure Infos;
Begin
  Reset_Screen;
  Informations;
  Initialisation_Ecran
End; { infos }

Function Nouveau : Boolean;
Begin
  Nouveau := Question_Alerte ('Voulez-vous effacer ce listing ?');
  Message_Menu
End; { nouveau }

Function Quitter: Boolean;
Var Reponse : Boolean;
Begin
  Quitter := Question_Alerte ('Voulez-vous me quitter ?');
  Message_Menu
End; { quitter }

Procedure Sauver;
Begin
{$IFDEF DEMO_VERS}
     message_alerte ('Version de d‚monstration, pas de sauvegarde...', true);
{$ELSE}
     Message_Alerte ('Entrez le nom du fichier … sauver.', True);
     Demande_Nom_Fichier ('Sauvegarde du fichier :');
     Sauvegarde_Code_Source;
{$ENDIF}
     Initialisation_Ecran
End; { sauver }

Procedure Impression_Listing;
Begin
     If (Question_Alerte ('Voulez-vous imprimer ce programme ?'))
     Then
         Impression_Code_Source;
     {endif}
     Message_Menu;
End; { impression_listing }

procedure dos_shell;
begin
     textcolor (lightgray);
     textbackground (black);
     window (1, 1, 80, 25);
     clrscr;
     writeln ('Tapez EXIT pour retourner dans ce programme...');
     writeln;
     swapvectors;
     exec (getenv ('COMSPEC'), '');
     swapvectors;
     if (doserror <> 0)
     then
         message_alerte ('Impossible d''utiliser COMMAND.COM !', true);
     {endif}
     initialisation_ecran;
end; { dos_shell }

End. { Fin de l'unit‚ 'U_Menu'. }
